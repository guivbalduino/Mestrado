import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns

# Caminho da pasta com os CSVs
csv_dir = os.path.join('data', 'csv')
output_dir = os.path.join(csv_dir, 'tempo_fusao_relatorios')
os.makedirs(output_dir, exist_ok=True)

print("📂 Arquivos encontrados na pasta:")
for f in os.listdir(csv_dir):
    print(" -", f)

tempo_fusao_dict = {}

# Leitura dos arquivos e extração dos tempos
for filename in os.listdir(csv_dir):
    if filename.endswith('.csv'):
        path = os.path.join(csv_dir, filename)
        try:
            df_raw = pd.read_csv(path)
            if 'Campo' in df_raw.columns and 'Valores Distintos' in df_raw.columns:
                campo = None
                if 'tempo_fusao_segundos' in df_raw['Campo'].values:
                    campo = 'tempo_fusao_segundos'
                elif 'tempo_modelagem_segundos' in df_raw['Campo'].values:
                    campo = 'tempo_modelagem_segundos'

                if campo:
                    valores_str = df_raw[df_raw['Campo'] == campo]['Valores Distintos'].values[0]
                    valores = [float(v.strip()) for v in valores_str.split(',')]
                    nome_base = filename.replace('.csv', '')
                    tempo_fusao_dict[nome_base] = valores
                    print(f"✅ '{filename}' contém {campo} com {len(valores)} valores")
                else:
                    print(f"⚠️ '{filename}' não contém 'tempo_fusao_segundos' nem 'tempo_modelagem_segundos'")
            else:
                print(f"⚠️ '{filename}' não possui colunas esperadas: 'Campo' e 'Valores Distintos'")
        except Exception as e:
            print(f"❌ Erro ao ler '{filename}': {e}")

# Criação de DataFrame com os tempos extraídos
if tempo_fusao_dict:
    df_fusao = pd.DataFrame(dict([(k, pd.Series(v)) for k, v in tempo_fusao_dict.items()]))

    # Gráfico: boxplot
    plt.figure(figsize=(14, 8))
    sns.boxplot(data=df_fusao)
    plt.title("Distribuição do Tempo de Execução (segundos)")
    plt.ylabel("Tempo (s)")
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'boxplot_tempo_fusao.png'))
    plt.close()

    # Estatísticas descritivas
    stats = df_fusao.describe().T
    stats.to_csv(os.path.join(output_dir, 'estatisticas_tempo_fusao.csv'))

    # Gráfico: média por arquivo com valores nas barras
    medias = stats['mean'].sort_values()
    plt.figure(figsize=(12, 8))
    bars = plt.barh(medias.index, medias.values, color='skyblue')
    plt.xlabel("Tempo Médio (s)")
    plt.title("Tempo Médio de Execução por Arquivo")
    for bar in bars:
        width = bar.get_width()
        plt.text(width, bar.get_y() + bar.get_height() / 2, f'{width:.4f}', va='center', ha='left', fontsize=10)
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'media_tempo_fusao.png'))
    plt.close()

    # Gerar gráfico de barras separado para cada estatística
    estatisticas_para_plotar = ['std', 'min', '25%', '50%', '75%', 'max']
    for estat in estatisticas_para_plotar:
        valores = stats[estat].sort_values()
        plt.figure(figsize=(12, 8))
        bars = plt.barh(valores.index, valores.values, color='mediumpurple')
        plt.xlabel("Valor (s)")
        plt.title(f"{estat.upper()} do Tempo de Fusão por Modelo")
        for bar in bars:
            width = bar.get_width()
            plt.text(width, bar.get_y() + bar.get_height() / 2, f'{width:.4f}', va='center', ha='left', fontsize=10)
        plt.tight_layout()
        plt.savefig(os.path.join(output_dir, f"{estat}_tempo_fusao.png"))
        plt.close()

    print("✅ Relatórios e gráficos gerados em:", output_dir)
else:
    print("⚠️ Nenhum tempo válido encontrado nos arquivos.")
