import socket
from pymongo import MongoClient
from sktime.forecasting.arima import ARIMA
from sktime.forecasting.exp_smoothing import ExponentialSmoothing
from sktime.forecasting.base import ForecastingHorizon
import pandas as pd
from datetime import datetime

# Definições dos parâmetros arima
arima_order = (1, 1, 1)
freq_resample = "D"
interpolacao = True
seasonal_order = (0, 0, 0, 0)
start_params = None
method = "lbfgs"
maxiter = 50
suppress_warnings = (False,)
out_of_sample_size = 0
scoring = "mse"
scoring_args = None
trend = None
with_intercept = True
time_varying_regression = False
enforce_stationarity = True
enforce_invertibility = True
simple_differencing = False
measurement_error = False
mle_regression = True
hamilton_representation = False
concentrate_scale = False

# Definições dos parâmetros es
es_trend = 'add'
es_damped_trend = False
es_seasonal = 'add'
es_sp = 24
es_initial_level = None
es_initial_trend = None
es_initial_seasonal = None
es_use_boxcox = None
es_initialization_method = 'estimated'
es_smoothing_level = None
es_smoothing_trend = None
es_smoothing_seasonal = None
es_damping_trend = None
es_optimized = True
es_remove_bias = False
es_start_params = None
es_method = None
es_minimize_kwargs = None
es_use_brute = True
es_random_state = None

# Obter o nome do computador
hostname = socket.gethostname()

# Conectando ao MongoDB
client = MongoClient("localhost", 27017)
db = client["dados"]  # Banco de dados

# Obtenha a data e hora atual
data_hora_atual = datetime.now()

# Crie o nome da coleção com base na data e hora atual
nome_colecao = "fusao_temp_arima_es_sktime_" + data_hora_atual.strftime(
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


# Função para aplicar o modelo ARIMA a uma coluna específica usando sktime
def aplicar_arima(df, coluna):
    y = df[coluna]
    forecaster = ARIMA(
        order=arima_order,
        seasonal_order=seasonal_order,
        start_params=start_params,
        method=method,
        maxiter=maxiter,
        suppress_warnings=suppress_warnings,
        out_of_sample_size=out_of_sample_size,
        scoring=scoring,
        scoring_args=scoring_args,
        trend=trend,
        with_intercept=with_intercept,
        time_varying_regression=time_varying_regression,
        enforce_stationarity=enforce_stationarity,
        enforce_invertibility=enforce_invertibility,
        simple_differencing=simple_differencing,
        measurement_error=measurement_error,
        mle_regression=mle_regression,
        hamilton_representation=hamilton_representation,
        concentrate_scale=concentrate_scale,
    )
    forecaster.fit(y)
    fh = ForecastingHorizon(y.index, is_relative=False)
    return forecaster.predict(fh)


# Função para aplicar o modelo de Suavização Exponencial a uma série temporal usando sktime
def aplicar_exponential_smoothing(y):
    forecaster = ExponentialSmoothing(
        trend=es_trend,
        damped_trend=es_damped_trend,
        seasonal=es_seasonal,
        sp=es_sp,
        initial_level=es_initial_level,
        initial_trend=es_initial_trend,
        initial_seasonal=es_initial_seasonal,
        use_boxcox=es_use_boxcox,
        initialization_method=es_initialization_method,
        smoothing_level=es_smoothing_level,
        smoothing_trend=es_smoothing_trend,
        smoothing_seasonal=es_smoothing_seasonal,
        damping_trend=es_damping_trend,
        optimized=es_optimized,
        remove_bias=es_remove_bias,
        start_params=es_start_params,
        method=es_method,
        minimize_kwargs=es_minimize_kwargs,
        use_brute=es_use_brute,
        random_state=es_random_state,
    )
    forecaster.fit(y)
    fh = ForecastingHorizon(y.index, is_relative=False)
    return forecaster.predict(fh)


inicio_fusao = datetime.now()

# Aplicar o modelo ARIMA às colunas de interesse
resultados_arima = {}
for coluna in ["temperature_C", "humidity_percent", "pressure_hPa"]:
    previsoes = aplicar_arima(df_resampled, coluna)
    resultados_arima[coluna] = previsoes

# Criar um DataFrame com as previsões ajustadas pelo ARIMA
df_resultados_arima = pd.DataFrame(resultados_arima, index=df_resampled.index)

# Remover linhas com valores NaN antes de aplicar Exponential Smoothing
df_resultados_arima.dropna(inplace=True)

# Aplicar o modelo de Suavização Exponencial às previsões do ARIMA
resultados_es = {}
for coluna in df_resultados_arima.columns:
    previsoes_es = aplicar_exponential_smoothing(df_resultados_arima[coluna])
    resultados_es[coluna] = previsoes_es

# Criar um DataFrame com as previsões ajustadas pelo Exponential Smoothing
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
    "nome_modelagem": "arima_es_sktime",
    "tipo_modelagem": "temporal",
    "quantidade_dados_utilizados": df_resampled.shape[0],
    "tempo_modelagem_segundos": tempo_fusao.total_seconds(),
    "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
    "data_hora": data_hora_atual,
    "arima_order": arima_order,
    "freq_resample": freq_resample,
    "interpolacao": interpolacao,
    "hostname": hostname,
    "seasonal_order": seasonal_order,
    "start_params": start_params,
    "method": method,
    "maxiter": maxiter,
    "suppress_warnings": suppress_warnings,
    "out_of_sample_size": out_of_sample_size,
    "scoring": scoring,
    "scoring_args": scoring_args,
    "trend": trend,
    "with_intercept": with_intercept,
    "time_varying_regression": time_varying_regression,
    "enforce_stationarity": enforce_stationarity,
    "enforce_invertibility": enforce_invertibility,
    "simple_differencing": simple_differencing,
    "measurement_error": measurement_error,
    "mle_regression": mle_regression,
    "hamilton_representation": hamilton_representation,
    "concentrate_scale": concentrate_scale,
    # es
    "trend": es_trend,
    "damped_trend": es_damped_trend,
    "seasonal": es_seasonal,
    "sp": es_sp,
    "initial_level": es_initial_level,
    "initial_trend": es_initial_trend,
    "initial_seasonal": es_initial_seasonal,
    "use_boxcox": es_use_boxcox,
    "initialization_method": es_initialization_method,
    "smoothing_level": es_smoothing_level,
    "smoothing_trend": es_smoothing_trend,
    "smoothing_seasonal": es_smoothing_seasonal,
    "damping_trend": es_damping_trend,
    "optimized": es_optimized,
    "remove_bias": es_remove_bias,
    "start_params": es_start_params,
    "method": es_method,
    "minimize_kwargs": es_minimize_kwargs,
    "use_brute": es_use_brute,
    "random_state": es_random_state,
}
colecao_fusoes.insert_one(info_modelagem)

print(
    "Previsões ARIMA com Exponential Smoothing ajustadas armazenadas na coleção:",
    nome_colecao,
)
