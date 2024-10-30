import os
import subprocess

# Defina as pastas com os scripts
pastas = {
    #"analises_arquitetura": "./src/graph/analises_arquitetura",
    "hierarquico_graph": "./src/graph/hierarquico_graph",
    "temporal_graph": "./src/graph/temporal_graph"
}

# Caminho para o interpretador Python no ambiente virtual
python_venv = os.path.join(os.getenv("VIRTUAL_ENV", ""), "Scripts", "python.exe")

# Armazena nomes de pastas que não foram encontradas
pastas_nao_encontradas = []

# Função para rodar todos os scripts .py em uma pasta
def executar_scripts(pasta):
    if not os.path.exists(pasta):
        return False  # Retorna False se a pasta não existe
    
    for arquivo in os.listdir(pasta):
        if arquivo.endswith(".py"):
            caminho_script = os.path.join(pasta, arquivo)
            print(f"Executando {caminho_script}...")
            # Executa o script com o interpretador Python do ambiente virtual
            subprocess.run([python_venv, caminho_script])
    
    return True  # Retorna True se a pasta existe e os scripts foram executados

# Executar scripts nas pastas 'analises_arquitetura', 'hierarquico_graph' e 'temporal_graph'
for nome, caminho in pastas.items():
    print(f"Executando scripts na pasta {nome}")
    if not executar_scripts(caminho):
        pastas_nao_encontradas.append(nome)  # Adiciona à lista se não encontrou a pasta

# Exibir as pastas que não foram encontradas
if pastas_nao_encontradas:
    print("As seguintes pastas não foram encontradas:")
    for pasta in pastas_nao_encontradas:
        print(f"- {pasta}")
else:
    print("Todas as pastas foram encontradas e processadas.")
