# PFE-ibdm

# START BACKEND:
1. Change directory to `backend`:
    ```sh
    cd backend
    ```

2. Install dependencies:
    ```sh
    npm install
    ```

3. Configure and run the database as stated in `src/config/db/README.md`.

4. Copy `.env.example` to `.env`:
    ```sh
    cp .env.example .env
    ```

5. Reflect `src/models/schema` into the database (creating collections, indexes, etc.):
    ```sh
    npm run prisma:dev
    ```

6. Start the application:
    ```sh
    npm start
    ```