import socket
from pymongo import MongoClient
from sktime.forecasting.sarimax import SARIMAX
from sktime.forecasting.base import ForecastingHorizon
import pandas as pd
from datetime import datetime


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
    fh = ForecastingHorizon(y.index, is_relative=False)  # Horizonte de previsão
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
    return forecaster.predict(fh)


def run_temp_sk_sarima():
    # Definições dos parâmetros
    freq_resample_options = ["H"]  # Frequência de reamostragem
    interpolacao_options = [True]  # Usar interpolação ou não
    order_options = [(1, 1, 1), (2, 1, 1), (1, 0, 1)]  # Ordens para ARIMA
    seasonal_order_options = [
        (1, 0, 0, 24),
        (0, 1, 0, 24),
        (0, 0, 1, 24),
        (1, 1, 1, 24),
    ]  # Ordens sazonais
    trend_options = ["c"]  # C para constante, t para tendência, n para nenhum
    measurement_error = True
    time_varying_regression = False
    mle_regression = True
    simple_differencing = False
    enforce_stationarity = False
    enforce_invertibility = False
    hamilton_representation = False
    concentrate_scale = True
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
    optim_score_options = [None]
    optim_complex_step = None
    optim_hessian = True
    low_memory = True
    trend_offset = 1
    use_exact_diffuse = False
    dates = None
    freq = None

    # Loop aninhado para percorrer as combinações de parâmetros
    for freq_resample in freq_resample_options:
        for interpolacao in interpolacao_options:
            for order in order_options:
                for seasonal_order in seasonal_order_options:
                    for trend in trend_options:
                        for optim_score in optim_score_options:
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
                                    "fusao_temp_sarima_sktime_"
                                    + data_hora_atual.strftime("%Y-%m-%d_%H:%M-%S")
                                )

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

                                # Criar um DataFrame com as previsões ajustadas
                                df_resultados = pd.DataFrame(
                                    resultados_sarima, index=df_resampled.index
                                )

                                # Remover linhas com valores NaN antes de salvar
                                df_resultados.dropna(inplace=True)

                                fim_fusao = datetime.now()
                                tempo_fusao = fim_fusao - inicio_fusao
                                inicio_armazenamento = datetime.now()

                                # Armazenar os resultados na coleção correspondente no MongoDB
                                colecao_resultado.insert_many(
                                    df_resultados.reset_index().to_dict(orient="records")
                                )

                                fim_armazenamento = datetime.now()
                                tempo_armazenamento = (
                                    fim_armazenamento - inicio_armazenamento
                                )

                                # Armazenar informações sobre a modelagem no banco de dados "fusoes"
                                info_modelagem = {
                                    "nome_modelagem": "sarima_sktime",
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
                                }
                                colecao_fusoes.insert_one(info_modelagem)

                                print(
                                    "Previsões SARIMA ajustadas armazenadas na coleção:",
                                    nome_colecao,
                                )
    print("===Acabou temp sk sarima===")
