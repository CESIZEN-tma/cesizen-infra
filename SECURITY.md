# Plan de sécurisation — CesiZen (global)

## 1. Périmètre

Ce document couvre l'ensemble de la solution CesiZen :
- **cesizen-api** — API REST .NET 10
- **cesizen-web** — SPA React 19
- **cesizen-mobile** — Application React Native / Expo
- **cesizen-infra** — Infrastructure Docker / PostgreSQL / PgBouncer

---

## 2. Analyse des vulnérabilités et risques

### Méthode de calcul de criticité

```
Criticité = Probabilité (1–3) × Impact (1–3)

Probabilité : 1 = Peu probable | 2 = Possible | 3 = Probable
Impact      : 1 = Faible       | 2 = Modéré   | 3 = Critique

Criticité   : 7–9 = CRITIQUE | 4–6 = ÉLEVÉ | 1–3 = MODÉRÉ
```

### Matrice des risques

| ID  | Vulnérabilité                        | Vecteur d'attaque              | P | I | Criticité | Niveau   | Statut       |
|-----|--------------------------------------|--------------------------------|---|---|-----------|----------|--------------|
| V01 | Brute force sur `/user/login`        | Attaque automatisée            | 3 | 3 | **9**     | CRITIQUE | ❌ À corriger |
| V02 | Vol / rejeu de token JWT             | Interception / XSS             | 2 | 3 | **6**     | ÉLEVÉ    | ⚠️ Partiel   |
| V03 | HTTPS absent en production           | Attaque MITM                   | 2 | 3 | **6**     | ÉLEVÉ    | ❌ À corriger |
| V04 | Refresh token non révocable          | Vol de session persistant      | 2 | 3 | **6**     | ÉLEVÉ    | ⚠️ Risque résiduel |
| V05 | Absence de rate limiting global      | DoS applicatif                 | 2 | 2 | **4**     | ÉLEVÉ    | ❌ À corriger |
| V06 | Exposition de secrets dans les logs  | Accès aux logs serveur         | 2 | 2 | **4**     | ÉLEVÉ    | ⚠️ À vérifier |
| V07 | Conteneurs Docker exécutés en root   | Escalade de privilèges         | 2 | 2 | **4**     | ÉLEVÉ    | ❌ À corriger |
| V08 | Dépendances avec vulnérabilités CVE  | Supply chain attack            | 2 | 2 | **4**     | ÉLEVÉ    | ⚠️ Monitoring (Dependabot) |
| V09 | Clé API exposée dans le bundle mobile| Reverse engineering APK        | 2 | 2 | **4**     | ÉLEVÉ    | ⚠️ Partiel   |
| V10 | Injection SQL                        | Requêtes API malformées        | 1 | 3 | **3**     | MODÉRÉ   | ✅ Mitigé (EF Core) |
| V11 | XSS (Cross-Site Scripting)           | Injection JS dans l'UI         | 1 | 2 | **2**     | MODÉRÉ   | ✅ Mitigé (React) |
| V12 | CORS mal configuré                   | Requêtes cross-origin non auth | 1 | 2 | **2**     | MODÉRÉ   | ✅ Configuré  |
| V13 | Données sensibles en base non chiffrées | Accès DB direct             | 1 | 3 | **3**     | MODÉRÉ   | ✅ Passwords hashés (bcrypt) |

---

## 3. Actions correctives et préventives

### V01 — Brute force (CRITIQUE)
**Action :** Implémenter un rate limiting sur les endpoints d'authentification.
```csharp
// Exemple ASP.NET Core — limiter à 5 tentatives / minute / IP
builder.Services.AddRateLimiter(options => {
    options.AddFixedWindowLimiter("login", o => {
        o.PermitLimit = 5;
        o.Window = TimeSpan.FromMinutes(1);
    });
});
```
**Prévention :** Ajouter un CAPTCHA après 3 échecs. Bloquer l'IP après 10 échecs.

### V02 — Vol de token JWT (ÉLEVÉ)
**Action :** Configurer une durée de vie courte (15 min) et utiliser le refresh token uniquement sur HTTPS.
**Prévention :** Stocker le token en mémoire côté web (pas localStorage). Utiliser `httpOnly` cookies si possible.

### V03 — HTTPS absent (ÉLEVÉ)
**Action :** Configurer un reverse proxy (nginx ou Caddy) avec certificat TLS (Let's Encrypt).
```nginx
server {
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/domain/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/domain/privkey.pem;
}
```
**Prévention :** Activer HSTS (Strict-Transport-Security).

### V04 — Refresh token non révocable (ÉLEVÉ)
**Action :** Stocker les refresh tokens en base de données avec un champ `isRevoked`. Invalider à la déconnexion.
**Prévention :** Implémenter une rotation des refresh tokens (chaque usage génère un nouveau token).

### V05 — Absence de rate limiting global (ÉLEVÉ)
**Action :** Appliquer un rate limiting global sur tous les endpoints de l'API.
**Prévention :** Monitorer les pics de trafic avec alertes automatiques.

### V06 — Secrets dans les logs (ÉLEVÉ)
**Action :** Auditer les logs pour s'assurer qu'aucun mot de passe, token ou clé d'API n'est loggé.
**Prévention :** Utiliser un logger structuré avec filtres sur les champs sensibles.

### V07 — Conteneurs en root (ÉLEVÉ)
**Action :** Ajouter un utilisateur non-root dans les Dockerfiles.
```dockerfile
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser
USER appuser
```
**Prévention :** Scanner les images avec Trivy dans la CI (déjà configuré).

### V08 — Dépendances vulnérables (ÉLEVÉ)
**Action :** Dependabot configuré pour alertes hebdomadaires. `npm audit` dans la CI.
**Prévention :** Trivy scanner les images Docker. Maintenir une politique de mise à jour régulière.

### V09 — Clé API dans le bundle mobile (ÉLEVÉ)
**Action :** Utiliser des variables d'environnement Expo non incluses dans le bundle de production.
**Prévention :** À terme, implémenter un proxy d'authentification pour éviter d'exposer la clé côté client.

### V10 à V13 — Vulnérabilités modérées
Ces vulnérabilités sont déjà mitigées par les choix technologiques (EF Core, React, bcrypt) et la configuration actuelle.

---

## 4. Mesures de sécurité déjà en place

| Mesure | Description |
|---|---|
| Authentification JWT | Access token (courte durée) + refresh token |
| Hachage des mots de passe | bcrypt avec salt |
| Clé API | Toutes les requêtes nécessitent une `x-api-key` valide |
| Validation des modèles | Data annotations .NET sur tous les DTOs |
| CORS | Origines autorisées explicitement configurées |
| Secrets gérés via GitHub | Variables d'environnement, jamais dans le code |
| CI avec tests | Non-régression à chaque commit |
| Scan Trivy | Vulnérabilités CVE sur les images Docker (CI) |
| Dependabot | Alertes automatiques sur dépendances obsolètes |

---

## 5. Procédure de gestion de crise en cas d'attaque

### 5.1 Niveaux d'incident

| Niveau | Critères | Délai de réponse |
|---|---|---|
| P1 — Critique | Service down, fuite de données, attaque active | < 1h |
| P2 — Élevé | Dégradation de service, tentative d'intrusion | < 4h |
| P3 — Modéré | Comportement suspect, alerte CVE | < 24h |

### 5.2 Procédure d'escalade

```
Détection (monitoring / alerte / utilisateur)
        │
        ▼
Qualification (quel service ? quel impact ? quelle criticité ?)
        │
        ├─► P1/P2 ─► Isolation immédiate du service concerné
        │                     │
        │                     ▼
        │            Notification de l'équipe (responsable technique + chef de projet)
        │                     │
        │                     ▼
        │            Analyse de la cause racine
        │                     │
        │                     ▼
        │            Déploiement du correctif (hotfix → PR → merge → déploiement)
        │                     │
        │                     ▼
        │            Vérification et surveillance renforcée (48h)
        │
        └─► P3 ─► Ticket GitHub Issues + traitement dans le prochain sprint
```

### 5.3 Actions d'isolation

```bash
# Arrêter un service spécifique sans affecter les autres
docker compose -f docker-compose.prod.yml stop cesizen-api

# Redémarrer sur la version stable précédente
docker pull ghcr.io/cesizen-tma/cesizen-api:vX.Y.Z
docker compose -f docker-compose.prod.yml up -d cesizen-api
```

### 5.4 Responsabilités

| Rôle | Responsabilité |
|---|---|
| Développeur de garde | Détection, qualification, isolation initiale |
| Responsable technique | Décision de rollback, communication équipe |
| Chef de projet | Communication client, suivi incident |

### 5.5 Post-mortem

Après tout incident P1/P2, rédiger un document post-mortem incluant :
- Chronologie de l'incident
- Cause racine identifiée
- Actions correctives mises en place
- Mesures préventives pour éviter la récidive

---

## 6. Signalement de vulnérabilité

Pour signaler une vulnérabilité de sécurité, ouvrir un **GitHub Issue privé** (Security Advisory) sur le repo concerné, ou contacter directement l'équipe via GitHub.

Ne pas divulguer publiquement une vulnérabilité avant qu'elle soit corrigée.
