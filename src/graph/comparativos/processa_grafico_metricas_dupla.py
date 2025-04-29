import os
import pandas as pd
import matplotlib.pyplot as plt
import itertools

# Estilo com cores acessíveis e visual agradável
plt.style.use('seaborn-v0_8-colorblind')

# Caminho para os CSVs
csv_dir = './comparativos/estimadores/RF'
duplos_dir = os.path.join(csv_dir, 'duplos')
os.makedirs(duplos_dir, exist_ok=True)

# Função genérica para gerar os gráficos de comparação
def generate_bar_plots(metric, filtro_regex, nome_saida_sufixo):
    csv_file = os.path.join(csv_dir, f"melhores_cada_fusao_{metric}.csv")
    if not os.path.exists(csv_file):
        print(f"Arquivo {csv_file} não encontrado. Pulando...")
        return

    df = pd.read_csv(csv_file)

    if df.empty:
        print(f"Nenhum dado no arquivo {csv_file}. Pulando...")
        return

    # Aplicar o filtro baseado no regex
    df_filtered = df[df['fusao_name'].str.contains(filtro_regex, case=False, regex=True)]

    if df_filtered.empty:
        print(f"Nenhum dado encontrado para filtro '{filtro_regex}' no arquivo {csv_file}. Pulando...")
        return

    # Gerar cores diferentes para cada barra
    palette = itertools.cycle(plt.rcParams['axes.prop_cycle'].by_key()['color'])
    colors = [next(palette) for _ in range(len(df_filtered))]

    # Criar gráfico de barras com cores distintas
    plt.figure(figsize=(10, 6))
    bars = plt.bar(df_filtered['fusao_name'], df_filtered[metric], color=colors)
    plt.title(f"Comparação de {metric.upper()} - {nome_saida_sufixo.replace('_', ' ').title()}")
    plt.xlabel("Fusões")
    plt.ylabel(metric.upper())
    plt.xticks(rotation=45, ha='right')

    # Adiciona os valores no topo das barras
    for bar, value in zip(bars, df_filtered[metric]):
        casas_decimais = '.10f' if metric == 'r2' else '.5f'
        valor_formatado = format(value, casas_decimais)
        plt.text(bar.get_x() + bar.get_width() / 2, bar.get_height(), valor_formatado,
                 ha='center', va='bottom', fontsize=10)

    plt.tight_layout()
    nome_arquivo = f"{metric}_{nome_saida_sufixo}_barras.png"
    graph_path = os.path.join(duplos_dir, nome_arquivo)
    plt.savefig(graph_path)
    plt.close()
    print(f"[✓] Gráfico salvo: {graph_path}")

# Listas de filtros e nomes de saída
comparacoes = [
    ('prophet|_arima_es_sktime|inmet', 'prophet_arima_es_sktime_inmet'),
    ('hdbscan|hier_kmeans|inmet', 'hdbscan_kmeans_inmet'),
    ('hdbscan|_arima_es_sktime|inmet', 'hdbscan_arima_es_sktime_inmet')
]

# Gera os gráficos para todas as combinações de métrica e comparação
for metric in ['mae', 'mse', 'r2', 'cv_mae']:
    for filtro, sufixo in comparacoes:
        generate_bar_plots(metric, filtro, sufixo)

print("\nTodos os gráficos gerados com sucesso na pasta 'duplos' ✅")
