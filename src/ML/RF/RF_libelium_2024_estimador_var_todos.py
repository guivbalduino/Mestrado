import os
import pandas as pd
from pymongo import MongoClient
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import matplotlib.pyplot as plt
from datetime import datetime
import csv

# Função para verificar e criar diretórios, se necessário
def ensure_directory_exists(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)

# Diretório para salvar os arquivos de comparação
output_dir = os.path.join("comparativos", "estimadores", "RF")
ensure_directory_exists(output_dir)

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
    return [col for col in db.list_collection_names() if col.startswith('libelium')]

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
def train_and_predict_rf(           collection_name, 
                                    hoje, 
                                    n_estimators, 
                                    max_depth, 
                                    min_samples_leaf, 
                                    min_samples_split, 
                                    criterion, 
                                    bootstrap,
                                    random_state
                                ):
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

    print(f"Resultados: MAE={mae:.2f}, MSE={mse:.2f}, R²={r2:.4f}")
    
    # Salvar modelo e gráficos conforme o original (opcional)

    return mae,mse,r2  # Retorna o 



# Executar o código para todas as coleções que começam com "fusao_"
# Executar o código para todas as coleções que começam com "fusao_"
if __name__ == "__main__":
    import csv
    from datetime import datetime

    # Valores para os hiperparâmetros
    n_estimators_values = [50, 100, 150]
    max_depth_values = [5, 10]
    min_samples_leaf_values = [2, 4]
    min_samples_split_values = [2,10]
    criterion_values = ['squared_error']
    bootstrap_values = [True, False]  # Inclua se quiser variar também o bootstrap
    random_state = 42

    collections = get_fusao_collections()  # Obtenha todas as coleções "fusao_"
    hoje = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    results = []  # Lista para armazenar os melhores resultados de cada coleção

    for collection_name in collections:
        print(f"\nIniciando modelagem para a coleção: {collection_name}")

        # Verificar se o arquivo da coleção já existe
        collection_file = os.path.join(output_dir, f"{collection_name}.csv")
        if os.path.exists(collection_file):
            print(f"Arquivo {collection_file} já existe. Pulando...")
            continue

        # Inicializar lista para registrar todos os parâmetros testados
        collection_results = []

        # Inicializar os melhores resultados para a coleção atual
        best_mae = float("inf")  # Melhor MAE (quanto menor, melhor)
        best_params_mae = None  # Melhores parâmetros para MAE
        best_mse = float("inf")  # Melhor MSE (quanto menor, melhor)
        best_params_mse = None  # Melhores parâmetros para MSE
        best_r2 = -float("inf")  # Melhor R² (quanto maior, melhor)
        best_params_r2 = None  # Melhores parâmetros para R²

        # Iteração sobre todas as combinações
        for n_estimators in n_estimators_values:
            for max_depth in max_depth_values:
                for min_samples_leaf in min_samples_leaf_values:
                    for min_samples_split in min_samples_split_values:
                        for criterion in criterion_values:
                            for bootstrap in bootstrap_values:
                                # Treinar e avaliar o modelo
                                mae, mse, r2 = train_and_predict_rf(
                                    collection_name, 
                                    hoje, 
                                    n_estimators, 
                                    max_depth, 
                                    min_samples_leaf, 
                                    min_samples_split, 
                                    criterion, 
                                    bootstrap,
                                    random_state
                                )

                                # Salvar parâmetros e métricas no resultado da coleção
                                collection_results.append({
                                    "n_estimators": n_estimators,
                                    "max_depth": max_depth,
                                    "min_samples_leaf": min_samples_leaf,
                                    "min_samples_split": min_samples_split,
                                    "criterion": criterion,
                                    "bootstrap": bootstrap,
                                    "mae": mae,
                                    "mse": mse,
                                    "r2": r2,
                                })

                                # Atualizar o melhor MAE
                                if mae < best_mae:
                                    best_mae = mae
                                    best_params_mae = {
                                        "n_estimators": n_estimators,
                                        "max_depth": max_depth,
                                        "min_samples_leaf": min_samples_leaf,
                                        "min_samples_split": min_samples_split,
                                        "criterion": criterion,
                                        "bootstrap": bootstrap,
                                    }

                                # Atualizar o melhor MSE
                                if mse < best_mse:
                                    best_mse = mse
                                    best_params_mse = {
                                        "n_estimators": n_estimators,
                                        "max_depth": max_depth,
                                        "min_samples_leaf": min_samples_leaf,
                                        "min_samples_split": min_samples_split,
                                        "criterion": criterion,
                                        "bootstrap": bootstrap,
                                    }

                                # Atualizar o melhor R²
                                if r2 > best_r2:
                                    best_r2 = r2
                                    best_params_r2 = {
                                        "n_estimators": n_estimators,
                                        "max_depth": max_depth,
                                        "min_samples_leaf": min_samples_leaf,
                                        "min_samples_split": min_samples_split,
                                        "criterion": criterion,
                                        "bootstrap": bootstrap,
                                    }

        # Salvar todos os resultados testados para a coleção em CSV
        with open(f"comparativos/estimadores/RF/{sanitize_directory_name(collection_name)}.csv", mode="w", newline="") as csvfile:
            writer = csv.DictWriter(csvfile, fieldnames=[
                "n_estimators", "max_depth", "min_samples_leaf", "min_samples_split",
                "criterion", "bootstrap", "mae", "mse", "r2"
            ])
            writer.writeheader()
            writer.writerows(collection_results)

        print(f"Resultados para {collection_name} salvos em {collection_file}")

        # Salvar os melhores resultados da coleção atual
        results.append({
            "collection_name": collection_name,
            "best_mae": best_mae,
            "best_params_mae": best_params_mae,
            "best_mse": best_mse,
            "best_params_mse": best_params_mse,
            "best_r2": best_r2,
            "best_params_r2": best_params_r2,
        })

    # Salvar resumo dos melhores resultados no arquivo CSV
    output_file = f"comparativos/estimadores/RF/{sanitize_directory_name(collection_name)}_melhores_parametros.csv"
    with open(output_file, mode="w", newline="") as csvfile:
        writer = csv.writer(csvfile)
        writer.writerow(["Collection Name", "Best MAE", "Best Params MAE", "Best MSE", "Best Params MSE", "Best R²", "Best Params R²"])
        for result in results:
            writer.writerow([
                result["collection_name"],
                result["best_mae"],
                result["best_params_mae"],
                result["best_mse"],
                result["best_params_mse"],
                result["best_r2"],
                result["best_params_r2"],
            ])

    # Mostrar o melhor de cada coleção no final
    for result in results:
        print(f"\nColeção: {result['collection_name']}")
        print(f"Melhor MAE: {result['best_mae']} com parâmetros {result['best_params_mae']}")
        print(f"Melhor MSE: {result['best_mse']} com parâmetros {result['best_params_mse']}")
        print(f"Melhor R²: {result['best_r2']} com parâmetros {result['best_params_r2']}")

    print(f"\nResultados salvos em {output_file}")