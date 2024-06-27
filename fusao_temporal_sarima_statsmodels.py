from pymongo import MongoClient
from statsmodels.tsa.statespace.sarimax import SARIMAX
import pandas as pd
from datetime import datetime

# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Obtenha a data e hora atual
data_hora_atual = datetime.now()

# Crie o nome da coleção com base na data e hora atual
nome_colecao = "fusao_temp_sarima_statsmodels_" + data_hora_atual.strftime("%Y-%m-%d_%H:%M")

# Coleção para armazenar os resultados
colecao_resultado = db[nome_colecao]

# Coleção para armazenar as informações sobre as fusões
colecao_fusoes = db['fusoes']

# Coleções de dados originais
colecao_inmet = db['inmet']
colecao_libelium = db['libelium']

# Projetar e recuperar apenas as colunas necessárias para cada coleção
projecao = {"timestamp": 1, "temperature_C": 1, "humidity_percent": 1, "pressure_hPa": 1}

dados_inmet = list(colecao_inmet.find({}, projecao))
dados_libelium = list(colecao_libelium.find({}, projecao))

# Converter para DataFrames
df_inmet = pd.DataFrame(dados_inmet)
df_libelium = pd.DataFrame(dados_libelium)

# Concatenar os DataFrames
df_concatenado = pd.concat([df_inmet, df_libelium], ignore_index=True)

# Transformar a coluna de timestamp para datetime
df_concatenado['timestamp'] = pd.to_datetime(df_concatenado['timestamp'])

# Resample dos dados para uma frequência uniforme (exemplo: 1 hora)
df_resampled = df_concatenado.set_index('timestamp').resample('H').mean()

# Interpolar os valores ausentes para preencher a frequência
df_resampled.interpolate(method='time', inplace=True)

# Remover linhas que ainda possuem valores ausentes após a interpolação
df_resampled.dropna(inplace=True)

# Função para ajustar o modelo SARIMA aos dados
def ajustar_sarima(df, coluna, ordem=(1, 1, 1), sazonal_ordem=(1, 1, 1, 12)):
    modelo = SARIMAX(df[coluna], order=ordem, seasonal_order=sazonal_ordem)
    modelo_fit = modelo.fit(disp=False)
    df[f'{coluna}_sarima_adjusted'] = modelo_fit.fittedvalues
    return df

# Ajustar o modelo SARIMA às colunas de interesse
inicio_fusao = datetime.now()
for coluna in ['temperature_C', 'humidity_percent', 'pressure_hPa']:
    df_resampled = ajustar_sarima(df_resampled, coluna)

fim_fusao = datetime.now()
tempo_fusao = fim_fusao - inicio_fusao

# Armazenar os resultados na coleção correspondente no MongoDB
inicio_armazenamento = datetime.now()
colecao_resultado.insert_many(df_resampled.reset_index().to_dict(orient='records'))
fim_armazenamento = datetime.now()
tempo_armazenamento = fim_armazenamento - inicio_armazenamento

# Armazenar informações sobre a fusão no banco de dados "fusoes"
info_fusao = {
    "nome_fusao": "sarima_fusion",
    "tipo_fusao": "temporal",
    "quantidade_dados_utilizados": df_resampled.shape[0],
    "tempo_fusao_segundos": tempo_fusao.total_seconds(),
    "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
    "data_hora": data_hora_atual,  # Adicionando a data e hora atual
    "sarima_order": (1, 1, 1),
    "sarima_seasonal_order": (1, 1, 1, 12)
}
colecao_fusoes.insert_one(info_fusao)

print("Fusão temporal SARIMA concluída e resultados armazenados na coleção:", nome_colecao)
