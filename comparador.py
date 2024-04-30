import pandas as pd
from pymongo import MongoClient

# Conectar ao banco de dados MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']
colecao = db['inmet']

# Carregar os dados do banco de dados MongoDB para um DataFrame pandas
df_mongodb = pd.DataFrame(list(colecao.find()))

# Carregar os dados do arquivo CSV para um DataFrame pandas
df_csv = pd.read_csv('dados_inmet.csv')

# Remover a coluna "_id" dos DataFrames
df_mongodb = df_mongodb.drop(columns='_id', errors='ignore')
df_csv = df_csv.drop(columns='_id', errors='ignore')

# Identificar as diferenças entre os DataFrames
diferencas = df_mongodb.compare(df_csv)

# Mostrar as diferenças
print("Diferenças entre os DataFrames (excluindo a coluna '_id'):")
print(diferencas)
