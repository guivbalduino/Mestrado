import os
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from pymongo import MongoClient

# === CONFIGURAÇÕES ===
csv_dir = os.path.join("data","csv", "relatorios_modelagem")
os.makedirs(csv_dir, exist_ok=True)

# === CONEXÃO COM MONGODB ===
client = MongoClient("mongodb://localhost:27017/")
db = client.dados
collection = db.resultados_modelagem

# === CONSULTA: SOMENTE DADOS DE 2025 ===
cursor = collection.find({"data_hora": {"$regex": "2025"}})

# === AGRUPAMENTO POR PREFIXO DE COLLECTION ===
tempo_por_fusao = {}
for doc in cursor:
    try:
        tempo = doc.get("tempo_modelagem_segundos")
        col_full = doc.get("collection")

        if tempo is not None and col_full is not None:
            col_lower = col_full.lower()

            if 'inmet' in col_lower:
                fusao_key = col_full  # NÃO corta para INMET
            else:
                fusao_key = col_full[:-20]  # Corta para os demais

            tempo_por_fusao.setdefault(fusao_key, []).append(tempo)

    except Exception as e:
        print(f"❌ Erro ao processar documento: {e}")

# === PROCESSAMENTO E GERAÇÃO DE RELATÓRIOS ===
if tempo_por_fusao:
    df_fusao = pd.DataFrame(dict([(k, pd.Series(v)) for k, v in tempo_por_fusao.items()]))

    # Remove colunas 100% vazias
    df_fusao = df_fusao.dropna(axis=1, how='all')

    # Detecta se há 'inmet' e move para o fim
    inmet_col = None
    for col in df_fusao.columns:
        if 'inmet' in col.lower():
            inmet_col = col
            break

    if inmet_col:
        inmet_data = df_fusao[inmet_col].dropna().reset_index(drop=True)
        df_fusao = df_fusao.drop(columns=[inmet_col])
        df_fusao['inmet'] = inmet_data

    # Ordena colunas pela mediana (exceto inmet)
    colunas_excluindo_inmet = df_fusao.drop(columns=['inmet'], errors='ignore')
    medianas = colunas_excluindo_inmet.median().sort_values()
    colunas_ordenadas = list(medianas.index) + (['inmet'] if 'inmet' in df_fusao.columns else [])
    df_fusao = df_fusao[colunas_ordenadas]

    # === BOX PLOT COM INMET DESTACADO ===
    plt.figure(figsize=(20, 10))
    palette = []
    for col in df_fusao.columns:
        if col == 'inmet':
            palette.append('crimson')  # destaque
        else:
            palette.append('skyblue')

    sns.boxplot(data=df_fusao, palette=palette, width=0.5, fliersize=3)
    plt.title("Distribuição do Tempo de Modelagem (segundos)", fontsize=16)
    plt.ylabel("Tempo (s)", fontsize=14)
    plt.xticks(rotation=45, ha='right', fontsize=10)
    plt.yticks(fontsize=12)
    plt.tight_layout()
    plt.savefig(os.path.join(csv_dir, 'boxplot_tempo_modelagem.png'), dpi=300)
    plt.close()

    # === ESTATÍSTICAS DESCRITIVAS ===
    stats = df_fusao.describe().T
    stats.to_csv(os.path.join(csv_dir, 'estatisticas_tempo_modelagem.csv'))

    # === GRÁFICO DE MÉDIA COM VALORES ===
    medias = stats['mean'].sort_values()
    plt.figure(figsize=(12, 8))
    bar_colors = ['crimson' if idx == 'inmet' else 'darkcyan' for idx in medias.index]
    bars = plt.barh(medias.index, medias.values, color=bar_colors)
    plt.xlabel("Tempo Médio (s)")
    plt.title("Tempo Médio de Modelagem por Fusão")
    for bar in bars:
        width = bar.get_width()
        plt.text(width, bar.get_y() + bar.get_height() / 2, f'{width:.4f}', va='center', ha='left', fontsize=10)
    plt.tight_layout()
    plt.savefig(os.path.join(csv_dir, 'media_tempo_modelagem.png'), dpi=300)
    plt.close()

    print("✅ Relatórios e gráficos gerados em:", csv_dir)

else:
    print("⚠️ Nenhum dado encontrado com data_hora contendo '2025'.")
