import os
import subprocess
import sys

# Defina as pastas com os scripts
pastas = {
    "temporal": "./src/fusoes/temporal",
    "hierarquica": "./src/fusoes/hierarquica"
}

# Caminho para o interpretador Python no ambiente virtual
python_venv = os.path.join(os.getenv("VIRTUAL_ENV", ""), "Scripts", "python.exe")

# Função para rodar todos os scripts .py em uma pasta
def executar_scripts(pasta):
    for arquivo in os.listdir(pasta):
        if arquivo.endswith(".py"):
            caminho_script = os.path.join(pasta, arquivo)
            print(f"Executando {caminho_script}...")
            # Executa o script com o interpretador Python do ambiente virtual
            subprocess.run([python_venv, caminho_script])

# Executar scripts nas pastas 'temporal' e 'hierarquica'
for nome, caminho in pastas.items():
    print(f"Executando scripts na pasta {nome}")
    executar_scripts(caminho)
