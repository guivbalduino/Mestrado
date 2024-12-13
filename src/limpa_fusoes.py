from pymongo import MongoClient

# Conectando ao MongoDB
client = MongoClient("localhost", 27017)
db = client["dados"]  # Banco de dados

# Listar todas as coleções no banco de dados
colecoes = db.list_collection_names()

# Iterar sobre as coleções e dropar as que começam com "fusao_"
for colecao in colecoes:
    if colecao.startswith("fusao_temp_arima_es_statsmodels_"):
        db.drop_collection(colecao)
        print(f"Coleção {colecao} foi removida.")

print("Remoção de coleções completada.")
