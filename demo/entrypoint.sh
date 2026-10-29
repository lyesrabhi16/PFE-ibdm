#!/usr/bin/env bash
set -euo pipefail
cd /app/ibdm_api
mkdir -p certs data/logs

# --- TLS -------------------------------------------------------------------------------------------------
# The API is HTTPS-only. Like the real deployment (see certs/create_certificates.readme.md) we create a local
# certificate authority once, then issue the server certificate from it. The CA is served at /ca (certs/ibdmCA.crt),
# which is what the apps download and trust. Demo only: the CA key is not password protected.
if [ ! -f certs/ibdmCA.crt ]; then
  openssl genrsa -out certs/ibdmCA.key 2048 2>/dev/null
  openssl req -x509 -new -nodes -key certs/ibdmCA.key -sha256 -days 1825 -out certs/ibdmCA.crt \
    -subj "/C=DZ/O=IBDM Demo/CN=IBDM Demo Local CA"
  rm -f certs/ibdm.crt certs/ibdm.key   # anything issued by a previous CA is no longer valid
fi
if [ ! -f certs/ibdm.crt ]; then
  openssl genrsa -out certs/ibdm.key 2048 2>/dev/null
  openssl req -new -key certs/ibdm.key -out certs/ibdm.csr -subj "/C=DZ/O=IBDM Demo/CN=localhost"
  openssl x509 -req -in certs/ibdm.csr -CA certs/ibdmCA.crt -CAkey certs/ibdmCA.key -CAcreateserial \
    -out certs/ibdm.crt -days 825 -sha256 -extfile /app/demo/certs.ext 2>/dev/null
  rm -f certs/ibdm.csr
fi

# Demo configuration (the app reads DB connections from settings.json)
cp /app/demo/settings.json settings.json

# Wait for SQL Server, then run migrations and seed demo data
python /app/demo/prepare_databases.py
exec daphne -b 0.0.0.0 -e ssl:8443:privateKey=certs/ibdm.key:certKey=certs/ibdm.crt ibdm_api.asgi:application
