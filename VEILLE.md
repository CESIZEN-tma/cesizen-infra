# Veille technologique — CesiZen

## 1. Objectif

Ce document centralise la veille technologique de la solution CesiZen. Il recense les dépendances critiques, leur état de maintenance, les vulnérabilités connues, et les alternatives évaluées.

**Fréquence de mise à jour :** mensuelle (ou à chaque alerte Dependabot critique).

---

## 2. Outils de veille automatisée en place

| Outil | Rôle | Fréquence |
|---|---|---|
| **GitHub Dependabot** | Alertes sur dépendances vulnérables (npm, NuGet, Docker) | Hebdomadaire |
| **npm audit** | Scan des vulnérabilités dans `node_modules` | À chaque push CI |
| **Trivy** | Scan CVE des images Docker en production | À chaque déploiement |
| **GitHub Security Advisories** | Notifications CVE liées aux dépendances utilisées | Temps réel |

---

## 3. Dépendances critiques par service

### 3.1 cesizen-api (.NET 10)

| Dépendance | Version actuelle | Fin de support | Criticité | Notes |
|---|---|---|---|---|
| .NET SDK | 10 (LTS) | Nov. 2026 | Critique | Version LTS active, supportée |
| ASP.NET Core | 10 | Nov. 2026 | Critique | Inclus dans .NET 10 |
| Entity Framework Core | 10 | Nov. 2026 | Élevé | Migrations, ORM principal |
| PostgreSQL | 16 | Nov. 2028 | Élevé | Base de données principale |
| PgBouncer | 1.22 | Maintenu | Modéré | Pool de connexions |
| BCrypt.Net | Stable | Maintenu | Élevé | Hachage des mots de passe |

### 3.2 cesizen-web (React 19 / Vite)

| Dépendance | Version actuelle | Statut | Criticité | Notes |
|---|---|---|---|---|
| React | 19 | Stable (Dec. 2024) | Critique | Version majeure récente |
| Vite | 6 | Stable | Élevé | Bundler, remplace Webpack |
| TypeScript | 5 | Stable | Élevé | Typage statique |
| Vitest | 3 | Stable | Modéré | Tests unitaires |
| React Router | 7 | Stable | Élevé | Routing SPA |
| Axios | 1.x | Stable | Modéré | Client HTTP |
| jwt-decode | 4 | Stable | Modéré | Décodage JWT côté client |

### 3.3 cesizen-mobile (Expo 54 / React Native 0.81)

| Dépendance | Version actuelle | Statut | Criticité | Notes |
|---|---|---|---|---|
| Expo SDK | 54 | Stable | Critique | SDK mobile — mises à jour régulières |
| React Native | 0.81 | Stable | Critique | Runtime natif |
| expo-secure-store | 14 | Stable | Élevé | Stockage sécurisé des tokens |
| expo-router | 4 | Stable | Élevé | Navigation basée sur fichiers |
| jest-expo | Compatible Expo 54 | Stable | Modéré | Tests unitaires |

### 3.4 Infrastructure Docker

| Image | Version actuelle | Fin de support | Notes |
|---|---|---|---|
| `postgres` | 16 | Nov. 2028 | Préférer images officielles |
| `edoburu/pgbouncer` | 1.22 | Maintenu | Alternative : `bitnami/pgbouncer` |
| `nginx` | alpine | Maintenu | Serveur web, image légère |

---

## 4. Vulnérabilités connues (au 2026-05-06)

| CVE | Service | Sévérité | Description | Statut |
|---|---|---|---|---|
| Aucune CVE critique identifiée à ce jour | — | — | Résultats des scans Trivy + npm audit | ✅ |

> Cette section doit être mise à jour après chaque scan Trivy ou alerte Dependabot.

---

## 5. Alternatives technologiques évaluées

### Backend

| Alternative | Évaluation | Décision |
|---|---|---|
| **Node.js / Express** | Écosystème large, mais moins typé et performant que .NET pour les API | Écarté — équipe maîtrise .NET |
| **FastAPI (Python)** | Rapide à développer, mais rupture de stack avec le reste | Écarté |
| **.NET 10 (retenu)** | Performance, typage fort, Entity Framework, LTS | ✅ Retenu |

### Base de données

| Alternative | Évaluation | Décision |
|---|---|---|
| **MySQL** | Très répandu, mais fonctionnalités avancées moins riches | Écarté |
| **MongoDB** | Flexible (NoSQL), mais inadapté au modèle relationnel de CesiZen | Écarté |
| **PostgreSQL 16 (retenu)** | Robustesse, conformité SQL, JSON natif, LTS | ✅ Retenu |

### Frontend web

| Alternative | Évaluation | Décision |
|---|---|---|
| **Vue.js / Nuxt** | Courbe d'apprentissage douce, mais écosystème plus petit | Écarté |
| **Angular** | Très structuré, mais verbose et lourd pour un projet de cette taille | Écarté |
| **React 19 (retenu)** | Écosystème dominant, Server Components, performance | ✅ Retenu |

### Mobile

| Alternative | Évaluation | Décision |
|---|---|---|
| **Flutter (Dart)** | Performance native excellente, mais stack totalement différente | Écarté |
| **Swift / Kotlin natif** | Performances optimales, mais double codebase | Écarté |
| **React Native / Expo (retenu)** | Code partagé iOS/Android, écosystème JS, Expo simplifie le build | ✅ Retenu |

---

## 6. Politique de mise à jour

| Catégorie | Fréquence de mise à jour | Processus |
|---|---|---|
| Correctifs de sécurité (CVE critique/élevé) | Immédiate (< 48h) | Branche `fix/` → PR → merge urgent |
| Dépendances mineures | Mensuelle | PR Dependabot revue et mergée |
| Versions majeures de frameworks | Trimestrielle | Évaluation, tests de compatibilité, migration planifiée |
| Images Docker de base | Mensuelle | Dependabot + rebuild automatique CI |

---

## 7. Sources de veille

| Source | Type | URL |
|---|---|---|
| GitHub Security Advisories | Alertes CVE auto | github.com/security |
| CVE NIST NVD | Base CVE officielle | nvd.nist.gov |
| .NET Blog | Annonces Microsoft | devblogs.microsoft.com/dotnet |
| React Blog | Annonces React | react.dev/blog |
| Expo Changelog | Mises à jour Expo | expo.dev/changelog |
| OWASP Top 10 | Vulnérabilités web | owasp.org/Top10 |
| Snyk Advisor | Santé des packages npm | snyk.io/advisor |
