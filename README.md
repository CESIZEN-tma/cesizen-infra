# CesiZen — Infrastructure

Configuration Docker de la base de données CesiZen : **PostgreSQL** + **PgBouncer** (connection pooling).

## Prérequis

- [Docker](https://docs.docker.com/get-docker/) et Docker Compose

## Installation

```bash
git clone <repo-url>
cd cesizen-infra
cp .env.example .env
```

Remplissez le `.env` :

| Variable | Description |
|---|---|
| `DB_NAME` | Nom de la base de données |
| `DB_USER` | Utilisateur PostgreSQL |
| `DB_PASSWORD` | Mot de passe PostgreSQL |
| `API_BUILD_CONTEXT` | Chemin vers le dossier de l'API |
| `API_DOCKERFILE_PATH` | Chemin vers le Dockerfile de l'API |
| `API_ENV_FILE` | Chemin vers le `.env` de l'API |
| `API_PORT` | Port exposé pour l'API (mappé sur le port interne 8080) |
| `BACKOFFICE_BUILD_CONTEXT` | Chemin vers le dossier du back-office |
| `BACKOFFICE_DOCKERFILE_PATH` | Chemin vers le Dockerfile du back-office |
| `BACKOFFICE_PORT` | Port exposé pour le back-office |
| `GITHUB_USERNAME` | Compte GitHub pour l'accès aux packages privés |
| `GITHUB_TOKEN` | Token GitHub (lecture des packages) |

## Lancement

```bash
# Démarrer uniquement la base de données
docker compose up postgres pg-bouncer -d

# Démarrer toute l'infrastructure (DB + API + back-office)
docker compose up -d
```

PostgreSQL est accessible sur `localhost:5432`, PgBouncer sur `localhost:6432`.

## Scripts SQL

| Fichier | Rôle |
|---|---|
| `init.sql` | Création du schéma (tables, indexes) |
| `seed.sql` | Données de démonstration |
| `flush.sql` | Remise à zéro des données (conserve le schéma) |

```bash
# Initialiser la base
docker exec -i postgres-db psql -U $DB_USER -d $DB_NAME < init.sql

# Charger les données de démo
docker exec -i postgres-db psql -U $DB_USER -d $DB_NAME < seed.sql

# Remettre à zéro
docker exec -i postgres-db psql -U $DB_USER -d $DB_NAME < flush.sql
```

## Services

| Service | Port | Description |
|---|---|---|
| `postgres` | 5432 | Base de données PostgreSQL |
| `pg-bouncer` | 6432 | Pooler de connexions |
| `api` | `$API_PORT` | API ASP.NET (optionnel) |
| `backoffice` | `$BACKOFFICE_PORT` | Front back-office (optionnel) |
