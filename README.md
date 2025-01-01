# PFE-ibdm

# START BACKEND:
1. Change directory to [`backend`](backend):
    ```sh
    cd backend
    ```

2. Install dependencies:
    ```sh
    pnpm install
    ```

3. Configure and run MongoDB database as stated in [`src/config/db/README.md`](backend/src/config/db/README.md).

4. Copy [`.env.example`](backend/.env.example) to `.env`:
    ```sh
    cp .env.example .env
    ```

5. Reflect [`src/models/schema`](backend/src/models/schema/) into the database (creating collections, indexes, etc.):
    ```sh
    pnpm run prisma:dev
    ```

6. Start the application:
    ```sh
    pnpm start
    ```

# Generate Api Client
1. api client must be regenerated whenever an API described in [`backend/openapi.json`](backend/openapi.json) is added, modified or deleted.
2. run this command to recreate the frontend api client:
```bash
pnpm run generate:api-client
```