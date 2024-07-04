from pymongo import MongoClient
import pandas as pd

# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Coleções de dados originais
colecao_inmet = db['libelium']
colecao_libelium = db['teste']

# Projetar e recuperar apenas as colunas necessárias para cada coleção
projecao = {"timestamp": 1, "temperature_C": 1, "humidity_percent": 1, "pressure_hPa": 1}

dados_inmet = list(colecao_inmet.find({}, projecao))
dados_libelium = list(colecao_libelium.find({}, projecao))

# Converter para DataFrames
df_inmet = pd.DataFrame(dados_inmet)
df_libelium = pd.DataFrame(dados_libelium)

# Transformar a coluna de timestamp para datetime
df_inmet['timestamp'] = pd.to_datetime(df_inmet['timestamp'])
df_libelium['timestamp'] = pd.to_datetime(df_libelium['timestamp'])

# Definir a coluna de timestamp como índice
df_inmet.set_index('timestamp', inplace=True)
df_libelium.set_index('timestamp', inplace=True)

# Encontrar diferenças
dif_inmet_not_in_libelium = df_inmet[~df_inmet.index.isin(df_libelium.index)]
dif_libelium_not_in_inmet = df_libelium[~df_libelium.index.isin(df_inmet.index)]

# Imprimir resultados
print("Registros em 'inmet' mas não em 'libelium':")
print(dif_inmet_not_in_libelium)

print("\nRegistros em 'libelium' mas não em 'inmet':")
print(dif_libelium_not_in_inmet)
