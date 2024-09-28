from pymongo import MongoClient
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
import joblib

# Caminho da pasta onde os PCA's são salvos
pca_pasta = "E:/Git/Mestrado/src/pcas"

# Diretório para salvar as imagens
output_dir = "E:/Git/Mestrado/comparativos/hierarquicos/clusters"
if not os.path.exists(output_dir):
    os.makedirs(output_dir)

# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Obter todas as coleções que começam com 'fusao_hier'
colecoes = db.list_collection_names(filter={"name": {"$regex": "^fusao_hier"}})

# Processar cada coleção
for nome_colecao in colecoes:
    print(f"Processando a coleção: {nome_colecao}")

    # Coleção para armazenar os resultados
    colecao_resultado = db[nome_colecao]

    # Carregar os dados da coleção
    dados = list(colecao_resultado.find({}))
    df = pd.DataFrame(dados)

    # Verificar se as colunas 'cluster_label' e 'timestamp' estão presentes
    if 'cluster_label' not in df.columns or 'timestamp' not in df.columns:
        print(f"Pulos dados da coleção {nome_colecao} devido à falta de colunas necessárias.")
        continue

    # Recuperar o PCA salvo com base no nome da coleção
    pca_path = f"{pca_pasta}/pca_{nome_colecao[:-3]}.pkl"
    if not os.path.exists(pca_path):
        print(f"PCA não encontrado para a coleção {nome_colecao}.")
        continue

    # Carregar o PCA
    pca = joblib.load(pca_path)

    # Aplicar PCA aos dados para a visualização
    df_features = df[['temperature_C', 'humidity_percent', 'pressure_hPa']]
    df_pca = pca.transform(df_features)
    df_pca_df = pd.DataFrame(df_pca, columns=[f'PC{i+1}' for i in range(df_pca.shape[1])])
    df_pca_df['cluster_label'] = df['cluster_label']
    df_pca_df['timestamp'] = df['timestamp']

    # Gráfico de Dispersão dos Clusters
    plt.figure(figsize=(12, 8))
    sns.scatterplot(data=df_pca_df, x='PC1', y='PC2', hue='cluster_label', palette='viridis', alpha=0.7)
    plt.title(f'Dispersão dos Clusters em PCA {nome_colecao[:-3]}')
    plt.xlabel('Componente Principal 1')
    plt.ylabel('Componente Principal 2')
    plt.legend(title='Cluster')
    plt.savefig(f'{output_dir}/disp_clusters_{nome_colecao[:-3]}.png')
    plt.close()

    # Gráfico de Centróides dos Clusters
    centroids = df_pca_df.groupby('cluster_label').mean()

    plt.figure(figsize=(12, 8))
    sns.scatterplot(data=df_pca_df, x='PC1', y='PC2', hue='cluster_label', palette='viridis', alpha=0.5, legend=False)
    sns.scatterplot(data=centroids, x='PC1', y='PC2', s=200, color='red', marker='X', label='Centróides')
    plt.title('Centróides dos Clusters em PCA')
    plt.xlabel('Componente Principal 1')
    plt.ylabel('Componente Principal 2')
    plt.legend()
    plt.savefig(f'{output_dir}/centroides_clusters_{nome_colecao[:-3]}.png')
    plt.close()

    # Gráfico de Distribuição de Tamanho dos Clusters
    cluster_sizes = df['cluster_label'].value_counts()

    plt.figure(figsize=(12, 8))
    sns.barplot(x=cluster_sizes.index, y=cluster_sizes.values, palette='viridis')
    plt.title('Distribuição de Tamanho dos Clusters')
    plt.xlabel('Cluster')
    plt.ylabel('Número de Pontos')
    plt.savefig(f'{output_dir}/tamanho_clusters_{nome_colecao[:-3]}.png')
    plt.close()

    # Matriz de Correlação entre Variáveis por Cluster
    plt.figure(figsize=(16, 12))
    for i in df['cluster_label'].unique():
        cluster_data = df_features[df['cluster_label'] == i]
        plt.subplot(len(df['cluster_label'].unique()), 1, i+1)
        sns.heatmap(cluster_data.corr(), annot=True, cmap='coolwarm', vmin=-1, vmax=1)
        plt.title(f'Matriz de Correlação para Cluster {i}')

    plt.tight_layout()
    plt.savefig(f'{output_dir}/correlacao_clusters_{nome_colecao[:-3]}.png')
    plt.close()

    print(f"Gráficos para a coleção {nome_colecao} salvos em {output_dir}")

print("Processamento concluído.")
