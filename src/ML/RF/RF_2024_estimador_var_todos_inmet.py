import os
import pandas as pd
from pymongo import MongoClient
from sklearn.ensemble import RandomForestRegressor
from sklearn.model_selection import train_test_split
from sklearn.metrics import mean_absolute_error, mean_squared_error, r2_score
import matplotlib.pyplot as plt
from datetime import datetime
import csv
import joblib

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

# Função para encontrar todas as coleções que começam com "fusao_"
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


def save_model_info(collection_name, model_params, eval_metrics, tempo_modelagem, tempo_armazenamento, hoje, quantidade_dados_utilizados,model_path):
    client = MongoClient("localhost", 27017)
    db = client["dados"]
    colecao_fusoes = db["resultados_modelagem"]

    # Dados para armazenar no MongoDB
    info_modelagem = {
        "nome_modelagem": "random_forest_regressor",
        "tipo_modelagem": "previsao_precipitacao",
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
    
    inicio_modelagem = datetime.now()
    # Carregar dados
    data = load_data_from_mongo(collection_name, start_date="2024-02-13", end_date="2024-09-03")

    # Extrair características temporais do 'timestamp'
    data = extract_time_features(data)

    # Definir variável alvo (temperatura) e características
    y = data["PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"]
    
    # Selecionando variáveis para X (humidade, pressão, cluster_label se disponível, e componentes temporais)
    X = data[['temperature_C','humidity_percent', 'pressure_hPa', 'year', 'month', 'day', 'hour', 'minute']]  # Variáveis para previsão
    
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

    fim_modelagem = datetime.now()
    tempo_modelagem = fim_modelagem - inicio_modelagem
    inicio_armazenamento = datetime.now()
    # Diretório para salvar previsões e modelo
    base_dir = f"./previsoes/2024/RF/{sanitize_directory_name(hoje)}/{sanitize_directory_name(collection_name)}_{n_estimators}_{max_depth}_{min_samples_leaf}_{min_samples_split}_{criterion}_{bootstrap}"
    os.makedirs(base_dir, exist_ok=True)

    # Salvar modelo
    model_path = os.path.join(base_dir, f"{sanitize_directory_name(collection_name)}_rf_model.joblib")
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
        "random_state": 42,
        "bootstrap": bootstrap,
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

    
    # Salvar modelo e gráficos conforme o original (opcional)

    return mae,mse,r2  # Retorna o 



# Executar o código para todas as coleções que começam com "fusao_"
if __name__ == "__main__":
    import csv
    from datetime import datetime

    # Valores para os hiperparâmetros
    n_estimators_values = [50, 100, 150]
    max_depth_values = [5, 10, 20]
    min_samples_leaf_values = [2, 4, 6]
    min_samples_split_values = [2,5,10]
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