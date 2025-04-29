import os
import pandas as pd
import shutil

# Caminho do CSV com os resultados do INMET
caminho_csv_inmet = r'E:\Git\Mestrado\comparativos\estimadores\RF\inmet.csv'
df_inmet = pd.read_csv(caminho_csv_inmet)

# Linha com menor MAE
linha_menor_mae = df_inmet.loc[df_inmet['mae'].idxmin()]
print("Menor MAE INMET:")
print(linha_menor_mae)

# Diretório base onde estão as previsões geradas
pasta_base_previsoes = r'E:\Git\Mestrado\previsoes\2024\RF\2025-04-28_11-53-59'

# Pasta de destino
pasta_destino = r'E:\Git\Mestrado\comparativos\estimadores\RF\previsoes\inmet_mae'
os.makedirs(pasta_destino, exist_ok=True)

# Monta o nome da subpasta do modelo conforme padrão do script gerador
subpasta_modelo = f"inmet_{linha_menor_mae['n_estimators']}_{linha_menor_mae['max_depth']}_{linha_menor_mae['min_samples_leaf']}_{linha_menor_mae['min_samples_split']}_{linha_menor_mae['criterion']}_{linha_menor_mae['bootstrap']}"
caminho_subpasta = os.path.join(pasta_base_previsoes, subpasta_modelo)

# Monta o sufixo esperado no nome dos arquivos
padrao_esperado = (
    f"n{linha_menor_mae['n_estimators']}_"
    f"maxd{linha_menor_mae['max_depth']}_"
    f"minsl{linha_menor_mae['min_samples_leaf']}_"
    f"minsp{linha_menor_mae['min_samples_split']}_"
    f"critsquared_error_"
    f"boot{linha_menor_mae['bootstrap']}"
).lower()

# Copiar arquivos que batem com esse padrão
if os.path.exists(caminho_subpasta):
    arquivos = os.listdir(caminho_subpasta)
    encontrados = 0
    for arquivo in arquivos:
        if padrao_esperado in arquivo.lower() and arquivo.endswith('.png'):
            origem = os.path.join(caminho_subpasta, arquivo)
            destino = os.path.join(pasta_destino, arquivo)
            shutil.copy(origem, destino)
            print(f"Copiado: {arquivo}")
            encontrados += 1
    if encontrados == 0:
        print(f"[AVISO] Nenhum arquivo .png com padrão {padrao_esperado} encontrado.")
else:
    print(f"[ERRO] Subpasta não encontrada: {caminho_subpasta}")
