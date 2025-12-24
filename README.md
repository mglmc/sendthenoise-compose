# SendTheNoise Compose Setup

This repository contains the Docker Compose configuration for the **SendTheNoise** application. It orchestrates the necessary services including the PostgreSQL database, the backend API server, and an Nginx reverse proxy.

## Services

The stack consists of the following services:

- **postgres**: PostgreSQL 16 database.
  - Port: `5432` (exposed to host)
  - Data Volume: `postgres_data`
  - Default Credentials: user/password

- **server**: The main SendTheNoise Go application.
  - Built from the parent directory (`..`) using the `Dockerfile`.
  - Dependent on the `postgres` service.
  - Not directly exposed to the host (accessible via Nginx).

- **nginx**: Nginx reverse proxy.
  - Port: `80` (exposed to host)
  - Proxies requests to the `server` service.
  - Configuration: `./nginx.conf`

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Getting Started

1. **Clone the repository** (if you haven't already).

2. **Navigate to the compose directory**:
   ```bash
   cd compose
   ```

3. **Start the application**:
   To build and start the services in the background:
   ```bash
   docker compose up -d --build
   ```

   To stop the services:
   ```bash
   docker compose down
   ```

## Configuration

- **Environment Variables**: The `docker-compose.yaml` file defines default environment variables for the database connection.
- **Nginx**: The `nginx.conf` file contains the server block configuration for the reverse proxy.

## Networking

All services communicate over the `sendthenoise-net` bridge network.
