1. ```docker-compose.yml``` - from tutorial here: [tap](https://github.com/elastic/elasticsearch/blob/8.14/docs/reference/setup/install/docker.asciidoc). <br>Important: need in volumes change 'certs' or 'esdata01' to './certs' and './esdata01' respectively (add'./' to create local folder)
2. ```docker-compose_start.sh``` - starter for testing (deletes trash and restarts services)
3. ```elasticsearch_setup.sh``` - setting elasticsearch with docker (step before docker-compose in testing)
5. ```es.py``` - conversation with elasticsearch from python

- Simple way to test is elasticsearch running is ```curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200```
- .env is needed for way with docker-compose - we can manually set passwods (shoul be careful with stack_version). <br>In just docker way its more complicated - we take password from logs of container (btw ```docker logs <container_name>```) and then trying to set it globally or save it etc. <br>Also taken from tutorial
