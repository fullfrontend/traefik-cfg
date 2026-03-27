Traefik Load Balancer
=====================

Docker Compose setup for a Traefik reverse proxy, with:

- a local `dev` mode based on mkcert-generated certificates
- a preserved `prod` mode kept as an educational example

The production mode is intentionally no longer wired to a real environment. It stays in the repository so the deployment structure, static config, ACME setup, and dashboard protection remain visible for learning.

## Repository Layout

- `docker-compose.yml`: shared Traefik service definition
- `docker-compose.dev.yml`: local development overlay with mkcert
- `docker-compose.prod.yml`: production-style overlay kept as an example
- `config_dev/`: local Traefik configuration
- `config/`: production-style Traefik configuration kept as a template

## Quick Start

1. Start the local stack:

```bash
./deploy.sh
```

`APP_ENV` defaults to `dev`, so `./deploy.sh`, `./restart.sh`, and `./down.sh` all target the local setup unless you explicitly set `APP_ENV=prod`.

2. If you want to run the production example mode, create the ACME storage file first:

```bash
touch config/acme.json
chmod 600 config/acme.json
APP_ENV=prod ./deploy.sh
```

## Open Source Notes

Before publishing this repository:

- keep `.env.local` private
- keep `/certs` private
- replace example values in `config/traefik.yml` before any real production use
- replace the dashboard password hash in `config/dynamic/basic-auth.yml`
- replace the host rule in `docker-compose.prod.yml`

## Local Configuration

Tracked `.env` contains only safe defaults. If you later adapt this repository to a real environment, keep any private overrides in `.env.local`, which is gitignored.

For local certificates:

- tracked shared domains live in `config_dev/mkcert-domains.txt`
- private local-only domains go in `config_dev/mkcert-domains.local.txt`
- `./deploy.sh` regenerates `docker-compose.dev.generated.yml` automatically before starting the `dev` stack
- `./deploy.sh` also regenerates `config_dev/dynamic/https-certs.local.yml`, which stays out of Git

You can start from:

```bash
cp config_dev/mkcert-domains.local.example.txt config_dev/mkcert-domains.local.txt
```

## Commands

```bash
./deploy.sh
./restart.sh
./down.sh
APP_ENV=prod ./deploy.sh
```

## Important Caveat

The `prod` files are examples, not a ready-to-run public production setup. They are useful to study, adapt, and compare against the local mode, but they should be reviewed line by line before reuse on a real server.
