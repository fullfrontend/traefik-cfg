#!/bin/bash

APP_ENV="${APP_ENV:-dev}"
COMPOSE_ARGS=(--env-file .env -f docker-compose.yml)

if [ "$APP_ENV" = "prod" ]; then
  COMPOSE_ARGS+=(-f docker-compose.prod.yml)
else
  ./scripts/generate-dev-compose.sh
  COMPOSE_ARGS+=(-f docker-compose.dev.yml -f docker-compose.dev.generated.yml)
fi
