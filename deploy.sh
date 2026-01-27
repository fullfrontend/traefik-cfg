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
docker compose ${FILE} restart;

if [ $APP_ENV != "prod" ]; then
  echo "Waiting for mkcert container and certs...";
  attempts=0
  max_attempts=30
  while [ $attempts -lt $max_attempts ]; do
    mkcert_id="$(docker compose ${FILE} ps -q mkcert || true)"
    if [ -n "$mkcert_id" ]; then
      mkcert_status="$(docker inspect -f '{{.State.Status}}' "$mkcert_id" 2>/dev/null || true)"
    else
      mkcert_status=""
    fi

    if [ "$mkcert_status" = "running" ] && ls ./certs/*.pem >/dev/null 2>&1; then
      break
    fi
    attempts=$((attempts + 1))
    sleep 1
  done
  ./scripts/generate-https-certs.sh
fi
