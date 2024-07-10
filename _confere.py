import pymongo

# Conectando ao MongoDB
client = pymongo.MongoClient('localhost', 27017)
db = client['dados']  # Nome do seu banco de dados
colecao_resultado = db['fusao_temp_arima_sktime']  # Nome da sua coleção

# Query para encontrar documentos onde pressure_hPa_ajustado não é NaN
query = {"pressure_hPa_ajustado": {"$exists": True, "$ne": None, "$type": 1}}

# Executar a consulta
resultados = colecao_resultado.find(query)

# Iterar sobre os resultados
for resultado in resultados:
    print(resultado)
