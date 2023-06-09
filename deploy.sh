#!/bin/bash

FILE="--env-file .env -f docker-compose.yml"

if [ $APP_ENV = "prod" ]; then
  FILE+=" -f docker-compose.prod.yml"
else
  FILE+=" -f docker-compose.dev.yml"
fi

echo "Creating 'web' network if not exist";
docker network create web &> /dev/null || true;
docker compose ${FILE} up --pull always -d;
