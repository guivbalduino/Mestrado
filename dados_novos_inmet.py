import pandas as pd
import os

def processar_arquivos_csv(data_inicio, data_fim):
    """
    Processa todos os arquivos CSV em uma pasta específica e filtra os dados dentro do intervalo de datas especificado.
    Converte as colunas, exceto "Data Hora", para o tipo de dado float.

    Args:
    - data_inicio (str): Data de início no formato 'YYYY-MM-DD'.
    - data_fim (str): Data de fim no formato 'YYYY-MM-DD'.

    Returns:
    - DataFrame: O DataFrame final contendo os dados unificados, processados, filtrados pelo intervalo de datas
                 e com as colunas relevantes convertidas para o tipo float.
    """

    # Lista para armazenar todos os DataFrames
    todos_os_dataframes = []
    pasta_especifica = './inmet'

    # Percorra todos os arquivos na pasta
    for arquivo in os.listdir(pasta_especifica):
        if arquivo.endswith('.csv'):
            caminho_completo = os.path.join(pasta_especifica, arquivo)
            try:
                df = pd.read_csv(caminho_completo, skiprows=10, usecols=range(0, 22), delimiter=';')  # Especifique o delimitador correto
                
                # Filtrar os dados dentro do intervalo de datas especificado
                df['Data Medicao'] = pd.to_datetime(df['Data Medicao'])
                df = df[(df['Data Medicao'] >= data_inicio) & (df['Data Medicao'] <= data_fim)]
                
                if not df.empty:
                    todos_os_dataframes.append(df)
            except pd.errors.ParserError:
                print(f"Erro ao analisar o arquivo {arquivo}. Verifique o formato dos dados.")

    # Unifique todos os DataFrames em um único DataFrame
    df_final = pd.concat(todos_os_dataframes)

    df_final.dropna(inplace=True)

    # Remova linhas duplicadas com base em todas as colunas
    df_final.drop_duplicates(inplace=True)

    # Extraia a parte da hora (HHmm) da coluna "Hora Medicao"
    df_final['Hora Medicao'] = df_final['Hora Medicao'].astype(str).str.zfill(4)  # Preencha com zeros à esquerda
    df_final['Hora'] = df_final['Hora Medicao'].str[:2] + ':' + df_final['Hora Medicao'].str[2:]

    # Crie a nova coluna "Data Hora" combinando a data e a hora e converta para datetime
    df_final['Data Hora'] = pd.to_datetime(df_final['Data Medicao'].dt.strftime('%Y-%m-%d') + ' ' + df_final['Hora'])

    # Remova as colunas intermediárias "Data Medicao" e "Hora Medicao"
    df_final.drop(columns=['Data Medicao', 'Hora Medicao', 'Hora'], inplace=True)

    # Substitua vírgulas por pontos em todas as colunas numéricas
    for coluna in df_final.columns:
        if coluna != 'Data Hora' and df_final[coluna].dtype == 'object':
            df_final[coluna] = df_final[coluna].str.replace(',', '.')

    # Converta as colunas relevantes para o tipo de dado float
    for coluna in df_final.columns:
        if coluna != 'Data Hora':
            df_final[coluna] = pd.to_numeric(df_final[coluna], errors='coerce')

    return df_final

# Exemplo de uso da função
data_inicio = '2024-01-01'
data_fim = '2024-01-31'
df_final = processar_arquivos_csv(data_inicio, data_fim)
print(df_final)
