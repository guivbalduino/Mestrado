import socket
from pymongo import MongoClient
from sktime.forecasting.arima import ARIMA
from sktime.forecasting.base import ForecastingHorizon
import pandas as pd
from datetime import datetime

# Definições dos parâmetros arima
arima_order = (5, 1, 0)
freq_resample = "D"
interpolacao = True
seasonal_order=(0, 0, 0, 0)
start_params=None
method='lbfgs'
maxiter=50
suppress_warnings=False, 
out_of_sample_size=0
scoring='mse'
scoring_args=None
trend=None
with_intercept=True
time_varying_regression=False
enforce_stationarity=True
enforce_invertibility=True
simple_differencing=False
measurement_error=False
mle_regression=True
hamilton_representation=False
concentrate_scale=False

# Obter o nome do computador
hostname = socket.gethostname()

# Conectando ao MongoDB
client = MongoClient("localhost", 27017)
db = client["dados"]  # Banco de dados

# Obtenha a data e hora atual
data_hora_atual = datetime.now()

# Crie o nome da coleção com base na data e hora atual
nome_colecao = "fusao_temp_arima_sktime_" + data_hora_atual.strftime("%Y-%m-%d_%H:%M")

# Coleção para armazenar os resultados
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
    fh = ForecastingHorizon(y.index, is_relative=False)  # Horizonte de previsão
    forecaster = ARIMA(order=arima_order, seasonal_order=seasonal_order, start_params=start_params, method=method, maxiter=maxiter, suppress_warnings=suppress_warnings, out_of_sample_size=out_of_sample_size, scoring=scoring, scoring_args=scoring_args, trend=trend, with_intercept=with_intercept, time_varying_regression=time_varying_regression, enforce_stationarity=enforce_stationarity, enforce_invertibility=enforce_invertibility, simple_differencing=simple_differencing, measurement_error=measurement_error, mle_regression=mle_regression, hamilton_representation=hamilton_representation, concentrate_scale=concentrate_scale)
    forecaster.fit(y)
    return forecaster.predict(fh)


inicio_fusao = datetime.now()

# Aplicar o modelo ARIMA às colunas de interesse
resultados_arima = {}
for coluna in ["temperature_C", "humidity_percent", "pressure_hPa","PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"]:
    previsoes = aplicar_arima(df_resampled, coluna)
    resultados_arima[coluna] = previsoes

# Criar um DataFrame com as previsões ajustadas
df_resultados = pd.DataFrame(resultados_arima, index=df_resampled.index)

# Remover linhas com valores NaN antes de salvar
df_resultados.dropna(inplace=True)

fim_fusao = datetime.now()
tempo_fusao = fim_fusao - inicio_fusao
inicio_armazenamento = datetime.now()

# Armazenar os resultados na coleção correspondente no MongoDB
colecao_resultado.insert_many(df_resultados.reset_index().to_dict(orient="records"))
fim_armazenamento = datetime.now()
tempo_armazenamento = fim_armazenamento - inicio_armazenamento
# Armazenar informações sobre a modelagem no banco de dados "fusoes"
info_modelagem = {
    "nome_modelagem": "arima_sktime",
    "tipo_modelagem": "temporal",
    "quantidade_dados_utilizados": df_resampled.shape[0],
    "tempo_modelagem_segundos": tempo_fusao.total_seconds(),  
    "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),  
    "data_hora": data_hora_atual,
    "arima_order": arima_order,
    "freq_resample": freq_resample,
    "interpolacao": interpolacao,
    "hostname": hostname,
    "seasonal_order":seasonal_order,
    "start_params":start_params,
    "method":method,
    "maxiter":maxiter,
    "suppress_warnings":suppress_warnings, 
    "out_of_sample_size":out_of_sample_size,
    "scoring":scoring,
    "scoring_args":scoring_args,
    "trend":trend,
    "with_intercept":with_intercept,
    "time_varying_regression":time_varying_regression,
    "enforce_stationarity":enforce_stationarity,
    "enforce_invertibility":enforce_invertibility,
    "simple_differencing":simple_differencing,
    "measurement_error":measurement_error,
    "mle_regression":mle_regression,
    "hamilton_representation":hamilton_representation,
    "concentrate_scale":concentrate_scale
}
colecao_fusoes.insert_one(info_modelagem)

print("Previsões ARIMA ajustadas armazenadas na coleção:", nome_colecao)
