#!/bin/bash
# Start the database, wait for it to be ready, then apply seed data.

DB_CONTAINER="postgres-db"
DB_USER="myuser"
DB_NAME="cesizen"
SEED_FILE="$(dirname "$0")/seed.sql"



echo "Seeding database..."
docker exec -i "$DB_CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" < "$SEED_FILE"

echo "Done. Database is up and seeded."
