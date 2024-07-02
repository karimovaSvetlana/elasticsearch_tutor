#!/bin/bash

echo "|||||| docker-compose down"
docker-compose down

# Delete files locally
echo "|||||| rm -rf certs/ es_data/"
rm -rf certs/ esdata01/ esdata02/ esdata03/ kibanadata/

# Start your main service
docker-compose up -d