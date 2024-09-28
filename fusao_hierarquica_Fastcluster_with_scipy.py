from pymongo import MongoClient
from sklearn.decomposition import PCA
import pandas as pd
from datetime import datetime
import fastcluster
from scipy.cluster.hierarchy import fcluster
import joblib  # Para salvar e carregar objetos

# Parâmetros do algoritmo Fastcluster
n_clusters = 5  # Define o número de clusters
linkage_method = 'ward'  # Método de ligação para calcular a distância entre os clusters
block_size = 10000  # Define o tamanho do bloco para processamento

# Parâmetros do PCA
n_components = 3  # Número de componentes principais a serem mantidos

# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Obtenha a data e hora atual
data_hora_atual = datetime.now()

# Crie o nome da coleção com base na data e hora atual
nome_colecao = "fusao_hier_fastcluster_pca_" + data_hora_atual.strftime("%Y-%m-%d_%H-%M")

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

# Excluir colunas não numéricas ou não relevantes para o clustering
df_cluster = df_concatenado[['temperature_C', 'humidity_percent', 'pressure_hPa']].copy()

# Remover linhas com valores ausentes
df_cluster.dropna(inplace=True)

# Redução de dimensionalidade usando PCA
pca = PCA(n_components=n_components)
df_pca = pca.fit_transform(df_cluster)

# Contar a quantidade de dados utilizados após a redução de dimensionalidade
quantidade_dados_utilizados = len(df_pca)

# Processamento em blocos
cluster_labels_full = []
inicio_fusao = datetime.now()

for i in range(0, quantidade_dados_utilizados, block_size):
    df_pca_block = df_pca[i:i + block_size]

    # Realizar o clustering hierárquico no bloco
    linkage_matrix = fastcluster.linkage(df_pca_block, method=linkage_method)
    cluster_labels = fcluster(linkage_matrix, t=n_clusters, criterion='maxclust')
    
    # Armazenar rótulos do bloco processado
    cluster_labels_full.extend(cluster_labels)

fim_fusao = datetime.now()
tempo_fusao = fim_fusao - inicio_fusao

# Adicionar rótulos de cluster ao DataFrame original
df_concatenado = df_concatenado.iloc[:len(cluster_labels_full)]
df_concatenado['cluster_label'] = cluster_labels_full

# Armazenar os resultados na coleção correspondente no MongoDB
inicio_armazenamento = datetime.now()
colecao_resultado.insert_many(df_concatenado.to_dict(orient='records'))
fim_armazenamento = datetime.now()
tempo_armazenamento = fim_armazenamento - inicio_armazenamento

# Armazenar informações sobre a fusão no banco de dados "fusoes"
info_fusao = {
    "nome_fusao": "fastcluster_pca",
    "tipo_fusao": "hierarquica",
    "linkage_method": linkage_method,
    "n_clusters": n_clusters,
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
pca_path = f"E:/Git/Mestrado/src/pcas/pca_{nome_colecao[:-3]}.pkl"
joblib.dump(pca, pca_path)

print("Fusão hierárquica Fastcluster com PCA concluída e resultados armazenados na coleção:", nome_colecao)
print("Modelo PCA salvo em:", pca_path)
