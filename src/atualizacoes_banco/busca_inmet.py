from selenium import webdriver
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import csv
from datetime import datetime
from bs4 import BeautifulSoup

def obter_dados_inmet(url):
    # Configuração do navegador Chrome (certifique-se de ter o ChromeDriver instalado)
    opcoes = Options()
    opcoes.headless = True  # Execute sem abrir uma janela do navegador

    # Desativa a verificação de certificado SSL
    opcoes.add_argument('--ignore-certificate-errors')

    # Define um usuário-agente
    opcoes.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3')

    service = ChromeService("./chromedriver.exe")  # Caminho do seu chromedriver.exe no mesmo diretório
    driver = webdriver.Chrome(service=service, options=opcoes)

    # Abre a página usando o navegador Chrome
    driver.get(url)

    # Espera até que a tabela seja carregada (timeout de 10 segundos)
    try:
        tabela_presente = EC.presence_of_element_located((By.CLASS_NAME, 'ui.blue.celled.striped.unstackable.table'))
        WebDriverWait(driver, 10).until(tabela_presente)
    except Exception as e:
        print(f"Erro ao aguardar a tabela: {e}")
        driver.quit()
        return None

    # Utiliza o BeautifulSoup para analisar o HTML da página
    soup = BeautifulSoup(driver.page_source, 'html.parser')

    # Encontra a tabela com a classe especificada
    tabela = soup.find('table', {'class': 'ui blue celled striped unstackable table'})

    if tabela:
        # Extrai os cabeçalhos da tabela (nomes das colunas)
        cabecalhos = [th.text.strip() for th in tabela.find('thead').find_all('th')]

        # Inicializa uma lista para armazenar os dados
        dados = []

        # Itera sobre as linhas da tabela
        for linha in tabela.find('tbody').find_all('tr'):
            # Extrai os dados de cada célula na linha
            celulas = [td.text.strip() for td in linha.find_all('td')]

            # Cria um dicionário associando os cabeçalhos aos dados da linha
            linha_dict = dict(zip(cabecalhos, celulas))

            # Adiciona a linha ao conjunto de dados
            dados.append(linha_dict)

        # Fecha o navegador
        driver.quit()

        # Retorna os dados extraídos
        return dados
    else:
        print('Tabela não encontrada na página.')

    # Fecha o navegador
    driver.quit()
    return None

def salvar_em_csv(dados, nome_modulo):
    # Converte o formato da data
    for linha in dados:
        if 'Data' in linha:  # Certifique-se de ajustar conforme a coluna real que contém a data
            linha['Data'] = datetime.strptime(linha['Data'], '%d/%m/%Y').strftime('%Y-%m-%d')

    # Gera o nome do arquivo
    agora = datetime.now().strftime("%Y%m%d%H")
    nome_arquivo_csv = f'{nome_modulo}_{agora[:4]}-{agora[4:6]}-{agora[6:8]}-{agora[8:]}'

    # Cria um arquivo CSV e escreve os dados
    with open(f'{nome_arquivo_csv}.csv', 'w', newline='', encoding='utf-8') as arquivo_csv:
        escritor_csv = csv.DictWriter(arquivo_csv, fieldnames=dados[0].keys())
        escritor_csv.writeheader()
        escritor_csv.writerows(dados)

    print(f'Dados salvos em {nome_arquivo_csv}.csv')

# URL da página
url = 'https://tempo.inmet.gov.br/TabelaEstacoes/A711'
nome_modulo = 'A711'  # Substitua pelo nome do módulo desejado

# Obtém os dados da tabela
dados_tabela = obter_dados_inmet(url)

# Se os dados foram obtidos com sucesso, salva em um arquivo CSV
if dados_tabela:
    salvar_em_csv(dados_tabela, nome_modulo)
