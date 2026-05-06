# Plan de déploiement — cesizen-infra

## 1. Architecture globale

cesizen-infra contient les fichiers d'orchestration Docker Compose pour l'ensemble de la solution CesiZen. Il centralise la configuration des services, réseaux et volumes de chaque environnement.

```
cesizen-infra/
├── docker-compose.yml          # Développement local
├── docker-compose.preprod.yml  # Préprod
├── docker-compose.prod.yml     # Production
├── .env.preprod.example        # Template variables préprod
└── .env.prod.example           # Template variables prod
```

### Vue d'ensemble des services

```
                    ┌─────────────────────────────────────────┐
                    │              Serveur hôte               │
                    │                                         │
  Internet ────────►│  cesizen-web (nginx)                    │
                    │       │                                 │
                    │       ▼                                 │
                    │  cesizen-api (.NET)                     │
                    │       │                                 │
                    │       ▼                                 │
                    │  PgBouncer (pooling)                    │
                    │       │                                 │
                    │       ▼                                 │
                    │  PostgreSQL (base de données)           │
                    └─────────────────────────────────────────┘
```

## 2. Environnements

| Environnement | Fichier Compose | Réseau Docker | Ports exposés |
|---|---|---|---|
| Développement | `docker-compose.yml` | `cesizen-network` | API: 3000, DB: 5432 |
| Préprod | `docker-compose.preprod.yml` | `cesizen-preprod-network` | Web: 3001, API: 3001, DB: 5433 |
| Production | `docker-compose.prod.yml` | `cesizen-prod-network` | Web: 3000, API: 3000, DB: 5432 |

## 3. Déploiement par environnement

### 3.1 Prérequis communs

```bash
# 1. Authentification GHCR (GitHub Container Registry)
echo $GITHUB_PAT | docker login ghcr.io -u <github_username> --password-stdin

# 2. Cloner cesizen-infra sur le serveur
git clone https://github.com/CESIZEN-tma/cesizen-infra.git
cd cesizen-infra
```

### 3.2 Préprod

```bash
# Créer le fichier de variables d'environnement
cp .env.preprod.example .env.preprod
# Remplir les valeurs dans .env.preprod

# Récupérer les dernières images
docker compose -f docker-compose.preprod.yml pull

# Démarrer les services
docker compose -f docker-compose.preprod.yml --env-file .env.preprod up -d

# Vérifier l'état
docker compose -f docker-compose.preprod.yml ps
```

### 3.3 Production

```bash
# Créer le fichier de variables d'environnement
cp .env.prod.example .env.prod
# Remplir les valeurs dans .env.prod

# Récupérer les dernières images
docker compose -f docker-compose.prod.yml pull

# Démarrer les services
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d

# Vérifier l'état
docker compose -f docker-compose.prod.yml ps
```

## 4. Variables d'environnement

### Préprod (`.env.preprod`)

| Variable | Description |
|---|---|
| `POSTGRES_DB` | Nom de la base de données |
| `POSTGRES_USER` | Utilisateur PostgreSQL |
| `POSTGRES_PASSWORD` | Mot de passe PostgreSQL |
| `PGBOUNCER_AUTH_TYPE` | Mode d'authentification PgBouncer |
| `JWT_SECRET` | Clé de signature des tokens JWT |
| `API_KEY` | Clé d'authentification de l'API |
| `VITE_API_BASE_URL` | URL de l'API côté front |

### Prod (`.env.prod`)

Mêmes variables que préprod avec des valeurs de production distinctes. Les mots de passe et clés doivent être des valeurs fortes et différentes de la préprod.

## 5. Versioning et mises à jour

### Mise à jour d'un service

```bash
# Tirer la nouvelle image (ex. après un déploiement depuis cesizen-api)
docker compose -f docker-compose.prod.yml pull cesizen-api

# Redémarrer uniquement le service mis à jour (zéro downtime sur les autres)
docker compose -f docker-compose.prod.yml up -d cesizen-api
```

### Versioning de l'infra

Chaque merge sur `main` crée un tag sémantique automatique (`vX.Y.Z`) via `release.yml`. Cela permet de revenir à une configuration d'infrastructure précédente si nécessaire.

| Mention dans le commit | Effet |
|---|---|
| `#major` | Changement structurel majeur (nouveau service, refonte réseau) |
| `#minor` | Ajout de service ou configuration notable |
| *(défaut)* | Correction ou ajustement de configuration |

## 6. Procédure de rollback complet

```bash
# 1. Revenir à une version de l'infra
git checkout vX.Y.Z

# 2. Revenir aux images de cette version
docker compose -f docker-compose.prod.yml pull

# 3. Redéployer
docker compose -f docker-compose.prod.yml up -d
```

Pour les bases de données, consulter le plan de rollback de `cesizen-api` (migrations EF).

## 7. Supervision et logs

```bash
# Voir les logs en temps réel
docker compose -f docker-compose.prod.yml logs -f

# Logs d'un service spécifique
docker compose -f docker-compose.prod.yml logs -f cesizen-api

# Vérifier la santé des conteneurs
docker compose -f docker-compose.prod.yml ps
docker stats
```

## 8. Cohérence avec le projet

| Contrainte | Solution retenue |
|---|---|
| Multi-environnements | Fichiers Compose distincts par env, réseau Docker isolé |
| Secrets | Variables d'environnement injectées via `.env`, jamais dans le code |
| Portabilité | Images GHCR versionnées, déployables sur tout serveur Docker |
| Maintenabilité | Un seul repo infra centralisé, mise à jour service par service possible |
