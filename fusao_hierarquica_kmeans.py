from pymongo import MongoClient
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
import pandas as pd
from datetime import datetime
import joblib  # Importa o módulo joblib para salvar e carregar objetos

# Parâmetros do algoritmo KMeans
n_clusters = 5  # Define o número de clusters

# Parâmetros do PCA
n_components = 3  # Número de componentes principais a serem mantidos

# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Obtenha a data e hora atual
data_hora_atual = datetime.now()

# Crie o nome da coleção com base na data e hora atual
nome_colecao = "fusao_hier_kmeans_pca_" + data_hora_atual.strftime("%Y-%m-%d_%H-%M")

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

# Redução de dimensionalidade usando PCA
pca = PCA(n_components=n_components)
df_pca = pca.fit_transform(df_cluster)

# Contar a quantidade de dados utilizados após a redução de dimensionalidade
quantidade_dados_utilizados = len(df_pca)

# Realizar o clustering usando KMeans nos dados reduzidos pelo PCA
inicio_fusao = datetime.now()
kmeans = KMeans(n_clusters=n_clusters, random_state=42)
df_concatenado['cluster_label'] = kmeans.fit_predict(df_pca)
fim_fusao = datetime.now()
tempo_fusao = fim_fusao - inicio_fusao

# Reintroduzir a coluna 'timestamp' no DataFrame final
df_concatenado['timestamp'] = timestamps.reset_index(drop=True)

# Armazenar os resultados na coleção correspondente no MongoDB
inicio_armazenamento = datetime.now()
colecao_resultado.insert_many(df_concatenado.to_dict(orient='records'))
fim_armazenamento = datetime.now()
tempo_armazenamento = fim_armazenamento - inicio_armazenamento

# Armazenar informações sobre a fusão no banco de dados "fusoes"
info_fusao = {
    "nome_fusao": "kmeans_pca",
    "tipo_fusao": "kmeans",
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

print("Fusão KMeans com PCA concluída e resultados armazenados na coleção:", nome_colecao)
print("Modelo PCA salvo em:", pca_path)
