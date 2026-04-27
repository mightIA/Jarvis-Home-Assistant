---
title: Jarvis — Audits & TODO
version: 2
last_update: 2026-04-25 (S52)
scope: Document consolidé — Audit sécurité + Liste des tâches à faire
owner: Mickael Rubino
---

# Jarvis — Audits & TODO

Document consolidé — audit sécurité + liste des tâches à faire. Version 2 — 23 avril 2026.

---

## Partie 1 — Audit de sécurité (18 avril 2026, statut S33 23/04/2026)

Audit de la connexion distante à Home Assistant via **ha.might.ovh**. Infrastructure globalement bien sécurisée grâce à Cloudflare (proxy inverse, DDoS, SSL auto). **2 failles HAUTES fermées (MFA + HSTS, S19)**, CSP en mode report-only (S20), MightTab ajourné (choix assumé S21), restent 2 BASSES.

### Fiche de l'audit

| Champ              | Valeur                                                    |
|--------------------|-----------------------------------------------------------|
| Cible              | `https://ha.might.ovh/`                                   |
| Date audit initial | 18 avril 2026                                             |
| MAJ statut         | 23 avril 2026 (S33)                                       |
| Version HA         | 2026.4.3+ (reboot post S18)                               |
| Réalisé par        | Jarvis (assistant HA de Mickael)                          |
| Méthode            | Analyse via navigateur authentifié (Claude in Chrome)     |

### Résumé exécutif (mise à jour S33)

| Catégorie             | Statut        | Détail                                             |
|-----------------------|---------------|----------------------------------------------------|
| Chiffrement HTTPS     | OK            | Cloudflare actif (CDG / Paris)                     |
| Protection API        | OK            | Endpoints en 403 sans auth                         |
| Anti-clickjacking     | OK            | `X-Frame-Options: SAMEORIGIN`                      |
| Protection MIME       | OK            | `X-Content-Type-Options: nosniff`                  |
| CORS                  | OK            | Pas d'origine externe autorisée                    |
| HSTS                  | **FAIT S19**  | max-age 6 mois, TLS min 1.2                        |
| MFA / 2FA (TOTP)      | **FAIT S19**  | Actif compte Mickael + secret base32 coffre        |
| CSP                   | **EN COURS S20** | Mode report-only actif — phase 2 collecte       |
| MightTab local_only   | **AJOURNÉ S21** | Choix assumé tant que tablette au domicile      |
| Permissions-Policy    | À faire       | Tâche #16 — priorité BASSE                         |
| SSH aux clés (local)  | À faire       | Tâche #14 — priorité BASSE                         |

### Points positifs

**Cloudflare actif** (datacenter CDG / Paris) : protection DDoS, masquage IP réelle, certificat SSL automatique, filtrage requêtes malveillantes. Header `server: cloudflare` confirmé.

**API protégée** : tous les endpoints testés retournent 403 Forbidden sans authentification valide (`/api/`, `/api/discovery_info`, `/auth/providers`, `/api/onboarding`). Un attaquant non authentifié ne peut pas découvrir la version HA, les providers, ni accéder à l'API.

**MCP Server HA** : le `mcp_server` core HA a été supprimé S19 (bug DCR RFC 7591). Remplacé par l'add-on `ha-mcp` (FastMCP + DCR) exposé via Cloudflare Tunnel sur `https://mcp.might.ovh/private_PfjEvJTqhCdo9ELRqCPADlzo` (secret path auto-généré, bypass CF Access). Auth OAuth DCR compatible Claude.ai + Cowork.

### Vulnérabilités — statut S33

#### FERMÉE — HSTS (Strict-Transport-Security)

**Sévérité initiale** : HAUTE — **FAIT 19/04/2026 (S19)**.
Cloudflare : SSL/TLS → Edge Certificates → Always Use HTTPS ON + HSTS max-age 6 mois + TLS minimum 1.2.

#### FERMÉE — MFA / Authentification à deux facteurs

**Sévérité initiale** : HAUTE — **FAIT 19/04/2026 (S19)**.
TOTP activé dans HA : Profil utilisateur → Modules d'authentification multifacteur → TOTP. Secret base32 + photo QR sauvegardés dans coffre Mickael (HA n'a pas de codes de secours natifs).

#### EN COURS — Content-Security-Policy (CSP)

**Sévérité** : MOYENNE — **Phase 1 FAIT (S20) : mode report-only actif**.
Règle Cloudflare Transform Response Header `CSP-Report-Only-HA` déployée sur `ha.might.ovh`. Politique permissive de démarrage.

- **Phase 2** : collecte 1–2 semaines (Mickael navigue normalement, violations visibles F12 Console)
- **Phase 3** : basculer sur `Content-Security-Policy` (actif)

#### AJOURNÉE — Compte MightTab accessible à distance

**Sévérité** : MOYENNE — **Choix assumé S21**.
Aujourd'hui la tablette se connecte avec le compte admin principal de Mickael (owner HA). Risque accepté : si la tablette est volée ou manipulée, accès admin total à HA. Mitigation implicite : la tablette reste au domicile.

**À rediscuter plus tard** quand la config HA sera stabilisée. Fix cible : compte `MightTab` non-admin + TOTP + groupe `tablette_mobile` avec exposition limitée (climate, light, switch, media_player uniquement).

#### À FAIRE — Permissions-Policy (tâche #16)

**Sévérité** : BASSE — **À faire**.
Aucune restriction des APIs navigateur (géolocation, caméra, microphone). À ajouter via Cloudflare Transform Response Headers. Priorité BASSE car les APIs ne sont pas exposées par HA à des tiers externes.

#### À FAIRE — SSH aux clés (tâche #14)

**Sévérité** : BASSE — **À faire**.
Port SSH 22 local uniquement (non exposé internet), mais authentification par mot de passe. Passer aux clés SSH (ed25519) pour éliminer le risque brute force local. Priorité BASSE : attaque locale uniquement.

### Données sensibles accessibles via session authentifiée

Une session authentifiée (cookie ou token) donne accès à l'ensemble des données et actions ci-dessous. Le risque est qu'un vol de session (via XSS, phishing, ou accès physique au navigateur) donne un contrôle total sur l'installation domotique.

> **La MFA TOTP (S19) réduit fortement ce risque à l'étape d'authentification.**

#### Données personnelles exposées

| Donnée                    | Détail                              | Risque                    |
|---------------------------|-------------------------------------|---------------------------|
| Adresse postale           | Via capteur `geocoded_location`     | Localisation du domicile  |
| Coordonnées GPS maison    | Latitude / Longitude exactes        | Localisation du domicile  |
| Position GPS temps réel   | iPhone + tablette (device_tracker)  | Suivi des déplacements    |
| Réseau Wi-Fi              | SSID + BSSID de la Livebox          | Identification du réseau  |
| Caméras intérieures       | Chambre, cuisine (fixe + PTZ)       | Vie privée                |
| Appareils connectés       | TV, EcoFlow, téléphones…            | Inventaire du domicile    |
| Présence au domicile      | `home` / `not_home` en temps réel   | Cambriolage facilité      |

#### Actions exécutables à distance

La session dispose des fonctions `callService`, `callWS` et `callApi`, ce qui permet d'exécuter n'importe quelle action : allumer/éteindre lumières et interrupteurs, prendre photos/vidéos caméras, piloter PTZ, exécuter scripts, activer/désactiver automatisations, couper Wi-Fi (switch Livebox), modifier interface Lovelace, accéder à la config complète de HA.

#### Utilisateurs du système

| Utilisateur              | Propriétaire | Actif | Système | Local only        |
|--------------------------|--------------|-------|---------|-------------------|
| Mickael                  | Oui          | Oui   | Non     | Non (MFA active)  |
| MightTab                 | Non          | Oui   | Non     | Non (ajourné #9)  |
| mqtt                     | Non          | Oui   | Non     | Oui               |
| Home Assistant Content   | Non          | Oui   | Oui     | Non               |
| Supervisor               | Non          | Oui   | Oui     | Non               |

---

## Partie 2 — TODO consolidée (snapshot S33, 23/04/2026)

Liste des tâches à traiter, classées par priorité. Source complète : `TASKS.md` à la racine du projet.

### Priorité HAUTE (reportées)

| #  | Tâche                                                       | Source                 |
|----|-------------------------------------------------------------|------------------------|
| 4  | Miniature dernière photo (cellule caméra) — sans cache      | Historique session 1   |
| 5  | Cellule vidéo cliquable — ouvre dernière vidéo enregistrée  | Historique session 1   |

### Priorité MOYENNE

| #  | Tâche                                                              | Statut                 |
|----|--------------------------------------------------------------------|------------------------|
| 6  | Menu Frigate dédié (buffer 60s, clips à la demande)                | À faire                |
| 7  | Créer preset Fav 5 via interface web caméra Dahua                  | À faire                |
| 17 | Valider procédure débannissement IP (contexte non-PC)              | Testé S10 partiel      |
| 19 | Sous-domaine CF Tunnel `admin.might.ovh` pour `/hassio/*`          | À faire                |
| 22 | Documenter raccourcis clavier HA (skill `ha-shortcuts`)            | À faire                |
| 40 | Mode Réactif Phase 2 (4 événements signalement)                    | À faire (post #39)     |
| 44 | Vérifier Cowork autostart Windows au prochain reboot               | À vérifier             |
| 46 | Refonte skill `redaction-email` post-Gmail MCP                     | À faire                |
| 48 | MCP Outlook pour might@live.fr                                     | À faire (audit sécu)   |
| 49 | Audit transverse Brave → MCP (tokens / vitesse)                    | À faire                |
| 50 | Actions restantes audit dashboard HA (4a–4c / 5a–5c / 6 / 7 / 8)   | À faire                |
| 52 | Tri multi-boîtes auto 04h15 (4 boîtes)                             | À faire session dédiée |

### Priorité BASSE

| #  | Tâche                                                            | Statut           |
|----|------------------------------------------------------------------|------------------|
| 11 | Lumières automatiques le soir + bouton on/off                    | À faire          |
| 12 | Intégration Claude cerveau assistant vocal                       | À faire          |
| 13 | Corriger ampoules cuisine Inconnu (piles IR)                     | À faire          |
| 14 | Améliorer SSH : passer aux clés SSH (port 22 local)              | À faire          |
| 15 | Boutons : Mode nuit, Mode cinéma, Mode absence                   | À faire          |
| 16 | Ajouter Permissions-Policy via Cloudflare                        | À faire          |
| 34 | Skill `ha-logs-archive` (design à valider)                       | À concevoir      |
| 35 | Fonction Vie perso V1                                            | À lancer session dédiée |
| 47 | Macros clavier G915 / G502 / Tartarus V2                         | À faire          |

### Priorité BLOQUÉE (prérequis matériel)

| #  | Tâche                                                            | Statut                 |
|----|------------------------------------------------------------------|------------------------|
| 41 | Migration HA Pi → mini-PC Proxmox VE                             | À planifier (achat PC) |
| 42 | Mode Réactif Phase 3 : update auto snapshot + rollback           | Dépend de #41          |

---

## Tâches faites récentes

| Tâche                                                                   | Date / Session         |
|-------------------------------------------------------------------------|------------------------|
| **Tâche #61b — Décongestion `TASKS.md` + skill `decongestion-fichiers-vivants` (politique récurrente)** (-46 % poids, ~14K tokens/tour libérés, archive `TASKS_archive_2026-Q2.md`, seuils Vert/Jaune/Orange/Rouge) | **25/04/2026 (S52)**   |
| **Tâche #61 — Décongestion `CLAUDE.md` + `METRIQUES.md`** (-76,5 % poids combiné, ~42K tokens/tour libérés) | **25/04/2026 (S51)**   |
| Création dossier racine `Runtime/` pour services permanents             | 23/04/2026 (S33)       |
| Déplacement Gmail-MCP-Server `Projets/` → `Runtime/`                    | 23/04/2026 (S33)       |
| Intégration Macros_Clavier + Vie_Perso dans `Ressources/Competences/`   | 23/04/2026 (S33)       |
| Bascule `check-jarvis-alert` 100% CLI (Task Scheduler 04h00)            | 23/04/2026 (S31)       |
| Bascule `rapport-journalier-reactif` 100% CLI (Task Scheduler 23h30)    | 23/04/2026 (S32)       |
| Gmail MCP custom Phase 5 FAIT — tri Gmail auto 05h00                    | 22/04/2026 (S27)       |
| Audit dashboard HA + refonte aires / étages (2 floors, 7 aires)         | 22/04/2026 (S30)       |
| Mode Réactif Phase 1 FAIT (pipeline HA → Gmail → Jarvis)                | 21/04/2026 (S24)       |
| Migration MCP HA : suppression `mcp_server` core                        | 20/04/2026 (S19)       |
| HSTS Cloudflare + MFA TOTP actifs (2 HAUTES fermées)                    | 19/04/2026 (S19)       |

---

*Document consolidé généré par Jarvis — à relire en début de chaque session pour prioriser le travail. Régénéré en fin de session si nouvelles tâches ou audits.*

*Jarvis_Audits_Todo.md — Version 2.1 — 25 avril 2026 (entrée #61 FAIT S51 ajoutée ; reste = snapshot S33, audit complet S34→S51 à faire en session dédiée si Mickael repart en mode chat fallback Claude.ai)*
