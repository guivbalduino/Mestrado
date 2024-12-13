import os
import pandas as pd
from pymongo import MongoClient
from sklearn.svm import SVR
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import matplotlib.pyplot as plt
from datetime import datetime
import joblib
import numpy as np

# Função para carregar dados de uma coleção MongoDB com filtro e tratamento do timestamp
def load_data_from_mongo(collection_name, filter_date="2024-03-01"):
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

# Função para encontrar todas as coleções que começam com "fusao_"
def get_fusao_collections():
    client = MongoClient("localhost", 27017)
    db = client["dados"]
    return [col for col in db.list_collection_names() if col.startswith('fusao_')]

# Função para sanitizar nomes de arquivos/diretórios e substituir ":" por "-"
def sanitize_directory_name(name):
    return name.replace(":", "-").replace("/", "-").replace("\\", "-")

# Função para extrair componentes temporais do timestamp
def extract_time_features(data):
    data['year'] = data['timestamp'].dt.year
    data['month'] = data['timestamp'].dt.month
    data['day'] = data['timestamp'].dt.day
    data['hour'] = data['timestamp'].dt.hour
    data['minute'] = data['timestamp'].dt.minute
    return data

# Função para treinar e prever com SVM
def train_and_predict_svm(collection_name, hoje, C, epsilon):
    inicio_modelagem = datetime.now()
    # Carregar dados
    data = load_data_from_mongo(collection_name)

    # Extrair características temporais do 'timestamp'
    data = extract_time_features(data)

    # Definir variável alvo (temperatura) e características
    y = data['temperature_C']
    
    # Selecionando variáveis para X (humidade, pressão, cluster_label se disponível, e componentes temporais)
    X = data[['humidity_percent', 'pressure_hPa', 'year', 'month', 'day', 'hour', 'minute']]
    
    if 'cluster_label' in data.columns:
        X['cluster_label'] = data['cluster_label']
    
    # Ordenar dados pela data para garantir que a previsão seja sequencial
    data = data.sort_values('timestamp')

    # Dividir em conjuntos de treino e teste (de forma cronológica)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, shuffle=False)
    
    # Configurar e treinar o modelo SVM
    svm_model = SVR(kernel='rbf', C=C, epsilon=epsilon)
    svm_model.fit(X_train, y_train)
    
    # Fazer previsões
    y_pred = svm_model.predict(X_test)

    # Avaliação
    mae = mean_absolute_error(y_test, y_pred)
    mse = mean_squared_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)

    print(f"Resultados: MAE={mae:.2f}, MSE={mse:.2f}, R²={r2:.4f}")
    
    # Salvar modelo e gráficos conforme o original (opcional)

    return r2  # Retorna o R² para comparar os modelos

# Executar o código para todas as coleções que começam com "fusao_"
if __name__ == "__main__":
    # Parâmetros para teste
    # Valores para o parâmetro C
    C_values = list(range(10, 110, 10)) + list(range(150, 900, 50)) + list(range(900, 1010, 10))

    # Valores para o parâmetro epsilon
    epsilon_values = [0.01] + [round(i, 2) for i in list(range(1, 90))] + list(range(0.91, 1.01, 0.01))

    
    best_r2 = -float("inf")  # Para rastrear o melhor modelo com base no R²
    best_params = None       # Para armazenar os melhores parâmetros
    best_collection = None   # Coleção correspondente aos melhores parâmetros
    
    collection_name = 'fusao_temp_arima_es_sktime_2024-08-11_16:58'
    for param_c in C_values:
        for param_ep in epsilon_values:
            print(f"Treinando com C={param_c} e epsilon={param_ep}")
            hoje = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
            # Atualizar a função de treinamento para aceitar C e epsilon
            r2 = train_and_predict_svm(collection_name, hoje, param_c, param_ep)
            
            # Avaliar se este modelo é melhor
            if r2 > best_r2:
                best_r2 = r2
                best_params = (param_c, param_ep)
                best_collection = collection_name
    
    # Resultado final
    print("\nMelhor configuração encontrada:")
    print(f"R²: {best_r2:.4f}")
    print(f"Parâmetros: C={best_params[0]}, epsilon={best_params[1]}")
    print(f"Coleção: {best_collection}")
