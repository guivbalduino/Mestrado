from pymongo import MongoClient
import pandas as pd
import os
from datetime import datetime, timedelta
from dados_novos_inmet import processar_arquivos_csv as pac_inmet
from dados_novos_libelium import processar_arquivos_csv as pac_libelium


# Conexão com o banco de dados MongoDB
client = MongoClient('localhost', 27017)  # Conecte-se ao MongoDB local
db = client['dados']  # Banco de dados

# Adiciona os do inmet

colecao = db['inmet']  # Coleção

# Encontre a data de início mais antiga e a data de fim mais recente presentes no banco de dados
primeiro_registro = colecao.find_one({}, sort=[("timestamp", 1)])
ultimo_registro = colecao.find_one({}, sort=[("timestamp", -1)])

if primeiro_registro is None or ultimo_registro is None:
    print("Banco de dados está vazio. Definindo intervalo de datas de 1º de janeiro de 2010 até ontem.")
    data_inicio = datetime.now()
    data_fim = datetime.now()
else:
    data_inicio = primeiro_registro["timestamp"]
    data_fim = ultimo_registro["timestamp"]


# Chame a função para processar os arquivos CSV
df_final = pac_inmet(data_inicio, data_fim)

df_final.to_csv('dados_inmet.csv', index=False)

if df_final.empty:
    print("Nenhum dado adicional foi encontrado.")
else:
    # Converta o DataFrame para um formato compatível com o MongoDB
    dados_json = df_final.to_dict(orient='records')

    # Insira os dados na coleção do MongoDB
    resultado = colecao.insert_many(dados_json)

    print(f"Foram inseridos {len(resultado.inserted_ids)} registros na coleção 'inmet' do banco de dados 'dados' no MongoDB.")

# Adiciona os do libelium


colecao = db['libelium']  # Coleção

# Encontre a data de início mais antiga e a data de fim mais recente presentes no banco de dados
primeiro_registro = colecao.find_one({}, sort=[("timestamp", 1)])
ultimo_registro = colecao.find_one({}, sort=[("timestamp", -1)])

if primeiro_registro is None or ultimo_registro is None:
    print("Banco de dados está vazio. Definindo intervalo de datas de 1º de janeiro de 2010 até ontem.")
    data_inicio = datetime.now()
    data_fim = datetime.now()
else:
    data_inicio = primeiro_registro["timestamp"]
    data_fim = ultimo_registro["timestamp"]


# Chame a função para processar os arquivos CSV
df_final = pac_libelium(data_inicio, data_fim)


df_final.to_csv('dados_libelium.csv', index=False)

if df_final.empty:
    print("Nenhum dado adicional foi encontrado.")
else:
    # Converta o DataFrame para um formato compatível com o MongoDB
    dados_json = df_final.to_dict(orient='records')

    # Insira os dados na coleção do MongoDB
    resultado = colecao.insert_many(dados_json)

    print(f"Foram inseridos {len(resultado.inserted_ids)} registros na coleção 'libelium' do banco de dados 'dados' no MongoDB.")

