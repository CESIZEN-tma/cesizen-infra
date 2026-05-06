# Guide de contribution — cesizen-infra

## 1. Stratégie de branches

```
main          ← configuration de production (protégée, merge via PR uniquement)
  └── dev     ← configuration de préprod (protégée, merge via PR uniquement)
        └── feature/<nom>   ← nouvelle configuration ou service
        └── fix/<nom>        ← correction de configuration
        └── chore/<nom>      ← maintenance
```

**Règles :**
- On ne pousse jamais directement sur `main` ou `dev`.
- Tout changement d'infrastructure passe par une Pull Request avec description de l'impact.
- Les fichiers `.env` contenant des secrets réels ne sont **jamais** commités.

## 2. Conventions de commits

Format : `type: description courte`

| Type | Usage |
|---|---|
| `feat` | Ajout d'un nouveau service ou environnement |
| `fix` | Correction de configuration |
| `chore` | Mise à jour de versions d'images, nettoyage |
| `docs` | Documentation uniquement |
| `security` | Correctif de sécurité (ports, permissions, secrets) |

**Exemples :**
```
feat: add redis service for session caching
fix: correct pgbouncer port mapping in preprod
chore: update postgres image to 16.3
```

**Versioning sémantique :** pour contrôler le bump lors du merge sur `main` :
- `#major` → v1.0.0 → v2.0.0 (refonte structurelle de l'infra)
- `#minor` → v1.0.0 → v1.1.0 (ajout de service)
- *(défaut)* → bump patch automatique

## 3. Gestion des tickets (GitHub Issues)

### Créer un ticket

Tout incident, évolution ou besoin d'infrastructure est tracé dans **GitHub Issues** du repo `cesizen-infra`.

**Labels disponibles :**

| Label | Couleur | Usage |
|---|---|---|
| `bug` | Rouge | Service qui ne démarre pas, port bloqué, etc. |
| `enhancement` | Bleu | Nouveau service ou amélioration de configuration |
| `security` | Rouge foncé | Vulnérabilité ou mauvaise configuration de sécurité |
| `chore` | Gris | Mise à jour d'image Docker, nettoyage |
| `critical` | Rouge foncé | Incident en production, service down |

**Structure d'un ticket d'incident :**
```
Titre : [BUG] cesizen-api ne démarre pas en prod (erreur de connexion DB)

Description :
- Environnement : prod
- Symptôme : conteneur cesizen-api redémarre en boucle
- Logs : [coller les logs docker]
- Impact : API inaccessible
- Priorité : critique
```

### Workflow d'un ticket

```
Open → In Progress → In Review → Done
```

## 4. Processus de Pull Request

1. Créer une branche depuis `dev` : `git checkout -b fix/pgbouncer-port`
2. Modifier les fichiers de configuration
3. Tester en local avec `docker compose up -d`
4. Committer et pousser
5. Ouvrir une PR vers `dev` avec description de l'impact
6. Revue obligatoire sur tout changement touchant `prod`
7. Merger

## 5. Gestion des secrets

Les fichiers `.env` contenant des valeurs réelles ne sont **jamais versionnés**.

| Fichier | Statut | Usage |
|---|---|---|
| `.env.preprod.example` | ✅ Versionné | Template pour la préprod |
| `.env.prod.example` | ✅ Versionné | Template pour la production |
| `.env.preprod` | ❌ Ignoré (.gitignore) | Valeurs réelles préprod |
| `.env.prod` | ❌ Ignoré (.gitignore) | Valeurs réelles prod |

Pour configurer un nouvel environnement :
```bash
cp .env.preprod.example .env.preprod
# Editer .env.preprod avec les vraies valeurs
```

## 6. Commandes utiles

```bash
# Démarrer en développement local
docker compose up -d

# Démarrer en préprod
docker compose -f docker-compose.preprod.yml --env-file .env.preprod up -d

# Démarrer en production
docker compose -f docker-compose.prod.yml --env-file .env.prod up -d

# Voir les logs
docker compose logs -f

# Arrêter tous les services
docker compose down

# Voir l'état des services
docker compose ps

# Supprimer les volumes (ATTENTION : perte de données)
docker compose down -v
```
