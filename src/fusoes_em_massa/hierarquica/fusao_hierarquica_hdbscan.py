from pymongo import MongoClient
import hdbscan
from sklearn.decomposition import PCA
import pandas as pd
from datetime import datetime
import joblib  # Importa o módulo joblib para salvar e carregar objetos
#import time


def run_hier_hdbscan():
    # Parâmetros do HDBSCAN
    min_cluster_size_options = [5, 10, 20]  # Exemplo de diferentes tamanhos de clusters
    min_samples_options = [None, 5, 10]      # Exemplo de diferentes valores para min_samples

    # Parâmetros do PCA
    n_components_options = [2, 3, 4]         # Exemplo de diferentes números de componentes principais

    # Laços aninhados para percorrer diferentes combinações de parâmetros
    for min_cluster_size in min_cluster_size_options:
        for min_samples in min_samples_options:
            for n_components in n_components_options:

                # Conectando ao MongoDB
                client = MongoClient('localhost', 27017)
                db = client['dados']  # Banco de dados

                # Obtenha a data e hora atual
                data_hora_atual = datetime.now()

                # Crie o nome da coleção com base na data e hora atual
                nome_colecao = "fusao_hier_hdbscan_pca_" + data_hora_atual.strftime("%Y-%m-%d_%H-%M-%S")

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

                # Garantir que 'timestamp' está no formato datetime
                df_inmet['timestamp'] = pd.to_datetime(df_inmet['timestamp'], errors='coerce')
                df_libelium['timestamp'] = pd.to_datetime(df_libelium['timestamp'], errors='coerce')

                # Concatenar os DataFrames
                df_concatenado = pd.concat([df_inmet, df_libelium], ignore_index=True)

                # Excluir colunas não numéricas ou não relevantes para o clustering
                df_cluster = df_concatenado[['timestamp', 'temperature_C', 'humidity_percent', 'pressure_hPa',"PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"]].copy()

                # Remover linhas com valores ausentes
                df_cluster.dropna(inplace=True)

                # Redução de dimensionalidade usando PCA
                pca = PCA(n_components=n_components)
                df_pca = pca.fit_transform(df_cluster[['temperature_C', 'humidity_percent', 'pressure_hPa',"PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"]])

                # Contar a quantidade de dados utilizados após a redução de dimensionalidade
                quantidade_dados_utilizados = len(df_pca)

                # Realizar o clustering HDBSCAN nos dados reduzidos pelo PCA
                inicio_fusao = datetime.now()
                hdb = hdbscan.HDBSCAN(min_cluster_size=min_cluster_size, min_samples=min_samples)
                hdb.fit(df_pca)
                fim_fusao = datetime.now()
                tempo_fusao = fim_fusao - inicio_fusao

                # Adicionar rótulos de cluster ao DataFrame original
                df_concatenado = df_concatenado.iloc[df_cluster.index]  # Filtrar o DataFrame para manter apenas as linhas utilizadas no clustering
                df_concatenado['cluster_label'] = hdb.labels_

                # Armazenar os resultados na coleção correspondente no MongoDB
                inicio_armazenamento = datetime.now()
                colecao_resultado.insert_many(df_concatenado.to_dict(orient='records'))
                fim_armazenamento = datetime.now()
                tempo_armazenamento = fim_armazenamento - inicio_armazenamento

                # Armazenar informações sobre a fusão no banco de dados "fusoes"
                info_fusao = {
                    "nome_fusao": "hdbscan_pca",
                    "tipo_fusao": "hierarquica",
                    "min_cluster_size": min_cluster_size,
                    "min_samples": min_samples,
                    "quantidade_dados_utilizados": quantidade_dados_utilizados,
                    "tempo_fusao_segundos": tempo_fusao.total_seconds(),
                    "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
                    "data_hora": data_hora_atual,  # Adicionando a data e hora atual
                    "pca_n_components": n_components,
                    "pca_explained_variance_ratio": pca.explained_variance_ratio_.tolist(),
                    "pca_singular_values": pca.singular_values_.tolist()
                }
                colecao_fusoes.insert_one(info_fusao)

                # Salvar o PCA no arquivo
                pca_path = f"./src/pcas/pca_{nome_colecao[:-3]}.pkl"
                joblib.dump(pca, pca_path)

                print("Fusão hierárquica HDBSCAN com PCA concluída e resultados armazenados na coleção:", nome_colecao)
                print("Modelo PCA salvo em:", pca_path)
                #time.sleep(70)
    print("===Acabou hier hdbscan===")
