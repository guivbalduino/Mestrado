from pymongo import MongoClient
import pandas as pd
import os
from dados_novos_inmet import processar_arquivos_csv as pac_inmet

# Conexão com o banco de dados MongoDB
client = MongoClient('localhost', 27017)  # Conecte-se ao MongoDB local
db = client['dados']  # Banco de dados
colecao = db['inmet']  # Coleção

# Defina o intervalo de datas desejado
data_inicio = '2024-01-01'
data_fim = '2024-01-31'

# Chame a função para processar os arquivos CSV
df_final = pac_inmet(data_inicio, data_fim)

# Converta o DataFrame para um formato compatível com o MongoDB
dados_json = df_final.to_dict(orient='records')

# Insira os dados na coleção do MongoDB
colecao.insert_many(dados_json)

print("Dados inseridos com sucesso na coleção 'inmet' do banco de dados 'dados' no MongoDB.")
