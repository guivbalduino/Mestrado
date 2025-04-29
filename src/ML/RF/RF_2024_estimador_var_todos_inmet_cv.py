import os
import pandas as pd
from pymongo import MongoClient
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split, cross_val_score
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import matplotlib.pyplot as plt
from datetime import datetime
import csv
import joblib
from joblib import Parallel, delayed
from itertools import product
from multiprocessing import Lock

FONT_SETTINGS = {
    'font.size': 14,
    'axes.titlesize': 16,
    'axes.labelsize': 14,
    'xtick.labelsize': 12,
    'ytick.labelsize': 12,
    'legend.fontsize': 10
}

plt.rcParams.update(FONT_SETTINGS)

# Função para verificar e criar diretórios, se necessário
def ensure_directory_exists(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)

# Diretório para salvar os arquivos de comparação
output_dir = os.path.join("comparativos", "estimadores", "RF")
ensure_directory_exists(output_dir)

# Função para carregar dados de uma coleção MongoDB com filtro e tratamento do timestamp
def load_data_from_mongo(collection_name, start_date="2024-02-14", end_date="2024-09-02"):
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
    
    data = data[(data['timestamp'] >= pd.to_datetime(start_date)) & (data['timestamp'] <= pd.to_datetime(end_date))]
    
    return data

# Função para encontrar todas as coleções que começam com "inmet"
def get_fusao_collections():
    client = MongoClient("localhost", 27017)
    db = client["dados"]
    return [col for col in db.list_collection_names() if col.startswith('inmet')]

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

# Função para salvar informações do modelo no MongoDB
def save_model_info(collection_name, model_params, eval_metrics, tempo_modelagem, tempo_armazenamento, hoje, quantidade_dados_utilizados, model_path):
    client = MongoClient("localhost", 27017)
    db = client["dados"]
    colecao_fusoes = db["resultados_modelagem"]

    # Dados para armazenar no MongoDB
    info_modelagem = {
        "nome_modelagem": "random_forest_regressor",
        "tipo_modelagem": "previsao_precipitacao",
        "quantidade_dados_utilizados": quantidade_dados_utilizados,
        "tempo_modelagem_segundos": tempo_modelagem.total_seconds(),
        "tempo_armazenamento_segundos": tempo_armazenamento.total_seconds(),
        "data_hora": hoje,
        "collection": collection_name,
        "local_modelo": model_path,
        # Parâmetros do modelo
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
        "cv_mae": eval_metrics["cv_mae"],  # Adicionado MAE da validação cruzada
    }
    colecao_fusoes.insert_one(info_modelagem)
    print("Informações de avaliação e parâmetros armazenadas no MongoDB com sucesso.")

# Função para salvar os resultados no CSV com Lock
def save_results_to_csv(csv_file_path, results, lock):
    with lock:  # Usar o Lock para garantir acesso exclusivo ao arquivo
        with open(csv_file_path, mode="a", newline="") as csvfile:  # Modo "a" para adicionar linhas
            writer = csv.DictWriter(csvfile, fieldnames=[
                "n_estimators", "max_depth", "min_samples_leaf", "min_samples_split",
                "criterion", "bootstrap", "mae", "mse", "r2", "cv_mae"
            ])
            if csvfile.tell() == 0:  # Verificar se o arquivo está vazio (escrever cabeçalho apenas uma vez)
                writer.writeheader()
            writer.writerow(results)

# Função para treinar e prever com Random Forest
def train_and_predict_rf(collection_name, hoje, n_estimators, max_depth, min_samples_leaf, min_samples_split, criterion, bootstrap, random_state):
    plt.rcParams.update(FONT_SETTINGS)
    
    inicio_modelagem = datetime.now()
    
    # Carregar dados
    data = load_data_from_mongo(collection_name, start_date="2024-02-13", end_date="2024-09-03")
    
    # Extrair características temporais do 'timestamp'
    data = extract_time_features(data)
    
    # Definir variável alvo (precipitação) e características
    y = data["PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"]
    X = data[['temperature_C', 'humidity_percent', 'pressure_hPa', 'year', 'month', 'day', 'hour', 'minute']]
    
    if 'cluster_label' in data.columns:
        X['cluster_label'] = data['cluster_label']
    
    # Ordenar dados pela data para garantir que a previsão seja sequencial
    data = data.sort_values('timestamp')
    
    # Dividir em conjuntos de treino e teste (de forma cronológica)
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, shuffle=False)
    
    # Configurar e treinar o modelo
    rf_model = RandomForestRegressor(
        n_estimators=n_estimators,
        max_depth=max_depth,
        min_samples_leaf=min_samples_leaf,
        min_samples_split=min_samples_split,
        criterion=criterion,
        random_state=random_state,
        bootstrap=bootstrap
    )
    rf_model.fit(X_train, y_train)
    
    # Fazer previsões
    y_pred = rf_model.predict(X_test)

    # Avaliação
    mae = mean_absolute_error(y_test, y_pred)
    mse = mean_squared_error(y_test, y_pred)
    r2 = r2_score(y_test, y_pred)
    
    # Validação Cruzada
    cv_scores = cross_val_score(rf_model, X_train, y_train, cv=5, scoring='neg_mean_absolute_error')
    cv_mae = -cv_scores.mean()
    
    print(f"Resultados: MAE={mae:.2f}, MSE={mse:.2f}, R²={r2:.4f}, CV MAE={cv_mae:.2f}")
    
    fim_modelagem = datetime.now()
    tempo_modelagem = fim_modelagem - inicio_modelagem
    inicio_armazenamento = datetime.now()
    
    # Criar diretório único para esta combinação de hiperparâmetros
    base_dir = f"./previsoes/2024/RF/{sanitize_directory_name(hoje)}/{sanitize_directory_name(collection_name)}_{n_estimators}_{max_depth}_{min_samples_leaf}_{min_samples_split}_{criterion}_{bootstrap}"
    os.makedirs(base_dir, exist_ok=True)
    
    # Salvar modelo
    model_path = os.path.join(base_dir, f"rf_model_n{n_estimators}_maxd{max_depth}_minsl{min_samples_leaf}_minsp{min_samples_split}_crit{criterion}_boot{bootstrap}.joblib")
    joblib.dump(rf_model, model_path)
    print(f"Modelo salvo em: {model_path}")
    
    fim_armazenamento = datetime.now()
    tempo_armazenamento = fim_armazenamento - inicio_armazenamento
    
    # Salvar informações do modelo e avaliação no MongoDB
    model_params = {
        "n_estimators": n_estimators,
        "max_depth": max_depth,
        "min_samples_leaf": min_samples_leaf,
        "min_samples_split": min_samples_split,
        "criterion": criterion,
        "random_state": random_state,
        "bootstrap": bootstrap,
    }
    eval_metrics = {
        "mae": mae,
        "mse": mse,
        "r2": r2,
        "cv_mae": cv_mae,
    }
    quantidade_dados_utilizados = len(y_train)
    save_model_info(collection_name, model_params, eval_metrics, tempo_modelagem, tempo_armazenamento, hoje, quantidade_dados_utilizados, model_path)
    
    # Gerar gráficos
    X_test_dates = data.loc[X_test.index, 'timestamp']
    residuals = y_test - y_pred
    # Gráfico de Previsões vs. Valores Reais
    plt.figure(figsize=(10, 5))
    plt.plot(X_test_dates, y_test.values, label="Real", color='blue', linestyle='-')  # linha azul contínua
    plt.plot(X_test_dates, y_pred, label="Previsto", color='red', linestyle='--')     # linha vermelha tracejada
    plt.xlabel("Data")
    plt.ylabel("Precipitação Total Horária (mm)")
    plt.title(f"Previsão de Precipitação - Random Forest - INMET")
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, f"previsao_precipitacao_n{n_estimators}_maxd{max_depth}_minsl{min_samples_leaf}_minsp{min_samples_split}_crit{criterion}_boot{bootstrap}.png"), dpi=300, bbox_inches='tight')
    plt.close()

    # Gráfico de Métricas de Avaliação
    plt.figure(figsize=(10, 6))
    metrics = ['MAE', 'MSE', 'R²', 'CV MAE']
    values = [mae, mse, r2, cv_mae]
    colors = ['blue', 'orange', 'green', 'purple']
    bars = plt.bar(metrics, values, color=colors)
    for bar in bars:
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width() / 2, height, f"{height:.2f}", ha='center', va='bottom')
    plt.title(f"Avaliação do Modelo - INMET")
    plt.ylabel("Valor")
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, f"avaliacao_modelo_n{n_estimators}_maxd{max_depth}_minsl{min_samples_leaf}_minsp{min_samples_split}_crit{criterion}_boot{bootstrap}.png"), dpi=300, bbox_inches='tight')
    plt.close()

    # Gráfico de Resíduos
    plt.figure(figsize=(10, 5))
    plt.scatter(X_test_dates, residuals, color='red', label='Resíduos')
    plt.axhline(y=0, color='black', linestyle='--', label='Zero')
    plt.xlabel("Data")
    plt.ylabel("Resíduo (Erro)")
    plt.title(f"Resíduos do Modelo - INMET")
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, f"residuos_modelo_n{n_estimators}_maxd{max_depth}_minsl{min_samples_leaf}_minsp{min_samples_split}_crit{criterion}_boot{bootstrap}.png"), dpi=300, bbox_inches='tight')
    plt.close()

    # Gráfico de Todos os Dados com Previsões
    plt.figure(figsize=(10, 5))
    plt.plot(data['timestamp'], data['PRECIPITAÇÃO TOTAL, HORÁRIO (mm)'], label="Dados Reais (Todos)", color='blue', alpha=0.5)
    plt.plot(X_test_dates, y_pred, label="Previsões - Random Forest", color='red')
    plt.xlabel("Data")
    plt.ylabel("Precipitação Total Horária (mm)")
    plt.title(f"Todos os Dados com Previsões - INMET")
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, f"todos_dados_com_previsoes_n{n_estimators}_maxd{max_depth}_minsl{min_samples_leaf}_minsp{min_samples_split}_crit{criterion}_boot{bootstrap}.png"), dpi=300, bbox_inches='tight')
    plt.close()

    # Gráfico de Dados Reais com Previsões (onde há previsões)
    plt.figure(figsize=(10, 5))
    plt.plot(X_test_dates, y_test.values, label="Reais com Previsão", color='blue', marker='o', linestyle='None')
    plt.plot(X_test_dates, y_pred, label="Previsões", color='red', marker='x', linestyle='--')
    plt.xlabel("Data")
    plt.ylabel("Precipitação Total Horária (mm)")
    plt.title(f"Dados Reais e Previsões - INMET")
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, f"dados_reais_com_previsoes_n{n_estimators}_maxd{max_depth}_minsl{min_samples_leaf}_minsp{min_samples_split}_crit{criterion}_boot{bootstrap}.png"), dpi=300, bbox_inches='tight')
    plt.close()

    return {
        "n_estimators": n_estimators,
        "max_depth": max_depth,
        "min_samples_leaf": min_samples_leaf,
        "min_samples_split": min_samples_split,
        "criterion": criterion,
        "bootstrap": bootstrap,
        "mae": mae,
        "mse": mse,
        "r2": r2,
        "cv_mae": cv_mae,
    }

# Executar o código para todas as coleções que começam com "inmet"
if __name__ == "__main__":
    # Valores para os hiperparâmetros
    n_estimators_values = [50, 100, 150]
    max_depth_values = [5, 10, 20]
    min_samples_leaf_values = [2, 4, 6]
    min_samples_split_values = [2, 5, 10]
    criterion_values = ["squared_error"]
    bootstrap_values = [True, False]
    random_state = 42

    collections = get_fusao_collections()
    hoje = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    csv_lock = Lock()  # Criar um Lock para sincronizar o acesso ao arquivo CSV

    for collection_name in collections:
        print(f"\nIniciando modelagem para a coleção: {collection_name}")

        # Verificar se o arquivo da coleção já existe
        collection_file = os.path.join(output_dir, f"{sanitize_directory_name(collection_name)}.csv")
        if os.path.exists(collection_file):
            print(f"Arquivo {collection_file} já existe. Pulando...")
            continue

        # Gerar todas as combinações de hiperparâmetros
        param_combinations = list(
            product(
                n_estimators_values,
                max_depth_values,
                min_samples_leaf_values,
                min_samples_split_values,
                criterion_values,
                bootstrap_values,
            )
        )

        # Executar em paralelo
        results = Parallel(n_jobs=2)(
            delayed(train_and_predict_rf)(
                collection_name,
                hoje,
                n_estimators,
                max_depth,
                min_samples_leaf,
                min_samples_split,
                criterion,
                bootstrap,
                random_state,
            )
            for n_estimators, max_depth, min_samples_leaf, min_samples_split, criterion, bootstrap in param_combinations
        )

        # Salvar os resultados no CSV com Lock
        for result in results:
            save_results_to_csv(collection_file, result, csv_lock)

        print(f"Resultados para {collection_name} salvos em {collection_file}")

    print("\nProcesso concluído!")