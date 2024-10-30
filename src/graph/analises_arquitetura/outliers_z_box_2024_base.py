import os
import pandas as pd
import matplotlib.pyplot as plt
from scipy.stats import zscore
from datetime import datetime
from pymongo import MongoClient

def load_data_from_mongo(collection_name, filter_date="2024-01-01"):
    client = MongoClient("localhost", 27017)
    db = client["dados"]
    collection = db[collection_name]
    data = pd.DataFrame(list(collection.find()))
    
    # Verificar se a coluna 'timestamp' está em string ou datetime
    if 'timestamp' in data.columns:
        if data['timestamp'].dtype == 'object':  # Se for string
            data['timestamp'] = pd.to_datetime(data['timestamp'], format='%Y-%m-%d %H:%M:%S')
        elif data['timestamp'].dtype == 'datetime64[ns]':  # Se já for datetime
            pass
        else:
            raise ValueError("Formato da coluna 'timestamp' não reconhecido.")
    
    # Filtrar por data se necessário
    if filter_date:
        data = data[data['timestamp'] >= filter_date]
    
    return data

# Diretórios de saída para os gráficos e Z-score
base_dir = r'.\analises_artigo_arquitetura\parcial_2024'
current_date_time_dir = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')

# Diretórios para salvar análises de inmet e libelium
boxplot_dir_inmet = os.path.join(base_dir, 'boxplots', 'inmet', current_date_time_dir)
zscore_dir_inmet = os.path.join(base_dir, 'zscore', 'inmet', current_date_time_dir)
outliers_dir_inmet = os.path.join(base_dir, 'outliers', 'inmet', current_date_time_dir)

boxplot_dir_libelium = os.path.join(base_dir, 'boxplots', 'libelium', current_date_time_dir)
zscore_dir_libelium = os.path.join(base_dir, 'zscore', 'libelium', current_date_time_dir)
outliers_dir_libelium = os.path.join(base_dir, 'outliers', 'libelium', current_date_time_dir)

# Criação das pastas
os.makedirs(boxplot_dir_inmet, exist_ok=True)
os.makedirs(zscore_dir_inmet, exist_ok=True)
os.makedirs(outliers_dir_inmet, exist_ok=True)

os.makedirs(boxplot_dir_libelium, exist_ok=True)
os.makedirs(zscore_dir_libelium, exist_ok=True)
os.makedirs(outliers_dir_libelium, exist_ok=True)

# Função para plotar boxplots para detectar outliers
def plot_boxplot(data, variable, label, output_dir):
    plt.figure(figsize=(10, 6))
    plt.boxplot(data[variable].dropna())
    plt.title(f'Boxplot - {variable} - {label}')
    plt.ylabel(variable)
    file_path = os.path.join(output_dir, f'boxplot_{label}_{variable}.png')
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

# Carregar os dados de inmet e libelium
inmet_data = load_data_from_mongo('inmet')
libelium_data = load_data_from_mongo('libelium')

# Filtrar as colunas necessárias
columns_to_keep = ['timestamp', 'temperature_C', 'humidity_percent', 'pressure_hPa']
inmet_data = inmet_data[columns_to_keep]
libelium_data = libelium_data[columns_to_keep]

# Variáveis para a análise de outliers
variables = ['temperature_C', 'humidity_percent', 'pressure_hPa']

# Analisando outliers para inmet
for variable in variables:
    try:
        # Gerar boxplot para visualizar os outliers
        plot_boxplot(inmet_data, variable, 'inmet', boxplot_dir_inmet)

        # Detectar outliers usando Z-score
        outliers_inmet = detect_outliers_zscore(inmet_data, variable)
        if not outliers_inmet.empty:
            print(f"Outliers encontrados em inmet - {variable}: {len(outliers_inmet)}")

            # Salvando os outliers detectados em um arquivo CSV
            outliers_file = os.path.join(outliers_dir_inmet, f'outliers_inmet_{variable}.csv')
            outliers_inmet.to_csv(outliers_file, index=False)
            print(f"Outliers salvos como: {outliers_file}")

        # Lidar com os outliers (remoção neste exemplo, pode ser alterado para 'mean_replace')
        inmet_cleaned = handle_outliers(inmet_data, variable, method='remove')

        # Salvando os Z-scores em um arquivo CSV
        zscore_file = os.path.join(zscore_dir_inmet, f'zscore_inmet_{variable}.csv')
        inmet_data[['timestamp', variable, 'zscore']].to_csv(zscore_file, index=False)
        print(f"Z-scores salvos como: {zscore_file}")

    except Exception as e:
        print(f"Erro ao analisar outliers para inmet - {variable}: {e}")

# Analisando outliers para libelium
for variable in variables:
    try:
        # Gerar boxplot para visualizar os outliers
        plot_boxplot(libelium_data, variable, 'libelium', boxplot_dir_libelium)

        # Detectar outliers usando Z-score
        outliers_libelium = detect_outliers_zscore(libelium_data, variable)
        if not outliers_libelium.empty:
            print(f"Outliers encontrados em libelium - {variable}: {len(outliers_libelium)}")

            # Salvando os outliers detectados em um arquivo CSV
            outliers_file = os.path.join(outliers_dir_libelium, f'outliers_libelium_{variable}.csv')
            outliers_libelium.to_csv(outliers_file, index=False)
            print(f"Outliers salvos como: {outliers_file}")

        # Lidar com os outliers (remoção neste exemplo, pode ser alterado para 'mean_replace')
        libelium_cleaned = handle_outliers(libelium_data, variable, method='remove')

        # Salvando os Z-scores em um arquivo CSV
        zscore_file = os.path.join(zscore_dir_libelium, f'zscore_libelium_{variable}.csv')
        libelium_data[['timestamp', variable, 'zscore']].to_csv(zscore_file, index=False)
        print(f"Z-scores salvos como: {zscore_file}")

    except Exception as e:
        print(f"Erro ao analisar outliers para libelium - {variable}: {e}")

print(f"Análises de outliers concluídas para inmet e libelium. Gráficos e dados salvos em {base_dir}!")
