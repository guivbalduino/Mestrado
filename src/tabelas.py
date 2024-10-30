import os
import pandas as pd
import matplotlib.pyplot as plt
from pymongo import MongoClient

# Função para carregar dados de uma coleção MongoDB com filtro de data
def load_data_from_mongo(collection_name, start_date=None, end_date=None):
    client = MongoClient("localhost", 27017)
    db = client["dados"]
    collection = db[collection_name]
    data = pd.DataFrame(list(collection.find()))
    
    # Verificar se a coluna 'timestamp' está em string ou datetime
    if 'timestamp' in data.columns:
        if data['timestamp'].dtype == 'object':  # Se for string
            data['timestamp'] = pd.to_datetime(data['timestamp'], format='%Y-%m-%d %H:%M:%S')
    
    # Aplicar o filtro de data se fornecido
    if start_date and end_date:
        data = data[(data['timestamp'] >= start_date) & (data['timestamp'] <= end_date)]
    
    return data

# Função para garantir que o nome do arquivo seja válido
def sanitize_filename(filename):
    return "".join(c if c.isalnum() or c in (' ', '_') else '_' for c in filename)

# Função para gerar imagens de tabelas com título e salvar como PNG
def generate_table_images(fusao_data, variables, output_dir, num_rows=10):
    os.makedirs(output_dir, exist_ok=True)
    
    for collection_name, data in fusao_data.items():
        for variable in variables:
            if variable in data.columns:
                # Extrair as primeiras 'num_rows' linhas da variável
                table = data[['timestamp', variable]].head(num_rows)
                
                # Criar figura para a tabela
                fig, ax = plt.subplots(figsize=(10, 5))  # Ajuste o tamanho da imagem conforme necessário
                
                # Adicionar título com o nome da coleção
                fig.suptitle(f"Tabela - {collection_name}", fontsize=16)
                ax.axis('tight')
                ax.axis('off')
                
                # Renderizar a tabela
                table_render = ax.table(cellText=table.values, colLabels=table.columns, cellLoc='center', loc='center')

                # Salvar a imagem da tabela em PNG
                file_name = f"{sanitize_filename(collection_name)}_{variable}_tabela.png"
                file_path = os.path.join(output_dir, file_name)
                plt.savefig(file_path, bbox_inches='tight', dpi=300)  # Salvar com alta resolução
                plt.close()
                print(f"Imagem da tabela salva como: {file_path}")
            else:
                print(f"Variável '{variable}' não encontrada na coleção '{collection_name}'.")

# Função para encontrar todas as coleções que começam com "fusao_"
def get_fusao_collections():
    client = MongoClient("localhost", 27017)
    db = client["dados"]
    return [col for col in db.list_collection_names() if col.startswith('fusao_temp')]

# Carregando os dados das coleções de fusao_ com filtro de março de 2024
start_date = pd.to_datetime('2024-03-01')
end_date = pd.to_datetime('2024-03-31 23:59:59')

# Carregando as coleções que começam com "fusao_"
fusao_collections = get_fusao_collections()

# Carregando os dados das coleções com filtro
fusao_data = {col: load_data_from_mongo(col, start_date, end_date) for col in fusao_collections}

# Definindo as variáveis para as tabelas
variables = ['temperature_C', 'humidity_percent', 'pressure_hPa']

# Diretório de saída para as imagens das tabelas
output_dir = r'.\tabelas_marco_2024'

# Gerando imagens de tabelas com as primeiras 10 linhas de março para cada variável, com o nome do banco como título
generate_table_images(fusao_data, variables, output_dir, num_rows=10)
