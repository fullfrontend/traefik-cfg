#!/bin/bash
set -eu


FILE="--env-file .env -f docker-compose.yml"
APP_ENV="${APP_ENV:-dev}"

if [ "$APP_ENV" = "prod" ]; then
  FILE+=" -f docker-compose.prod.yml"
else
  FILE+=" -f docker-compose.dev.yml"
fi

docker compose ${FILE} restart
