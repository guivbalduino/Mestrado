from pymongo import MongoClient
from prophet import Prophet
import pandas as pd
from datetime import datetime
import socket

# Função para aplicar o modelo Prophet a uma coluna específica
def aplicar_prophet(df, coluna, periods, freq):
    df_prophet = df[['timestamp', coluna]].rename(columns={'timestamp': 'ds', coluna: 'y'})
    modelo = Prophet()
    modelo.fit(df_prophet)
    future = modelo.make_future_dataframe(periods=periods, freq=freq)  
    forecast = modelo.predict(future)
    return forecast[['ds', 'yhat']].rename(columns={'ds': 'timestamp', 'yhat': f'{coluna}_forecast'})

def run_temp_prophet():
    # Definições dos parâmetros Prophet
    periods_options = [24, 48, 72]  # Exemplos de períodos para previsão (em horas)
    freq_options = ['H', 'D', 'W']  # Frequências: Horária, Diária, Semanal

    # Loop aninhado para percorrer diferentes combinações de parâmetros
    for periods in periods_options:
        for freq in freq_options:


            # Obter o nome do computador
            hostname = socket.gethostname()
            # Conectando ao MongoDB
            client = MongoClient('localhost', 27017)
            db = client['dados']  # Banco de dados

            # Obtenha a data e hora atual
            data_hora_atual = datetime.now()

            # Crie o nome da coleção com base na data e hora atual
            nome_colecao = "fusao_temp_prophet_" + data_hora_atual.strftime("%Y-%m-%d_%H:%M-%S")

            # Coleção para armazenar os resultados
            colecao_resultado = db[nome_colecao]

            # Coleção para armazenar as informações sobre as fusões
            colecao_fusoes = db['fusoes']

            # Coleções de dados originais
            colecao_inmet = db['inmet']
            colecao_libelium = db['libelium']

            # Projetar e recuperar apenas as colunas necessárias para cada coleção
            projecao = {"timestamp": 1, "temperature_C": 1, "humidity_percent": 1, "pressure_hPa": 1,
                "PRECIPITAÇÃO TOTAL, HORÁRIO (mm)": 1}

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

            # Remover linhas com valores ausentes
            df_resampled.dropna(inplace=True)


            # Aplicar o modelo Prophet às colunas de interesse
            inicio_fusao = datetime.now()
            forecasts = []
            for coluna in ['temperature_C', 'humidity_percent', 'pressure_hPa',"PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"]:
                forecast = aplicar_prophet(df_resampled.reset_index(), coluna, periods, freq)
                forecasts.append(forecast.set_index('timestamp'))

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
                "nome_fusao": "prophet_forecasting",
                "tipo_fusao": "temporal",
                "quantidade_dados_utilizados": df_resampled.shape[0],
                "tempo_fusao_segundos": tempo_fusao.total_seconds(),
                "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
                "data_hora": data_hora_atual,  # Adicionando a data e hora atual
                "prophet_params": {
                    "periods": 24,
                    "freq": 'H',
                },
                "hostname": hostname
            }
            colecao_fusoes.insert_one(info_fusao)

            print("Fusão temporal Prophet concluída e resultados armazenados na coleção:", nome_colecao)

    print("===Acabou temp prophet===")  