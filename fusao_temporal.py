# https://pytorch-forecasting.readthedocs.io/en/stable/tutorials/stallion.html --- segue daqui
# ve mais hierarquica antes


from pytorch_forecasting.data import TimeSeriesDataSet
import pandas as pd
import numpy as np

# Arrays de data e vendas com comprimentos iguais
dates = pd.date_range(start="2022-01-01", periods=10)
sales = [100, 150, 120, 200, 180, 220, 250, 300, 280, 320]

# Criação do DataFrame
data = pd.DataFrame({
    "date": dates.astype(str),  # Convertendo para string
    "sales": sales,
})

# Adicionando uma coluna para representar o índice sequencial
data["time_idx"] = np.arange(len(data))

# Adicionando uma coluna de grupo com um valor constante para todos os registros
data["group"] = "grupo_unico"  

# Definindo os parâmetros do conjunto de dados
max_encoder_length = 5  # por exemplo
max_prediction_length = 2  # por exemplo

# Criação do conjunto de dados de séries temporais
training = TimeSeriesDataSet(
    data=data,
    time_idx="time_idx",
    target="sales",
    group_ids=["group"],  # Adicionando a coluna de grupo
    min_encoder_length=max_encoder_length // 2,  # por exemplo
    max_encoder_length=max_encoder_length,
    min_prediction_length=1,
    max_prediction_length=max_prediction_length,
    time_varying_unknown_reals=["sales"],
    time_varying_known_categoricals=["date"],
    target_normalizer="auto",
    add_relative_time_idx=True,
    add_target_scales=True,
    add_encoder_length=True
)

print(training)
