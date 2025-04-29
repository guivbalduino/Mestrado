import os

def apagar_arquivos_joblib(pasta_raiz):
    for root, dirs, files in os.walk(pasta_raiz):
        for file in files:
            if file.endswith('.joblib'):
                caminho_arquivo = os.path.join(root, file)
                try:
                    os.remove(caminho_arquivo)
                    print(f"Arquivo removido: {caminho_arquivo}")
                except Exception as e:
                    print(f"Erro ao remover {caminho_arquivo}: {e}")

# Exemplo de uso:
pasta = r'E:\Git\Mestrado\previsoes\2024\RF'  # substitua pelo caminho que quiser
apagar_arquivos_joblib(pasta)
