import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns  # Biblioteca Seaborn para gráficos mais bonitos

# Caminho para os CSVs
csv_dir = './comparativos/estimadores/RF'
column_graphs_dir = os.path.join(csv_dir, 'grafico_coluna')
candle_graphs_dir = os.path.join(csv_dir, 'grafico_candle')

# Criar pastas se não existirem
os.makedirs(column_graphs_dir, exist_ok=True)
os.makedirs(candle_graphs_dir, exist_ok=True)

# Listar arquivos CSV não relacionados a "inmet"
csv_files = [f for f in os.listdir(csv_dir) if f.endswith('.csv') and 'inmet' not in f]

# Agrupar arquivos por "fusao" (parte antes do timestamp no nome do arquivo)
fusao_groups = {}
for csv_file in csv_files:
    fusao_name = csv_file[:-24]  # Remove o timestamp e extensão
    if fusao_name not in fusao_groups:
        fusao_groups[fusao_name] = []
    fusao_groups[fusao_name].append(csv_file)
fusao_groups['inmet'] = []
fusao_groups['inmet'].append('inmet.csv')

# Função para criar gráficos de colunas e boxplot para cada fusao
def create_fusao_graphs_and_summary(fusao_name, files, summaries):
    metrics = ['mae', 'mse', 'r2']
    best_rows = {metric: None for metric in metrics}

    # Processar os arquivos da fusao
    for csv_file in files:
        csv_path = os.path.join(csv_dir, csv_file)
        df = pd.read_csv(csv_path)

        # Verificar se as colunas necessárias existem
        if {'mae', 'mse', 'r2'}.issubset(df.columns):
            for metric in metrics:
                if metric == 'r2':
                    candidate_row = df.loc[df[metric].idxmax()]
                else:
                    candidate_row = df.loc[df[metric].idxmin()]

                if best_rows[metric] is None or (
                    metric == 'r2' and candidate_row[metric] > best_rows[metric][metric]) or (
                    metric != 'r2' and candidate_row[metric] < best_rows[metric][metric]):
                    best_rows[metric] = candidate_row

    # Criar gráficos para cada métrica
    for metric, best_row in best_rows.items():
        if best_row is not None:
            x_labels = [file[-23:-4] for file in files]  # Extrair timestamp como rótulos X
            y_values = []

            # Calcular os valores reais para cada arquivo
            for csv_file in files:
                csv_path = os.path.join(csv_dir, csv_file)
                df = pd.read_csv(csv_path)
                if metric == 'r2':
                    value = df[metric].max()
                else:
                    value = df[metric].min()
                y_values.append(value)

            # Criar gráfico de colunas
            plt.figure(figsize=(10, 6))
            bars = plt.bar(x_labels, y_values, color='skyblue')
            plt.title(f"Fusion: {fusao_name}\nMetric: {metric.upper()}")
            plt.ylabel(metric.upper())
            plt.xlabel("Archives (timestamp)")

            # Adicionar os valores em cima das barras
            for bar, value in zip(bars, y_values):
                plt.text(bar.get_x() + bar.get_width() / 2.0, bar.get_height(), f'{value:.5f}', ha='center', va='bottom')

            # Rotacionar os rótulos do eixo X
            plt.xticks(rotation=45, ha='right')

            # Salvar o gráfico de colunas
            graph_name = f"{fusao_name}_{metric}.png"
            graph_path = os.path.join(column_graphs_dir, graph_name)
            plt.savefig(graph_path)
            plt.close()

            # Adicionar ao resumo
            if metric not in summaries:
                summaries[metric] = []
            summaries[metric].append({"fusao_name": fusao_name, metric: best_row[metric]})

            # Gerar gráfico de boxplot para a métrica (agregando todos os arquivos do grupo)
            all_values = []
            for csv_file in files:
                csv_path = os.path.join(csv_dir, csv_file)
                df = pd.read_csv(csv_path)
                all_values.extend(df[metric].tolist())  # Junta todos os valores da métrica

            # Criar um DataFrame para o Seaborn
            df_boxplot = pd.DataFrame({metric: all_values})

            # Plotar o gráfico de boxplot usando Seaborn
            plt.figure(figsize=(8, 6))
            sns.boxplot(data=df_boxplot, y=metric, color='skyblue', width=0.5)
            plt.title(f"Fusion: {fusao_name}\nMetric: {metric.upper()} (Boxplot)")
            plt.ylabel(metric.upper())
            plt.xlabel("Fusions")

            # Adicionar a média ao gráfico
            mean_value = df_boxplot[metric].mean()
            plt.axhline(mean_value, color='red', linestyle='--', label=f'Average: {mean_value:.5f}')

            # Adicionar a mediana ao gráfico
            median_value = df_boxplot[metric].median()
            plt.axhline(median_value, color='green', linestyle='-', label=f'Median: {median_value:.5f}')

            # Adicionar legendas
            plt.legend()

            # Salvar o gráfico de boxplot
            boxplot_graph_name = f"{fusao_name}_{metric}_boxplot.png"
            boxplot_graph_path = os.path.join(candle_graphs_dir, boxplot_graph_name)
            plt.savefig(boxplot_graph_path)
            plt.close()

# Inicializar resumos
summaries = {}

# Criar gráficos para cada fusao
for fusao_name, files in fusao_groups.items():
    create_fusao_graphs_and_summary(fusao_name, files, summaries)

# Salvar resumos em arquivos CSV
for metric, summary in summaries.items():
    summary_df = pd.DataFrame(summary)
    summary_file = os.path.join(csv_dir, f"melhores_cada_fusao_{metric}.csv")
    summary_df.to_csv(summary_file, index=False)

print("Gráficos de coluna e boxplot gerados com sucesso!")

# Criar gráficos de barra para os resumos gerados
colors = {
    'mae': '#FFD700',  # Amarelo
    'mse': '#1E90FF',  # Azul
    'r2': '#FF4500'    # Vermelho
}

highlight_colors = {
    'mae': '#FFC107',  # Amarelo mais escuro
    'mse': '#4682B4',  # Azul mais escuro
    'r2': '#FF6347'    # Vermelho mais claro
}

for metric, summary in summaries.items():
    summary_df = pd.DataFrame(summary)
    if not summary_df.empty:
        plt.figure(figsize=(12, 8))  # Aumentar o tamanho da figura
        color = colors[metric]  # Cor padrão
        # Ajustar valores negativos para zero
        summary_df[metric] = summary_df[metric].clip(lower=0)
        bars = plt.bar(summary_df['fusao_name'], summary_df[metric], color=color, width=0.6)

        # Definir o limite superior do eixo Y dinamicamente para todas as métricas
        plt.ylim(0, max(summary_df[metric]) * 1.2)  # Limite superior dinâmico

        # Definir o valor de destaque (menor para MAE/MSE, maior para R²)
        if metric in ['mae', 'mse']:
            best_value = min(summary_df[metric])
        else:  # Para R²
            best_value = max(summary_df[metric])
        # Adicionar as cores especiais
        for bar, value in zip(bars, summary_df[metric]):
            if value == best_value:  # Melhor valor
                bar.set_color('green')
            elif value == 0:  # Valores ajustados para zero
                bar.set_color('red')
        plt.title(f"Summary of Best Values ​​by Fusion\nMetrics: {metric.upper()}", fontsize=16)
        plt.ylabel(metric.upper(), fontsize=12)
        plt.xlabel("Fusions", fontsize=12)
        # Adicionar os valores em cima das barras
        for bar, value in zip(bars, summary_df[metric]):
            # Posição do texto (número) acima da barra
            text_x = bar.get_x() + bar.get_width() / 2.0
            text_y = bar.get_height() + 0.02 * max(summary_df[metric])  # Pequeno deslocamento
            
            # Adicionar o número acima da barra
            plt.text(text_x, text_y, 
                     f'{value:.3f}', ha='center', va='bottom', fontsize=10, 
                     color='green' if value == best_value else 'red' if value == 0 else 'black')
            
            # Adicionar uma seta e o texto "Best" para a barra verde
            if value == best_value:  # Melhor valor
                # Posição da ponta da seta (ajustada para cima)
                arrow_x = text_x
                arrow_y = text_y + 0.04 * max(summary_df[metric])  # Subir a ponta da seta
                plt.annotate('Best', 
                             xy=(arrow_x, arrow_y),  # Posição da ponta da seta (mesma do número)
                             xytext=(0, 20),  # Deslocamento da seta (x, y)
                             textcoords='offset points',  # Coordenadas relativas ao ponto
                             arrowprops=dict(arrowstyle="->", color='black'),  # Estilo da seta
                             ha='center', fontsize=10, color='black')
        # Rotacionar e ajustar os rótulos do eixo X
        plt.xticks(rotation=45, ha='right', fontsize=10)
        # Melhorar espaçamento geral
        plt.tight_layout()
        # Salvar o gráfico
        graph_name = f"resumo_melhores_{metric}.png"
        graph_path = os.path.join(csv_dir, graph_name)
        plt.savefig(graph_path)
        plt.close()
print("Gráficos de resumo gerados com sucesso!")

# Filtrar apenas as fusões que começam com "fusao_temp" OU são exatamente "inmet"
temp_summary_df = summary_df[
    summary_df['fusao_name'].str.startswith('fusao_temp') | 
    (summary_df['fusao_name'] == 'inmet')
]

# Verifique o DataFrame filtrado
print(temp_summary_df)

if not temp_summary_df.empty:
    plt.figure(figsize=(12, 8))
    color = colors[metric]
    
    # Correção aqui: Usar .loc para evitar SettingWithCopyWarning
    temp_summary_df.loc[:, metric] = temp_summary_df[metric].clip(lower=0)
    
    bars = plt.bar(temp_summary_df['fusao_name'], temp_summary_df[metric], color=color, width=0.6)
    plt.ylim(0, max(temp_summary_df[metric]) * 1.2)
    
    if metric in ['mae', 'mse']:
        best_value = min(temp_summary_df[metric])
    else:
        best_value = max(temp_summary_df[metric])
    
    for bar, value in zip(bars, temp_summary_df[metric]):
        if value == best_value:
            bar.set_color('green')
        elif value == 0:
            bar.set_color('red')
    
    plt.title(f"Summary of Best Values by Fusion (Temp or INMET)\nMetrics: {metric.upper()}", fontsize=16)
    plt.ylabel(metric.upper(), fontsize=12)
    plt.xlabel("Fusions", fontsize=12)
    
    for bar, value in zip(bars, temp_summary_df[metric]):
        text_x = bar.get_x() + bar.get_width() / 2.0
        text_y = bar.get_height() + 0.02 * max(temp_summary_df[metric])
        plt.text(text_x, text_y, f'{value:.3f}', ha='center', va='bottom', fontsize=10,
                 color='green' if value == best_value else 'red' if value == 0 else 'black')
        
        if value == best_value:
            arrow_x = text_x
            arrow_y = text_y + 0.04 * max(temp_summary_df[metric])
            plt.annotate('Best', xy=(arrow_x, arrow_y), xytext=(0, 20),
                         textcoords='offset points', arrowprops=dict(arrowstyle="->", color='black'),
                         ha='center', fontsize=10, color='black')
    
    plt.xticks(rotation=45, ha='right', fontsize=10)
    plt.tight_layout()
    
    graph_name = f"resumo_temp_melhores_{metric}.png"
    graph_path = os.path.join(csv_dir, graph_name)
    plt.savefig(graph_path)
    plt.close()

print("Gráficos de resumo para fusões temporais gerados com sucesso!")