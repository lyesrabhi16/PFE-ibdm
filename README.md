# PFE-ibdm

# START BACKEND:
1. Make sure you have python 3.12.9 and pipenv installed:
    ```sh
    python --version # should be 3.12.9
    pipenv --version # should be installed preferably version 2024.4.1
    ```

2. Install dependencies:
    ```sh
    pnpm install:deps
    ```

3. Configure and run databases as stated in [`backend/config/config/db/README.md`](backend/config/config/db/README.md).

4. Copy [`backend/ibdm_api/api_v1/.env.example`](backend/.env.example) to `backend/ibdm_api/api_v1/.env`:
    ```sh
    copy backend/ibdm_api/api_v1/.env.example backend/ibdm_api/api_v1/.env
    ```

5. preform migration:
    ```sh
    cd backend/ibdm_api
    python manage.py makemigrations
    python manage.py migrate
    ```

6. Start the application:
    ```sh
    pnpm run dev:server
    ```

# Generate Api Client
1. run this command to recreate the frontend api client:
```bash
pnpm run generate:api-client 
# will copy file to frontend/ibdm/lib/api/openapi.spec.json,
# must be modified to work with swagger_parser
cd frontend/ibdm
dart run swagger_parser
dart run build_runner build
```


# Api Documentation
### see the documentation
1. run the backend server
```bash
pnpm run dev:server
```

2. open your browser and navigate to: [`Docs`](https://localhost/api/v1/docs). url: https://localhost:8443/api/documentation

3. you can checkout the [`openapi.json`](./backend/ibdm_api/openapi/openapi.json) file.
