import firebase_admin
from firebase_admin import credentials, firestore
import firebase_functions as functions
from firebase_functions import https_fn, options
import json 

# --- Imports do Apriori ---
import pandas as pd
from mlxtend.preprocessing import TransactionEncoder
from mlxtend.frequent_patterns import apriori, association_rules
from collections import defaultdict

# --- Configuração do Firebase ---
try:
    cred = credentials.Certificate('serviceAccountKey.json')
    firebase_admin.initialize_app(cred)
    print("✅ Firebase Admin inicializado.")
except ValueError:
    print("🔥 Firebase App já inicializado.")
    pass

db = firestore.client()

# --- Lógica do Apriori  ---
def _get_all_transactions():
    """
    Busca todas as tags e as agrupa por usuário .
    """
    print("Buscando transações no Firestore...")
    user_tags_ref = db.collection('user_tags')
    docs = user_tags_ref.stream()
    transactions_dict = defaultdict(list)
    
    for doc_snapshot in docs:
        data = doc_snapshot.to_dict()
        user_id = data.get('user_id') 
        tag_id = data.get('tag_id')
        if user_id and tag_id:
            transactions_dict[user_id].append(tag_id)
    
    transactions_list = list(transactions_dict.values())
    print(f"Encontradas {len(transactions_list)} transações (usuários).")
    return transactions_list


@https_fn.on_request(
    memory=options.MemoryOption.GB_1,
    cors=options.CorsOptions(
        cors_origins="*",
        cors_methods=["get", "post"] 
    )
)
def get_rules(req: https_fn.Request) -> https_fn.Response:
    """
    Endpoint HTTP que executa o Apriori e retorna as regras.
    """
    try:
        #  Buscar e formatar os dados
        transactions = _get_all_transactions()
        
        if len(transactions) < 5:
            
             return https_fn.Response(
                json.dumps({"message": "Dados insuficientes"}), 
                status=400, 
                headers={"Content-Type":"application/json"}
             )

        # Lógica do Apriori 
        te = TransactionEncoder()
        te_ary = te.fit(transactions).transform(transactions)
        df = pd.DataFrame(te_ary, columns=te.columns_)

        frequent_itemsets = apriori(df, min_support=0.1, use_colnames=True)
        if frequent_itemsets.empty:
            return https_fn.Response(
                json.dumps({"message": "Nenhuma regra encontrada com o suporte mínimo."}),
                status=200,
                headers={"Content-Type":"application/json"}
            )

        rules = association_rules(frequent_itemsets, metric="confidence", min_threshold=0.3)
        # --- BLOCO DE VISUALIZAÇÃO  ---
        print("\n" + "="*60)
        print(f"🔍 RELATÓRIO DE REGRAS GERADAS (Total: {len(rules)})")
        print("="*60)
        
        rules_sorted = rules.sort_values(by='confidence', ascending=False)

        for index, row in rules_sorted.iterrows():
            ants = ", ".join(map(str, list(row['antecedents'])))
            cons = ", ".join(map(str, list(row['consequents'])))
            conf = row['confidence'] * 100
            lift = row['lift']
            suporte = row['support'] * 100
            
            print(f"Regra #{index+1}:")
            print(f"  • SE O USUÁRIO TEM: [{ants}]")
            print(f"  • ENTÃO SUGERIR:    [{cons}]")
            print(f"  • Métricas: Confiança {conf:.1f}% | Lift {lift:.2f} | Suporte {suporte:.1f}%")
            print("-" * 60)
        print("="*60 + "\n")

        # --- FIM DO BLOCO DE VISUALIZAÇÃO ---


        if rules.empty:
            return https_fn.Response(
                json.dumps({"message": "Nenhuma regra atingiu o confidence mínimo."}),
                status=200,
                headers={"Content-Type":"application/json"}
            )
        
        # Formatar o resultado
        rules_clean = rules[['antecedents', 'consequents', 'support', 'confidence', 'lift']].copy()
        rules_clean['antecedents'] = rules_clean['antecedents'].apply(list)
        rules_clean['consequents'] = rules_clean['consequents'].apply(list)
        
        result_json_string = rules_clean.to_dict(orient='records')
        
        # Retornar a resposta em json
        return https_fn.Response(
            json.dumps(result_json_string), 
            status=200, 
            headers={"Content-Type":"application/json"}
        )

    except Exception as e:
        print(f"❌ ERRO ao gerar regras: {e}")
        return https_fn.Response(
            json.dumps({"error": str(e)}), 
            status=500, 
            headers={"Content-Type":"application/json"}
        )
    
@https_fn.on_request(
    memory=options.MemoryOption.GB_1,
    cors=options.CorsOptions(
        cors_origins="*",
        cors_methods=["get", "post"] 
    )
)
def get_user_tags(req: https_fn.Request) -> https_fn.Response:
    """
    Busca todas as tags de um usuário específico.
    """
    try:
        # Pega o user_id da URL
        user_id_str = req.args.get("user_id")
        if not user_id_str:
            return https_fn.Response(
                json.dumps({"error": "user_id é obrigatório"}), 
                status=400, 
                headers={"Content-Type":"application/json"}
            )
        
        user_id = int(user_id_str)
        print(f"Buscando tags para o usuário: {user_id}")

        # Consulta o Firestore
        user_tags_ref = db.collection('user_tags')
        query = user_tags_ref.where('user_id', '==', user_id).stream()
        
        tags_list = []
        for doc in query:
            data = doc.to_dict()
            tags_list.append({
                "id": doc.id,
                "user_id": data.get('user_id'),
                "tag_id": data.get('tag_id')
            })
        
        # Retorna a lista de tags
        return https_fn.Response(
            json.dumps(tags_list), 
            status=200, 
            headers={"Content-Type":"application/json"}
        )
        
    except Exception as e:
        print(f"❌ ERRO ao buscar tags: {e}")
        return https_fn.Response(
            json.dumps({"error": str(e)}), 
            status=500, 
            headers={"Content-Type":"application/json"}
        )


@https_fn.on_request(
    memory=options.MemoryOption.GB_1,
    cors=options.CorsOptions(
        cors_origins="*",
        cors_methods=["get", "post"] 
    )
)
def add_user_tags_batch(req: https_fn.Request) -> https_fn.Response:
    """
    Adiciona uma lista de tags para um usuário a partir do questionário.
    """
    try:
        # Pega o user_id da URL
        user_id_str = req.args.get("user_id")
        if not user_id_str:
            return https_fn.Response(json.dumps({"error": "user_id é obrigatório"}), status=400)
        
        user_id = int(user_id_str)

        # Pega a lista de tag_ids do corpo (body) da requisição
        req_data = req.get_json()
        tag_ids = req_data.get("tag_ids")
        
        if not tag_ids or not isinstance(tag_ids, list):
            return https_fn.Response(json.dumps({"error": "corpo JSON inválido, 'tag_ids' (lista) é obrigatório"}), status=400)

        print(f"Adicionando {len(tag_ids)} tags para o usuário: {user_id}")
        
        # Salva no Firestore em lote 
        batch = db.batch()
        user_tags_ref = db.collection('user_tags')
        
        count = 0
        for tag_id in tag_ids:
            if tag_id: 
                new_doc_ref = user_tags_ref.document()
                batch.set(new_doc_ref, {
                    "user_id": user_id,
                    "tag_id": int(tag_id) 
                })
                count += 1
        
        batch.commit()
        
        return https_fn.Response(
            json.dumps({"message": f"{count} tags adicionadas com sucesso."}), 
            status=200, 
            headers={"Content-Type":"application/json"}
        )

    except Exception as e:
        print(f"❌ ERRO ao salvar tags em lote: {e}")
        return https_fn.Response(
            json.dumps({"error": str(e)}), 
            status=500, 
            headers={"Content-Type":"application/json"}
        )