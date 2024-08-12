import os
import pandas as pd
import matplotlib.pyplot as plt
from pymongo import MongoClient
import socket
from datetime import datetime

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

# Função para encontrar todas as coleções que começam com "fusao_temp_"
def get_fusao_collections():
    return [col for col in db.list_collection_names() if col.startswith('fusao_temp_')]

# Função para garantir que o nome do arquivo seja válido
def sanitize_filename(filename):
    return "".join(c if c.isalnum() or c in (' ', '_') else '_' for c in filename)

# Função para plotar gráficos individuais
def plot_individual_graph(data, variable, label, output_dir, plot_type='line'):
    plt.figure(figsize=(10, 6))
    if plot_type == 'line':
        plt.plot(data['timestamp'], data[variable], label=label, color='blue')
    elif plot_type == 'bar':
        plt.bar(data['timestamp'], data[variable], label=label, color='blue')
    plt.xlabel('Timestamp')
    plt.ylabel(variable)
    plt.title(f'{variable} - {label}')
    plt.legend()
    file_path = os.path.join(output_dir, f'{sanitize_filename(label)}_{variable}_{plot_type}.png')
    plt.savefig(file_path)
    plt.close()
    print(f"Gráfico individual ({plot_type}) salvo como: {file_path}")

# Função para plotar gráficos comparativos
def plot_comparative_graph(fusao_data, inmet_data, libelium_data, variable, fusao_label, output_dir, plot_type='line'):
    plt.figure(figsize=(10, 6))
    if plot_type == 'line':
        plt.plot(fusao_data['timestamp'], fusao_data[variable], label=f'{fusao_label}', color='blue')
        if not inmet_data.empty:
            plt.plot(inmet_data['timestamp'], inmet_data[variable], label='inmet', color='green')
        if not libelium_data.empty:
            plt.plot(libelium_data['timestamp'], libelium_data[variable], label='libelium', color='red')
    elif plot_type == 'bar':
        plt.bar(fusao_data['timestamp'] - pd.DateOffset(days=0.2), fusao_data[variable], width=0.2, label=f'{fusao_label}', color='blue')
        if not inmet_data.empty:
            plt.bar(inmet_data['timestamp'], inmet_data[variable], width=0.2, label='inmet', color='green', align='center')
        if not libelium_data.empty:
            plt.bar(libelium_data['timestamp'] + pd.DateOffset(days=0.2), libelium_data[variable], width=0.2, label='libelium', color='red', align='center')
    plt.xlabel('Timestamp')
    plt.ylabel(variable)
    plt.title(f'{variable} - {sanitize_filename(fusao_label)} vs Inmet vs Libelium')
    plt.legend()
    file_path = os.path.join(output_dir, f'{sanitize_filename(fusao_label)}_{variable}_{plot_type}_comparative.png')
    plt.savefig(file_path)
    plt.close()
    print(f"Gráfico comparativo ({plot_type}) salvo como: {file_path}")

# Carregando as coleções que começam com "fusao_temp_"
fusao_collections = get_fusao_collections()

# Verificando as coleções encontradas
print(f"Coleções encontradas: {fusao_collections}")

# Carregando os dados das coleções de fusao_temp_, inmet e libelium
fusao_data = {col: load_data_from_mongo(col) for col in fusao_collections}
inmet_data = load_data_from_mongo('inmet')
libelium_data = load_data_from_mongo('libelium')

# Verificando os dados carregados
print(f"Dados inmet carregados: {not inmet_data.empty}")
print(f"Dados libelium carregados: {not libelium_data.empty}")

# Variáveis para o eixo y
variables = ['temperature_C', 'humidity_percent', 'pressure_hPa']

# Tipo de gráfico ('line' ou 'bar')
plot_types = ['line', 'bar']

# Diretório de saída para os gráficos
base_dir = r'E:\Git\Mestrado\comparativos'
current_date_time_dir = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
output_dir = os.path.join(base_dir, current_date_time_dir)
os.makedirs(output_dir, exist_ok=True)

# Gerando gráficos individuais para inmet e libelium
for variable in variables:
    for plot_type in plot_types:
        try:
            plot_individual_graph(inmet_data, variable, 'inmet', output_dir, plot_type)
            plot_individual_graph(libelium_data, variable, 'libelium', output_dir, plot_type)
        except Exception as e:
            print(f"Erro ao gerar gráfico individual para {variable} ({plot_type}): {e}")

# Gerando gráficos comparativos para cada fusao_temp_
for variable in variables:
    for fusao_label, fusao_df in fusao_data.items():
        for plot_type in plot_types:
            try:
                plot_comparative_graph(fusao_df, inmet_data, libelium_data, variable, fusao_label, output_dir, plot_type)
            except Exception as e:
                print(f"Erro ao gerar gráfico comparativo para {fusao_label} - {variable} ({plot_type}): {e}")

print(f"Gráficos gerados com sucesso em {output_dir}!")
