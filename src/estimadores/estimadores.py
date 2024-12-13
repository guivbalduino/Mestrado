import os
import pandas as pd
import matplotlib.pyplot as plt
from ast import literal_eval

# Diretório base para os arquivos
base_dir = "E:/Git/Mestrado/comparativos/estimadores"

# Função para gerar gráficos para arquivos padrão
def generate_graphs_from_csv(file_path, output_dir):
    # Ler CSV
    data = pd.read_csv(file_path)
    metrics = ["mae", "mse", "r2"]
    varying_columns = ["n_estimators", "max_depth", "min_samples_leaf", "min_samples_split", "criterion", "bootstrap"]

    # Criar pasta para salvar gráficos deste CSV
    csv_folder_name = os.path.splitext(os.path.basename(file_path))[0]
    csv_output_dir = os.path.join(output_dir, csv_folder_name)
    os.makedirs(csv_output_dir, exist_ok=True)

    # Para cada coluna que vai variar
    for col in varying_columns:
        # Criar subpasta para o estimador atual
        estimator_output_dir = os.path.join(csv_output_dir, col)
        os.makedirs(estimator_output_dir, exist_ok=True)

        fixed_values = data.loc[data[metrics].idxmin().values].iloc[0]  # Selecionar os mínimos
        fixed_values = {c: fixed_values[c] for c in data.columns if c not in metrics + [col]}

        # Filtrar os dados onde as colunas estão fixadas
        filtered_data = data.copy()
        for key, value in fixed_values.items():
            filtered_data = filtered_data[filtered_data[key] == value]

        # Gerar gráfico se houver dados
        if not filtered_data.empty:
            for metric in metrics:
                plt.figure(figsize=(10, 6))
                plt.plot(filtered_data[col], filtered_data[metric], label=metric)
                plt.title(f"Variação de {col} - Métrica: {metric}")
                plt.xlabel(col)
                plt.ylabel(metric.upper())
                plt.grid()
                plt.legend()

                # Adicionar os números no gráfico
                for i, value in enumerate(filtered_data[metric]):
                    plt.text(filtered_data[col].iloc[i], value, f'{value:.2f}', fontsize=9, ha='right')

                # Salvar gráfico
                output_file = os.path.join(estimator_output_dir, f"{metric}.png")
                plt.savefig(output_file)
                plt.close()

# Função para criar imagem de tabela para "melhores_parametros"
def create_table_image_from_best_params(file_path, output_dir):
    # Ler CSV
    data = pd.read_csv(file_path)

    # Ajustar colunas que contêm dicionários em string
    for col in data.columns:
        if data[col].dtype == "object" and data[col].str.startswith("{").any():
            data[col] = data[col].apply(literal_eval)

    # Criar tabela visual
    plt.figure(figsize=(12, len(data) * 0.8))  # Ajusta altura pela quantidade de linhas
    plt.table(cellText=data.values, colLabels=data.columns, loc="center", cellLoc="center")
    plt.axis("off")

    output_file = os.path.join(output_dir, f"{os.path.basename(file_path).split('.')[0]}_table.png")
    plt.savefig(output_file)
    plt.close()

# Processar arquivos
for method_dir in os.listdir(base_dir):
    method_path = os.path.join(base_dir, method_dir)

    if os.path.isdir(method_path):  # Verificar se é um diretório
        for file_name in os.listdir(method_path):
            file_path = os.path.join(method_path, file_name)

            if "melhores_parametros" in file_name:  # Arquivos de melhores parâmetros
                print(f"Processando tabela para: {file_name}")
                create_table_image_from_best_params(file_path, method_path)
            else:  # Arquivos padrão
                print(f"Gerando gráficos para: {file_name}")
                generate_graphs_from_csv(file_path, method_path)
