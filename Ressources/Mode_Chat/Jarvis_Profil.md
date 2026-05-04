---
title: Jarvis — Profil & Configuration
version: 8
last_update: 2026-05-01 (S82)
owner: Mickael Rubino (Seremange-Erzange, 57)
scope: Document permanent du projet — relu automatiquement à chaque nouvelle session
---

# Jarvis — Profil & Configuration

Document de référence — Projet PERSO Home Assistant. Version 8 — 1 mai 2026 (S82).

---

## 1. Identité & profil

### Profil utilisateur

| Champ          | Valeur                                                          |
|----------------|-----------------------------------------------------------------|
| Nom            | Mickael Rubino — Seremange-Erzange (57)                         |
| Niveau IA      | Utilisateur avancé écosystème Claude (Cowork desktop + Claude Code CLI) |
| Système        | Windows 11 — PC allumé 24h/24 (Cowork en tâche de fond)         |
| Abonnement     | Claude Max (137 EUR/mois) — `claude -p` headless inclus         |
| Profil tech    | Pas développeur, sait faire du petit code occasionnel           |
| Domotique      | Home Assistant — plusieurs marques et modèles                   |
| Marque caméras | Dahua (app DMSS sur iPhone)                                     |
| GPU            | RTX 3090 (Hermès Agent local depuis S47)                        |

### Identité de l'assistant

| Champ              | Valeur                                                       |
|--------------------|--------------------------------------------------------------|
| Nom                | Jarvis                                                       |
| Rôle principal     | Assistant domotique privé — Home Assistant + gestion emails  |
| Personnalité / ton | Patient, pédagogique, technicien domotique de confiance      |
| Langue             | Français — toujours                                          |

---

## 2. Setup technique

| Élément              | Statut / Valeur                                              |
|----------------------|--------------------------------------------------------------|
| Système              | Windows 11 — PC allumé 24h/24                                |
| Abonnement           | Claude Max (137 EUR/mois)                                    |
| Navigateur           | Brave (Chromium) — navigateur principal                      |
| Extension Claude     | Claude in Chrome — installée dans Brave                      |
| Pilotage mobile      | App Claude iPhone (Dispatch + Claude Code Remote)            |
| Tab ID Brave         | Change à chaque session — toujours vérifier en début         |
| Env dev PC           | Node LTS, Git 2.53, Claude Code 2.1.114, Python 3.14.4       |
| Claude Code Remote   | Actif (reprise session PC depuis iPhone, S19)                |
| Hermès Agent local   | RTX 3090, modèles Ollama (qwen3:32b, etc.) — installé S47    |
| Repo GitHub          | `mightIA/hermes-agent-rtx3090-cookbook` (public, MIT, S64)   |

---

## 3. Accès réseau Home Assistant

| Paramètre               | Valeur                                                         |
|-------------------------|----------------------------------------------------------------|
| URL locale (priorité)   | `http://192.168.1.11:2096/` — toujours privilégier             |
| URL distante (fallback) | `https://ha.might.ovh/` — Cloudflare + OVH                     |
| Add-on `ha-mcp`         | Port 9583 local, exposé public via Cloudflare Tunnel           |
| MCP URL Cowork/CLI      | `https://mcp.might.ovh/private_<secret>` (rotation S70)        |
| `mcp_server` core HA    | **Supprimé S19** (bug DCR, remplacé par add-on `ha-mcp`)       |
| Port SSH                | 22 — local uniquement, non exposé internet                     |
| Auth SSH                | Mot de passe — à améliorer avec clés SSH (T#14)                |
| Caméras                 | ONVIF — app mobile DMSS                                        |

---

## 4. Structure du projet (architecture S70-S82)

Architecture fichiers plats (`.md`) depuis migration 19/04/2026. Évolutions majeures S33 → S82 :

- **S33** : `Runtime/` racine pour services permanents (vs `Projets/` initiatives temporaires).
- **S35** : MCP `pdf-toolkit` ajouté (21 outils, 14 invites).
- **S47** : Hermès Agent local installé (RTX 3090, modèles Ollama).
- **S70** : rotation secret_path MCP HA → `https://mcp.might.ovh/private_<secret>`.
- **S71** : 4 skills lifecycle tâches créées (`add-task`, `close-task`, `regen-tasks-index` + index séparé).
- **S72** : hook PreToolUse `.claude/hooks/check-secrets.sh` (renfort Règle 0).
- **S73** : 3 sub-agents `.claude/agents/` créés (CLI-only confirmé S75/76).
- **S75** : refonte CLAUDE.md v4.0 (option C, footer externalisé, `@imports` non supportés Cowork).
- **S81** : ADR-A004 vault Obsidian = connaissance pure (`Wiki/` 3 dossiers top-level).

| Chemin                              | Description                                                     |
|-------------------------------------|-----------------------------------------------------------------|
| `CLAUDE.md` (racine, v4.0 S75)      | Instructions principales Jarvis — lues auto au démarrage        |
| `CONTEXTE.md` (racine, v2.0 S82)    | Profil + setup + config HA consolidée                           |
| `TASKS.md` (racine)                 | Index 38 ouvertes + 44 archivées Q2 (auto-généré)               |
| `tasks/task_NNN.md`                 | Détail de chaque tâche (frontmatter YAML)                       |
| `METRIQUES.md` (racine)             | Compteurs sessions, tris email, bans IP                         |
| `memory/MEMORY.md`                  | Index mémoire persistante locale                                |
| `memory/historique/*.md`            | Historique des sessions (une par session)                       |
| `memory/historique_reactif/*.md`    | Logs Mode Réactif (1 fichier/jour)                              |
| `memory/SKILLS_INDEX.md`            | Index détaillé des 32 skills                                    |
| `memory/reference_*.md`             | Références techniques (sub-agents, hooks, MCP, vault…)          |
| `Ressources/Mode_Chat/`             | 3 `.md` fallback Claude.ai + `Description.md`                   |
| `Ressources/Cowork/Instructions.md` | Bloc à coller dans Cowork Desktop                               |
| `Ressources/Competences/`           | Home_Assistant, Gestion_Emails, Mode_Reactif, Gmail_MCP_Custom… |
| `Ressources/Protocoles/`            | Gmail (v3.0), Outlook, IP_Bans, Backup_Jarvis                   |
| `Ressources/Data/`                  | `gmail_patterns/` + `outlook_patterns/` (JSON auto-apprentissage) |
| `.claude/skills/` (32 skills)       | Skills Jarvis — déclenchement auto par description              |
| `.claude/agents/` (3 sub-agents)    | **CLI-only** (audit-securite-ha, redacteur-email, debannissement-ip) |
| `.claude/hooks/check-secrets.sh`    | Hook PreToolUse — renfort technique Règle 0 (S72)               |
| `.claude/settings.json`             | Configuration des hooks                                         |
| `.claude/settings.local.json`       | Allowlist / denylist mode CLI headless                          |
| `.mcp.json` (racine)                | Connecteurs MCP (gmail, ha-mcp, gmail-mcp-local, pdf-toolkit)   |
| `Runtime/Gmail-MCP-Server/`         | MCP stdio permanent (135 MB, SHA `a890d19`, S33)                |
| `scripts/*.ps1` + `*.xml`           | Launchers PowerShell + XML Task Scheduler Windows               |
| `rapports/journalier/`              | PDFs quotidiens Mode Réactif (23h30)                            |
| `Projets/`                          | Initiatives temporaires (Cookbook_Hermes_RTX3090, Hardware_Upgrade…) |
| `Wiki/`                             | Vault Obsidian — **connaissance pure** (ADR-A004 S81) — 3 dossiers : `00_Index/`, `10_Domaines/`, `30_References/` |
| `Archives/`                         | Anciens fichiers et backups pre-migration (lecture seule)       |

---

## 5. Add-ons Home Assistant installés

| Add-on               | Usage                                                       |
|----------------------|-------------------------------------------------------------|
| ESPHome              | Transmetteurs IR, climatiseur                               |
| Zigbee2MQTT          | Ampoules, prises, capteurs                                  |
| EcoFlow River 2 Pro  | Batterie portable connectée                                 |
| Frigate              | Vidéosurveillance (menu dédié à créer — T#6)                |
| HACS                 | Intégrations communautaires                                 |
| Music Assistant      | Gestion musique                                             |
| AdGuard Home         | Volontairement coupé (test utilité vs Cloudflare)           |
| Studio Code Server   | Éditeur de code dans HA                                     |
| Terminal & SSH       | Terminal web + SSH port 22                                  |
| File Editor          | Éditeur de fichiers dans HA                                 |
| Cloudflared          | Tunnel CF (`ha.might.ovh` + `mcp.might.ovh`)                |
| `ha-mcp`             | MCP Server HA (FastMCP + DCR), port 9583 — remplace core    |

### 5.1 Intégrations HACS notables

| Intégration                     | Usage                                                |
|---------------------------------|------------------------------------------------------|
| `dyson_local` (shenxn/ha-dyson) | Contrôle MQTT local du Dyson Purifier                |
| Frisquet Connect (TheGui01)     | Pilotage chaudière Frisquet v2.5.4                   |
| Browser Mod (thomasloven)       | Contrôle navigateur, badges, popups v2.10.2          |
| EcoFlowCloud                    | Batterie EcoFlow River 2 Pro v1.4.1                  |
| iCloud3                         | Suivi localisation iPhone v3.4.3                     |
| `custom:button-card`            | Boutons personnalisés Lovelace                       |
| `google_mail` (natif)           | Intégration Gmail (`notify.might57290_gmail_com`)    |

---

## 6. Caméras Dahua

| Caméra       | Entité HA                                               | MAC               |
|--------------|---------------------------------------------------------|-------------------|
| Chambre      | `camera.chambre_mediaprofile_channel1_mainstream`       | c4:aa:c4:b6:68:40 |
| Cuisine fixe | `camera.cuisine_profile100`                             | f8:ce:07:b5:5b:f6 |
| Cuisine PTZ  | `camera.cuisine_profile000`                             | f8:ce:07:b5:5b:f6 |

- Structure médias : `/media/cameras/{chambre,cuisine_fixe,cuisine_ptz}/{photo,video}/`.
- Scripts : `cam_snapshot_*`, `cam_record_*` (120s), `cam_vider_*`.
- PTZ favoris : Fav 1-4 OK, Fav 5 à créer via interface web caméra (T#7).
- Détails complets dans `Ressources/Competences/Home_Assistant.md` §5.

---

## 7. Dashboard Lovelace (19 onglets — refonte S30)

Refonte S30 (22/04/2026) : 3 vues renommées (Chaudière, Télécommandes, Système), 2 étages créés (RDC + Haut), 3 aires refaites, 23 entités migrées. Badges universels sur toutes les vues : Rafraîchir, Page précédente/suivante, Jour, Nuit, Capteurs mouvement.

Vues principales : Home, Lumières, Caméras, Média, Dyson, Chaudière Frisquet, Télécommandes, Système, Réseaux, Impression 3D.

### Architecture des aires

| Étage                                | Aires                                                       |
|--------------------------------------|-------------------------------------------------------------|
| Haut (level 1, `mdi:home-floor-1`)   | Chambre (208 ent.), Couloir Haut (2), Cuisine (87)          |
| RDC (level 0, `mdi:home-floor-g`)    | Atelier (64), Couloir Bas (5), Salle de bain (14), WC (2)   |

---

## 8. Chaudière Frisquet — entités clés

| Entité                                    | Type                                    |
|-------------------------------------------|-----------------------------------------|
| `climate.maison_zone_1_2`                 | Thermostat                              |
| `water_heater.chauffe_eau_maison_2`       | Chauffe-eau (MAX, Eco, Eco Timer, Stop) |
| `sensor.maison_alerte_2`                  | Alertes chaudière                       |
| `sensor.maison_consommation_chauffage_2`  | Conso chauffage cumul (kWh)             |
| `sensor.maison_consommation_eau_chaude_2` | Conso eau chaude cumul (kWh)            |
| `sensor.maison_temperature_zone_1_2`      | Température Zone 1                      |

Presets permanents : `confort_permanent`, `reduit_permanent`, `hors_gel`, `vacances`. En mode Auto, les changements depuis HA = dérogations temporaires (retour planning au prochain cycle).

---

## 9. Gestion automatisée des emails (refondue S27)

Pipeline tri Gmail **100% CLI** via Gmail MCP custom local (`Runtime/Gmail-MCP-Server/`, SHA `a890d19`) déclenché par Windows Task Scheduler. Outlook reste sur workflow Brave (MCP Outlook à étudier — T#48).

| Boîte                  | Outil                                     | Scheduler                              |
|------------------------|-------------------------------------------|----------------------------------------|
| might57290@gmail.com   | Gmail MCP custom stdio (CLI only)         | Task Scheduler Windows 05h00           |
| might@live.fr          | Brave + Claude in Chrome                  | Cowork scheduled 05h + 14h (+ priorités S28) |

### Scores de confiance (Gmail)

| Score   | Action                            | Rapport                  |
|---------|-----------------------------------|--------------------------|
| 100     | Suppression auto (spam évident)   | NON                      |
| 90-99   | Suppression auto                  | OUI (vérification)       |
| 70-89   | Ne pas supprimer                  | OUI (validation Mickael) |
| < 70    | Ne pas supprimer                  | OUI (décision Mickael)   |

Rapport de tri auto-envoyé via service HA `notify.might57290_gmail_com` (`data.target` obligatoire) + filtre Gmail auto-label `Jarvis-RapportTri`.
Auto-apprentissage : `whitelist.json` / `blacklist.json` / `learning_log.json` dans `Ressources/Data/gmail_patterns/` et `outlook_patterns/`.

---

## 10. Mode Réactif Jarvis v1.1 (Phase 1 — 100% CLI S31/S32)

Pipeline de réaction aux événements HA, 100% automatique. Déclenchement :

1. HA → email vers `might57290+jarvis@gmail.com` avec sujet `[JARVIS-ALERT]`.
2. Label Gmail `Jarvis-Alert` auto-appliqué.
3. Task Scheduler Windows **04h00** lance `claude -p` headless.
4. Jarvis applique le niveau d'autonomie HA → action / propose / signaler.
5. Archivage label `Jarvis-Alert/Traité` + log `memory/historique_reactif/AAAA-MM-JJ.md`.

| Composant                           | Cadence          | Statut                                               |
|-------------------------------------|------------------|------------------------------------------------------|
| `check-jarvis-alert` (CLI)          | 04h00 quotidien  | FAIT S31 (bascule post boucle infinie Cowork)        |
| `rapport-journalier-reactif` (CLI)  | 23h30 quotidien  | FAIT S32 (mail via `notify` HA, PDF local)           |
| Phase 2 (signalement non-safe)      | —                | À faire (T#40)                                       |
| Phase 3 (update HA + snapshot)      | —                | Bloquée par Proxmox (T#41/T#42)                      |

---

## 11. Skills, sub-agents et hooks (architecture S70-S82)

### 11.1 Skills (32 actives)

Les skills sont stockées dans `.claude/skills/<nom>/SKILL.md` et déclenchées automatiquement par Cowork / Claude Code selon leur description. Index détaillé : `memory/SKILLS_INDEX.md`.

Skills incontournables : `tri-email-gmail`, `tri-email-outlook`, `tri-email-outlook-priorites`, `ha-status`, `ha-scripts`, `chaudiere-frisquet`, `cameras-dahua`, `dyson-purifier`, `debannissement-ip`, `redaction-email`, `yaml-automation`, `lovelace-edit`, `decongestion-fichiers-vivants`, `regen-tasks-index`, `add-task`, `close-task`, `git-github-push`, `hermes-agent`.

### 11.2 Sub-agents (3 — CLI uniquement)

Les sub-agents sont stockés dans `.claude/agents/<nom>.md` et invoqués automatiquement par **Claude Code CLI**. **Cowork desktop ne charge PAS les sub-agents custom** (testé S75/S76). Détail : `memory/reference_sub_agents_p3.md`.

| Sub-agent           | Modèle | Skill associée       | Usage                                            |
|---------------------|--------|----------------------|--------------------------------------------------|
| `audit-securite-ha` | opus   | (aucune)             | Audit posture sécurité HA en lecture seule       |
| `redacteur-email`   | sonnet | `redaction-email`    | Brouillons Gmail à partir d'un brief             |
| `debannissement-ip` | sonnet | `debannissement-ip`  | Diagnostic + résolution ban IP avec confirmation |

Côté Cowork desktop, utiliser les sub-agents builtin (`Explore`, `Plan`, `general-purpose`) — ils ne sont pas spécialisés Jarvis mais peuvent invoquer les MCP du parent.

### 11.3 Hook PreToolUse `check-secrets.sh` (S72)

Renfort technique de la Règle 0 — bloque (exit 2) tout accès à des fichiers sensibles ou des commandes contenant des secrets en clair. 7 règles, 14/14 tests OK. Configuration dans `.claude/settings.json`. Détail : `memory/reference_hooks_securite_p2.md`.

### 11.4 Connecteurs MCP

| Connecteur                | Mode      | Cowork | CLI | Usage                                  |
|---------------------------|-----------|--------|-----|----------------------------------------|
| `home-assistant` (ha-mcp) | HTTP/SSE  | OUI    | OUI | URL publique avec secret (rotation S70)|
| `gmail` (Anthropic)       | HTTP/SSE  | OUI    | OUI | Lecture + drafts + labels uniquement   |
| `gmail-mcp-local`         | stdio     | NON    | OUI | Écriture Gmail (modify/batch/filter)   |
| `pdf-toolkit`             | (mixte)   | OUI    | OUI | 21 outils + 14 invites (S35)           |
| Claude in Chrome          | inclus    | OUI    | NON | Brave automation (Outlook web, etc.)   |

Détail : `memory/reference_mcp_connecteurs.md`.

---

## 12. Points importants à retenir

| Sujet              | Information                                                         |
|--------------------|---------------------------------------------------------------------|
| Règle 0            | Données sensibles — arrêt + accord explicite (sauf `ip_bans.yaml`). Renfort hook `check-secrets.sh` (S72). |
| Mode par défaut    | PC/Cowork — réponses détaillées (sauf signal iPhone explicite)      |
| Titre conv FR      | Proposer en début de session (S53 — 5-10 mots, `<Domaine> — <Action>`) |
| Label app blocs    | Étiqueter Ubuntu / WSL2 / PowerShell / HA UI / Brave / etc. (S48)   |
| Pas-à-pas          | UNE étape à la fois pour manipulations Mickael (S53)                |
| WebSocket          | Toujours `hass.callWS` pour lire/écrire config Lovelace             |
| Reload scripts     | Paramètres → Outils dev → YAML → Scripts                            |
| Reload config      | Recharger Configuration entière après modif `configuration.yaml`    |
| Tab ID Brave       | Change à chaque session — toujours vérifier en début                |
| Caméras            | Marque Dahua, app DMSS, protocole ONVIF                             |
| Ban IP             | Permanent — skill `debannissement-ip` + `Ressources/Protocoles/IP_Bans.md` |
| MFA TOTP           | Actif (S19) + secret base32 sauvegardé coffre Mickael               |
| HSTS Cloudflare    | Actif (S19) — max-age 6 mois, TLS min 1.2                           |
| CSP Cloudflare     | Mode report-only actif (S20) — phase 2 collecte                     |
| MCP URL publique   | `https://mcp.might.ovh/private_<secret>` (rotation S70)             |
| Cowork + stdio MCP | **INCOMPATIBLE** — pattern brain (Cowork) + hands (CLI) obligatoire |
| Cowork + sub-agents| **INCOMPATIBLE** — sub-agents `.claude/agents/` = CLI uniquement    |
| Cowork + @imports  | **NON SUPPORTÉS** (test S75 LIBELLULE-3742 concluant)               |
| Envoi mail CLI     | `ha_call_service notify.might57290_gmail_com` (`data.target` obligatoire) |
| Plan Max + CLI     | `claude -p` headless inclus — planning heures creuses recommandé    |
| Vault Obsidian     | `Wiki/` = connaissance pure uniquement (ADR-A004 S81)               |
| Confidentialité    | Données (IP, tokens, config) strictement confidentielles            |

---

## 13. Objectifs domotique restants

Liste détaillée dans `TASKS.md` + `Jarvis_Audits_Todo.md`. Résumé par priorité :

| Priorité | Tâche                                                          | Statut          |
|----------|----------------------------------------------------------------|-----------------|
| HAUTE    | Miniature dernière photo caméra (problème cache)               | Reportée T#4    |
| HAUTE    | Cellule vidéo cliquable (dernière vidéo enregistrée)           | Reportée T#5    |
| MOYENNE  | Menu Frigate dédié (buffer 60s, clips à la demande)            | À faire T#6     |
| MOYENNE  | Créer preset Fav 5 via interface web caméra Dahua              | À faire T#7     |
| MOYENNE  | Sous-domaine Cloudflare Tunnel `admin.might.ovh`               | À faire T#19    |
| MOYENNE  | Tri multi-boîtes auto 04h15                                    | À faire T#52    |
| MOYENNE  | Voix Jarvis via HA TTS                                         | À faire T#53    |
| MOYENNE  | Profils réutilisables MCP `pdf-toolkit`                        | À faire T#54    |
| MOYENNE  | Workflow `fill_pdf` complet validation                         | À faire T#57    |
| MOYENNE  | Compléter hub Domotique vault (6 équipements TODO)             | En cours T#80   |
| BASSE    | Lumières automatiques le soir + bouton on/off                  | À faire T#11    |
| BASSE    | Intégration Claude cerveau assistant vocal                     | À faire T#12    |
| BASSE    | Améliorer SSH (clés ed25519)                                   | À faire T#14    |
| BASSE    | Permissions-Policy via Cloudflare                              | À faire T#16    |
| BASSE    | Skill `ha-logs-archive`                                        | À concevoir T#34|
| BASSE    | Fonction Vie perso V1                                          | À lancer T#35   |
| BASSE    | MCP Outlook pour might@live.fr                                 | À faire T#48    |
| BASSE    | Macros clavier G915 / G502 / Tartarus V2                       | À faire T#47    |
| BLOQUÉE  | Mini-PC Proxmox (prérequis Mode Réactif Phase 3)               | À planifier T#41|

---

*Jarvis_Profil.md — Version 8 — 1 mai 2026 (S82 — refresh post-architecture S70→S81 : ha-mcp via mcp.might.ovh, 32 skills, 3 sub-agents CLI-only, hooks check-secrets, Hermès Agent, vault Obsidian connaissance pure ADR-A004, repo GitHub mightIA, règles S53 titre+label+pas-à-pas).*
