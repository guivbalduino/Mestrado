import pandas as pd
import os
from datetime import datetime

# Função para converter o formato do timestamp
def convert_timestamp_format(iso_timestamp):
    try:
        # Converter ISO 8601 para datetime
        dt = datetime.fromisoformat(iso_timestamp)
        
        # Formatar para o novo formato
        new_format_timestamp = dt.strftime("%Y-%m-%d_%H:%M:%S")
        
        return new_format_timestamp
    except ValueError:
        print(f"Erro ao converter o timestamp: {iso_timestamp}")
        return iso_timestamp

# Função para dividir a coluna 7 em quatro colunas separadas
def split_column_7(data):
    try:
        parts = data.split(" ")
        temperature_C = float(parts[1]) / 100
        humidity_percent = float(parts[3]) / 10
        pressure_hPa = float(parts[5]) / 100
        battery = float(parts[7])
        return temperature_C, humidity_percent, pressure_hPa, battery
    except Exception as e:
        print(f"Erro ao dividir a coluna 7: {e}")
        return None, None, None, None

# Função para processar os arquivos CSV em uma pasta e retornar um DataFrame unificado
def processar_arquivos_csv(data_inicio, data_fim):
    # Lista para armazenar todos os DataFrames
    todos_os_dataframes = []

    pasta = "./sensor_libelium"
    
    # Percorre todos os arquivos na pasta
    for arquivo in os.listdir(pasta):
        if arquivo.endswith('.csv'):
            caminho_completo = os.path.join(pasta, arquivo)
            try:
                # Lê o arquivo CSV sem cabeçalho e seleciona as colunas desejadas
                df = pd.read_csv(caminho_completo, header=None, usecols=[1, 2, 6, 7], names=["nome_sensor", "id_dispositivo", "dados", "timestamp"])
                
                # Divide a coluna 7 em quatro colunas separadas
                df[["temperature_C", "humidity_percent", "pressure_hPa", "battery"]] = pd.DataFrame(df["dados"].apply(split_column_7).tolist(), index=df.index)
                
                # Remove a coluna "dados" original
                df.drop(columns=["dados"], inplace=True)
                
                # Converte o formato do timestamp para datetime
                df["timestamp"] = pd.to_datetime(df["timestamp"])
                
                # Converte os dados de temperatura, umidade e pressão para float
                df["temperature_C"] = df["temperature_C"].astype(float)
                df["humidity_percent"] = df["humidity_percent"].astype(float)
                df["pressure_hPa"] = df["pressure_hPa"].astype(float)
                
                # Filtra os dados dentro do intervalo de datas especificado
                df = df[(df["timestamp"] < data_inicio) | (df["timestamp"] > data_fim)]
                
                todos_os_dataframes.append(df)
            except Exception as e:
                print(f"Erro ao ler o arquivo {arquivo}: {e}")

    # Retorna a lista de DataFrames unificados
    df_unificado = pd.concat(todos_os_dataframes, ignore_index=True)
    df_unificado.drop_duplicates(inplace=True)
    return df_unificado

# Exemplo de uso da função
data_inicio = datetime(2024, 4, 1)
data_fim = datetime.now()
dfs = processar_arquivos_csv(data_inicio, data_fim)

print(dfs)
