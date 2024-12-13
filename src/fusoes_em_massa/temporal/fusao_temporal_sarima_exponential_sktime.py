import socket
from pymongo import MongoClient
from sktime.forecasting.sarimax import SARIMAX
from sktime.forecasting.exp_smoothing import ExponentialSmoothing
from sktime.forecasting.base import ForecastingHorizon
import pandas as pd
from datetime import datetime

# Definições dos parâmetros es
es_trend = "add"
es_damped_trend = False
es_seasonal = "add"
es_sp = 24
es_initial_level = None
es_initial_trend = None
es_initial_seasonal = None
es_use_boxcox = None
es_initialization_method = "estimated"
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


# Função para aplicar o modelo SARIMA a uma coluna específica usando sktime
def aplicar_sarima(
    df,
    coluna,
    order,
    seasonal_order,
    trend,
    measurement_error,
    time_varying_regression,
    mle_regression,
    simple_differencing,
    enforce_stationarity,
    enforce_invertibility,
    hamilton_representation,
    concentrate_scale,
    trend_offset,
    use_exact_diffuse,
    dates,
    freq,
    missing,
    validate_specification,
    disp,
    random_state,
    start_params,
    transformed,
    includes_fixed,
    cov_type,
    cov_kwds,
    method,
    maxiter,
    full_output,
    callback,
    return_params,
    optim_score,
    optim_complex_step,
    optim_hessian,
    low_memory,
):
    y = df[coluna]
    forecaster = SARIMAX(
        order=order,
        seasonal_order=seasonal_order,
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
        disp=disp,
        random_state=random_state,
        start_params=start_params,
        transformed=transformed,
        includes_fixed=includes_fixed,
        cov_type=cov_type,
        cov_kwds=cov_kwds,
        method=method,
        maxiter=maxiter,
        full_output=full_output,
        callback=callback,
        return_params=return_params,
        optim_score=optim_score,
        optim_complex_step=optim_complex_step,
        optim_hessian=optim_hessian,
        low_memory=low_memory,
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


def run_temp_sk_sarima_ex():
    # Definições dos parâmetros
    trend_offset = 1
    use_exact_diffuse = False
    dates = None
    freq = None

    # Definições dos parâmetros
    freq_resample_options = ["D"]  # Frequência de reamostragem
    interpolacao_options = [True]  # Usar interpolação ou não
    order_options = [(1, 1, 1), (2, 1, 1), (1, 0, 1)]  # Ordens para ARIMA
    seasonal_order_options = [
        (1, 1, 0, 12),
        (0, 1, 1, 24),
        (1, 0, 1, 24),
    ]  # Ordens sazonais
    trend_options = ["c", "t", "n"]  # C para constante, t para tendência, n para nenhum
    measurement_error = True
    time_varying_regression = True
    mle_regression = False
    simple_differencing = True
    enforce_stationarity = False
    enforce_invertibility = False
    hamilton_representation = False
    concentrate_scale = False
    missing = "none"
    validate_specification = False
    disp = False
    random_state = 42  # Exemplo de semente aleatória
    start_params = None  # Exemplos de parâmetros iniciais
    transformed = False
    includes_fixed = False
    cov_type = None
    cov_kwds = None
    method = "lbfgs"
    maxiter_options = [50, 100]  # Exemplos de iterações máximas
    full_output = 0
    callback = None
    return_params = False
    optim_score = "mse"
    optim_complex_step = True
    optim_hessian = True
    low_memory = True

    # Loop aninhado para percorrer as combinações de parâmetros
    for freq_resample in freq_resample_options:
        for interpolacao in interpolacao_options:
            for order in order_options:
                for seasonal_order in seasonal_order_options:
                    for trend in trend_options:

                        for maxiter in maxiter_options:
                            # Obter o nome do computador
                            hostname = socket.gethostname()

                            # Conectando ao MongoDB
                            client = MongoClient("localhost", 27017)
                            db = client["dados"]  # Banco de dados

                            # Obtenha a data e hora atual
                            data_hora_atual = datetime.now()

                            # Crie o nome da coleção com base na data e hora atual
                            nome_colecao = (
                                "fusao_temp_sarima_es_sktime_"
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
                                previsoes = aplicar_sarima(
                                    df_resampled,
                                    coluna,
                                    order,
                                    seasonal_order,
                                    trend,
                                    measurement_error,
                                    time_varying_regression,
                                    mle_regression,
                                    simple_differencing,
                                    enforce_stationarity,
                                    enforce_invertibility,
                                    hamilton_representation,
                                    concentrate_scale,
                                    trend_offset,
                                    use_exact_diffuse,
                                    dates,
                                    freq,
                                    missing,
                                    validate_specification,
                                    disp,
                                    random_state,
                                    start_params,
                                    transformed,
                                    includes_fixed,
                                    cov_type,
                                    cov_kwds,
                                    method,
                                    maxiter,
                                    full_output,
                                    callback,
                                    return_params,
                                    optim_score,
                                    optim_complex_step,
                                    optim_hessian,
                                    low_memory,
                                )
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
                            tempo_armazenamento = (
                                fim_armazenamento - inicio_armazenamento
                            )

                            # Armazenar informações sobre a modelagem no banco de dados "fusoes"
                            info_modelagem = {
                                "nome_modelagem": "sarima_es_sktime",
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
                                "disp": disp,
                                "random_state": random_state,
                                "start_params": start_params,
                                "transformed": transformed,
                                "includes_fixed": includes_fixed,
                                "cov_type": cov_type,
                                "cov_kwds": cov_kwds,
                                "method": method,
                                "maxiter": maxiter,
                                "full_output": full_output,
                                "callback": callback,
                                "return_params": return_params,
                                "optim_score": optim_score,
                                "optim_complex_step": optim_complex_step,
                                "optim_hessian": optim_hessian,
                                "low_memory": low_memory,
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
                                "Previsões SARIMA com Exponential Smoothing ajustadas armazenadas na coleção:",
                                nome_colecao,
                            )
    print("===Acabou temp sk sarima ex===")
