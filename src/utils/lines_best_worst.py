import os
import pandas as pd
import shutil

# === Caminhos ===
caminho_csv_melhores = r'E:\Git\Mestrado\comparativos\estimadores\RF\melhores_cada_fusao_mae.csv'
pasta_csvs_fusoes = r'E:\Git\Mestrado\comparativos\estimadores\RF'

# Previsões temporais e hierárquicas
previsoes_temporal = r'E:\Git\Mestrado\previsoes\2024\RF\2025-04-28_12-30-16'
previsoes_hierarquico = r'E:\Git\Mestrado\previsoes\2024\RF\2025-04-28_12-30-16'

# Pasta de destino final
pasta_destino_base = r'E:\Git\Mestrado\comparativos\estimadores\RF\previsoes'

# === Leitura do CSV com os melhores modelos ===
df = pd.read_csv(caminho_csv_melhores)

# === Função para identificar o tipo ===
def identificar_tipo(fusao_name):
    fusao = fusao_name.lower()
    if 'hierarquico' in fusao:
        return 'hierarquico'
    elif 'temporal' in fusao:
        return 'temporal'
    else:
        return 'geral'

# === Função para buscar a linha no CSV de origem ===
def encontrar_linha_fusao(fusao_name, valor_mae):
    arquivos_fusao = [arq for arq in os.listdir(pasta_csvs_fusoes) if arq.startswith(fusao_name)]
    for arquivo in arquivos_fusao:
        caminho_completo = os.path.join(pasta_csvs_fusoes, arquivo)
        df_fusao = pd.read_csv(caminho_completo)
        linha = df_fusao[df_fusao['mae'] == valor_mae]
        if not linha.empty:
            return linha.iloc[0], arquivo
    return None, None

# === Função para localizar arquivos .png e copiar ===
def copiar_png(fusao_name, linha, nome_arquivo_csv, tipo, categoria_mae):
    # Caminho base de onde copiar
    base_previsao = previsoes_hierarquico if tipo == 'hierarquico' else previsoes_temporal

    # Acha subpasta que começa com o nome do arquivo .csv da fusão
    nome_base = nome_arquivo_csv.replace('.csv', '')
    subpastas = [p for p in os.listdir(base_previsao) if p.startswith(nome_base)]
    if not subpastas:
        print(f"[AVISO] Nenhuma subpasta encontrada para {nome_base} em {base_previsao}")
        return

    caminho_subpasta = os.path.join(base_previsao, subpastas[0])

    # Gera o nome do arquivo esperado
    padrao = (
        f"n{linha['n_estimators']}_"
        f"maxd{linha['max_depth']}_"
        f"minsl{linha['min_samples_leaf']}_"
        f"minsp{linha['min_samples_split']}_"
        f"crit{linha['criterion']}_"
        f"boot{linha['bootstrap']}.png"
    ).lower()

    arquivos_png = [f for f in os.listdir(caminho_subpasta) if f.lower().endswith('.png') and padrao in f.lower()]
    if not arquivos_png:
        print(f"[AVISO] Nenhum arquivo .png encontrado para {fusao_name} com padrão {padrao}")
        return

    # Pasta de destino
    destino = os.path.join(pasta_destino_base, tipo, categoria_mae)
    os.makedirs(destino, exist_ok=True)

    for arquivo in arquivos_png:
        origem = os.path.join(caminho_subpasta, arquivo)
        destino_final = os.path.join(destino, arquivo)
        shutil.copy(origem, destino_final)
        print(f"[{tipo.upper()} - {categoria_mae.upper()}] Copiado: {arquivo}")

# === Função auxiliar para executar para maior/menor de um DataFrame ===
def processar_extremos(df_parcial, tipo):
    menor = df_parcial.loc[df_parcial['mae'].idxmin()]
    maior = df_parcial.loc[df_parcial['mae'].idxmax()]

    linha_menor, arquivo_menor = encontrar_linha_fusao(menor['fusao_name'], menor['mae'])
    linha_maior, arquivo_maior = encontrar_linha_fusao(maior['fusao_name'], maior['mae'])

    if linha_menor is not None:
        print(f"[{tipo.upper()} - MENOR MAE] Fusão: {menor['fusao_name']} | MAE: {menor['mae']:.7f} | Arquivo CSV: {arquivo_menor}")
        copiar_png(menor['fusao_name'], linha_menor, arquivo_menor, tipo, 'menor_mae')
    if linha_maior is not None:
        print(f"[{tipo.upper()} - MAIOR MAE] Fusão: {maior['fusao_name']} | MAE: {maior['mae']:.7f} | Arquivo CSV: {arquivo_maior}")
        copiar_png(maior['fusao_name'], linha_maior, arquivo_maior, tipo, 'maior_mae')

# === Processamento ===

# Geral (todos)
processar_extremos(df, 'geral')

# Hierárquico
df_h = df[df['fusao_name'].str.lower().str.contains("fusao_hier")]
if not df_h.empty:
    processar_extremos(df_h, 'hierarquico')

# Temporal
df_t = df[df['fusao_name'].str.lower().str.contains("fusao_temp")]
if not df_t.empty:
    processar_extremos(df_t, 'temporal')
