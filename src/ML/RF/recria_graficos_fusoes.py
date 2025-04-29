import os
import pandas as pd
import matplotlib.pyplot as plt

# Configurações de fonte para os gráficos
FONT_SETTINGS = {
    'font.size': 14,
    'axes.titlesize': 16,
    'axes.labelsize': 14,
    'xtick.labelsize': 12,
    'ytick.labelsize': 12,
    'legend.fontsize': 10
}
plt.rcParams.update(FONT_SETTINGS)

# Função para garantir que o diretório existe
def ensure_directory_exists(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)

# Função para carregar dados salvos
def load_prediction_data(base_dir):
    prediction_file_path = os.path.join(base_dir, "prediction_data.csv")
    return pd.read_csv(prediction_file_path)

def load_residuals_data(base_dir):
    residuals_file_path = os.path.join(base_dir, "residuals_data.csv")
    return pd.read_csv(residuals_file_path)

def load_evaluation_metrics(base_dir):
    metrics_file_path = os.path.join(base_dir, "evaluation_metrics.csv")
    return pd.read_csv(metrics_file_path)

# Função para gerar todos os gráficos
def generate_all_plots(base_dir, prediction_data, residuals_data, metrics_data):
    # Garantir que o diretório existe
    ensure_directory_exists(base_dir)
    
    # 1. Gráfico de Previsões vs. Valores Reais
    plt.figure(figsize=(12, 7))
    plt.plot(prediction_data["timestamp"], prediction_data["actual"], label="Actual", color='blue')
    plt.plot(prediction_data["timestamp"], prediction_data["predicted"], label="Predicted", color='red')
    plt.xlabel("Date")
    plt.ylabel("Hourly Total Precipitation (mm)")
    plt.title("Precipitation Prediction - Random Forest - INMET")
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, "precipitation_prediction.png"), dpi=300, bbox_inches='tight')
    plt.close()

    # 2. Gráfico de Métricas de Avaliação
    plt.figure(figsize=(12, 7))
    metrics = ['MAE', 'MSE', 'R2', 'CV MAE']
    values = [
        metrics_data.loc[metrics_data['metric'] == 'MAE', 'value'].values[0],
        metrics_data.loc[metrics_data['metric'] == 'MSE', 'value'].values[0],
        metrics_data.loc[metrics_data['metric'] == 'R2', 'value'].values[0],
        metrics_data.loc[metrics_data['metric'] == 'CV_MAE', 'value'].values[0]
    ]
    colors = ['blue', 'orange', 'green', 'purple']
    bars = plt.bar(metrics, values, color=colors)
    for bar in bars:
        height = bar.get_height()
        plt.text(bar.get_x() + bar.get_width() / 2, height, f"{height:.2f}", ha='center', va='bottom')
    plt.title("Model Evaluation - INMET")
    plt.ylabel("Value")
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, "model_evaluation.png"), dpi=300, bbox_inches='tight')
    plt.close()

    # 3. Gráfico de Resíduos
    plt.figure(figsize=(12, 7))
    plt.scatter(residuals_data["timestamp"], residuals_data["residuals"], color='red', label='Residuals')
    plt.axhline(y=0, color='black', linestyle='--', label='Zero')
    plt.xlabel("Date")
    plt.ylabel("Residual (Error)")
    plt.title("Model Residuals - INMET")
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, "model_residuals.png"), dpi=300, bbox_inches='tight')
    plt.close()

    # 4. Gráfico de Todos os Dados com Previsões
    all_data = pd.concat([
        prediction_data[["timestamp", "actual"]].rename(columns={"actual": "PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"}),
        prediction_data[["timestamp", "predicted"]].rename(columns={"predicted": "PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"})
    ])
    plt.figure(figsize=(12, 7))
    plt.plot(all_data["timestamp"], all_data["PRECIPITAÇÃO TOTAL, HORÁRIO (mm)"], label="All Actual Data", color='blue', alpha=0.5)
    plt.plot(prediction_data["timestamp"], prediction_data["predicted"], label="Predictions - Random Forest", color='red')
    plt.xlabel("Date")
    plt.ylabel("Hourly Total Precipitation (mm)")
    plt.title("All Data and Predictions - INMET")
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, "all_data_with_predictions.png"), dpi=300, bbox_inches='tight')
    plt.close()

    # 5. Gráfico de Dados Reais com Previsões (apenas onde há previsões)
    plt.figure(figsize=(12, 7))
    plt.plot(prediction_data["timestamp"], prediction_data["actual"], label="Actual with Predictions", color='blue', marker='o', linestyle='None')
    plt.plot(prediction_data["timestamp"], prediction_data["predicted"], label="Predictions", color='red', marker='x', linestyle='-')
    plt.xlabel("Date")
    plt.ylabel("Hourly Total Precipitation (mm)")
    plt.title("Actual Data and Predictions - INMET")
    plt.legend()
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(base_dir, "actual_data_with_predictions.png"), dpi=300, bbox_inches='tight')
    plt.close()

    print("Todos os gráficos foram gerados e salvos com sucesso!")

# Função principal
if __name__ == "__main__":
    # Diretório base onde os dados estão salvos
    main_dir = ".\previsoes\\2024\RF\\2025-04-05_15-11-27"
    
    # Iterar sobre todas as pastas que começam com "inmet"
    for folder_name in os.listdir(main_dir):
        if folder_name.startswith("fusao_"):
            base_dir = os.path.join(main_dir, folder_name)
            
            try:
                # Carregar os dados salvos
                prediction_data = load_prediction_data(base_dir)
                residuals_data = load_residuals_data(base_dir)
                metrics_data = load_evaluation_metrics(base_dir)
                
                # Gerar todos os gráficos
                generate_all_plots(base_dir, prediction_data, residuals_data, metrics_data)
            except Exception as e:
                print(f"Erro ao processar o diretório {base_dir}: {e}")