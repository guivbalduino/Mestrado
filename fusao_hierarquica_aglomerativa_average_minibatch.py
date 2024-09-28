from pymongo import MongoClient
from sklearn.cluster import AgglomerativeClustering
from sklearn.decomposition import PCA
import pandas as pd
from datetime import datetime
import joblib  # Importa o módulo joblib para salvar e carregar objetos

# Parâmetros do algoritmo Agglomerative Clustering
n_clusters = 5  # Define o número de clusters
linkage = 'average'  # Método de ligação para calcular a distância entre os clusters

# Parâmetros do PCA
n_components = 3  # Número de componentes principais a serem mantidos

# Parâmetros do Mini-batch
batch_size = 10000  # Define o tamanho do lote para processamento

# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Obtenha a data e hora atual
data_hora_atual = datetime.now()

# Crie o nome da coleção com base na data e hora atual
nome_colecao = "fusao_hier_aglom_average_pca_minibatch_" + data_hora_atual.strftime("%Y-%m-%d_%H-%M")

# Coleção para armazenar os resultados
colecao_resultado = db[nome_colecao]

# Coleção para armazenar as informações sobre as fusões
colecao_fusoes = db['fusoes']

# Coleções de dados originais
colecao_inmet = db['inmet']
colecao_libelium = db['libelium']

# Projetar e recuperar apenas as colunas necessárias para cada coleção
projecao = {"timestamp": 1, "temperature_C": 1, "humidity_percent": 1, "pressure_hPa": 1}

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

# Excluir colunas não numéricas ou não relevantes para o clustering (.copy usado para evitar SettingWithCopyWarning)
df_cluster = df_concatenado[['timestamp', 'temperature_C', 'humidity_percent', 'pressure_hPa']].copy()

# Remover linhas com valores ausentes
df_cluster.dropna(inplace=True)

# Armazenar a coluna 'timestamp' para reinserir após o PCA
timestamps = df_cluster['timestamp'].copy()

# Excluir a coluna 'timestamp' antes de aplicar o PCA
df_cluster.drop(columns=['timestamp'], inplace=True)

# Contar a quantidade de dados utilizados
quantidade_dados_utilizados = len(df_cluster)

# Inicializar listas para armazenar resultados
df_clusters = []

inicio_fusao = datetime.now()

# Processamento em lotes
for start in range(0, quantidade_dados_utilizados, batch_size):
    end = min(start + batch_size, quantidade_dados_utilizados)
    batch_data = df_cluster.iloc[start:end].copy()
    
    # Redução de dimensionalidade usando PCA
    pca = PCA(n_components=n_components)
    batch_data_pca = pca.fit_transform(batch_data)
    
    # Realizar o clustering hierárquico usando Agglomerative Clustering
    agglomerative_clusterer = AgglomerativeClustering(n_clusters=n_clusters, linkage=linkage)
    cluster_labels = agglomerative_clusterer.fit_predict(batch_data_pca)
    
    # Armazenar os rótulos de cluster e o lote processado
    batch_data['cluster_label'] = cluster_labels
    df_clusters.append(batch_data)

# Concatenar todos os lotes processados em um único DataFrame
df_cluster_final = pd.concat(df_clusters, ignore_index=True)

# Reintroduzir a coluna 'timestamp' no DataFrame final
df_cluster_final['timestamp'] = timestamps.reset_index(drop=True)

fim_fusao = datetime.now()
tempo_fusao = fim_fusao - inicio_fusao

# Armazenar os resultados na coleção correspondente no MongoDB
inicio_armazenamento = datetime.now()
colecao_resultado.insert_many(df_cluster_final.to_dict(orient='records'))
fim_armazenamento = datetime.now()
tempo_armazenamento = fim_armazenamento - inicio_armazenamento

# Armazenar informações sobre a fusão no banco de dados "fusoes"
info_fusao = {
    "nome_fusao": "agglomerative_average_pca_minibatch",
    "tipo_fusao": "hierarquica",
    "n_clusters": n_clusters,
    "linkage": linkage,
    "quantidade_dados_utilizados": quantidade_dados_utilizados,
    "tempo_fusao_segundos": tempo_fusao.total_seconds(),
    "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
    "data_hora": data_hora_atual,  # Adicionando a data e hora atual
    "pca_n_components": n_components,
    "pca_explained_variance_ratio": pca.explained_variance_ratio_.tolist(),
    "pca_singular_values": pca.singular_values_.tolist(),
    "batch_size": batch_size
}
colecao_fusoes.insert_one(info_fusao)

# Salvar o PCA no arquivo
pca_path = f"E:/Git/Mestrado/src/pcas/pca_{nome_colecao[:-3]}.pkl"
joblib.dump(pca, pca_path)

print("Fusão hierárquica aglomerativa com Mini-batch PCA concluída e resultados armazenados na coleção:", nome_colecao)
print("Modelo PCA salvo em:", pca_path)
