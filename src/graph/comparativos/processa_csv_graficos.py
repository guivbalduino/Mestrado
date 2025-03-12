import os
import pandas as pd
import matplotlib.pyplot as plt

# Caminho para os CSVs
csv_dir = './comparativos/estimadores/RF'
graphs_dir = os.path.join(csv_dir, 'graficos')
os.makedirs(graphs_dir, exist_ok=True)

# Caminhos para os arquivos de resumo
summary_inmet_path = os.path.join(graphs_dir, 'summary_inmet.txt')
summary_others_path = os.path.join(graphs_dir, 'summary_others.txt')

# Listar arquivos CSV
inmet_files = [f for f in os.listdir(csv_dir) if f.endswith('.csv') and 'melhores_parametros' not in f and 'inmet' in f]
other_files = [f for f in os.listdir(csv_dir) if f.endswith('.csv') and 'melhores_parametros' not in f and 'inmet' not in f]

# Função para processar arquivos
def process_csv_files(csv_files, summary_path):
    summary_lines = []

    for csv_file in csv_files:
        csv_path = os.path.join(csv_dir, csv_file)

        # Ler o CSV
        df = pd.read_csv(csv_path)

        # Garantir que o CSV tem os parâmetros necessários
        if {'mae', 'mse', 'r2'}.issubset(df.columns):
            # Encontrar as linhas com os melhores valores para cada métrica
            best_mae_row = df.loc[df['mae'].idxmin()]
            best_mse_row = df.loc[df['mse'].idxmin()]
            best_r2_row = df.loc[df['r2'].idxmax()]

            # Criar gráficos para cada melhor métrica
            for metric, best_row in zip(['mae', 'mse', 'r2'], [best_mae_row, best_mse_row, best_r2_row]):
                # Extrair os parâmetros para o título do gráfico
                params = best_row[['n_estimators', 'max_depth', 'min_samples_leaf', 'min_samples_split', 'criterion', 'bootstrap']]
                file_name_without_extension = os.path.splitext(csv_file)[0]
                params_title = file_name_without_extension  # Usar o nome do arquivo como título

                # Criar o gráfico
                plt.figure(figsize=(8, 6))
                metrics = ['mae', 'mse', 'r2']
                values = best_row[metrics]

                bars = plt.bar(metrics, values, color=['blue', 'orange', 'green'])
                plt.title(f"Best {metric.upper()}\n{params_title}")
                plt.ylabel('Values')
                plt.xlabel('Metrics')
                plt.ylim(0, max(values) * 1.2)

                # Adicionar os valores em cima das barras
                for bar in bars:
                    height = bar.get_height()
                    plt.text(bar.get_x() + bar.get_width() / 2.0, height, f'{height:.4f}', ha='center', va='bottom')

                # Salvar o gráfico
                graph_name = f"{os.path.splitext(csv_file)[0]}_grafico_{metric}.png"
                graph_path = os.path.join(graphs_dir, graph_name)
                plt.savefig(graph_path)
                plt.close()

            # Adicionar resumo ao arquivo de texto
            summary_lines.append(f"Arquivo {csv_file} obteve melhor MAE com parametros:\n{', '.join([f'{col}={best_mae_row[col]}' for col in params.index])}")
            summary_lines.append(f"Arquivo {csv_file} obteve melhor MSE com parametros:\n{', '.join([f'{col}={best_mse_row[col]}' for col in params.index])}")
            summary_lines.append(f"Arquivo {csv_file} obteve melhor R2 com parametros:\n{', '.join([f'{col}={best_r2_row[col]}' for col in params.index])}")

    # Salvar o resumo em um arquivo de texto
    with open(summary_path, 'w') as summary_file:
        summary_file.write("\n".join(summary_lines))

# Processar arquivos "inmet"
process_csv_files(inmet_files, summary_inmet_path)

# Processar outros arquivos
process_csv_files(other_files, summary_others_path)

print("Gráficos gerados e resumos salvos em 'summary_inmet.txt' e 'summary_others.txt' na subpasta 'graficos'!")
