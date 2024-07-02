import os
from elasticsearch import Elasticsearch

username = 'elastic'
password = os.getenv('ELASTIC_PASSWORD')

es = Elasticsearch(
    "https://localhost:9200",
    basic_auth=(username, password),
    ca_certs='http_ca.crt'
)
client_info = es.info()
print('Connected to Elasticsearch!')
print(client_info.body)
es.indices.create(index="my_index")

# testing functions
es.index(
    index="my_index",
    id="my_document_id",
    document={
        "foo": "foo",
        "bar": "bar",
    }
)

print(es.get(index="my_index", id="my_document_id"))
print(es.search(index="my_index", query={
    "match": {
        "foo": "foo"
    }
}))
print(es.update(index="my_index", id="my_document_id", doc={
    "foo": "bar",
    "new_field": "new value",
}))
print(es.delete(index="my_index", id="my_document_id"))
print(es.indices.delete(index="my_index"))
