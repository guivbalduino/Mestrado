from pymongo import MongoClient
from statsmodels.tsa.statespace.sarimax import SARIMAX
from statsmodels.tsa.holtwinters import ExponentialSmoothing
import pandas as pd
from datetime import datetime

# Conectando ao MongoDB
client = MongoClient('localhost', 27017)
db = client['dados']  # Banco de dados

# Obtenha a data e hora atual
data_hora_atual = datetime.now()

# Crie o nome da coleção com base na data e hora atual
nome_colecao = "fusao_temp_sarima_es_statsmodels_" + data_hora_atual.strftime("%Y-%m-%d_%H:%M")

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

# Função para ajustar o modelo SARIMA e Exponential Smoothing a uma coluna específica
def ajustar_sarima_es(df, coluna, sarima_ordem=(1, 1, 1), sarima_sazonal=(1, 1, 1, 24), es_tendencia='add', es_sazonal='add'):
    # Ajustar modelo SARIMA
    modelo_sarima = SARIMAX(df[coluna], order=sarima_ordem, seasonal_order=sarima_sazonal)
    modelo_sarima_fit = modelo_sarima.fit(disp=False)
    df[f'{coluna}_sarima_adjusted'] = modelo_sarima_fit.fittedvalues

    # Ajustar modelo Exponential Smoothing
    modelo_es = ExponentialSmoothing(df[coluna], trend=es_tendencia, seasonal=es_sazonal, seasonal_periods=24)
    modelo_es_fit = modelo_es.fit()
    df[f'{coluna}_es_adjusted'] = modelo_es_fit.fittedvalues

    return df

# Ajustar os modelos SARIMA e Exponential Smoothing às colunas de interesse
inicio_fusao = datetime.now()
for coluna in ['temperature_C', 'humidity_percent', 'pressure_hPa']:
    df_resampled = ajustar_sarima_es(df_resampled, coluna)

fim_fusao = datetime.now()
tempo_fusao = fim_fusao - inicio_fusao

# Armazenar os resultados na coleção correspondente no MongoDB
inicio_armazenamento = datetime.now()
colecao_resultado.insert_many(df_resampled.reset_index().to_dict(orient='records'))
fim_armazenamento = datetime.now()
tempo_armazenamento = fim_armazenamento - inicio_armazenamento

# Armazenar informações sobre a fusão no banco de dados "fusoes"
info_fusao = {
    "nome_fusao": "sarima_es_fusion",
    "tipo_fusao": "temporal",
    "quantidade_dados_utilizados": df_resampled.shape[0],
    "tempo_fusao_segundos": tempo_fusao.total_seconds(),
    "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
    "data_hora": data_hora_atual,  # Adicionando a data e hora atual
    "sarima_order": (1, 1, 1),
    "sarima_seasonal_order": (1, 1, 1, 24),
    "es_tendencia": "add",
    "es_sazonalidade": "add",
    "es_sazonal_periodo": 24
}
colecao_fusoes.insert_one(info_fusao)

print("Fusão temporal SARIMA + Exponential Smoothing (statsmodels) concluída e resultados armazenados na coleção:", nome_colecao)
