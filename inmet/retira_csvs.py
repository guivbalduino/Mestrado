import zipfile
import os
import shutil

# Diretórios e arquivos
download_dir = r'E:\Git\Mestrado\inmet\todas_estacoes_ano'
extract_dir = r'E:\Git\Mestrado\inmet\extraidos'
stations_file = r'E:\Git\Mestrado\inmet\estacoes.txt'

# Cria o diretório de extração se não existir
if not os.path.exists(extract_dir):
    os.makedirs(extract_dir)

# Lê as estações do arquivo .txt
with open(stations_file, 'r') as file:
    stations = [line.strip() for line in file.readlines()]

# Função para extrair arquivos específicos de um arquivo .zip
def extract_specific_files(zip_path, extract_to, stations):
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        for file in zip_ref.namelist():
            if any(station in file for station in stations):
                print(f"Extraindo {file} de {zip_path} para {extract_to}")
                zip_ref.extract(file, extract_to)

# Função para mover todos os arquivos das subpastas para o diretório principal e remover subpastas
def move_files_and_cleanup(src_dir, dest_dir):
    for root, dirs, files in os.walk(src_dir):
        for file in files:
            # Verifica se o arquivo não está no diretório de destino para evitar loops
            if root != dest_dir:
                src_path = os.path.join(root, file)
                dest_path = os.path.join(dest_dir, file)
                print(f"Movendo {src_path} para {dest_path}")
                shutil.move(src_path, dest_path)
                
        # Remove as subpastas vazias
        for dir in dirs:
            dir_path = os.path.join(root, dir)
            if not os.listdir(dir_path):  # Verifica se o diretório está vazio
                print(f"Removendo diretório vazio {dir_path}")
                os.rmdir(dir_path)

# Navega pelo diretório e extrai arquivos específicos de cada .zip
for root, dirs, files in os.walk(download_dir):
    for file in files:
        if file.endswith('.zip'):
            zip_path = os.path.join(root, file)
            extract_specific_files(zip_path, extract_dir, stations)

# Move arquivos das subpastas para o diretório principal e remove subpastas
move_files_and_cleanup(extract_dir, extract_dir)

print("Todos os arquivos específicos foram extraídos e todas as subpastas foram removidas!")
