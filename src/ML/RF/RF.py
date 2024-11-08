import os
import pandas as pd
from pymongo import MongoClient
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import matplotlib.pyplot as plt
from datetime import datetime
import joblib

# Função para carregar dados de uma coleção MongoDB com filtro e tratamento do timestamp
def load_data_from_mongo(collection_name, filter_date=None):
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

# Função para treinar e prever com Random Forest
def train_and_predict(collection_name,hoje):
    # Carregar dados
    data = load_data_from_mongo(collection_name)

    # Extrair características temporais do 'timestamp'
    data = extract_time_features(data)

    # Definir variável alvo (temperatura) e características
    y = data['temperature_C']
    
    # Selecionando variáveis para X (humidade, pressão, cluster_label se disponível, e componentes temporais)
    X = data[['humidity_percent', 'pressure_hPa', 'year', 'month', 'day', 'hour', 'minute']]  # Variáveis para previsão
    
    if 'cluster_label' in data.columns:
        X['cluster_label'] = data['cluster_label']  # Adicionando cluster_label, se existir
    
    # Ordenar dados pela data para garantir que a previsão seja sequencial
    data = data.sort_values('timestamp')

    # Dividir em conjuntos de treino e teste (de forma cronológica)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, shuffle=False)  # shuffle=False mantém ordem cronológica
    
    # Configurar e treinar o modelo
    rf_model = RandomForestRegressor(
        n_estimators=100, 
        max_depth=10, 
        min_samples_leaf=2, 
        min_samples_split=5, 
        criterion='squared_error', 
        random_state=42, 
        bootstrap=True
    )
    rf_model.fit(X_train, y_train)
    
    # Fazer previsões
    y_pred = rf_model.predict(X_test)

    # Avaliação
    mae = mean_absolute_error(y_test, y_pred)
    mse = mean_squared_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)

    # Diretório para salvar previsões e modelo
    base_dir = f"./previsoes/completa/{sanitize_directory_name(hoje)}/{sanitize_directory_name(collection_name)}"
    os.makedirs(base_dir, exist_ok=True)

    # Salvar modelo
    model_path = os.path.join(base_dir, f"{sanitize_directory_name(collection_name)}_rf_model.joblib")
    joblib.dump(rf_model, model_path)
    print(f"Modelo salvo em: {model_path}")

    # Ajustar a correspondência entre as previsões e as datas
    X_test_dates = data.loc[X_test.index, 'timestamp']  # Obter as datas reais de X_test
    
    # Plotar previsões e valores reais
    plt.figure(figsize=(10, 5))
    plt.plot(X_test_dates, y_test.values, label="Real", color='blue')
    plt.plot(X_test_dates, y_pred, label="Previsto", color='red')
    
    plt.xlabel("Data")
    plt.ylabel("Temperatura (°C)")
    plt.title(f"Previsão de Temperatura - Random Forest - {collection_name}")
    plt.legend()
    
    # Formatar o eixo X para exibir as datas de forma legível
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, "previsao_temperatura.png"), dpi=300)
    plt.close()

    # Gráfico de avaliação - MAE, MSE, R2
    plt.figure(figsize=(8, 6))
    metrics = ['MAE', 'MSE', 'R2']
    values = [mae, mse, r2]
    plt.bar(metrics, values, color=['blue', 'orange', 'green'])
    plt.title(f"Avaliação do Modelo - {collection_name}")
    plt.ylabel("Valor")
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, "avaliacao_modelo.png"), bbox_inches='tight', dpi=300)
    plt.close()
    
    # Gráfico de resíduos (Erro entre previsões e valores reais)
    residuals = y_test - y_pred
    plt.figure(figsize=(10, 5))
    plt.scatter(X_test_dates, residuals, color='red', label='Resíduos')
    plt.axhline(y=0, color='black', linestyle='--', label='Zero')
    plt.xlabel("Data")
    plt.ylabel("Resíduo (Erro)")
    plt.title(f"Resíduos do Modelo - {collection_name}")
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, "residuos_modelo.png"), dpi=300)
    plt.close()

    # Gráfico de Todos os Dados Juntos com Previsão
    plt.figure(figsize=(10, 5))
    plt.plot(data['timestamp'], data['temperature_C'], label="Todos os Dados Reais", color='blue', alpha=0.5)
    plt.plot(X_test_dates, y_pred, label="Previsões - Random Forest", color='red')
    
    plt.xlabel("Data")
    plt.ylabel("Temperatura (°C)")
    plt.title(f"Todos os Dados e Previsão - {collection_name}")
    plt.legend()
    
    # Formatar o eixo X para exibir as datas de forma legível
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, "todos_dados_com_previsao.png"), dpi=300)
    plt.close()

    print(f"Gráficos de previsão, avaliação, resíduos e todos os dados salvos em: {base_dir}")



# Loop para todas as coleções 'fusao_'
hoje = datetime.now().strftime("%Y-%m-%d_%H-%M")
collections = get_fusao_collections()
for collection in collections:
    train_and_predict(collection,hoje)
    break  # Remover este break quando quiser processar todas as coleções
