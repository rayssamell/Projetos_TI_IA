"""
OBD-II Coletor Completo
========================
Coleta todos os PIDs disponíveis do carro via adaptador Bluetooth ELM327
e salva os dados em CSV com timestamp.

Instalação:
    pip install obd pandas

Uso:
    python obd_coletor_completo.py                  # detecta porta automaticamente
    python obd_coletor_completo.py --porta /dev/rfcomm0
    python obd_coletor_completo.py --porta COM4     # Windows
    python obd_coletor_completo.py --intervalo 1.0  # leitura a cada 1 segundo
"""

import obd
import pandas as pd
import time
import argparse
import sys
from datetime import datetime
from pathlib import Path


# ──────────────────────────────────────────────
# Configurações
# ──────────────────────────────────────────────

INTERVALO_PADRAO    = 0.5   # segundos entre cada ciclo de leitura
TIMEOUT_CONEXAO     = 10    # segundos aguardando conexão
PASTA_SAIDA         = Path(".")  # onde salvar o CSV


# ──────────────────────────────────────────────
# Conexão
# ──────────────────────────────────────────────

def conectar(porta: str | None) -> obd.OBD:
    print("\n[OBD] Conectando ao adaptador ELM327...")

    if porta:
        conexao = obd.OBD(porta, timeout=TIMEOUT_CONEXAO)
    else:
        print("[OBD] Porta não informada — tentando detectar automaticamente...")
        conexao = obd.OBD(timeout=TIMEOUT_CONEXAO)

    if conexao.status() == obd.OBDStatus.NOT_CONNECTED:
        print("[ERRO] Não foi possível conectar.")
        print("       Verifique se o adaptador está pareado via Bluetooth")
        print("       e se o contato do carro está ligado (posição ACC).\n")
        sys.exit(1)

    print(f"[OBD] Conectado! Status: {conexao.status()}")
    return conexao


# ──────────────────────────────────────────────
# Descoberta de PIDs
# ──────────────────────────────────────────────

def descobrir_pids(conexao: obd.OBD) -> list:
    """Testa todos os comandos conhecidos e retorna os suportados pelo carro."""
    print("\n[OBD] Verificando quais PIDs o carro suporta...")

    suportados = []
    total = 0

    for cmd in obd.commands:
        # Ignora meta-comandos internos da biblioteca
        if not hasattr(cmd, 'command'):
            continue
        total += 1
        if conexao.supports(cmd):
            suportados.append(cmd)

    print(f"[OBD] {len(suportados)} PIDs suportados (de {total} testados)\n")

    # Exibe a lista completa
    print(f"{'PID':<30} {'Descrição'}")
    print("-" * 65)
    for cmd in suportados:
        print(f"  {cmd.name:<28} {cmd.desc}")
    print()

    return suportados


# ──────────────────────────────────────────────
# Leitura de um snapshot
# ──────────────────────────────────────────────

def ler_snapshot(conexao: obd.OBD, pids: list) -> dict:
    """Lê todos os PIDs de uma vez e retorna um dicionário com os valores."""
    registro = {"timestamp": datetime.now().isoformat(timespec="milliseconds")}

    for cmd in pids:
        try:
            resp = conexao.query(cmd)

            if resp.is_null():
                registro[cmd.name] = None
                continue

            val = resp.value

            # Extrai o número puro se for uma grandeza com unidade (pint)
            if hasattr(val, 'magnitude'):
                registro[cmd.name] = round(float(val.magnitude), 4)
            # Lista de DTCs (códigos de erro)
            elif isinstance(val, list):
                registro[cmd.name] = "; ".join(
                    f"{code} ({desc})" for code, desc in val
                ) if val else "nenhum"
            else:
                registro[cmd.name] = str(val)

        except Exception as e:
            registro[cmd.name] = f"ERRO: {e}"

        # Pequena pausa para não sobrecarregar o barramento CAN
        time.sleep(0.03)

    return registro


# ──────────────────────────────────────────────
# Coleta contínua
# ──────────────────────────────────────────────

def coletar(conexao: obd.OBD, pids: list, intervalo: float) -> list:
    """Loop principal de coleta. Pressione Ctrl+C para encerrar."""
    historico = []
    inicio = time.time()

    print("[OBD] Iniciando coleta... Pressione Ctrl+C para encerrar.\n")
    print(f"{'Nº':<6} {'Timestamp':<27} {'RPM':>7} {'Speed':>7} {'Temp':>6} {'Load':>6}")
    print("-" * 60)

    try:
        n = 0
        while True:
            n += 1
            snap = ler_snapshot(conexao, pids)
            historico.append(snap)

            # Exibe resumo no terminal
            rpm   = snap.get("RPM",          "—")
            speed = snap.get("SPEED",         "—")
            temp  = snap.get("COOLANT_TEMP",  "—")
            load  = snap.get("ENGINE_LOAD",   "—")
            ts    = snap["timestamp"][11:]  # só hora

            print(
                f"{n:<6} {ts:<27}"
                f"{str(rpm):>7}"
                f"{str(speed):>7}"
                f"{str(temp):>6}"
                f"{str(load):>6}"
            )

            time.sleep(intervalo)

    except KeyboardInterrupt:
        duracao = round(time.time() - inicio, 1)
        print(f"\n\n[OBD] Coleta encerrada após {duracao}s — {len(historico)} registros capturados.")

    return historico


# ──────────────────────────────────────────────
# Salvar CSV
# ──────────────────────────────────────────────

def salvar_csv(historico: list) -> Path:
    if not historico:
        print("[AVISO] Nenhum dado para salvar.")
        return None

    agora = datetime.now().strftime("%Y%m%d_%H%M%S")
    arquivo = PASTA_SAIDA / f"obd_{agora}.csv"

    df = pd.DataFrame(historico)
    df.to_csv(arquivo, index=False, encoding="utf-8")

    print(f"\n[OBD] Salvo em: {arquivo.resolve()}")
    print(f"      {len(df)} linhas  x  {len(df.columns)} colunas\n")

    # Resumo estatístico das colunas numéricas
    numericas = df.select_dtypes(include="number")
    if not numericas.empty:
        print("[OBD] Resumo estatístico:")
        print(numericas.describe().round(2).to_string())

    return arquivo


# ──────────────────────────────────────────────
# DTCs (códigos de erro)
# ──────────────────────────────────────────────

def verificar_dtc(conexao: obd.OBD):
    """Lê e exibe os códigos de falha ativos."""
    print("\n[DTC] Verificando códigos de erro...")

    resp = conexao.query(obd.commands.GET_DTC)

    if resp.is_null() or not resp.value:
        print("[DTC] Nenhum código de erro encontrado.")
        return

    print(f"[DTC] {len(resp.value)} código(s) encontrado(s):\n")
    for codigo, descricao in resp.value:
        print(f"  {codigo}  —  {descricao}")

    resposta = input("\nDeseja limpar os códigos de erro? (s/N): ").strip().lower()
    if resposta == "s":
        conexao.query(obd.commands.CLEAR_DTC)
        print("[DTC] Códigos apagados.")


# ──────────────────────────────────────────────
# Entry point
# ──────────────────────────────────────────────

def main():
    parser = argparse.ArgumentParser(description="Coletor OBD-II completo via Bluetooth ELM327")
    parser.add_argument("--porta",     type=str,   default=None, help="Porta serial (ex: /dev/rfcomm0 ou COM4)")
    parser.add_argument("--intervalo", type=float, default=INTERVALO_PADRAO, help="Segundos entre leituras (padrão: 0.5)")
    parser.add_argument("--so-dtc",   action="store_true", help="Apenas verifica códigos de erro e sai")
    args = parser.parse_args()

    print("=" * 50)
    print("  OBD-II Coletor Completo")
    print("=" * 50)

    conexao  = conectar(args.porta)
    pids     = descobrir_pids(conexao)

    if args.so_dtc:
        verificar_dtc(conexao)
        conexao.close()
        return

    verificar_dtc(conexao)

    historico = coletar(conexao, pids, args.intervalo)
    salvar_csv(historico)

    conexao.close()
    print("[OBD] Conexão encerrada.")


if __name__ == "__main__":
    main()
