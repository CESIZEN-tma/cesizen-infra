#!/bin/bash
# Start the database, wait for it to be ready, then apply seed data.

DB_CONTAINER="postgres-db"
DB_USER="myuser"
DB_NAME="cesizen"
SEED_FILE="$(dirname "$0")/seed.sql"

echo "Starting database..."
docker compose up -d

echo "Waiting for PostgreSQL to be ready..."
until docker exec "$DB_CONTAINER" pg_isready -U "$DB_USER" -d "$DB_NAME" > /dev/null 2>&1; do
    sleep 1
done
echo "PostgreSQL is ready."

echo "Applying seed data..."
docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$SEED_FILE"

echo "Done. Database is up and seeded."
