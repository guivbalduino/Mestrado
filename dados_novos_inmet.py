import pandas as pd
import os

def processar_arquivos_csv(data_inicio, data_fim):
    """
    Processa todos os arquivos CSV em uma pasta específica e filtra os dados fora do intervalo de datas especificado.
    Converte as colunas, exceto "Data Hora", para o tipo de dado float.

    Args:
    - data_inicio (str): Data de início no formato 'YYYY-MM-DD'.
    - data_fim (str): Data de fim no formato 'YYYY-MM-DD'.

    Returns:
    - DataFrame: O DataFrame final contendo os dados unificados, processados, filtrados fora do intervalo de datas
                 e com as colunas relevantes convertidas para o tipo float.
    """

    # Lista para armazenar todos os DataFrames
    todos_os_dataframes = []
    pasta_especifica = './inmet/extraidos'

    # Percorre todos os arquivos na pasta
    for arquivo in os.listdir(pasta_especifica):
        if arquivo.endswith('.CSV'):
            caminho_completo = os.path.join(pasta_especifica, arquivo)
            try:
                df = pd.read_csv(caminho_completo, skiprows=8, delimiter=';', encoding='ISO-8859-1')
                
                # Renomeia a coluna de data para um nome padrão
                data_colunas = ['DATA (YYYY-MM-DD)', 'Data', 'DATA']
                coluna_data = None
                for col in data_colunas:
                    if col in df.columns:
                        coluna_data = col
                        df.rename(columns={coluna_data: 'Data'}, inplace=True)
                        break
                
                if coluna_data is None:
                    print(f"Erro: coluna de data não encontrada no arquivo {arquivo}")
                    continue
                
                # Filtra os dados fora do intervalo de datas especificado
                df['Data'] = pd.to_datetime(df['Data'], format='%Y-%m-%d')
                df = df[(df['Data'] < data_inicio) | (df['Data'] > data_fim)]
                
                if not df.empty:
                    todos_os_dataframes.append(df)
            except pd.errors.ParserError as e:
                print(f"Erro ao analisar o arquivo {arquivo}. Verifique o formato dos dados. {e}")
            except Exception as e:
                print(f"Ocorreu um erro ao processar o arquivo {arquivo}: {e}")

    # Verifica se há dados disponíveis
    if not todos_os_dataframes:
        return pd.DataFrame()  # Retorna um DataFrame vazio se não houver dados

    # Unifica todos os DataFrames em um único DataFrame
    df_final = pd.concat(todos_os_dataframes)

    df_final.dropna(inplace=True)

    # Remove linhas duplicadas com base em todas as colunas
    df_final.drop_duplicates(inplace=True)

    # Extrai a parte da hora (HHmm) da coluna "Hora UTC"
    df_final['Hora UTC'] = df_final['Hora UTC'].astype(str).str.zfill(4)  # Preenche com zeros à esquerda
    df_final['Hora'] = df_final['Hora UTC'].str[:2] + ':' + df_final['Hora UTC'].str[2:]

    # Cria a nova coluna "Data Hora" combinando a data e a hora e converte para datetime
    df_final['Data Hora'] = pd.to_datetime(df_final['Data'].dt.strftime('%Y-%m-%d') + ' ' + df_final['Hora'])

    # Remove as colunas intermediárias "Data" e "Hora UTC"
    df_final.drop(columns=['Data', 'Hora UTC', 'Hora'], inplace=True)

    # Substitui vírgulas por pontos em todas as colunas numéricas
    for coluna in df_final.columns:
        if coluna != 'Data Hora' and df_final[coluna].dtype == 'object':
            df_final[coluna] = df_final[coluna].str.replace(',', '.')

    # Converte as colunas relevantes para o tipo de dado float
    for coluna in df_final.columns:
        if coluna != 'Data Hora':
            df_final[coluna] = pd.to_numeric(df_final[coluna], errors='coerce')

    # Substitui espaços nos cabeçalhos por underscores
    df_final.columns = df_final.columns.str.replace(' ', '_')

    df_final.rename(columns={
        'PRESSAO_ATMOSFERICA_AO_NIVEL_DA_ESTACAO,_HORARIA_(mB)': 'pressure_hPa',
        'TEMPERATURA_DO_AR_-_BULBO_SECO,_HORARIA_(°C)': 'temperature_C',
        'UMIDADE_RELATIVA_DO_AR,_HORARIA_(%)': 'humidity_percent',
        'Data_Hora': 'timestamp'
    }, inplace=True)

    return df_final

# Exemplo de uso da função
data_inicio = '2024-01-01'
data_fim = '2024-01-31'
df_final = processar_arquivos_csv(data_inicio, data_fim)
print(df_final)
