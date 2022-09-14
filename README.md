Traefik Configuration
=====================

## Setup
1. Upon clone create the `config/acme.json` file

    ```
    $ touch config/acme.json
    $ chmod 600 config/acme.json
    ```
2. Create a new network `web`
   
   ```
   $ docker network create web
   ```
   
2. Run `./deploy.sh`
