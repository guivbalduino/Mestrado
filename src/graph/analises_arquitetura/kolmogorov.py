import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from scipy.stats import kstest, norm
from pymongo import MongoClient
import socket

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

# Função para realizar o Teste de Kolmogorov-Smirnov
def kolmogorov_smirnov_test(data, variable):
    stat, p_value = kstest(data[variable].dropna(), 'norm')
    return stat, p_value

# Função para garantir que o nome do arquivo seja válido
def sanitize_filename(filename):
    return "".join(c if c.isalnum() or c in (' ', '_') else '_' for c in filename)

# Função para criar gráficos comparativos entre a distribuição dos dados e uma normal
def plot_ks_test(data, variable, label, output_dir):
    data_clean = data[variable].dropna()

    # Plotando o histograma dos dados observados
    plt.figure(figsize=(10, 6))
    count, bins, ignored = plt.hist(data_clean, bins=30, density=True, alpha=0.6, color='g', label='Dados Observados')

    # Plotando a curva de distribuição normal teórica
    mu, std = norm.fit(data_clean)
    p = norm.pdf(bins, mu, std)
    plt.plot(bins, p, 'r--', linewidth=2, label='Distribuição Normal Ajustada')

    plt.title(f'Teste de Kolmogorov-Smirnov - {variable} - {label}')
    plt.xlabel(variable)
    plt.ylabel('Frequência')
    plt.legend()

    # Salvando o gráfico
    file_path = os.path.join(output_dir, f'ks_test_{sanitize_filename(label)}_{variable}.png')
    plt.savefig(file_path)
    plt.close()
    print(f"Gráfico do Teste de Kolmogorov-Smirnov salvo como: {file_path}")

# Diretório para salvar os resultados
output_dir = r'E:\Git\Mestrado\analises_artigo_arquitetura\normalidade'
os.makedirs(output_dir, exist_ok=True)

# Carregar coleções fusionadas
fusao_collections = [col for col in db.list_collection_names() if col.startswith('fusao_')]
fusao_data = {col: load_data_from_mongo(col) for col in fusao_collections}

# Variáveis para a análise de normalidade
variables = ['temperature_C', 'humidity_percent', 'pressure_hPa']

# Realizando o Teste de Kolmogorov-Smirnov para cada coleção e plotando os gráficos
for fusao_label, fusao_df in fusao_data.items():
    for variable in variables:
        try:
            # Realizando o Teste de Kolmogorov-Smirnov
            stat, p_value = kolmogorov_smirnov_test(fusao_df, variable)
            result = f"Teste de Kolmogorov-Smirnov para {variable} em {fusao_label}:\n"
            result += f"Estatística: {stat}, P-valor: {p_value}\n"
            result += "Distribuição normal\n" if p_value > 0.05 else "Distribuição não normal\n"
            print(result)

            # Salvando os resultados em um arquivo de texto
            result_file = os.path.join(output_dir, f'ks_test_{sanitize_filename(fusao_label)}_{variable}.txt')
            with open(result_file, 'w') as file:
                file.write(result)
            print(f"Resultados salvos em {result_file}")

            # Gerar gráfico comparativo entre a distribuição observada e a distribuição normal ajustada
            plot_ks_test(fusao_df, variable, fusao_label, output_dir)

        except Exception as e:
            print(f"Erro ao realizar o teste para {fusao_label} - {variable}: {e}")
