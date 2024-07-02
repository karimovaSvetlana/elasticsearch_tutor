#!/bin/bash

source .venv/bin/activate

# DELETE
# Remove the Elastic network
echo "|||||| docker network disconnect elastic es01"
docker network disconnect elastic es01
echo "|||||| network rm elastic"
docker network rm elastic

# Remove Elasticsearch containers
echo "|||||| docker stop es01"
docker stop es01
echo "|||||| docker rm es01"
docker rm es01

# Remove the Kibana container
echo "|||||| docker stop kib01"
docker stop kib01
echo "|||||| docker rm kib01"
docker rm kib01

# START
echo "|||||| docker network create elastic"
docker network create elastic
echo "|||||| docker pull docker.elastic.co/elasticsearch/elasticsearch:8.14.1"
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.14.1
echo "|||||| docker pull docker.elastic.co/kibana/kibana:8.14.1"
docker pull docker.elastic.co/kibana/kibana:8.14.1

# COSIGN
echo "|||||| brew install cosign"
brew install cosign
echo "|||||| wget https://artifacts.elastic.co/cosign.pub"
wget https://artifacts.elastic.co/cosign.pub
echo "|||||| cosign verify --key cosign.pub docker.elastic.co/elasticsearch/elasticsearch:8.14.1"
cosign verify --key cosign.pub docker.elastic.co/elasticsearch/elasticsearch:8.14.1
echo "|||||| cosign verify --key cosign.pub docker.elastic.co/kibana/kibana:8.14.1"
cosign verify --key cosign.pub docker.elastic.co/kibana/kibana:8.14.1

# RUN
## ELASTIC
echo "|||||| docker run --name es01 --net elastic -p 9200:9200 -it -m 1GB docker.elastic.co/elasticsearch/elasticsearch:8.14.1"
docker run -d --name es01 --net elastic -p 9200:9200 -it -m 1GB docker.elastic.co/elasticsearch/elasticsearch:8.14.1

echo "|||||| sleep 100"
sleep 200

echo "|||||| docker logs es01"
docker logs es01 > elastic_logs.txt
echo "||||||> check logs above and save all credentials"

## KIBANA
echo "|||||| docker run --name kib01 --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:8.14.1"
docker run -d --name kib01 --net elastic -p 5601:5601 docker.elastic.co/kibana/kibana:8.14.1

echo "|||||| sleep 100"
sleep 200

echo "|||||| docker logs es01"
docker logs kib01 > kibana_logs.txt
echo "||||||> check logs above and save all credentials"



# check is running and start python
read -p "Enter the ELASTIC_PASSWORD (see it from running 'sh elasticsearch_setup.sh') : " PASSWORD
echo "You entered $PASSWORD"

export ELASTIC_PASSWORD=$PASSWORD

docker cp es01:/usr/share/elasticsearch/config/certs/http_ca.crt .
curl --cacert http_ca.crt -u elastic:$ELASTIC_PASSWORD https://localhost:9200

poetry run python es.py