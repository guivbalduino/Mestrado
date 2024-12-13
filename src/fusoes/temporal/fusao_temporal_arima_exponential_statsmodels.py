import socket
from pymongo import MongoClient
from statsmodels.tsa.arima.model import ARIMA
from statsmodels.tsa.holtwinters import ExponentialSmoothing
import pandas as pd
from datetime import datetime

# Definições dos parâmetros
freq_resample = "H"
interpolacao = True
order = (5, 1, 0)
exog = None
dates = None
freq = None
missing = "none"

# Definições dos parâmetros es
es_trend = "add"
es_damped_trend = False
es_seasonal = "add"
es_seasonal_periods = 24
es_initialization_method = "estimated"
es_initial_level = None
es_initial_trend = None
es_initial_seasonal = None
es_use_boxcox = False
es_bounds = None
es_dates = None
es_freq = None
es_missing = "none"

# Obter o nome do computador
hostname = socket.gethostname()

# Conectando ao MongoDB
client = MongoClient("localhost", 27017)
db = client["dados"]  # Banco de dados

# Obtenha a data e hora atual
data_hora_atual = datetime.now()

# Crie o nome da coleção com base na data e hora atual
nome_colecao = "fusao_temp_arima_es_statsmodels_" + data_hora_atual.strftime(
    "%Y-%m-%d_%H:%M"
)

# Coleções para armazenar os resultados
colecao_resultado = db[nome_colecao]

# Coleção para armazenar as informações sobre as fusões
colecao_fusoes = db["fusoes"]

# Coleções de dados originais
colecao_inmet = db["inmet"]
colecao_libelium = db["libelium"]

# Projetar e recuperar apenas as colunas necessárias para cada coleção
projecao = {
    "timestamp": 1,
    "temperature_C": 1,
    "humidity_percent": 1,
    "pressure_hPa": 1,
    "PRECIPITAÇÃO TOTAL, HORÁRIO (mm)": 1
}

dados_inmet = list(colecao_inmet.find({}, projecao))
dados_libelium = list(colecao_libelium.find({}, projecao))

# Converter para DataFrames
df_inmet = pd.DataFrame(dados_inmet)
df_libelium = pd.DataFrame(dados_libelium)

# Concatenar os DataFrames
df_concatenado = pd.concat([df_inmet, df_libelium], ignore_index=True)

# Transformar a coluna de timestamp para datetime
df_concatenado["timestamp"] = pd.to_datetime(df_concatenado["timestamp"])

# Resample dos dados para uma frequência uniforme
df_resampled = df_concatenado.set_index("timestamp").resample(freq_resample).mean()

# Tratar valores ausentes com base no tipo de tratamento
if interpolacao:
    # Interpolar os valores ausentes para preencher a frequência
    df_resampled.interpolate(method="time", inplace=True)

# Sempre remover valores ausentes para garantir a integridade dos dados
df_resampled.dropna(inplace=True)


# Função para aplicar o modelo ARIMA a uma coluna específica
def aplicar_arima(df, coluna):
    y = df[coluna]
    model = ARIMA(y, order=order, exog=exog, dates=dates, freq=freq, missing=missing)
    model_fit = model.fit()
    return model_fit.predict(start=y.index[0], end=y.index[-1])


# Função para aplicar o modelo de Suavização Exponencial a uma série temporal
def aplicar_exponential_smoothing(y):
    model = ExponentialSmoothing(
        y,
        trend=es_trend,
        damped_trend=es_damped_trend,
        seasonal=es_seasonal,
        seasonal_periods=es_seasonal_periods,
        initialization_method=es_initialization_method,
        initial_level=es_initial_level,
        initial_trend=es_initial_trend,
        initial_seasonal=es_initial_seasonal,
        use_boxcox=es_use_boxcox,
        bounds=es_bounds,
        dates=es_dates,
        freq=es_freq,
        missing=es_missing,
    )
    model_fit = model.fit()
    return model_fit.fittedvalues


inicio_fusao = datetime.now()

# Aplicar o modelo ARIMA às colunas de interesse
resultados_arima = {}
for coluna in ["temperature_C", "humidity_percent", "pressure_hPa","PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"]:
    previsoes = aplicar_arima(df_resampled, coluna)
    resultados_arima[coluna] = previsoes

# Criar um DataFrame com as previsões ajustadas
df_resultados_arima = pd.DataFrame(resultados_arima, index=df_resampled.index)

# Remover linhas com valores NaN antes de aplicar Exponential Smoothing
df_resultados_arima.dropna(inplace=True)

# Aplicar o modelo de Suavização Exponencial às previsões do ARIMA
resultados_es = {}
for coluna in df_resultados_arima.columns:
    previsoes_es = aplicar_exponential_smoothing(df_resultados_arima[coluna])
    resultados_es[coluna] = previsoes_es

# Criar um DataFrame com as previsões ajustadas
df_resultados_es = pd.DataFrame(resultados_es, index=df_resultados_arima.index)

fim_fusao = datetime.now()
tempo_fusao = fim_fusao - inicio_fusao

inicio_armazenamento = datetime.now()

# Armazenar os resultados combinados na coleção correspondente no MongoDB
colecao_resultado.insert_many(df_resultados_es.reset_index().to_dict(orient="records"))

fim_armazenamento = datetime.now()
tempo_armazenamento = fim_armazenamento - inicio_armazenamento

# Armazenar informações sobre a modelagem no banco de dados "fusoes"
info_modelagem = {
    "nome_modelagem": "arima_es_statsmodels",
    "tipo_modelagem": "temporal",
    "quantidade_dados_utilizados": df_resampled.shape[0],
    "tempo_modelagem_segundos": tempo_fusao.total_seconds(),
    "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
    "data_hora": data_hora_atual,
    "arima_order": order,
    "freq_resample": freq_resample,
    "interpolacao": interpolacao,
    "hostname": hostname,
    "exog": exog,
    "dates": dates,
    "freq": freq,
    "missing": missing,
    # es
    "es_trend": es_trend,
    "es_damped_trend": es_damped_trend,
    "es_seasonal": es_seasonal,
    "es_seasonal_periods": es_seasonal_periods,
    "es_initialization_method": es_initialization_method,
    "es_initial_level": es_initial_level,
    "es_initial_trend": es_initial_trend,
    "es_initial_seasonal": es_initial_seasonal,
    "es_use_boxcox": es_use_boxcox,
    "es_bounds": es_bounds,
    "es_dates": es_dates,
    "es_freq": es_freq,
    "es_missing": es_missing,
}
colecao_fusoes.insert_one(info_modelagem)

print(
    "Previsões ARIMA com Exponential Smoothing ajustadas armazenadas na coleção:",
    nome_colecao,
)
