import os
import pandas as pd
import matplotlib.pyplot as plt
from pymongo import MongoClient
import socket
from datetime import datetime
from scipy.stats import zscore

# Obter o nome do computador (hostname)
hostname = socket.gethostname()

# Conectando ao MongoDB
client = MongoClient("localhost", 27017)
db = client["dados"]  # Banco de dados

# Função para carregar dados de uma coleção MongoDB
def load_data_from_mongo(collection_name, filter={}):
    collection = db[collection_name]
    data = pd.DataFrame(list(collection.find(filter)))
    if data.empty:
        print(f"Sem dados na coleção: {collection_name}")
    data['timestamp'] = pd.to_datetime(data['timestamp'])
    return data

# Função para encontrar todas as coleções que começam com "fusao_"
def get_fusao_collections():
    return [col for col in db.list_collection_names() if col.startswith('fusao_')]

# Função para garantir que o nome do arquivo seja válido
def sanitize_filename(filename):
    return "".join(c if c.isalnum() or c in (' ', '_') else '_' for c in filename)

# Função para plotar boxplots para detectar outliers
def plot_boxplot(data, variable, label, output_dir):
    plt.figure(figsize=(10, 6))
    plt.boxplot(data[variable].dropna())
    plt.title(f'Boxplot - {variable} - {label}')
    plt.ylabel(variable)
    file_path = os.path.join(output_dir, f'boxplot_{sanitize_filename(label)}_{variable}.png')
    plt.savefig(file_path)
    plt.close()
    print(f"Boxplot salvo como: {file_path}")

# Função para calcular o Z-score e identificar outliers
def detect_outliers_zscore(data, variable, threshold=3):
    data['zscore'] = zscore(data[variable].dropna())
    outliers = data[abs(data['zscore']) > threshold]
    return outliers

# Função para lidar com outliers (remoção ou correção)
def handle_outliers(data, variable, method='remove'):
    outliers = detect_outliers_zscore(data, variable)
    if method == 'remove':
        data_cleaned = data[~data.index.isin(outliers.index)]
        print(f"Outliers removidos para {variable}: {len(outliers)}")
    elif method == 'mean_replace':
        data_cleaned = data.copy()
        mean_value = data_cleaned[variable].mean()
        data_cleaned.loc[outliers.index, variable] = mean_value
        print(f"Outliers substituídos pela média para {variable}: {len(outliers)}")
    return data_cleaned

# Carregando as coleções que começam com "fusao_temp_"
fusao_collections = get_fusao_collections()

# Verificando as coleções encontradas
print(f"Coleções encontradas: {fusao_collections}")

# Carregando os dados das coleções de fusao_temp_, inmet e libelium
fusao_data = {col: load_data_from_mongo(col) for col in fusao_collections}
inmet_data = load_data_from_mongo('inmet')
libelium_data = load_data_from_mongo('libelium')

# Variáveis para a análise de outliers
variables = ['temperature_C', 'humidity_percent', 'pressure_hPa']

# Diretórios de saída para os gráficos
base_dir = r'.\analises_artigo_arquitetura'
current_date_time_dir = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')

# Criação de subpastas
boxplot_dir = os.path.join(base_dir, 'boxplots', current_date_time_dir)
zscore_dir = os.path.join(base_dir, 'zscore', current_date_time_dir)
outliers_dir = os.path.join(base_dir, 'outliers', current_date_time_dir)

# Criação das pastas
os.makedirs(boxplot_dir, exist_ok=True)
os.makedirs(zscore_dir, exist_ok=True)
os.makedirs(outliers_dir, exist_ok=True)

# Analisando outliers para cada fusao_temp_
for fusao_label, fusao_df in fusao_data.items():
    for variable in variables:
        try:
            # Gerar boxplot para visualizar os outliers
            plot_boxplot(fusao_df, variable, fusao_label, boxplot_dir)

            # Detectar outliers usando Z-score
            outliers = detect_outliers_zscore(fusao_df, variable)
            if not outliers.empty:
                print(f"Outliers encontrados em {fusao_label} - {variable}: {len(outliers)}")

                # Salvando os outliers detectados em um arquivo CSV
                outliers_file = os.path.join(outliers_dir, f'outliers_{sanitize_filename(fusao_label)}_{variable}.csv')
                outliers.to_csv(outliers_file, index=False)
                print(f"Outliers salvos como: {outliers_file}")

            # Lidar com os outliers (remoção neste exemplo, pode ser alterado para 'mean_replace')
            fusao_cleaned = handle_outliers(fusao_df, variable, method='remove')

            # Salvando os Z-scores em um arquivo CSV
            zscore_file = os.path.join(zscore_dir, f'zscore_{sanitize_filename(fusao_label)}_{variable}.csv')
            fusao_df[['timestamp', variable, 'zscore']].to_csv(zscore_file, index=False)
            print(f"Z-scores salvos como: {zscore_file}")

        except Exception as e:
            print(f"Erro ao analisar outliers para {fusao_label} - {variable}: {e}")

print(f"Análise de outliers concluída. Gráficos e dados salvos em {base_dir}!")
