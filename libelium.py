import paho.mqtt.client as mqtt
from pymongo import MongoClient
from datetime import datetime

print("Iniciando o script")

# Configurações do MQTT
mqtt_broker_address = "localhost"
mqtt_topics = ["meshliumfda8/Ag_xtr_01"]  # Adicione quantos tópicos desejar

# Configurações do MongoDB
mongo_client = MongoClient("mongodb://localhost:27017/")
mongo_db = mongo_client["monitoramento"]
mongo_collection = mongo_db["libelium"]

# Função para converter o formato do timestamp
def convert_timestamp_format(iso_timestamp):
    try:
        # Converter ISO 8601 para datetime
        dt = datetime.fromisoformat(iso_timestamp)
        
        # Formatar para o novo formato
        new_format_timestamp = dt.strftime("%Y-%m-%d_%H:%M:%S")
        
        return new_format_timestamp
    except ValueError:
        print(f"Erro ao converter o timestamp: {iso_timestamp}")
        return iso_timestamp  # Retornar o timestamp original em caso de erro

# Função chamada quando uma mensagem é recebida
def on_message(client, userdata, message):
    payload = message.payload.decode("utf-8")
    print(payload)

    try:
        # Converte o payload para um dicionário
        payload_dict = eval(payload)

        # Modifica o formato do timestamp
        payload_dict["timestamp"] = convert_timestamp_format(payload_dict["timestamp"])

        aux = payload_dict['value'].split(" ")
        temperatura = float(aux[1])
        umidade = float(aux[3])
        pressao = float(aux[5])
        bateria = float(aux[7])

        '''
        # Extrai os valores de temperatura, umidade e pressão atmosférica
        temperatura = float(payload.split('Temp: ')[1].split(' Humi: ')[0])
        umidade = float(payload.split('Humi: ')[1].split(' Pres: ')[0])
        pressao = float(payload.split('Pres: ')[1])
        '''
        # Adiciona os novos campos ao dicionário com o formato da unidade
        payload_dict["temperature_C"] = temperatura/100
        payload_dict["humidity_percent"] = umidade/10
        payload_dict["pressure_hPa"] = pressao
        payload_dict["battery"] = bateria


        # Remove o campo "value"
        del payload_dict["value"]

        # Salva os dados no MongoDB
        mongo_collection.insert_one(payload_dict)
        print("Dados salvos no MongoDB.")

    except Exception as e:
        print(f"Erro ao processar a mensagem: {e}")

# Configuração do cliente MQTT
mqtt_client = mqtt.Client()
mqtt_client.on_message = on_message

try:
    # Conexão ao Mosquitto
    mqtt_client.connect(mqtt_broker_address, 1883, 60)

    # Inscreve-se em todos os tópicos especificados
    for topic in mqtt_topics:
        mqtt_client.subscribe(topic)

    # Inicia o loop de espera por mensagens
    mqtt_client.loop_forever()

except KeyboardInterrupt:
    # Encerramento grácil quando o usuário pressiona Ctrl+C
    print("Encerrando o script")
    mqtt_client.disconnect()
    mongo_client.close()