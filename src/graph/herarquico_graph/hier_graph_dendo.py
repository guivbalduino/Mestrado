from pymongo import MongoClient
import pandas as pd
import joblib
import matplotlib.pyplot as plt
import scipy.cluster.hierarchy as sch
import numpy as np
import os

# Caminho da pasta onde os PCA's são salvos e onde os dendogramas serão armazenados
pca_pasta = "E:/Git/Mestrado/src/pcas"
dendograma_pasta = "E:/Git/Mestrado/comparativos/hierarquicos/dendogramas"

# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Filtrar todas as coleções que começam com 'fusao_hier'
colecoes = [col for col in db.list_collection_names() if col.startswith('fusao_hier')]

for nome_colecao in colecoes:
    print(f"Processando coleção: {nome_colecao}")
    
    # Coleção para armazenar os resultados
    colecao_resultado = db[nome_colecao]
    
    # Carregar os dados da coleção
    dados = list(colecao_resultado.find({}))
    df = pd.DataFrame(dados)
    
    # Certifique-se de que a coluna 'cluster_label' está presente
    if 'cluster_label' not in df.columns:
        print(f"A coluna 'cluster_label' não está presente nos dados da coleção {nome_colecao}. Pulando...")
        continue
    
    # Construir o caminho para o arquivo PCA
    pca_filename = f"pca_{nome_colecao[:-3]}.pkl"
    pca_path = os.path.join(pca_pasta, pca_filename)
    
    # Verificar se o arquivo PCA existe
    if not os.path.isfile(pca_path):
        print(f"O arquivo PCA não foi encontrado: {pca_path}. Pulando...")
        continue
    
    # Carregar o PCA salvo
    pca = joblib.load(pca_path)
    
    # Aplicar PCA aos dados para a visualização
    df_features = df[['temperature_C', 'humidity_percent', 'pressure_hPa']]
    df_pca = pca.transform(df_features)
    
    # Usar uma amostra dos dados se o volume for muito grande
    sample_size = 10000  # Ajuste conforme necessário
    if df_pca.shape[0] > sample_size:
        df_pca = df_pca[np.random.choice(df_pca.shape[0], sample_size, replace=False)]
    
    # Calcular a matriz de distância e a ligação
    distance_matrix = sch.distance.pdist(df_pca, metric='euclidean')
    linkage_matrix = sch.linkage(distance_matrix, method='ward')
    
    # Criar o gráfico do dendograma com tamanho maior
    plt.figure(figsize=(16, 12))  # Tamanho aumentado
    sch.dendrogram(linkage_matrix, labels=df.index[:df_pca.shape[0]], leaf_rotation=90, leaf_font_size=10)
    plt.title(f'Dendograma da Clusterização Hierárquica {nome_colecao[:-3]}')
    plt.xlabel('Índice dos Dados')
    plt.ylabel('Distância')
    
    # Salvar a imagem do dendograma
    dendograma_path = os.path.join(dendograma_pasta, f"{nome_colecao[:-3]}.png")
    plt.savefig(dendograma_path)
    plt.close()  # Fecha a figura para liberar memória
    
    print(f"Dendograma salvo em: {dendograma_path}")

print("Processamento concluído.")
