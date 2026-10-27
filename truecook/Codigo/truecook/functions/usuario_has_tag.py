# seed do usuario e tags no Firestore
import firebase_admin
from firebase_admin import credentials, firestore

# ---  Inicialização do Firebase ---
try:
    cred = credentials.Certificate('serviceAccountKey.json')
    firebase_admin.initialize_app(cred)
    print("✅ Firebase Admin inicializado.")
except ValueError:
    print("🔥 Firebase App já inicializado.")
    pass

db = firestore.client()

# --- Dados de Testen ---
USUARIO_TAGS_MAP = {
    1: [1, 2, 14], # Davi -> Celíaco, Diabético, Semi Industrializados
    2: [3, 15],    # Carlos Oliveira -> Vegetariano, Lowcarb
    3: [4, 17],    # Mariana Santos -> Vegano, 30 minutos ou menos
    4: [5, 18],    # João Pereira -> Colesterol alto, Alto proteína
    5: [6, 19],    # Fernanda Costa -> Intolerante a Lactose, Baixo Calorias
    6: [1, 20],    # Ricardo Almeida -> Celíaco, Rico em Fibras
    7: [2, 3],     # Juliana Rodrigues -> Diabético, Vegetariano
    8: [4, 5],     # Pedro Henrique -> Vegano, Colesterol alto
    9: [6, 7],     # Camila Ferreira -> Intolerante a Lactose, Ovo
    10: [8, 9],    # Alex Green -> Amendoim, Peixe
}


def delete_collection(coll_ref, batch_size=50):
    """
    Deleta todos os documentos de uma coleção.
    """
    print(f"Limpando a coleção '{coll_ref.id}'...")
    docs = coll_ref.limit(batch_size).stream()
    deleted = 0
    
    while True:
        doc_count = 0
        batch = db.batch()
        
        for doc in docs:
            batch.delete(doc.reference)
            doc_count += 1
            
        if doc_count == 0:
            break
            
        batch.commit()
        deleted += doc_count
        print(f"Documentos deletados: {deleted}")
        # Pega o próximo lote
        docs = coll_ref.limit(batch_size).stream()
        
    print(f"Coleção '{coll_ref.id}' limpa. Total de {deleted} documentos removidos.")


def seed_database():
    """
    Função principal que limpa e povoa o banco.
    """
    user_tags_ref = db.collection('user_tags')
    
    # Limpa a coleção 'user_tags'
    delete_collection(user_tags_ref)
    
    # Prepara o novo lote
    batch = db.batch()
    
    print("\nIniciando o povoamento (seeding) com dados do SQLite...")
    
    total_relations = 0
    
    # Itera sobre o MAPA 
    for user_id, tag_ids in USUARIO_TAGS_MAP.items():
        
        print(f"Processando Usuário ID: {user_id}")
        
        for tag_id in tag_ids:
            # Cria o documento da relação
            data = {
                'user_id': user_id, 
                'tag_id': tag_id    
            }
            
            # Adiciona ao lote
            new_doc_ref = user_tags_ref.document()
            batch.set(new_doc_ref, data)
            total_relations += 1

    #  Envia tudo para o Firestore
    batch.commit()
    
    print("\n--- SUCESSO! ---")
    print(f"✅ Banco povoado com {len(USUARIO_TAGS_MAP)} usuários.")
    print(f"✅ Total de {total_relations} relações 'user_tags' criadas.")
    print("Pode rodar o endpoint /rules agora!")


if __name__ == "__main__":
    print("=======================================")
    print("🛑 ATENÇÃO: Este script vai DELETAR")
    print("TODOS os dados da coleção 'user_tags'")
    print("e substituí-los por dados de teste.")
    print("=======================================")
    
    confirm = input("Digite 'SIM' para continuar: ")
    
    if confirm == "SIM":
        seed_database()
    else:
        print("Operação cancelada.")