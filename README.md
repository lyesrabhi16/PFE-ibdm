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

# Api Documentation
### see the documentation
1. run the backend server
```bash
pnpm run dev
```

2. open your browser and navigate to: [`Docs`](https://localhost:8443/api/documentation). url: https://localhost:8443/api/documentation

3. you can checkout the [`openapi.json`](./backend/openapi.json) file.

### write the documentation
check out this: [`OpenAPI Specifications`](https://spec.openapis.org/oas/v3.0.0.html)
1. you can write them directly inside the files in [`routes`](./backend/src/routes/) folder as comments with the decorator `@openapi`.
example: [`Documentation Routes`](./backend/src/routes/documentation/documentation.routes.ts)

2. or inside .spec.yml files.
example: [`Auth Routes Spec File`](./backend/src/routes/authRoutes.spec.yml).
