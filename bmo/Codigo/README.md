# 🚗 OBD-II Coletor Completo

> Script Python para coleta de dados veiculares via adaptador Bluetooth ELM327 e porta OBD-II, com exportação automática para CSV.

---

## 📋 Sobre o Projeto

Este script faz parte de um projeto de pesquisa interdisciplinar da **PUC Minas**, com o objetivo de detectar adulteração de combustível a partir de dados coletados pela rede CAN do veículo, acessados via protocolo OBD-II.

O coletor realiza a leitura contínua de todos os PIDs (*Parameter IDs*) suportados pelo veículo, armazenando os dados em arquivos CSV prontos para análise estatística e treinamento de modelos de aprendizado de máquina.

---

## ⚙️ Requisitos

- Python **3.10+**
- Adaptador **ELM327** com Bluetooth
- Veículo com suporte a OBD-II (maioria dos veículos fabricados após 2003)

### Dependências

```bash
pip install obd pandas
```

---

## 🚀 Como Usar

### 1. Conecte o adaptador ELM327 à porta OBD-II do veículo

A porta OBD-II geralmente está localizada abaixo do painel do motorista.

### 2. Ligue o veículo e pareie o adaptador via Bluetooth

### 3. Execute o script

```bash
# Detecção automática de porta
python obd_coletor_completo.py

# Especificando a porta manualmente (Linux)
python obd_coletor_completo.py --porta /dev/rfcomm0

# Especificando a porta manualmente (Windows)
python obd_coletor_completo.py --porta COM4

# Ajustando o intervalo entre leituras (em segundos)
python obd_coletor_completo.py --intervalo 1.0

# Apenas verificar códigos de erro (DTC) e sair
python obd_coletor_completo.py --so-dtc
```

### 4. Encerre a coleta com `Ctrl+C`

O arquivo CSV será salvo automaticamente no diretório atual.

---

## 🔄 Fluxo de Execução

```
Conexão Bluetooth com ELM327
        ↓
Identificação do protocolo CAN do veículo
        ↓
Descoberta dos PIDs suportados
        ↓
Verificação de DTCs (códigos de erro)
        ↓
Coleta contínua em laço (Ctrl+C para encerrar)
        ↓
Exportação para CSV com timestamp
```

---

## 📁 Saída

O script gera um arquivo CSV nomeado automaticamente com data e hora:

```
obd_20260507_143022.csv
```

### Estrutura do arquivo

| timestamp | RPM | SPEED | COOLANT_TEMP | SHORT\_FUEL\_TRIM\_1 | O2\_B1S1 | ... |
|---|---|---|---|---|---|---|
| 2026-05-07T14:30:22.413 | 850.0 | 0.0 | 92.0 | -1.5625 | 0.6758 | ... |

---

## 📡 PIDs Monitorados (Variáveis de Interesse)

As variáveis abaixo foram identificadas como mais relevantes para análise de adulteração de combustível:

| PID | Descrição |
|---|---|
| `SHORT_FUEL_TRIM` | Correção de curto prazo da mistura ar-combustível |
| `LONG_FUEL_TRIM` | Correção acumulada de longo prazo da mistura |
| `RPM` | Rotações por minuto do motor |
| `TIMING_ADVANCE` | Avanço de ignição ajustado pela ECU |
| `INTAKE_TEMP` | Temperatura do ar no coletor de admissão |
| `O2_B1S1` | Sonda lambda upstream (antes do catalisador) |
| `O2_B1S2` | Sonda lambda downstream (após o catalisador) |

> Os PIDs disponíveis variam de acordo com o fabricante e o modelo do veículo.

---

## 🛠️ Detalhes Técnicos

- **Intervalo padrão entre ciclos:** 500 ms
- **Pausa entre requisições consecutivas:** 30 ms (respeita a taxa do barramento CAN)
- **Timeout de conexão:** 10 segundos
- **Formato de timestamp:** ISO 8601 com precisão em milissegundos
- **Valores com unidade (pint):** apenas o valor numérico é armazenado
- **DTCs:** serializados em string no formato `código (descrição)`
