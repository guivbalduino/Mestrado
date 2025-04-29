import csv
import os
from pymongo import MongoClient

# Conexão com o MongoDB
client = MongoClient("mongodb://localhost:27017/")
db = client["dados"]
colecao = db["fusoes"]

# Diretórios de saída
base_dir = r"E:\Git\Mestrado\data"
csv_dir = os.path.join(base_dir, "csv")
md_dir = os.path.join(base_dir, "md")

os.makedirs(csv_dir, exist_ok=True)
os.makedirs(md_dir, exist_ok=True)

# Campos equivalentes que indicam a modelagem/fusão
campos_nome_equivalentes = ["nome_modelagem", "nome_fusao"]

# Pega todos os valores distintos dessas colunas
valores_set = set()
for campo in campos_nome_equivalentes:
    valores_set.update(colecao.distinct(campo))

# Para cada valor, agrupar os documentos por nome_modelagem OU nome_fusao
for valor in valores_set:
    filtro = {
        "$or": [
            {"nome_modelagem": valor},
            {"nome_fusao": valor}
        ]
    }

    campos = set()
    docs = colecao.find(filtro)

    for doc in docs:
        campos.update(doc.keys())

    campos.discard("_id")

    # Separa os campos "es_" dos demais
    campos_es = sorted([c for c in campos if c.startswith("es_")])
    campos_gerais = sorted([c for c in campos if not c.startswith("es_")])
    campos_ordenados = campos_gerais + campos_es

    # Coleta os valores distintos dos campos
    resultados = []
    for campo in campos_ordenados:
        distincts = colecao.distinct(campo, filtro)
        resultados.append((campo, distincts))

    # Nome do arquivo com base no valor da modelagem/fusão
    base_filename = f"{str(valor).replace('/', '_')}".replace(" ", "_")

    # Exporta CSV
    csv_path = os.path.join(csv_dir, f"{base_filename}.csv")
    with open(csv_path, "w", newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerow(["Campo", "Valores Distintos"])
        for campo, valores in resultados:
            writer.writerow([campo, ", ".join(map(str, valores))])

    # Exporta Markdown
    md_path = os.path.join(md_dir, f"{base_filename}.md")
    with open(md_path, "w", encoding='utf-8') as f:
        f.write(f"# Distintos para modelagem/fusão: {valor}\n\n")
        f.write("| Campo | Valores Distintos |\n")
        f.write("|-------|-------------------|\n")
        for campo, valores in resultados:
            preview = ", ".join(map(str, valores[:5]))
            suffix = " ..." if len(valores) > 5 else ""
            f.write(f"| {campo} | {preview}{suffix} |\n")

    print(f"Exportado: {valor}")
