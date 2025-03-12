from pymongo import MongoClient
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
import joblib

# Caminho da pasta onde os PCA's são salvos
pca_pasta = "E:/Git/Mestrado/src/pcas"

# Diretório base para salvar as imagens
output_base_dir = "E:/Git/Mestrado/comparativos/parcial_2024/hierarquicos/clusters"
if not os.path.exists(output_base_dir):
    os.makedirs(output_base_dir)

# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Listar todas as coleções no banco de dados
colecoes = db.list_collection_names()
print(colecoes)

# Filtrar coleções que começam com 'fusao_hier'
colecoes_fusao_hier = [colecao for colecao in colecoes if colecao.startswith('fusao_hier')]

for nome_colecao in colecoes_fusao_hier:
    print(f"Processando coleção: {nome_colecao}")

    # Dividir o nome da coleção para criar a pasta com base no penúltimo e no último elemento
    partes_nome = nome_colecao.split('_')
    if len(partes_nome) < 3:
        print(f"Nome da coleção {nome_colecao} não possui elementos suficientes para divisão.")
        continue

    # Criar a pasta principal com o nome da coleção até o penúltimo elemento
    pasta_principal = '_'.join(partes_nome[:-2])
    output_dir = os.path.join(output_base_dir, pasta_principal)
    
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    # Nome da subpasta
    nome_pasta = f"{partes_nome[-2]}_{partes_nome[-1]}"
    
    # Diretório específico para a coleção
    output_colecao_dir = os.path.join(output_dir, nome_pasta)
    
    if not os.path.exists(output_colecao_dir):
        os.makedirs(output_colecao_dir)

    # Coleção para armazenar os resultados
    colecao_resultado = db[nome_colecao]

    # Carregar os dados da coleção
    dados = list(colecao_resultado.find({}))
    df = pd.DataFrame(dados)

    # Verificar se a coluna 'cluster_label' está presente
    if 'cluster_label' not in df.columns:
        print(f"Coluna 'cluster_label' não encontrada na coleção {nome_colecao}")
        continue

    # Verificar se a coluna 'timestamp' está presente e converter para datetime
    if 'timestamp' not in df.columns:
        print(f"Coluna 'timestamp' não encontrada na coleção {nome_colecao}")
        continue
    df['timestamp'] = pd.to_datetime(df['timestamp'], errors='coerce')

    # Filtrar os dados para incluir apenas os registros a partir de '2024-02-01'
    data_inicio = pd.Timestamp('2024-02-01')
    df = df[df['timestamp'] >= data_inicio]

    # Recuperar o PCA salvo com base no nome da coleção
    pca_path = f"{pca_pasta}/pca_{nome_colecao[:-3]}.pkl"
    if not os.path.exists(pca_path):
        print(f"PCA não encontrado no caminho: {pca_path}")
        continue

    # Carregar o PCA
    pca = joblib.load(pca_path)

    # Aplicar PCA aos dados para a visualização
    df_features = df[['temperature_C', 'humidity_percent', 'pressure_hPa',"PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"]]
    df_pca = pca.transform(df_features)
    df_pca_df = pd.DataFrame(df_pca, columns=[f'PC{i+1}' for i in range(df_pca.shape[1])])
    df_pca_df['cluster_label'] = df['cluster_label']

    # Gráfico de Dispersão dos Clusters
    plt.figure(figsize=(12, 8))
    sns.scatterplot(data=df_pca_df, x='PC1', y='PC2', hue='cluster_label', palette='viridis', alpha=0.7)
    plt.title(f'Dispersão dos Clusters em PCA {nome_colecao[:-3]}')
    plt.xlabel('Componente Principal 1')
    plt.ylabel('Componente Principal 2')
    plt.legend(title='Cluster')
    plt.savefig(f'{output_colecao_dir}/disp_clusters_{nome_colecao[:-3]}.png')
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
    plt.savefig(f'{output_colecao_dir}/centroides_clusters_{nome_colecao[:-3]}.png')
    plt.close()

    # Gráfico de Distribuição de Tamanho dos Clusters
    cluster_sizes = df['cluster_label'].value_counts()

    plt.figure(figsize=(12, 8))
    sns.barplot(x=cluster_sizes.index, y=cluster_sizes.values)
    plt.title('Distribuição de Tamanho dos Clusters')
    plt.xlabel('Cluster')
    plt.ylabel('Número de Pontos')
    plt.savefig(f'{output_colecao_dir}/tamanho_clusters_{nome_colecao[:-3]}.png')
    plt.close()

    # Matriz de Correlação entre Variáveis por Cluster
    # Birch tem muitos clusters, imagem poluida entao pulando ele
    if not ("birch" in nome_colecao or "hdbscan" in nome_colecao):
        n_clusters = len(df['cluster_label'].unique())
        plt.figure(figsize=(16, 12))
        for i in range(n_clusters):
            cluster_data = df_features[df['cluster_label'] == i]
            plt.subplot(n_clusters, 1, i+1)
            sns.heatmap(cluster_data.corr(), annot=True, cmap='coolwarm', vmin=-1, vmax=1)
            plt.title(f'Matriz de Correlação para Cluster {i}')
            

        plt.tight_layout()
        plt.savefig(f'{output_colecao_dir}/correlacao_clusters_{nome_colecao[:-3]}.png')
        plt.close()

    else:
        print("Correlação do birch/hdbscan poluida, pulando")

    print(f"Gráficos salvos para a coleção {nome_colecao} em {output_colecao_dir}")
