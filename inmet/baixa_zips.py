import requests
import os

# Diretório onde os arquivos .zip serão salvos
download_dir = r'E:\Git\Mestrado\inmet\todas_estacoes_ano'

# Cria o diretório se não existir
if not os.path.exists(download_dir):
    os.makedirs(download_dir)

# Função para baixar um arquivo
def download_file(url, dest_folder):
    local_filename = os.path.join(dest_folder, os.path.basename(url))
    with requests.get(url, stream=True) as r:
        r.raise_for_status()
        with open(local_filename, 'wb') as f:
            for chunk in r.iter_content(chunk_size=8192): 
                f.write(chunk)
    return local_filename

# Gera os links e baixa os arquivos
base_url = 'https://portal.inmet.gov.br/uploads/dadoshistoricos/'
start_year = 2000
end_year = 2024

for year in range(start_year, end_year + 1):
    zip_url = f"{base_url}{year}.zip"
    print(f"Baixando {zip_url}...")
    try:
        download_file(zip_url, download_dir)
        print(f"{zip_url} baixado com sucesso!")
    except Exception as e:
        print(f"Erro ao baixar {zip_url}: {e}")

print("Todos os arquivos .zip foram baixados!")
