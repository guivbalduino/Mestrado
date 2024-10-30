import pandas as pd

from src.processadores_csv.A711_2006 import processar_arquivo_csv as pac_2006
from src.processadores_csv.A711_2007 import processar_arquivo_csv as pac_2007
from src.processadores_csv.A711_2008 import processar_arquivo_csv as pac_2008
from src.processadores_csv.A711_2009 import processar_arquivo_csv as pac_2009
from src.processadores_csv.A711_2010 import processar_arquivo_csv as pac_2010
from src.processadores_csv.A711_2011 import processar_arquivo_csv as pac_2011
from src.processadores_csv.A711_2012 import processar_arquivo_csv as pac_2012
from src.processadores_csv.A711_2013 import processar_arquivo_csv as pac_2013
from src.processadores_csv.A711_2014 import processar_arquivo_csv as pac_2014
from src.processadores_csv.A711_2015 import processar_arquivo_csv as pac_2015
from src.processadores_csv.A711_2016 import processar_arquivo_csv as pac_2016
from src.processadores_csv.A711_2017 import processar_arquivo_csv as pac_2017
from src.processadores_csv.A711_2018 import processar_arquivo_csv as pac_2018
from src.processadores_csv.A711_2019 import processar_arquivo_csv as pac_2019
from src.processadores_csv.A711_2020 import processar_arquivo_csv as pac_2020 
from src.processadores_csv.A711_2021 import processar_arquivo_csv as pac_2021
from src.processadores_csv.A711_2022 import processar_arquivo_csv as pac_2022
from src.processadores_csv.A711_2023 import processar_arquivo_csv as pac_2023
from src.processadores_csv.A711_2024 import processar_arquivo_csv as pac_2024


def pac_inmet():
    # Processar os arquivos CSV para cada ano
    df_2006 = pac_2006()
    df_2007 = pac_2007()
    df_2008 = pac_2008()
    df_2009 = pac_2009()
    df_2010 = pac_2010()
    df_2011 = pac_2011()
    df_2012 = pac_2012()
    df_2013 = pac_2013()
    df_2014 = pac_2014()
    df_2015 = pac_2015()
    df_2016 = pac_2016()
    df_2017 = pac_2017()
    df_2018 = pac_2018()
    df_2019 = pac_2019()
    df_2020 = pac_2020()
    df_2021 = pac_2021()
    df_2022 = pac_2022()
    df_2023 = pac_2023()
    df_2024 = pac_2024()

    # Concatenar todos os dataframes em um único dataframe
    df_concatenado = pd.concat([df_2006, df_2007, df_2008, df_2009, df_2010, df_2011, 
                                df_2012, df_2013, df_2014, df_2015, df_2016, df_2017, 
                                df_2018, df_2019, df_2020, df_2021, df_2022, df_2023, 
                                df_2024], ignore_index=True)
    
    return df_concatenado

if __name__ == "__main__":
    df = pac_inmet()

    print(df)

    caminho_arquivo2 = "E:\Git\Mestrado\src\processadores_csv\____teste.CSV"
    
    # Salva o DataFrame processado em um novo arquivo CSV
    df.to_csv(caminho_arquivo2, index=False, encoding="utf-8")
