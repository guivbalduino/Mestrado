import socket
from pymongo import MongoClient
from sktime.forecasting.arima import ARIMA
import pandas as pd
from datetime import datetime

# Definições dos parâmetros
arima_order = (5, 1, 0)
freq_resample = 'H'
tipo_tratamento = 'interpolacao'  # Pode ser 'interpolacao' ou 'dropna'

# Obter o nome do computador
hostname = socket.gethostname()
# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Obtenha a data e hora atual
data_hora_atual = datetime.now()

# Crie o nome da coleção com base na data e hora atual
nome_colecao = "fusao_temp_arima_sktime_" + data_hora_atual.strftime("%Y-%m-%d_%H:%M")

# Coleção para armazenar os resultados
colecao_resultado = db[nome_colecao]

# Coleção para armazenar as informações sobre as fusões
colecao_fusoes = db['fusoes']

# Coleções de dados originais
colecao_inmet = db['inmet']
colecao_libelium = db['libelium']

# Projetar e recuperar apenas as colunas necessárias para cada coleção
projecao = {"timestamp": 1, "temperature_C": 1, "humidity_percent": 1, "pressure_hPa": 1}

dados_inmet = list(colecao_inmet.find({}, projecao))
dados_libelium = list(colecao_libelium.find({}, projecao))

# Converter para DataFrames
df_inmet = pd.DataFrame(dados_inmet)
df_libelium = pd.DataFrame(dados_libelium)

# Concatenar os DataFrames
df_concatenado = pd.concat([df_inmet, df_libelium], ignore_index=True)

# Transformar a coluna de timestamp para datetime
df_concatenado['timestamp'] = pd.to_datetime(df_concatenado['timestamp'])

# Resample dos dados para uma frequência uniforme
df_resampled = df_concatenado.set_index('timestamp').resample(freq_resample).mean()

# Tratar valores ausentes com base no tipo de tratamento
if tipo_tratamento == 'interpolacao':
    # Interpolar os valores ausentes para preencher a frequência
    df_resampled.interpolate(method='time', inplace=True)
elif tipo_tratamento == 'dropna':
    # Remover linhas que possuem valores ausentes
    df_resampled.dropna(inplace=True)
else:
    raise ValueError("tipo_tratamento deve ser 'interpolacao' ou 'dropna'")

# Função para aplicar o modelo ARIMA a uma coluna específica
def aplicar_arima(df, coluna, order):
    y = df[coluna]
    forecaster = ARIMA(order=order)
    forecaster.fit(y)
    return forecaster

# Aplicar o modelo ARIMA às colunas de interesse
inicio_fusao = datetime.now()
arima_models = {}
for coluna in ['temperature_C', 'humidity_percent', 'pressure_hPa']:
    arima_models[coluna] = aplicar_arima(df_resampled, coluna, arima_order)

fim_fusao = datetime.now()
tempo_fusao = fim_fusao - inicio_fusao

# Armazenar os resultados na coleção correspondente no MongoDB
inicio_armazenamento = datetime.now()
colecao_resultado.insert_many(df_resampled.reset_index().to_dict(orient='records'))
fim_armazenamento = datetime.now()
tempo_armazenamento = fim_armazenamento - inicio_armazenamento

# Armazenar informações sobre a modelagem no banco de dados "fusoes"
info_modelagem = {
    "nome_modelagem": "arima_sktime",
    "tipo_modelagem": "temporal",
    "quantidade_dados_utilizados": df_resampled.shape[0],
    "tempo_modelagem_segundos": tempo_fusao.total_seconds(),
    "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
    "data_hora": data_hora_atual,  # Adicionando a data e hora atual
    "arima_order": arima_order,
    "freq_resample": freq_resample,
    "tipo_tratamento": tipo_tratamento,
    "hostname": hostname 
}
colecao_fusoes.insert_one(info_modelagem)

print("Modelagem ARIMA (sktime) concluída e resultados armazenados na coleção:", nome_colecao)
