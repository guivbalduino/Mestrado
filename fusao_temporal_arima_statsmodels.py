from pymongo import MongoClient
from statsmodels.tsa.arima.model import ARIMA
import pandas as pd
from datetime import datetime

# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Obtenha a data e hora atual
data_hora_atual = datetime.now()

# Crie o nome da coleção com base na data e hora atual
nome_colecao = "fusao_temp_arima_statsmodels_" + data_hora_atual.strftime("%Y-%m-%d_%H:%M")

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

# Resample dos dados para uma frequência uniforme (exemplo: 1 hora)
df_resampled = df_concatenado.set_index('timestamp').resample('H').mean()

# Interpolar os valores ausentes para preencher a frequência
df_resampled.interpolate(method='time', inplace=True)

# Remover linhas que ainda possuem valores ausentes após a interpolação
df_resampled.dropna(inplace=True)

# Função para aplicar o modelo ARIMA a uma coluna específica
def aplicar_arima(df, coluna, ordem=(5, 1, 0)):
    modelo = ARIMA(df[coluna], order=ordem)
    modelo_fit = modelo.fit()
    previsao = modelo_fit.forecast(steps=24)[0]  # Prever próximas 24 horas
    previsao_df = pd.DataFrame(previsao, columns=[f'{coluna}_arima_forecast'], index=pd.date_range(start=df.index[-1], periods=25, freq='H')[1:])
    return previsao_df

# Aplicar o modelo ARIMA às colunas de interesse
inicio_fusao = datetime.now()
forecasts = []
for coluna in ['temperature_C', 'humidity_percent', 'pressure_hPa']:
    forecast_arima = aplicar_arima(df_resampled, coluna)
    forecasts.append(forecast_arima)

# Concatenar previsões no DataFrame original
df_forecast = pd.concat(forecasts, axis=1)

# Adicionar previsões ao DataFrame original reamostrado
df_resampled = df_resampled.join(df_forecast)

fim_fusao = datetime.now()
tempo_fusao = fim_fusao - inicio_fusao

# Armazenar os resultados na coleção correspondente no MongoDB
inicio_armazenamento = datetime.now()
colecao_resultado.insert_many(df_resampled.reset_index().to_dict(orient='records'))
fim_armazenamento = datetime.now()
tempo_armazenamento = fim_armazenamento - inicio_armazenamento

# Armazenar informações sobre a fusão no banco de dados "fusoes"
info_fusao = {
    "nome_fusao": "arima_forecasting",
    "tipo_fusao": "temporal",
    "quantidade_dados_utilizados": df_resampled.shape[0],
    "tempo_fusao_segundos": tempo_fusao.total_seconds(),
    "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
    "data_hora": data_hora_atual  # Adicionando a data e hora atual
}
colecao_fusoes.insert_one(info_fusao)

print("Fusão temporal ARIMA statsmodels concluída e resultados armazenados na coleção:", nome_colecao)
