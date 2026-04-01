#!/bin/bash
# Stop the database, wipe all data (volume), then restart clean.

DB_CONTAINER="postgres-db"
DB_USER="myuser"
DB_NAME="cesizen"
VOLUME_NAME="postgre-db-cesizen_postgres-data"

echo "Stopping database and dropping volume..."
docker compose down -v


echo "Starting fresh database..."
docker compose up -d

echo "Waiting for PostgreSQL to be ready..."
until docker exec "$DB_CONTAINER" pg_isready -U "$DB_USER" -d "$DB_NAME" > /dev/null 2>&1; do
    sleep 1
done

echo "Done. Database is up and empty."
