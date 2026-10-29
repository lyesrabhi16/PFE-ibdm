#!/usr/bin/env bash
# Configure the Flutter app for the demo: create the (git-ignored) API config and trust the demo's local CA.
#   demo/configure-frontend.sh [host:port]      default: localhost:8443   (Android emulator: 10.0.2.2:8443)
# Needs curl and a running demo (docker compose -f demo/compose.yaml up).
set -euo pipefail
ADDRESS="${1:-localhost:8443}"
APP="$(cd "$(dirname "$0")/../frontend/ibdm" && pwd)"

# 1. API address
CONFIG="$APP/lib/config/api.config.dart"
if [ ! -f "$CONFIG" ]; then
  cp "$APP/lib/config/api.config.dart.example" "$CONFIG"
fi
sed -i -E "s#(static String address_or_domain = )\"[^\"]*\";#\1\"$ADDRESS\";#" "$CONFIG"
echo "api.config.dart -> $ADDRESS"

# 2. The CA that issued the server certificate (served at /ca). The download itself cannot be verified because we
#    do not trust the CA yet, so we then check that the server's certificate chains to the file we saved.
mkdir -p "$APP/assets/certificates"
CA="$APP/assets/certificates/myCA.pem"      # the file the Android app loads (lib/services/api/api_client.dart)
curl -ksf "https://$ADDRESS/ca" -o "$CA"
grep -q "BEGIN CERTIFICATE" "$CA" || { echo "the server did not return a certificate" >&2; exit 1; }
if curl -sf --cacert "$CA" "https://$ADDRESS/ca" -o /dev/null; then
  echo "assets/certificates/myCA.pem saved; https://$ADDRESS is trusted through it"
else
  echo "the server certificate does not chain to the downloaded CA (is $ADDRESS in demo/certs.ext?)" >&2
  exit 1
fi
