import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns


# ============================ CONFIGURAÇÕES ============================

FONT_SETTINGS = {
    'font.size': 14,
    'axes.titlesize': 16,
    'axes.labelsize': 14,
    'xtick.labelsize': 14,
    'ytick.labelsize': 12,
    'legend.fontsize': 10
}
plt.rcParams.update(FONT_SETTINGS)

# Diretórios
csv_dir = './comparativos/estimadores/RF'
column_graphs_dir = os.path.join(csv_dir, 'grafico_coluna')
candle_graphs_dir = os.path.join(csv_dir, 'grafico_candle')
os.makedirs(column_graphs_dir, exist_ok=True)
os.makedirs(candle_graphs_dir, exist_ok=True)

# Cores para os gráficos
colors = {
    'mae': '#FFD700',
    'mse': '#1E90FF',
    'r2': '#FF4500',
    'cv_mae': '#32CD32'
}

highlight_colors = {
    'mae': '#FFC107',
    'mse': '#4682B4',
    'r2': '#FF6347',
    'cv_mae': '#228B22'
}

metrics = ['mae', 'mse', 'r2', 'cv_mae']


# ============================ FUNÇÕES AUXILIARES ============================

def get_best_rows(files, metric):
    best_row = None
    for csv_file in files:
        df = pd.read_csv(os.path.join(csv_dir, csv_file))
        if metric not in df.columns:
            continue
        candidate = df.loc[df[metric].idxmax()] if metric == 'r2' else df.loc[df[metric].idxmin()]
        if best_row is None or (
            (metric == 'r2' and candidate[metric] > best_row[metric]) or
            (metric != 'r2' and candidate[metric] < best_row[metric])
        ):
            best_row = candidate
    return best_row


def create_bar_plot(fusao_name, metric, x_labels, y_values):
    plt.figure(figsize=(10, 6))
    bars = plt.bar(x_labels, y_values, color='skyblue')
    plt.title(f"Fusão: {fusao_name}\nMétrica: {metric.upper()}")
    plt.ylabel(metric.upper())
    plt.xlabel("Arquivos (timestamp)")
    for bar, value in zip(bars, y_values):
        plt.text(bar.get_x() + bar.get_width() / 2.0, bar.get_height(), f'{value:.7f}', ha='center', va='bottom')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    graph_path = os.path.join(column_graphs_dir, f"{fusao_name}_{metric}.png")
    plt.savefig(graph_path)
    plt.close()


def create_boxplot(fusao_name, metric, values):
    df_box = pd.DataFrame({metric: values})
    plt.figure(figsize=(8, 6))
    sns.boxplot(data=df_box, y=metric, color='skyblue', width=0.5)
    mean, median = df_box[metric].mean(), df_box[metric].median()
    plt.axhline(mean, color='red', linestyle='--', label=f'Média: {mean:.7f}')
    plt.axhline(median, color='green', linestyle='-', label=f'Mediana: {median:.7f}')
    plt.title(f"Fusão: {fusao_name}\nMétrica: {metric.upper()} (Boxplot)")
    plt.xlabel("Fusões")
    plt.ylabel(metric.upper())
    plt.legend()
    plt.tight_layout()
    plt.savefig(os.path.join(candle_graphs_dir, f"{fusao_name}_{metric}_boxplot.png"))
    plt.close()



def create_summary_bar(metric, summary):
    summary_df = pd.DataFrame(summary)
    if summary_df.empty:
        return

    summary_df[metric] = summary_df[metric].clip(lower=0)

    sorted_values = summary_df[metric].sort_values(ascending=(metric != 'r2')).unique()
    best_value = sorted_values[0] if len(sorted_values) > 0 else None
    second_best_value = sorted_values[1] if len(sorted_values) > 1 else None

    plt.figure(figsize=(14, 10))
    bar_colors = ['#FFA500' if name == 'inmet' else colors[metric] for name in summary_df['fusao_name']]
    bars = plt.bar(summary_df['fusao_name'], summary_df[metric], color=bar_colors, width=0.6)

    plt.ylim(0, summary_df[metric].max() * 1.2)
    plt.title(f"Resumo dos Melhores Valores por Fusão\nMétrica: {metric.upper()}")
    plt.ylabel(metric.upper())
    plt.xlabel("Fusões")

    second_best_marked = False

    for bar, value in zip(bars, summary_df[metric]):
        text_x = bar.get_x() + bar.get_width() / 2.0
        text_y = bar.get_height() + 0.02 * summary_df[metric].max()

        if value == best_value:
            text_color = 'green'
        elif value == second_best_value and not second_best_marked:
            text_color = 'blue'
        elif value == 0:
            text_color = 'red'
        else:
            text_color = 'black'

        plt.text(text_x, text_y, f'{value:.4f}', ha='center', va='bottom', fontsize=10, color=text_color)

        if value == best_value:
            plt.annotate('Melhor', xy=(text_x, text_y + 0.05 * summary_df[metric].max()),
                         xytext=(0, 10) if metric == 'r2' else (0, 20),
                         textcoords='offset points',
                         arrowprops=dict(arrowstyle="->", color='green'), ha='center')
        elif value == second_best_value and not second_best_marked:
            plt.annotate('2º Melhor', xy=(text_x, text_y + 0.05 * summary_df[metric].max()),
                         xytext=(0, 10) if metric == 'r2' else (0, 30),
                         textcoords='offset points',
                         arrowprops=dict(arrowstyle="->", color='blue'), ha='center')
            second_best_marked = True

    plt.xticks(rotation=60, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(csv_dir, f"resumo_melhores_{metric}.png"), dpi=300, bbox_inches='tight')
    plt.close()





def create_filtered_summary_bar(metric, summary, fusao_prefix):
    filtered_summary = [
        item for item in summary
        if item['fusao_name'].startswith(fusao_prefix) or item['fusao_name'] == 'inmet'
    ]
    summary_df = pd.DataFrame(filtered_summary)
    if summary_df.empty:
        return

    if 'temp' in fusao_prefix:
        fusion_type = "Fusão Temporal"
    elif 'hier' in fusao_prefix:
        fusion_type = "Fusão Hierárquica"
    else:
        fusion_type = "Fusões"

    summary_df[metric] = summary_df[metric].clip(lower=0)

    sorted_values = summary_df[metric].sort_values(ascending=(metric != 'r2')).unique()
    best_value = sorted_values[0] if len(sorted_values) > 0 else None
    second_best_value = sorted_values[1] if len(sorted_values) > 1 else None

    plt.figure(figsize=(10, 8))
    bar_colors = ['#FFA500' if name == 'inmet' else colors[metric] for name in summary_df['fusao_name']]
    bars = plt.bar(summary_df['fusao_name'], summary_df[metric], color=bar_colors, width=0.6)

    plt.ylim(0, summary_df[metric].max() * 1.3)
    plt.title(f"Melhores Valores: {fusion_type} vs INMET\nMétrica: {metric.upper()}")
    plt.ylabel(metric.upper())
    plt.xlabel("Tipo de Fusão")

    second_best_marked = False

    for bar, value in zip(bars, summary_df[metric]):
        text_x = bar.get_x() + bar.get_width() / 2.0
        text_y = bar.get_height() + 0.02 * summary_df[metric].max()

        if value == best_value:
            text_color = 'green'
        elif value == second_best_value and not second_best_marked:
            text_color = 'blue'
        elif value == 0:
            text_color = 'red'
        else:
            text_color = 'black'

        plt.text(text_x, text_y, f'{value:.4f}', ha='center', va='bottom', fontsize=12, color=text_color)

        if value == best_value:
            plt.annotate('Melhor', xy=(text_x, text_y + 0.05 * summary_df[metric].max()),
                         xytext=(0, 15) if metric == 'r2' else (0, 30),
                         textcoords='offset points',
                         arrowprops=dict(arrowstyle="->", color='green'), ha='center')
        elif value == second_best_value and not second_best_marked:
            plt.annotate('2º Melhor', xy=(text_x, text_y + 0.05 * summary_df[metric].max()),
                         xytext=(0, 15) if metric == 'r2' else (0, 30),
                         textcoords='offset points',
                         arrowprops=dict(arrowstyle="->", color='blue'), ha='center')
            second_best_marked = True

    plt.xticks(rotation=60, ha='right')
    plt.tight_layout()
    plt.savefig(os.path.join(csv_dir, f"resumo_{fusao_prefix}_vs_inmet_{metric}.png"), dpi=300, bbox_inches='tight')
    plt.close()


# ============================ PROCESSAMENTO ============================

# Agrupando arquivos por fusão
csv_files = [f for f in os.listdir(csv_dir) if f.endswith('.csv') and 'inmet' not in f and 'melhores' not in f]
fusao_groups = {}
for f in csv_files:
    key = f[:-24]
    fusao_groups.setdefault(key, []).append(f)
fusao_groups['inmet'] = ['inmet.csv']

# Resumo geral
summaries = {metric: [] for metric in metrics}

for fusao_name, files in fusao_groups.items():
    for metric in metrics:
        best_row = get_best_rows(files, metric)
        if best_row is None:
            continue
        summaries[metric].append({'fusao_name': fusao_name, metric: best_row[metric]})

        # Gráfico de colunas
        x_labels = [file[-23:-4] for file in files]
        y_values = []
        all_values = []
        for file in files:
            df = pd.read_csv(os.path.join(csv_dir, file))
            if metric in df.columns:
                y = df[metric].max() if metric == 'r2' else df[metric].min()
                y_values.append(y)
                all_values.extend(df[metric].tolist())

        create_bar_plot(fusao_name, metric, x_labels, y_values)
        create_boxplot(fusao_name, metric, all_values)

# Salvar resumos
for metric, summary in summaries.items():
    pd.DataFrame(summary).to_csv(os.path.join(csv_dir, f"melhores_cada_fusao_{metric}.csv"), index=False)
    create_summary_bar(metric, summary)
    create_filtered_summary_bar(metric, summary, fusao_prefix= 'fusao_temp')
    create_filtered_summary_bar(metric, summary, fusao_prefix= 'fusao_hier')

print("✅ Gráficos e resumos gerados com sucesso!")
