import pandas as pd


def processar_arquivo_csv():
    caminho_arquivo = "E:\Git\Mestrado\inmet\extraidos\INMET_SE_SP_A711_SAO CARLOS_01-01-2017_A_31-12-2017.CSV"
    """
    Processa um arquivo CSV, renomeia colunas de data e hora, unifica em uma única coluna de data e hora,
    remove linhas onde a pressão atmosférica é -9999 e salva o resultado em um novo arquivo CSV.

    Args:
    - caminho_arquivo (str): Caminho para o arquivo CSV de entrada.

    Returns:
    - DataFrame: O DataFrame processado.
    """

    try:
        df_is_old = False
        # Lê o arquivo CSV
        df = pd.read_csv(
            caminho_arquivo, skiprows=8, delimiter=";", encoding="ISO-8859-1"
        )

        # Verifica se há colunas vazias no final e as remove
        df = df.loc[:, ~df.columns.str.contains("^Unnamed")]

        # Renomeia a coluna de data para um nome padrão
        if "DATA (YYYY-MM-DD)" in df.columns:
            df.rename(columns={"DATA (YYYY-MM-DD)": "Data"}, inplace=True)
            df_is_old = True
        elif "DATA" in df.columns:
            df.rename(columns={"DATA": "Data"}, inplace=True)
            df_is_old = True
        elif "Data" in df.columns:
            df.rename(columns={"Data": "Data"}, inplace=True)
        else:
            print(f"Erro: coluna de data não encontrada no arquivo {caminho_arquivo}")
            return pd.DataFrame()

        # Renomeia a coluna de hora para um nome padrão
        if "HORA (UTC)" in df.columns:
            df.rename(columns={"HORA (UTC)": "Hora UTC"}, inplace=True)
        elif "Hora UTC" in df.columns:
            df.rename(columns={"Hora UTC": "Hora UTC"}, inplace=True)
        else:
            print(f"Erro: coluna de hora não encontrada no arquivo {caminho_arquivo}")
            return pd.DataFrame()

        # Converte a coluna de data para datetime
        df["Data"] = pd.to_datetime(df["Data"], errors="coerce")

        # Normaliza a coluna de hora para um formato uniforme (HHmm)
        df["Hora UTC"] = df["Hora UTC"].astype(str).str.zfill(4)

        # Cria a nova coluna "Data Hora" combinando a data e a hora
        if df_is_old:
            df["Hora"] = df["Hora UTC"]
        else:
            df["Hora"] = df["Hora UTC"].str[:2] + ":" + df["Hora UTC"].str[2:]

        df["Data Hora"] = pd.to_datetime(
            df["Data"].dt.strftime("%Y-%m-%d") + " " + df["Hora"]
        )

        # Remove as colunas intermediárias "Data" e "Hora UTC"
        df.drop(columns=["Data", "Hora UTC", "Hora"], inplace=True)

        # Substitui vírgulas por pontos em todas as colunas numéricas
        for coluna in df.columns:
            if df[coluna].dtype == "object":
                df[coluna] = df[coluna].str.replace(",", ".")
                df[coluna] = pd.to_numeric(df[coluna], errors="coerce")

        # Remove linhas onde a medição é -9999
        # Lista de colunas para verificar
        colunas = [
            "PRECIPITAÇÃO TOTAL, HORÁRIO (mm)",
            "PRESSÃO ATMOSFERICA MAX.NA HORA ANT. (AUT) (mB)",
            "PRESSÃO ATMOSFERICA MIN. NA HORA ANT. (AUT) (mB)",
            "RADIACAO GLOBAL (KJ/m²)",
            "TEMPERATURA DO PONTO DE ORVALHO (°C)",
            "TEMPERATURA MÁXIMA NA HORA ANT. (AUT) (°C)",
            "TEMPERATURA MÍNIMA NA HORA ANT. (AUT) (°C)",
            "TEMPERATURA ORVALHO MAX. NA HORA ANT. (AUT) (°C)",
            "TEMPERATURA ORVALHO MIN. NA HORA ANT. (AUT) (°C)",
            "UMIDADE REL. MAX. NA HORA ANT. (AUT) (%)",
            "UMIDADE REL. MIN. NA HORA ANT. (AUT) (%)",
            "VENTO, DIREÇÃO HORARIA (gr) (° (gr))",
            "VENTO, RAJADA MAXIMA (m/s)",
            "VENTO, VELOCIDADE HORARIA (m/s)",
        ]
        # Filtrar linhas indesejadas
        for coluna in colunas:
            df = df[df[coluna] >= 0]

        # Renomeia colunas específicas
        df.rename(
            columns={
                "PRESSAO ATMOSFERICA AO NIVEL DA ESTACAO, HORARIA (mB)": "pressure_hPa",
                "TEMPERATURA DO AR - BULBO SECO, HORARIA (°C)": "temperature_C",
                "UMIDADE RELATIVA DO AR, HORARIA (%)": "humidity_percent",
                "Data Hora": "timestamp",
            },
            inplace=True,
        )

        # Reordena as colunas para garantir que a coluna 'timestamp', 'temperature_C', 'humidity_percent', 'pressure_hPa' estejam no início
        colunas_reordenadas = [
            "timestamp",
            "temperature_C",
            "humidity_percent",
            "pressure_hPa",
            "PRECIPITAÇÃO TOTAL, HORÁRIO (mm)",
            "PRESSÃO ATMOSFERICA MAX.NA HORA ANT. (AUT) (mB)",
            "PRESSÃO ATMOSFERICA MIN. NA HORA ANT. (AUT) (mB)",
            "RADIACAO GLOBAL (KJ/m²)",
            "TEMPERATURA DO PONTO DE ORVALHO (°C)",
            "TEMPERATURA MÁXIMA NA HORA ANT. (AUT) (°C)",
            "TEMPERATURA MÍNIMA NA HORA ANT. (AUT) (°C)",
            "TEMPERATURA ORVALHO MAX. NA HORA ANT. (AUT) (°C)",
            "TEMPERATURA ORVALHO MIN. NA HORA ANT. (AUT) (°C)",
            "UMIDADE REL. MAX. NA HORA ANT. (AUT) (%)",
            "UMIDADE REL. MIN. NA HORA ANT. (AUT) (%)",
            "VENTO, DIREÇÃO HORARIA (gr) (° (gr))",
            "VENTO, RAJADA MAXIMA (m/s)",
            "VENTO, VELOCIDADE HORARIA (m/s)",
        ]
        df = df[colunas_reordenadas]

        # Remove o fuso horário do 'timestamp'
        df["timestamp"] = df["timestamp"].dt.strftime("%Y-%m-%d %H:%M:%S")

        return df

    except pd.errors.ParserError as e:
        print(
            f"Erro ao analisar o arquivo {caminho_arquivo}. Verifique o formato dos dados. {e}"
        )
        return pd.DataFrame()
    except Exception as e:
        print(f"Ocorreu um erro ao processar o arquivo {caminho_arquivo}: {e}")
        return pd.DataFrame()

if __name__ == "__main__":
# Caminho do arquivo específico
    caminho_arquivo2 = "E:\Git\Mestrado\src\processadores_csv\____INMET_SE_SP_A711_SAO CARLOS_01-01-2017_A_31-12-2017.CSV"
    # Processa o arquivo
    df_final = processar_arquivo_csv()

    # Exibe o DataFrame final
    print(df_final)

    # Salva o DataFrame processado em um novo arquivo CSV
    df_final.to_csv(caminho_arquivo2, index=False, encoding="utf-8")
