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
    inicio_modelagem = datetime.now()
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

    fim_modelagem = datetime.now()
    tempo_modelagem = fim_modelagem - inicio_modelagem

    inicio_armazenamento = datetime.now()
    # Diretório para salvar previsões e modelo
    base_dir = f"./previsoes/2024/RF/{sanitize_directory_name(hoje)}/{sanitize_directory_name(collection_name)}"
    os.makedirs(base_dir, exist_ok=True)

    # Salvar modelo
    model_path = os.path.join(base_dir, f"{sanitize_directory_name(collection_name)}_rf_model.joblib")
    joblib.dump(rf_model, model_path)
    print(f"Modelo salvo em: {model_path}")
    fim_armazenamento = datetime.now()
    tempo_armazenamento = fim_armazenamento - inicio_armazenamento

    # Salvar informações do modelo e avaliação no MongoDB
    model_params = {
        "n_estimators": 100,
        "max_depth": 10,
        "min_samples_leaf": 2,
        "min_samples_split": 5,
        "criterion": 'squared_error',
        "random_state": 42,
        "bootstrap": True,
        "y_train": y_train.shape[0]
    }
    eval_metrics = {
        "mae": mae,
        "mse": mse,
        "r2": r2
    }
    # Antes de chamar a função save_model_info
    quantidade_dados_utilizados = len(y_train)  # Ajuste se necessário para refletir a variável correta

    # E passe quantidade_dados_utilizados para save_model_info
    save_model_info(collection_name, model_params, eval_metrics, tempo_modelagem, tempo_armazenamento, hoje, quantidade_dados_utilizados,model_path)

    print(f"Modelo e informações armazenados para a coleção: {collection_name}")

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

    # Adicionar valores acima das barras
    [plt.text(i, v, f"{v:.2f}", ha='center', va='bottom') for i, v in enumerate(values)]

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

# Função para armazenar informações do modelo no MongoDB
def save_model_info(collection_name, model_params, eval_metrics, tempo_modelagem, tempo_armazenamento, hoje, quantidade_dados_utilizados,model_path):
    client = MongoClient("localhost", 27017)
    db = client["dados"]
    colecao_fusoes = db["resultados_modelagem"]

    # Dados para armazenar no MongoDB
    info_modelagem = {
        "nome_modelagem": "random_forest_regressor",
        "tipo_modelagem": "previsao_temperatura",
        "quantidade_dados_utilizados": quantidade_dados_utilizados,  # Usa o novo parâmetro
        "tempo_modelagem_segundos": tempo_modelagem.total_seconds(),
        "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
        "data_hora": hoje,
        "collection": collection_name,
        "local_modelo":model_path,
        # parâmetros do modelo
        "n_estimators": model_params["n_estimators"],
        "max_depth": model_params["max_depth"],
        "min_samples_leaf": model_params["min_samples_leaf"],
        "min_samples_split": model_params["min_samples_split"],
        "criterion": model_params["criterion"],
        "random_state": model_params["random_state"],
        "bootstrap": model_params["bootstrap"],
        # Métricas de avaliação
        "mean_absolute_error": eval_metrics["mae"],
        "mean_squared_error": eval_metrics["mse"],
        "r2_score": eval_metrics["r2"],
    }
    colecao_fusoes.insert_one(info_modelagem)
    print("Informações de avaliação e parâmetros armazenadas no MongoDB com sucesso.")



# Loop para todas as coleções 'fusao_'
hoje = datetime.now().strftime("%Y-%m-%d_%H-%M")
train_and_predict(collection_name="libelium", hoje=hoje)
