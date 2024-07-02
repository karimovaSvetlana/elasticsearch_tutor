import re
import json


def extract_credentials(logs):
    password_match = re.search(r"Password for the \x1b\[1melastic\x1b\[22m user.*:\s*\x1b\[1m(.+?)\[22m", logs)
    credentials = {
        'elastic_password': password_match.group(1)[:-1] if password_match else None,
    }

    return credentials


# Извлекаем креденшалы
elasticsearch_credentials = extract_credentials(open("elastic_logs.txt", "r", encoding='utf-8').read())
# kibana_credentials = extract_credentials(kibana_logs)

json.dump(elasticsearch_credentials, open("elastic_password.json", "w"))


