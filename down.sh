#!/bin/bash


FILE="--env-file .env -f docker-compose.yml"

if [ $APP_ENV = "prod" ]; then
  FILE+=" -f docker-compose.prod.yml"
else
  FILE+=" -f docker-compose.dev.yml"
fi

docker compose ${FILE} down
