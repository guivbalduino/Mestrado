import socket
from pymongo import MongoClient
from sktime.forecasting.arima import ARIMA
from sktime.forecasting.base import ForecastingHorizon
import pandas as pd
from datetime import datetime
import itertools


# Definições dos parâmetros
parametros_gerais = {
    "arima_order": [(1, 1, 1), (2, 1, 1), (1, 0, 1)],
    "freq_resample": ["H"],
    "interpolacao": [True],
    "seasonal_order": [(0, 0, 0, 0)],
    "method": ["lbfgs"],
    "maxiter": [50, 100],
    "scoring": ["mse", "mae"],
    "trend": ['c', 't'],
    "with_intercept": [False],
    "enforce_stationarity": [False],
    "enforce_invertibility": [False],
    "simple_differencing": [True],
    "mle_regression": [False],
    "hamilton_representation": [False],
    "concentrate_scale": [False],
}

# Função para gerar todas as combinações
combinacoes = itertools.product(
    parametros_gerais["arima_order"],
    parametros_gerais["freq_resample"],
    parametros_gerais["interpolacao"],
    parametros_gerais["seasonal_order"],
    parametros_gerais["method"],
    parametros_gerais["maxiter"],
    parametros_gerais["scoring"],
    parametros_gerais["trend"],
    parametros_gerais["with_intercept"],
    parametros_gerais["enforce_stationarity"],
    parametros_gerais["enforce_invertibility"],
    parametros_gerais["simple_differencing"],
    parametros_gerais["mle_regression"],
    parametros_gerais["hamilton_representation"],
    parametros_gerais["concentrate_scale"],
)

# Parâmetros ARIMA
start_params = None
suppress_warnings = (False,)
out_of_sample_size = 0
scoring_args = None
time_varying_regression = False
measurement_error = False

# Função para aplicar o modelo ARIMA a uma coluna específica
def aplicar_arima(df, coluna, arima_order, seasonal_order, start_params, method, maxiter, suppress_warnings, out_of_sample_size, scoring, scoring_args, trend, with_intercept, time_varying_regression, enforce_stationarity, enforce_invertibility, simple_differencing, measurement_error, mle_regression, hamilton_representation, concentrate_scale):
    y = df[coluna]
    fh = ForecastingHorizon(y.index, is_relative=False)  # Horizonte de previsão
    forecaster = ARIMA(order=arima_order, seasonal_order=seasonal_order, start_params=start_params, method=method, maxiter=maxiter, suppress_warnings=suppress_warnings, out_of_sample_size=out_of_sample_size, scoring=scoring, scoring_args=scoring_args, trend=trend, with_intercept=with_intercept, time_varying_regression=time_varying_regression, enforce_stationarity=enforce_stationarity, enforce_invertibility=enforce_invertibility, simple_differencing=simple_differencing, measurement_error=measurement_error, mle_regression=mle_regression, hamilton_representation=hamilton_representation, concentrate_scale=concentrate_scale)
    forecaster.fit(y)
    return forecaster.predict(fh)



def run_temp_sk_arima():
    for combinacao in combinacoes:

        (
        arima_order,
        freq_resample,
        interpolacao,
        seasonal_order,
        method,
        maxiter,
        scoring,
        trend,
        with_intercept,
        enforce_stationarity,
        enforce_invertibility,
        simple_differencing,
        mle_regression,
        hamilton_representation,
        concentrate_scale,
        ) = combinacao

        # Obter o nome do computador
        hostname = socket.gethostname()

        # Conectando ao MongoDB
        client = MongoClient("localhost", 27017)
        db = client["dados"]  # Banco de dados

        # Obtenha a data e hora atual
        data_hora_atual = datetime.now()

        # Crie o nome da coleção com base na data e hora atual
        nome_colecao = "fusao_temp_arima_sktime_" + data_hora_atual.strftime("%Y-%m-%d_%H:%M-%S")

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




        inicio_fusao = datetime.now()

        # Aplicar o modelo ARIMA às colunas de interesse
        resultados_arima = {}
        for coluna in ["temperature_C", "humidity_percent", "pressure_hPa","PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"]:
            previsoes = aplicar_arima(df_resampled, coluna,arima_order, seasonal_order, start_params, method, maxiter, suppress_warnings, out_of_sample_size, scoring, scoring_args, trend, with_intercept, time_varying_regression, enforce_stationarity, enforce_invertibility, simple_differencing, measurement_error, mle_regression, hamilton_representation, concentrate_scale)
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
    print("===Acabou temp sk arima===")  