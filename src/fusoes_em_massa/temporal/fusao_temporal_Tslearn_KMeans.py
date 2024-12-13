from pymongo import MongoClient
from tslearn.clustering import TimeSeriesKMeans
from sklearn.preprocessing import StandardScaler
import pandas as pd
import numpy as np
from datetime import datetime
import socket


def run_temp_ts_kmeans():
    # Definições dos parâmetros TimeSeriesKMeans
    n_clusters_options = [3, 5, 7, 10, 50]  # Exemplos de diferentes números de clusters

    # Loop para percorrer diferentes quantidades de clusters
    for n_clusters in n_clusters_options:
            
        # Obter o nome do computador
        hostname = socket.gethostname()
        # Conectando ao MongoDB
        client = MongoClient('localhost', 27017)
        db = client['dados']  # Banco de dados

        # Obtenha a data e hora atual
        data_hora_atual = datetime.now()

        # Crie o nome da coleção com base na data e hora atual
        nome_colecao = "fusao_temp_tslearn_tskmeans_" + data_hora_atual.strftime("%Y-%m-%d_%H:%M-%S")

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

        # Normalização dos dados
        scaler = StandardScaler()
        df_scaled = scaler.fit_transform(df_resampled)

        # Transformar os dados em um array 3D (n_samples, n_timestamps, n_features)
        # Neste caso, tratamos cada coluna como uma série temporal independente
        n_timestamps = df_scaled.shape[0]
        n_features = df_scaled.shape[1]
        df_3d = df_scaled.T.reshape((n_features, n_timestamps, 1))

        # Realizar o clustering usando TimeSeriesKMeans
        inicio_fusao = datetime.now()
        ts_kmeans = TimeSeriesKMeans(n_clusters=n_clusters, metric="euclidean")
        labels = ts_kmeans.fit_predict(df_3d)
        fim_fusao = datetime.now()
        tempo_fusao = fim_fusao - inicio_fusao

        # Adicionar rótulos de cluster ao DataFrame original (resampled DataFrame)
        for i, feature in enumerate(df_resampled.columns):
            df_resampled[f'cluster_label_{feature}'] = labels[i]

        # Armazenar os resultados na coleção correspondente no MongoDB
        inicio_armazenamento = datetime.now()
        colecao_resultado.insert_many(df_resampled.reset_index().to_dict(orient='records'))
        fim_armazenamento = datetime.now()
        tempo_armazenamento = fim_armazenamento - inicio_armazenamento

        # Armazenar informações sobre a fusão no banco de dados "fusoes"
        info_fusao = {
            "nome_fusao": "tslearn_timeserieskmeans",
            "tipo_fusao": "temporal",
            "n_clusters": n_clusters,
            "quantidade_dados_utilizados": n_timestamps,
            "tempo_fusao_segundos": tempo_fusao.total_seconds(),
            "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
            "data_hora": data_hora_atual,  # Adicionando a data e hora atual
            "scaled_mean": scaler.mean_.tolist(),
            "scaled_var": scaler.var_.tolist(),
            "hostname": hostname,
        }
        colecao_fusoes.insert_one(info_fusao)

        print("Fusão temporal Tslearn TimeSeriesKMeans concluída e resultados armazenados na coleção:", nome_colecao)
        print("Installed h5py to use hdf5 features: http://docs.h5py.org/")

    print("===Acabou temp kmeans===")