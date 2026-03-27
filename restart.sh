#!/bin/bash
set -eu

. ./scripts/compose-args.sh

docker compose "${COMPOSE_ARGS[@]}" restart
