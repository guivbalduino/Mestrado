import os
import pandas as pd
import matplotlib.pyplot as plt

# Diretórios para analisar
outliers_dirs = [
    r'.\analises_artigo_arquitetura\outliers',
    r'.\analises_artigo_arquitetura\parcial_2024\outliers'
]

# Variáveis que estamos analisando
variables = ['temperature_C', 'humidity_percent', 'pressure_hPa']

# Função para garantir que o nome do arquivo seja válido
def sanitize_filename(filename):
    return "".join(c if c.isalnum() or c in (' ', '_') else '_' for c in filename)

# Função para contar os outliers em cada arquivo CSV dentro da pasta para cada variável
def count_outliers_in_directory(directory):
    outlier_counts = {variable: {} for variable in variables}

    for csv_file in os.listdir(directory):
        if csv_file.endswith('.csv'):
            file_path = os.path.join(directory, csv_file)

            # Identificar a variável pelo nome do arquivo
            for variable in variables:
                if variable in csv_file:
                    # Remover o prefixo "outliers_" do nome do arquivo para usar como nome da fusão
                    fusion_name = csv_file.replace('outliers_', '').replace(f'_{variable}.csv', '')

                    # Carregar o CSV e contar os outliers (valores não nulos)
                    df = pd.read_csv(file_path)
                    outlier_counts[variable][fusion_name] = df[variable].notna().sum()
                    break

    return outlier_counts

# Função para plotar os resultados
def plot_outlier_comparison(variable, outlier_counts, output_dir):
    # Ordenar os dados para a variável específica
    fusion_names = list(outlier_counts.keys())
    counts = list(outlier_counts.values())

    # Gerar gráfico de barras comparando a quantidade de outliers por fusão
    plt.figure(figsize=(10, 6))
    plt.bar(fusion_names, counts, color='skyblue')
    plt.title(f'Comparação de Outliers para {variable}')
    plt.xlabel('Fusão')
    plt.ylabel('Quantidade de Outliers')
    plt.xticks(rotation=45, ha='right')

    # Salvando o gráfico
    file_path = os.path.join(output_dir, f'outlier_comparison_{sanitize_filename(variable)}.png')
    plt.tight_layout()  # Ajustar layout para evitar sobreposição de texto
    plt.savefig(file_path)
    plt.close()
    print(f"Gráfico salvo em: {file_path}")

# Percorrer cada pasta de outliers
for outliers_dir in outliers_dirs:
    for folder_name in os.listdir(outliers_dir):
        folder_path = os.path.join(outliers_dir, folder_name)

        # Ignorar 'inmet' e 'libelium'
        if os.path.isdir(folder_path) and folder_name not in ['inmet', 'libelium']:
            
            # Criar um diretório para salvar os gráficos de outliers dentro da pasta atual
            output_dir = os.path.join(folder_path, 'comparativo_outliers')
            os.makedirs(output_dir, exist_ok=True)

            # Contando os outliers na pasta
            outlier_counts = count_outliers_in_directory(folder_path)

            # Gerar gráficos separados para cada variável
            for variable in variables:
                plot_outlier_comparison(variable, outlier_counts[variable], output_dir)
