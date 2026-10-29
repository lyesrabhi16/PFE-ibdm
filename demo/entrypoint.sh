#!/usr/bin/env bash
set -euo pipefail
cd /app/ibdm_api
export PYTHONPATH=/app/demo:/app/ibdm_api
export DJANGO_SETTINGS_MODULE=demo_settings
mkdir -p certs data/logs

# Self-signed certificate for the HTTPS-only API (the app redirects HTTP to HTTPS)
if [ ! -f certs/ibdm.crt ]; then
  openssl req -x509 -newkey rsa:2048 -nodes -days 365 -keyout certs/ibdm.key -out certs/ibdm.crt \
    -subj "/CN=localhost" -addext "subjectAltName=DNS:localhost,IP:127.0.0.1" 2>/dev/null
fi

# Demo configuration (the app reads DB connections from settings.json)
cp /app/demo/settings.json settings.json

# Wait for SQL Server, then run migrations and seed demo data
python /app/demo/prepare_databases.py
exec daphne -b 0.0.0.0 -e ssl:8443:privateKey=certs/ibdm.key:certKey=certs/ibdm.crt ibdm_api.asgi:application
