#!/bin/bash

# Delete files locally
rm -rf certs/ es_data/

# Stop and remove containers
docker stop container1 container2
docker rm container1 container2

# Start your main service (example: Elasticsearch)
exec "$@"