# Database Configuration with Docker Compose

This guide will help you set up and run the database using the [`docker-compose.yml`](./docker-compose.yaml) file present in this directory.

## Prerequisites

- Docker installed on your machine

## Steps to Use Docker Compose

1. **Navigate to the Directory:**

    Open a terminal and navigate to the directory containing the [`docker-compose.yml`](./docker-compose.yaml) file:
    ```sh
    cd ./backend/src/config/db
    ```

2. **Configure files**
    1. Create a keyfile named `keyfile`:

        ```sh
        openssl rand -base64 756 > files/keyfile.txt
        ```

        This keyfile will be used for MongoDB replica set authentication. It is required.
    
    2. copy [`.env.example`](./.env.example) in the config/db directory, paste and rename to `.env`, change this if you need to, it is the file holding the environment
    variables that will be used in the containers, like user, password, etc

3. **Start the Services:**

    Run the following command to start the services defined in the [`docker-compose.yml`](./docker-compose.yaml) file:
    ```sh
    docker compose up -d
    ```

    The `-d` flag runs the containers in detached mode.
    you can use `-f path/to/docker-compose.yml` to run it without navigating to the directory


4. **Stopping the Services:**

    this is how to stop the services in case you need to, run:
    ```sh
    docker compose down
    ```

## Additional Commands

- **View Logs:**
  ```sh
  docker compose logs container_name_here # full logs of container_name
  docker compose logs mongo_test_db | grep INIT_SCRIPT # logs of INIT_SCRIPT executed in mongo_test_db container
  ```


- **Rebuild Services:**
  ```sh
  docker compose up --build -d
  ```

## Configuration

You can modify the [`docker-compose.yml`](./docker-compose.yaml) file to change the database configuration, such as the database name, user, and password directly or modify the [`.env`](.env) file to do so.

## Troubleshooting

- Ensure Docker and Docker Compose are properly installed and running.
- Check for any errors in the terminal output and the logs of each container and refer to the Docker documentation for troubleshooting tips.

For more information, refer to the [Docker Compose documentation](https://docs.docker.com/compose/).
