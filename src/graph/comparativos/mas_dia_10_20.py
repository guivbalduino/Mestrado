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
    
    if 'timestamp' in data.columns:
        if data['timestamp'].dtype == 'object':
            data['timestamp'] = pd.to_datetime(data['timestamp'], format='%Y-%m-%d %H:%M:%S')
    
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
    filename = filename.replace(":", "_")  # Substitui ":" por "_"
    return "".join(c if c.isalnum() or c in (' ', '_') else '_' for c in filename)

# Função para gerar gráficos de linha em múltiplos períodos para cada mês separadamente
def generate_line_graphs(fusao_data, variable, periods, output_base_dir):
    today = datetime.now().strftime("%Y_%m_%d")  # Data formatada com "_"
    period_dir = os.path.join(output_base_dir, f"{today}")
    os.makedirs(period_dir, exist_ok=True)
    
    # Criar subpasta "junção" dentro da pasta de hoje
    junction_dir = os.path.join(period_dir, "junção")
    os.makedirs(junction_dir, exist_ok=True)
    
    for period in periods:
        start_day, end_day = period

        for month in range(1, 13):  # Itera sobre cada mês (de 1 a 12)
            junction_data = {}

            for collection_name, data in fusao_data.items():
                if variable in data.columns:
                    # Filtrar dados pelo mês e período especificado
                    filtered_data = data[(data['timestamp'].dt.day >= start_day) & 
                                         (data['timestamp'].dt.day <= end_day) & 
                                         (data['timestamp'].dt.month == month)]
                    
                    col_name = collection_name.replace('fusao_temp_', '').replace('_2024', '')

                    # Coletar dados para o gráfico de junção
                    if not filtered_data.empty:
                        junction_data[col_name] = filtered_data[['timestamp', variable]]
            
            # Gerar gráfico de junção para o período, mês e variável
            if junction_data:
                plt.figure(figsize=(12, 6))
                for col_name, df in junction_data.items():
                    plt.plot(df['timestamp'], df[variable], label=col_name)
                
                plt.title(f"Junção de {variable.capitalize()} ({start_day}-{end_day} de {month}/2024)")
                plt.xlabel("Data")
                plt.ylabel(variable.capitalize())
                plt.legend()
                
                # Salvar gráfico de junção
                junction_file_name = f"junção_{sanitize_filename(variable)}_mes_{month}_dia_{start_day}_{end_day}.png"
                junction_file_path = os.path.join(junction_dir, junction_file_name)
                plt.savefig(junction_file_path, bbox_inches='tight', dpi=300)
                plt.close()
                print(f"Gráfico de junção salvo em: {junction_file_path}")

# Carregar as coleções que começam com "fusao_temp_"
fusao_collections = get_fusao_collections()

# Data inicial para filtro
start_date = pd.to_datetime('2024-03-01')

# Carregar dados de fusao_temp_ com filtro
fusao_data = {col: load_data_from_mongo(col, start_date) for col in fusao_collections}

# Variáveis para o eixo y
variables = ['temperature_C', 'humidity_percent', 'pressure_hPa',"PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"]

# Diretório base para os gráficos
output_base_dir = r'./comparativos/mini_graphs/mes_dia_10_20'

# Definir períodos (exemplo: dias 10 a 20 de cada mês)
periods = [(10, 20)]

# Gerar gráficos de linha para cada variável em cada período
for variable in variables:
    generate_line_graphs(fusao_data, variable, periods, output_base_dir)
