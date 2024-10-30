import os
import pandas as pd
import matplotlib.pyplot as plt
from pymongo import MongoClient
from datetime import datetime

# Função para carregar dados de uma coleção MongoDB com filtro e tratamento do timestamp
def load_data_from_mongo(collection_name, filter_date=None):
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

# Função para encontrar todas as coleções que começam com "fusao_temp_"
def get_fusao_collections():
    client = MongoClient("localhost", 27017)
    db = client["dados"]
    return [col for col in db.list_collection_names() if col.startswith('fusao_temp_')]

# Função para garantir que o nome do arquivo seja válido
def sanitize_filename(filename):
    return "".join(c if c.isalnum() or c in (' ', '_') else '_' for c in filename)

# Função para gerar uma tabela consolidada com dados de várias coleções em grupos
def generate_consolidated_grouped_tables(fusao_data, variable, output_dir, group_sizes, num_rows=10):
    os.makedirs(output_dir, exist_ok=True)
    
    # Dividir as coleções em grupos de acordo com o tamanho desejado
    collections_list = list(fusao_data.items())
    groups = []
    start = 0
    for size in group_sizes:
        end = start + size
        groups.append(collections_list[start:end])
        start = end

    # Processar cada grupo
    for i, group in enumerate(groups):
        # Iniciar a tabela com a coluna 'timestamp'
        consolidated_table = pd.DataFrame()

        for collection_name, data in group:
            if variable in data.columns:
                # Extrair o nome entre 'fusao_temp_' e '_2024'
                col_name = collection_name.replace('fusao_temp_', '').replace('_2024', '')

                # Selecionar os dados com timestamp e a variável, formatando a variável com uma casa decimal
                temp_table = data[['timestamp', variable]].copy()
                
                # Remover as horas do timestamp
                temp_table['timestamp'] = temp_table['timestamp']#.dt.date
                
                temp_table[variable] = temp_table[variable].astype(float).round(1)

                # Renomear a coluna da variável para o nome da coleção (col_name)
                temp_table.rename(columns={variable: col_name}, inplace=True)

                # Juntar os dados por 'timestamp'
                if consolidated_table.empty:
                    consolidated_table = temp_table
                else:
                    consolidated_table = pd.merge(consolidated_table, temp_table, on='timestamp', how='outer')

        # Selecionar as primeiras 'num_rows' linhas
        consolidated_table = consolidated_table.head(num_rows)
        
        # Criar figura para a tabela
        fig, ax = plt.subplots(figsize=(10, 5))  # Ajuste o tamanho da imagem conforme necessário
        
        # Adicionar título com a variável e grupo
        fig.suptitle(f"Tabela consolidada - {variable} (Grupo {i+1})", fontsize=16)
        ax.axis('tight')
        ax.axis('off')
        
        # Renderizar a tabela
        table_render = ax.table(cellText=consolidated_table.values, colLabels=consolidated_table.columns, cellLoc='center', loc='center')

        # Salvar a imagem da tabela em PNG
        file_name = f"{sanitize_filename(variable)}_grupo_{i+1}_consolidated_tabela.png"
        file_path = os.path.join(output_dir, file_name)
        plt.savefig(file_path, bbox_inches='tight', dpi=300)  # Salvar com alta resolução
        plt.close()
        print(f"Imagem da tabela consolidada (Grupo {i+1}) salva como: {file_path}")

# Carregando as coleções que começam com "fusao_temp_"
fusao_collections = get_fusao_collections()

# Definindo a data a partir da qual os dados serão filtrados (exemplo: março de 2024)
start_date = pd.to_datetime('2024-03-01')

# Carregando os dados das coleções de fusao_temp_ com filtro
fusao_data = {col: load_data_from_mongo(col, start_date) for col in fusao_collections}

# Variáveis para o eixo y
variables = ['temperature_C', 'humidity_percent', 'pressure_hPa']

# Diretório de saída para os gráficos
output_dir = r'.\tabelas_consolidadas'

# Tamanhos dos grupos (exemplo: 3, 3, 4)
group_sizes = [3, 3, 4]

# Gerar tabelas consolidadas para cada variável em grupos
for variable in variables:
    generate_consolidated_grouped_tables(fusao_data, variable, output_dir, group_sizes, num_rows=15)
