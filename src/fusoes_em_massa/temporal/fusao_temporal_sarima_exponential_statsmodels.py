import socket
from pymongo import MongoClient
from statsmodels.tsa.statespace.sarimax import SARIMAX
from statsmodels.tsa.holtwinters import ExponentialSmoothing
import pandas as pd
from datetime import datetime

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



# Função para aplicar o modelo SARIMA a uma coluna específica
def aplicar_sarima(df, coluna,order, seasonal_order, exog, trend, measurement_error, time_varying_regression, mle_regression, simple_differencing, enforce_stationarity, enforce_invertibility, hamilton_representation, concentrate_scale, trend_offset, use_exact_diffuse, dates, freq, missing, validate_specification):
    y = df[coluna]
    model = SARIMAX(
        y,
        order=order,
        seasonal_order=seasonal_order,
        exog=exog,
        trend=trend,
        measurement_error=measurement_error,
        time_varying_regression=time_varying_regression,
        mle_regression=mle_regression,
        simple_differencing=simple_differencing,
        enforce_stationarity=enforce_stationarity,
        enforce_invertibility=enforce_invertibility,
        hamilton_representation=hamilton_representation,
        concentrate_scale=concentrate_scale,
        trend_offset=trend_offset,
        use_exact_diffuse=use_exact_diffuse,
        dates=dates,
        freq=freq,
        missing=missing,
        validate_specification=validate_specification,
    )
    model_fit = model.fit(disp=False)
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


def run_temp_stats_sarima_ex():

    # Definições dos parâmetros
    freq_resample_options = ["H"]  # Frequências para reamostragem
    interpolacao_options = [True]  # Interpolação ou não
    order_options = [(1, 1, 1), (2, 1, 1), (1, 2, 1)]  # Ordens para ARIMA
    seasonal_order_options = [
        (1, 1, 0, 24),
        (0, 1, 1, 24),
        (1, 0, 1, 24),
    ]  # Ordens sazonais
    exog = None  # Variáveis exógenas
    trend_options = ['t','c','n']  # Tendências
    measurement_error = True  # Erro de medição
    time_varying_regression = False  # Regressão variável no tempo
    mle_regression = True  # Usar regressão MLE
    simple_differencing = False  # Diferenciação simples
    enforce_stationarity = False  # Forçar estacionariedade
    enforce_invertibility = False  # Forçar invertibilidade
    hamilton_representation = False  # Representação de Hamilton
    concentrate_scale = False  # Concentrar escala
    trend_offset_options = [1]  # Deslocamento de tendência
    use_exact_diffuse = False  # Usar difusão exata
    dates = None  # Exemplos de datas
    freq = "H"  # Frequências de séries temporais
    missing = "none"  # Métodos para dados ausentes
    validate_specification = False  # Validar especificação do modelo

    # Loop aninhado para percorrer todas as combinações de parâmetros
    for freq_resample in freq_resample_options:
        for interpolacao in interpolacao_options:
            for order in order_options:
                for seasonal_order in seasonal_order_options:
                    for trend in trend_options:
                        for trend_offset in trend_offset_options:

                            # Obter o nome do computador
                            hostname = socket.gethostname()

                            # Conectando ao MongoDB
                            client = MongoClient("localhost", 27017)
                            db = client["dados"]  # Banco de dados

                            # Obtenha a data e hora atual
                            data_hora_atual = datetime.now()

                            # Crie o nome da coleção com base na data e hora atual
                            nome_colecao = (
                                "fusao_temp_sarima_es_statsmodels_"
                                + data_hora_atual.strftime("%Y-%m-%d_%H:%M-%S")
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
                                "PRECIPITAÇÃO TOTAL, HORÁRIO (mm)": 1,
                            }

                            dados_inmet = list(colecao_inmet.find({}, projecao))
                            dados_libelium = list(colecao_libelium.find({}, projecao))

                            # Converter para DataFrames
                            df_inmet = pd.DataFrame(dados_inmet)
                            df_libelium = pd.DataFrame(dados_libelium)

                            # Concatenar os DataFrames
                            df_concatenado = pd.concat(
                                [df_inmet, df_libelium], ignore_index=True
                            )

                            # Transformar a coluna de timestamp para datetime
                            df_concatenado["timestamp"] = pd.to_datetime(
                                df_concatenado["timestamp"]
                            )

                            # Resample dos dados para uma frequência uniforme
                            df_resampled = (
                                df_concatenado.set_index("timestamp")
                                .resample(freq_resample)
                                .mean()
                            )

                            # Tratar valores ausentes com base no tipo de tratamento
                            if interpolacao:
                                # Interpolar os valores ausentes para preencher a frequência
                                df_resampled.interpolate(method="time", inplace=True)

                            # Sempre remover valores ausentes para garantir a integridade dos dados
                            df_resampled.dropna(inplace=True)

                            
                            inicio_fusao = datetime.now()

                            # Aplicar o modelo SARIMA às colunas de interesse
                            resultados_sarima = {}
                            for coluna in [
                                "temperature_C",
                                "humidity_percent",
                                "pressure_hPa",
                                "PRECIPITAÇÃO TOTAL, HORÁRIO (mm)",
                            ]:
                                previsoes = aplicar_sarima(df_resampled, coluna, order, seasonal_order, exog, trend, measurement_error, time_varying_regression, mle_regression, simple_differencing, enforce_stationarity, enforce_invertibility, hamilton_representation, concentrate_scale, trend_offset, use_exact_diffuse, dates, freq, missing, validate_specification)
                                resultados_sarima[coluna] = previsoes

                            # Criar um DataFrame com as previsões ajustadas pelo SARIMA
                            df_resultados_sarima = pd.DataFrame(
                                resultados_sarima, index=df_resampled.index
                            )

                            # Remover linhas com valores NaN antes de aplicar Exponential Smoothing
                            df_resultados_sarima.dropna(inplace=True)

                            # Aplicar o modelo de Suavização Exponencial às previsões do SARIMA
                            resultados_es = {}
                            for coluna in df_resultados_sarima.columns:
                                previsoes_es = aplicar_exponential_smoothing(
                                    df_resultados_sarima[coluna]
                                )
                                resultados_es[coluna] = previsoes_es

                            # Criar um DataFrame com as previsões ajustadas pelo Exponential Smoothing
                            df_resultados_es = pd.DataFrame(
                                resultados_es, index=df_resultados_sarima.index
                            )

                            fim_fusao = datetime.now()
                            tempo_fusao = fim_fusao - inicio_fusao

                            inicio_armazenamento = datetime.now()

                            # Armazenar os resultados combinados na coleção correspondente no MongoDB
                            colecao_resultado.insert_many(
                                df_resultados_es.reset_index().to_dict(orient="records")
                            )

                            fim_armazenamento = datetime.now()
                            tempo_armazenamento = fim_armazenamento - inicio_armazenamento

                            # Armazenar informações sobre a modelagem no banco de dados "fusoes"
                            info_modelagem = {
                                "nome_modelagem": "sarima_es_statsmodels",
                                "tipo_modelagem": "temporal",
                                "quantidade_dados_utilizados": df_resampled.shape[0],
                                "tempo_modelagem_segundos": tempo_fusao.total_seconds(),
                                "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
                                "data_hora": data_hora_atual,
                                "sarima_order": order,
                                "seasonal_order": seasonal_order,
                                "freq_resample": freq_resample,
                                "interpolacao": interpolacao,
                                "hostname": hostname,
                                "exog": exog,
                                "trend": trend,
                                "measurement_error": measurement_error,
                                "time_varying_regression": time_varying_regression,
                                "mle_regression": mle_regression,
                                "simple_differencing": simple_differencing,
                                "enforce_stationarity": enforce_stationarity,
                                "enforce_invertibility": enforce_invertibility,
                                "hamilton_representation": hamilton_representation,
                                "concentrate_scale": concentrate_scale,
                                "trend_offset": trend_offset,
                                "use_exact_diffuse": use_exact_diffuse,
                                "dates": dates,
                                "freq": freq,
                                "missing": missing,
                                "validate_specification": validate_specification,
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
                                "Previsões SARIMA com Exponential Smoothing ajustadas armazenadas na coleção:",
                                nome_colecao,
                            )
    print("===Acabou temp stats sarima ex===")
