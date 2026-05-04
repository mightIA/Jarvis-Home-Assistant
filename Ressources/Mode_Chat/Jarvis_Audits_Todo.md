---
title: Jarvis — Audits & TODO
version: 4
last_update: 2026-05-02 (S87)
scope: Snapshot léger — Audit sécurité + Tâches actives (30 ouvertes, 57 archivées Q2)
owner: Mickael Rubino
---

# Jarvis — Audits & TODO

Document consolidé — audit sécurité + liste des tâches à faire. Version 4 — 2 mai 2026 (S87).

> Snapshot léger : liste les **30 tâches ouvertes** par priorité. Les 57 tâches archivées Q2 ne sont pas détaillées ici (voir `tasks/archive_2026-Q2/` côté Cowork). Source de vérité : `TASKS.md` (auto-généré par skill `regen-tasks-index`).

---

## Partie 1 — Audit de sécurité (statut S82)

Audit de la connexion distante à Home Assistant via `ha.might.ovh`. Infrastructure globalement bien sécurisée grâce à Cloudflare (proxy inverse, DDoS, SSL auto). **2 failles HAUTES fermées (MFA + HSTS, S19)**, CSP en mode report-only (S20), MightTab ajourné (S21), reste 2 BASSES.

### Fiche de l'audit

| Champ              | Valeur                                                    |
|--------------------|-----------------------------------------------------------|
| Cible              | `https://ha.might.ovh/`                                   |
| Date audit initial | 18 avril 2026                                             |
| MAJ statut         | 1 mai 2026 (S82)                                          |
| Version HA         | 2026.4.3+                                                 |
| Réalisé par        | Jarvis (assistant HA de Mickael)                          |
| Méthode            | Analyse via navigateur authentifié (Claude in Chrome)     |

### Résumé exécutif (S82)

| Catégorie             | Statut          | Détail                                             |
|-----------------------|-----------------|----------------------------------------------------|
| Chiffrement HTTPS     | OK              | Cloudflare actif (CDG / Paris)                     |
| Protection API        | OK              | Endpoints en 403 sans auth                         |
| Anti-clickjacking     | OK              | `X-Frame-Options: SAMEORIGIN`                      |
| Protection MIME       | OK              | `X-Content-Type-Options: nosniff`                  |
| CORS                  | OK              | Pas d'origine externe autorisée                    |
| HSTS                  | **FAIT S19**    | max-age 6 mois, TLS min 1.2                        |
| MFA / 2FA (TOTP)      | **FAIT S19**    | Actif compte Mickael + secret base32 coffre        |
| CSP                   | **EN COURS S20**| Mode report-only actif — phase 2 collecte          |
| Hook check-secrets    | **FAIT S72**    | Renfort technique Règle 0 — 7 règles, 14/14 tests OK |
| MightTab local_only   | **AJOURNÉ S21** | Choix assumé tant que tablette au domicile         |
| Permissions-Policy    | À faire         | Tâche T#16 — priorité BASSE                        |
| SSH aux clés (local)  | À faire         | Tâche T#14 — priorité BASSE                        |

### Points positifs

**Cloudflare actif** (datacenter CDG / Paris) : protection DDoS, masquage IP réelle, certificat SSL automatique, filtrage requêtes malveillantes. Header `server: cloudflare` confirmé.

**API protégée** : tous les endpoints testés retournent 403 Forbidden sans authentification valide (`/api/`, `/api/discovery_info`, `/auth/providers`, `/api/onboarding`). Un attaquant non authentifié ne peut pas découvrir la version HA, les providers, ni accéder à l'API.

**MCP Server HA** : le `mcp_server` core HA a été supprimé S19 (bug DCR RFC 7591). Remplacé par l'add-on `ha-mcp` (FastMCP + DCR) exposé via Cloudflare Tunnel sur `https://mcp.might.ovh/private_<secret>` (secret path auto-généré, rotation S70, bypass CF Access). Auth OAuth DCR compatible Claude.ai + Cowork.

**Hook PreToolUse `check-secrets.sh`** (S72) : renfort technique non bypassable par injection de prompt. Bloque (exit 2) tout accès aux fichiers/commandes contenant des secrets (credentials Gmail OAuth, `.env*`, `secrets.yaml`, clés SSH privées, `settings.local.json`, `.mcp.json` en Edit/Write, patterns API keys OpenRouter/Google/ha-mcp/AWS/GitHub).

### Vulnérabilités résiduelles

#### À FAIRE — Permissions-Policy (T#16)

**Sévérité** : BASSE — **À faire**.
Aucune restriction des APIs navigateur (géolocation, caméra, microphone). À ajouter via Cloudflare Transform Response Headers. Priorité BASSE car les APIs ne sont pas exposées par HA à des tiers externes.

#### À FAIRE — SSH aux clés (T#14)

**Sévérité** : BASSE — **À faire**.
Port SSH 22 local uniquement (non exposé internet), mais authentification par mot de passe. Passer aux clés SSH (ed25519) pour éliminer le risque brute force local. Priorité BASSE : attaque locale uniquement.

#### AJOURNÉE — Compte MightTab accessible à distance (T#9)

**Sévérité** : MOYENNE — **Choix assumé S21**.
La tablette se connecte avec le compte admin principal de Mickael (owner HA). Risque accepté : si la tablette est volée ou manipulée, accès admin total à HA. Mitigation implicite : la tablette reste au domicile.

À rediscuter plus tard. Fix cible : compte `MightTab` non-admin + TOTP + groupe `tablette_mobile` avec exposition limitée (climate, light, switch, media_player uniquement).

### Données sensibles accessibles via session authentifiée

Une session authentifiée donne accès à : adresse postale + GPS exact, position GPS temps réel iPhone/tablette, SSID/BSSID Wi-Fi, caméras intérieures (chambre, cuisine), inventaire des appareils connectés, présence au domicile en temps réel.

> **MFA TOTP (S19) réduit fortement ce risque à l'étape d'authentification.**

La session dispose des fonctions `callService`, `callWS` et `callApi` — exécution de toute action (lumières, caméras, scripts, automations, Wi-Fi, Lovelace, config complète HA).

### Utilisateurs du système

| Utilisateur              | Propriétaire | Actif | Système | Local only        |
|--------------------------|--------------|-------|---------|-------------------|
| Mickael                  | Oui          | Oui   | Non     | Non (MFA active)  |
| MightTab                 | Non          | Oui   | Non     | Non (ajourné T#9) |
| mqtt                     | Non          | Oui   | Non     | Oui               |
| Home Assistant Content   | Non          | Oui   | Oui     | Non               |
| Supervisor               | Non          | Oui   | Oui     | Non               |

---

## Partie 2 — TODO snapshot léger (S82, 01/05/2026)

### Priorité HAUTE (P1) — reportées

| #     | Tâche                                                       | Statut       |
|-------|-------------------------------------------------------------|--------------|
| T#4   | Miniature dernière photo (cellule caméra) — sans cache      | deferred     |
| T#5   | Cellule vidéo cliquable — ouvre dernière vidéo enregistrée  | deferred     |

### Priorité MOYENNE (P2)

| #     | Tâche                                                                      | Statut    |
|-------|----------------------------------------------------------------------------|-----------|
| T#6   | Menu Frigate dédié (buffer 60s, clips à la demande)                        | open      |
| T#7   | Créer preset Fav 5 via interface web caméra Dahua                          | open      |
| T#8   | Run now sur les 2 tâches emails — pré-autoriser permissions                | open      |
| T#9   | Créer compte `MightTab` dédié (non-admin, 2FA, groupe `tablette_mobile`)   | open      |
| T#17  | Valider la procédure de débannissement IP depuis contexte non-PC           | open      |
| T#18  | Méthode tri emails par vagues (sélection par lots avec validation)         | testing   |
| T#19  | Mettre en place un sous-domaine Cloudflare Tunnel (`admin.might.ovh`)      | open      |
| T#22  | Documenter les raccourcis clavier HA dans `Ressources/`                    | open      |
| T#24  | Calibrer `LIMITE_OBSERVEE` dans `guidage-photo-etape/SKILL.md`             | pending   |
| T#49  | Remplacer les workflows navigateur Brave par MCP natifs                    | open      |
| T#52  | Tri automatique à 04h15 (15 min après `Jarvis-CheckAlert`)                 | open      |
| T#53  | Vraie voix à Jarvis via HA TTS                                             | open      |
| T#54  | Profils réutilisables du MCP `pdf-toolkit` (workflow factures)             | open      |
| T#55  | Tour complet des 4 toggles section 'Capacités' Cowork Desktop              | open      |
| T#56  | Revue guidée des paramètres avancés Cowork Desktop                         | open      |
| T#57  | Valider le flux complet `fill_pdf` du MCP `pdf-toolkit`                    | open      |
| T#60  | Endpoint `https://mcp.might.ovh/...` — tester comportement avec sub-paths  | open      |
| T#65  | Régénération secret_path en `private_Q4...` à valider                      | pending   |
| T#66  | Liste consolidée d'améliorations identifiées via recherche web S53         | open      |
| T#74  | Framework de génération de prompts optimisés pour 3 IA d'images            | open      |

### Priorité BASSE (P3)

| #     | Tâche                                                                     | Statut       |
|-------|---------------------------------------------------------------------------|--------------|
| T#80  | Compléter hub Domotique vault avec 6 équipements TODO                     | in_progress  |
| T#11  | Lumières automatiques le soir + bouton on/off                             | open         |
| T#12  | Intégration de Claude comme cerveau de l'assistant vocal                  | open         |
| T#13  | Corriger ampoules cuisine 'Inconnu' (piles transmetteurs IR)              | open         |
| T#14  | Améliorer SSH (passer aux clés SSH ed25519)                               | open         |
| T#15  | Boutons utiles : Mode nuit, Mode cinéma, Mode absence                     | open         |
| T#16  | Ajouter Permissions-Policy via Cloudflare                                 | open         |
| T#34  | Skill `ha-logs-archive` (design à valider)                                | open         |
| T#35  | Lancer la fonction « Vie perso » V1                                       | open         |
| T#40  | Implémenter les 4 événements de signalement Mode Réactif Phase 2          | open         |
| T#41  | Migration HA du Raspberry Pi vers mini-PC Proxmox                         | pending      |
| T#42  | Update HA auto avec snapshot + rollback via API Proxmox                   | open         |
| T#44  | Vérifier au prochain reboot que Cowork démarre bien automatiquement       | pending      |
| T#47  | Assigner les phrases Jarvis récurrentes aux 3 périphériques Logitech G    | open         |
| T#48  | Rechercher et installer un MCP pour la boîte Outlook (Microsoft Live)     | open         |
| T#59  | Investigation après vérif négative S40                                    | open         |
| T#76  | Re-tester les 4 modèles avec fix `reasoning_content` validé S63           | open         |
| T#77  | Modèle MAISON Nous Research conçu pour Hermès Agent                       | open         |
| T#78  | MEMORY (Cowork)                                                           | open         |
| T#79  | Décisions vault post-audit S72 (lien externe Inventaire, normalisation)   | open         |
| T#85  | Linter type cclint sur CLAUDE.md/TASKS.md (incohérences auto)             | open         |

---

## Partie 3 — Tâches récemment terminées (Q2 2026, sélection)

Sélection des clôtures notables depuis S33 (snapshot complet : `tasks/archive_2026-Q2/` côté Cowork).

| Tâche                                                                              | Session close |
|------------------------------------------------------------------------------------|---------------|
| T#46 — Refonte skill `redaction-email` post-Gmail MCP custom                       | S78 (29/04)   |
| T#82 — Décongestion `METRIQUES.md` lignes 47-52 (mode modéré)                      | S77 (29/04)   |
| T#83 — Tests unitaires sur `rebuild_tasks_index.py` (bug `t fm` latent)            | S77 (29/04)   |
| T#84 — Vérifier puis supprimer `.claude/hooks.json` annoté OBSOLÈTE                | S77 (29/04)   |
| T#81 — Refonte CLAUDE.md vers <100 lignes via `@imports` (P2 audit) — option C     | S75 (28/04)   |
| T#71 — Variable `MISTRAL_API_KEY` dans `~/.bashrc` (consolidation)                 | S70 (27/04)   |
| T#75 — Création repo GitHub public dédié — `mightIA/hermes-agent-rtx3090-cookbook` | S64 (26/04)   |
| T#58 — Étude faisabilité détaillée Hermès Agent sur RTX 3090                       | S69 (27/04)   |
| T#62 — Surveiller la consommation OpenRouter dans Home Assistant                   | S55 (26/04)   |
| T#63 — Fix connecteur 'Jarvis HA' côté Cowork Desktop renvoie `Server error`       | S54 (26/04)   |
| T#64 — qwen3:32b en Hermès v0                                                      | S58 (26/04)   |
| T#61 — Décongestion CLAUDE.md + METRIQUES.md (-76,5 % poids combiné)               | S51 (25/04)   |
| T#43 — Migrer l'envoi d'alertes HA de `notify` vers Mode Réactif                   | S24 (21/04)   |

---

*Document consolidé généré par Jarvis — à relire en début de chaque session pour prioriser le travail. Régénéré en fin de session si nouvelles tâches ou audits.*

*Jarvis_Audits_Todo.md — Version 3 — 1 mai 2026 (S82 — snapshot léger 38 ouvertes / 44 archivées Q2 ; audit sécu post-S72 hook check-secrets ; format `.md` uniquement depuis S33).*
