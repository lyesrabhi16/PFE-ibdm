# IBDM — Industrial Data Monitoring Platform

End-of-studies project (PFE) developed during an internship at IFRI (Algeria): a cross-platform application that collects, stores and displays **industrial production data in real time** for several plant units (syrup room, filtration, utilities, CO₂).

## Architecture

```
Flutter app (web, Android, Windows, Linux, macOS, iOS)
        │  REST + WebSockets (typed client generated from OpenAPI)
        ▼
Django / DRF API  ──── Channels + Redis (live updates)
        │
        ├── SQL Server (one database per business domain)
        └── existing plant databases (automate, siroperie, filtration, utilité)
```

| Part | Path | Stack |
| --- | --- | --- |
| API | [backend/ibdm_api](backend/ibdm_api) | Python 3.12, Django 5, Django REST Framework, Channels (Daphne), drf-spectacular, `mssql-django` |
| App | [frontend/ibdm](frontend/ibdm) | Flutter / Dart, Retrofit client generated from the OpenAPI spec |
| Infrastructure | [backend/config](backend/config) | Docker Compose files for SQL Server, Redis, a MongoDB sharded cluster, and a local DNS/proxy |

### Django apps

| App | Role |
| --- | --- |
| `users`, `app_auth` | Users, permissions and authentication |
| `siroperie`, `filtration`, `utilite` | Plant units: models, REST endpoints and WebSocket consumers for live data |
| `automate` | Unmanaged models mapped onto the existing `automate` plant database |
| `documentation` | Serves the API docs |

## Features

- Real-time dashboards through WebSockets (Django Channels with a Redis channel layer)
- Role-based permissions and an admin back office (Jazzmin)
- Separate SQL Server databases per business domain
- Email reports with HTML templates (e.g. sugar inventory)
- Auto-generated OpenAPI documentation and Dart API client
- HTTPS-only deployment (Hypercorn + local certificate authority)

## Screenshots

All captured from the demo stack below (synthetic data, 30 days of history, live readings).

### Plant dashboards

| | |
| --- | --- |
| ![Siroperie](docs/screenshots/siroperie.png) | ![Siroperie graph](docs/screenshots/siroperie-graph.png) |
| **Siroperie**: live sugar tank levels, totals and fill % | History graph (hours / days / weeks precision) |
| ![Inventory](docs/screenshots/siroperie-inventory.png) | ![Filtration](docs/screenshots/filtration.png) |
| Daily inventory, with the number of tanks to order | **Filtration**: flow, volume and pressure per line |
| ![Filtration consumption](docs/screenshots/filtration-consumption.png) | ![Utilité](docs/screenshots/utilite.png) |
| Consumption over a date range | **Utilité**: temperatures and pressures per zone |
| ![CO2](docs/screenshots/co2.png) | |
| **CO₂ / N₂**: tank levels, pressure gauges, consumption | |

### Administration

| | |
| --- | --- |
| ![Users](docs/screenshots/users.png) | ![Server status](docs/screenshots/server-status.png) |
| User management with roles and avatars | Server status: databases, Redis, memory |

### E-mail reports and alerts

| | |
| --- | --- |
| ![Schedules](docs/screenshots/email-schedules.png) | ![Alerts](docs/screenshots/email-alerts.png) |
| Scheduled reports (daily / weekly / monthly) | Alert thresholds (warning and danger) per monitored value |
| ![Sent](docs/screenshots/emails-sent.png) | ![Inbox](docs/screenshots/mail-inbox.png) |
| Delivery history (orange = warning, red = danger) | What recipients get (captured by Mailpit) |
| ![Report e-mail](docs/screenshots/mail-report.png) | ![Alert e-mail](docs/screenshots/mail-alert.png) |
| HTML report with an Excel attachment | Danger alert with the monitored value and a custom message |
| ![Excel export](docs/screenshots/export-excel.png) | ![Swagger UI](docs/screenshots/swagger.png) |
| The attached Excel export | Interactive OpenAPI documentation |

**Viewing the e-mails.** The demo does not send real mail: every message goes to [Mailpit](http://localhost:8025), which shows the rendered HTML (logo, tables, colours), the plain-text version, the headers and the attachments, so you can check the reports and alerts without an SMTP account. Mailpit renders with a standard browser engine, so it shows how the HTML looks, not how a particular mail client will treat it; its "HTML Check" tab estimates client compatibility (about 48% for the sugar report, 88% for the alert). The IBDM logo is embedded in each message as an inline image, so it displays without internet access. To send real e-mail, add an SMTP provider to `EMAIL_PROVIDERS` in `demo/settings.json`.

## Try it with Docker (demo)

One command starts SQL Server, Redis, Mailpit and the API, creates the five databases, migrates them and creates the plant tables. It then seeds:

- **30 days of sensor history** for every table (about 5,200 readings each), shaped like the real plant: tanks that drain and get refilled, daily production cycles, counters that reset daily. Values stay inside the healthy ranges used by the dashboards.
- **8 users** across five roles, with illustrated avatars.
- **4 e-mail schedules** (sugar inventory, filtration, CO₂, utilities) and **2 alert rules**; the reports and alerts are sent at start-up so the history and the mailbox are populated.

A `simulator` service then appends a new reading every 10 seconds, so the "live data" views keep moving. The API also serves the pre-built Flutter web app.

```bash
docker compose -f demo/compose.yaml up --build
```

Wait for `Databases ready` in the logs (about 3 minutes the first time), then open <https://localhost:8443/app/> (accept the self-signed certificate) and log in with `admin@ibdm.demo` / `Demo_Passw0rd!` (the other demo users share that password).

| URL | What |
| --- | --- |
| https://localhost:8443/app/ | Flutter web app (dashboards, users, e-mail settings, server status) |
| https://localhost:8443/api/v1/docs/ | Swagger UI |
| https://localhost:8443/admin | Django admin |
| http://localhost:8025 | Mailpit: every e-mail the app sends |

Everything under [demo](demo) is for local demonstration only: credentials are public and the TLS certificate is self-signed. Avatars are generated with DiceBear "Notionists" (CC0).

### Nix dev shell

```bash
nix develop          # Python 3.12, pipenv, ODBC Driver 18, docker compose, Node/pnpm
nix develop .#app    # Flutter toolchain for frontend/ibdm
```

## Getting started

### Prerequisites

Python 3.12, [pipenv](https://pipenv.pypa.io), pnpm, Docker, the [Flutter SDK](https://flutter.dev), and the Microsoft ODBC driver for SQL Server.

### Backend

```bash
pnpm run install:deps                       # pipenv sync
```

1. Start the databases and Redis from [backend/config/config/db](backend/config/config/db) (see its [README](backend/config/config/db/setup-README.md)); `pnpm run sql_server_db:up` starts SQL Server.
2. Create the environment file and fill in the real credentials:
   ```bash
   cp backend/.env.example backend/.env
   ```
3. Generate the HTTPS certificates ([instructions](backend/ibdm_api/certs/create_certificates.readme.md)).
4. Migrate and run:
   ```bash
   cd backend && pipenv run migrate
   pnpm run dev:server                      # https://localhost:8443
   ```

### Flutter app

```bash
cd frontend/ibdm
cp lib/config/api.config.dart.example lib/config/api.config.dart   # set the API URL
flutter pub get
flutter run -d chrome                       # or: android, windows, linux, macos
```

See [frontend/ibdm/README.md](frontend/ibdm/README.md) for Android certificate setup and release builds.

### Regenerate the API client

When the backend API changes:

```bash
pnpm run generate:api-client
```

This exports the OpenAPI schema, copies it to the Flutter project, fixes it for `swagger_parser`, and rebuilds the generated Dart client.

## API documentation

With the server running, open the interactive docs at `https://localhost:8443/api/v1/docs/` (Swagger UI, with ReDoc at `/api/v1/docs/redoc/`), or read the committed spec at [backend/ibdm_api/openapi/openapi.spec.json](backend/ibdm_api/openapi/openapi.spec.json).

## License

Apache License 2.0 — see [LICENSE](LICENSE).
