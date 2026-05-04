---
title: Contexte Jarvis
owner: Mickael Rubino
location: Seremange-Erzange (57)
last_update: 2026-05-01 (S82 — refresh complet post-architecture S70→S81)
version: 2.0
---

# Contexte Jarvis — Etat persistant du setup

## 1. Profil Mickael

| Champ          | Valeur                                                          |
|----------------|-----------------------------------------------------------------|
| Nom            | Mickael Rubino — Seremange-Erzange (57)                         |
| Niveau IA      | Utilisateur avancé écosystème Claude (Cowork desktop + CLI)     |
| Profil tech    | Pas développeur — sait faire du petit code occasionnel          |
| Système        | Windows 11 — PC allumé 24h/24                                   |
| Abonnement     | Claude Max (137 EUR/mois) — `claude -p` headless inclus         |
| Env dev PC     | Node LTS, Git 2.53, Claude Code 2.1.114, Python 3.14.4          |

## 2. Setup technique

| Element             | Statut / Valeur                                              |
|---------------------|--------------------------------------------------------------|
| Cowork              | Installé sur PC Mickael (mode principal)                     |
| iPhone              | App Claude (Dispatch + Claude Code Remote actif S19)         |
| Navigateur          | **Brave** (Chromium) + extension **Claude in Chrome**        |
| Tab ID Brave        | À vérifier en début de session (change à chaque ouverture)   |
| Hermès Agent local  | RTX 3090 — modèles Ollama (qwen3:32b, etc.) — installé S47   |

## 3. Accès réseau Home Assistant

| Paramètre               | Valeur                                                         |
|-------------------------|----------------------------------------------------------------|
| URL locale (priorité 1) | `http://192.168.1.11:2096/`                                    |
| URL distante (fallback) | `https://ha.might.ovh/` (Cloudflare + OVH)                     |
| Add-on `ha-mcp`         | Port 9583 local, exposé public via Cloudflare Tunnel           |
| MCP URL publique        | `https://mcp.might.ovh/private_<secret>` (rotation S70)        |
| `mcp_server` core HA    | **Supprimé S19** (bug DCR RFC 7591) — remplacé par `ha-mcp`    |
| Port SSH                | 22 — local uniquement, non exposé internet                     |
| Auth SSH                | Mot de passe (à améliorer : clés SSH ed25519 — tâche T#14)     |

## 4. Caméras Dahua

| Caméra       | Entité HA                                             | MAC               |
|--------------|-------------------------------------------------------|-------------------|
| Chambre      | `camera.chambre_mediaprofile_channel1_mainstream`     | c4:aa:c4:b6:68:40 |
| Cuisine fixe | `camera.cuisine_profile100`                           | f8:ce:07:b5:5b:f6 |
| Cuisine PTZ  | `camera.cuisine_profile000`                           | f8:ce:07:b5:5b:f6 |

App mobile : DMSS. Protocole : ONVIF.
Structure médias : `/media/cameras/<camera>/photo/` et `/video/`.
Détail des scripts (snapshot, record, vider) dans la skill `cameras-dahua` et
dans `Ressources/Competences/Home_Assistant.md` §5.

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

## 6. Intégrations HACS notables

| Intégration                     | Usage                                                |
|---------------------------------|------------------------------------------------------|
| `dyson_local` (shenxn/ha-dyson) | Contrôle MQTT local du Dyson Purifier                |
| Frisquet Connect (TheGui01)     | Pilotage chaudière Frisquet v2.5.4                   |
| Browser Mod (thomasloven)       | Contrôle navigateur, badges, popups v2.10.2          |
| EcoFlowCloud                    | Batterie EcoFlow River 2 Pro v1.4.1                  |
| iCloud3                         | Suivi localisation iPhone v3.4.3                     |
| `custom:button-card`            | Boutons personnalisés Lovelace                       |
| `google_mail` (natif)           | Intégration Gmail (`notify.might57290_gmail_com`)    |

## 7. Dashboard Lovelace (19 onglets — refonte S30)

Refonte S30 (22/04/2026) : 3 vues renommées (Chaudière, Télécommandes, Système),
2 étages créés (RDC + Haut), 3 aires refaites, 23 entités migrées.
Badges universels sur toutes les vues : Rafraîchir, Page précédente/suivante,
Jour, Nuit, Capteurs mouvement.

Pages principales : Home, Lumières & Interrupteurs, Caméras, Média, Dyson
Purifier, Chaudière Frisquet, Télécommandes, Système, Réseaux, Impression 3D.

### Architecture des aires

| Étage                                | Aires                                                      |
|--------------------------------------|------------------------------------------------------------|
| Haut (level 1, `mdi:home-floor-1`)   | Chambre (208 ent.), Couloir Haut (2), Cuisine (87)         |
| RDC (level 0, `mdi:home-floor-g`)    | Atelier (64), Couloir Bas (5), Salle de bain (14), WC (2)  |

## 8. Chaudière Frisquet — entités clés

| Entité                                    | Type                          |
|-------------------------------------------|-------------------------------|
| `climate.maison_zone_1_2`                 | Thermostat                    |
| `water_heater.chauffe_eau_maison_2`       | Chauffe-eau                   |
| `sensor.maison_alerte_2`                  | Alertes                       |
| `sensor.maison_consommation_chauffage_2`  | Conso chauffage cumul (kWh)   |
| `sensor.maison_consommation_eau_chaude_2` | Conso eau chaude cumul (kWh)  |
| `sensor.maison_temperature_zone_1_2`      | Température Zone 1            |

Presets permanents : `confort_permanent`, `reduit_permanent`, `hors_gel`,
`vacances`. En mode Auto, les changements depuis HA = dérogations temporaires.

## 9. Système de gestion des emails

| Boîte                  | Outil                                  | Cadence                        |
|------------------------|----------------------------------------|--------------------------------|
| might57290@gmail.com   | Gmail MCP custom stdio (CLI uniquement) | Task Scheduler Windows 05h00  |
| might@live.fr          | Brave + Claude in Chrome (MCP Outlook à étudier — T#48) | Cowork 05h + 14h |

Auto-apprentissage : `whitelist.json` / `blacklist.json` / `learning_log.json`
dans `Ressources/Data/gmail_patterns/` et `outlook_patterns/`.

Scores de confiance : 100 = spam évident (suppression auto), 90-99 =
suppression auto avec rapport, 70-89 = validation Mickael, < 70 = ne pas
supprimer.

Envoi mail depuis skill CLI : `ha_call_service notify.might57290_gmail_com`
avec `data.target=["might57290@gmail.com"]` obligatoire (scope OAuth
`gmail.send` volontairement absent).

## 10. Mode Réactif Jarvis v1.1 (Phase 1 — 100% CLI)

Pipeline de réaction aux événements HA, 100% automatique :

1. HA → email vers `might57290+jarvis@gmail.com` avec sujet `[JARVIS-ALERT]`.
2. Label Gmail `Jarvis-Alert` auto-appliqué.
3. Task Scheduler Windows **04h00** lance `claude -p` headless.
4. Jarvis applique le niveau d'autonomie HA → action / propose / signaler.
5. Archivage label `Jarvis-Alert/Traité` + log
   `memory/historique_reactif/AAAA-MM-JJ.md`.

Phase 2 (4 événements signalement) : T#40 ouverte.
Phase 3 (update HA snapshot + rollback Proxmox) : bloquée par T#41/T#42.

## 11. Architecture Cowork — éléments structurants

| Composant                          | Rôle / Statut                                              |
|------------------------------------|------------------------------------------------------------|
| `CLAUDE.md` (racine, v4.0 S75)     | Instructions principales — lues auto à chaque session      |
| `Runtime/Gmail-MCP-Server/`        | MCP stdio permanent (135 MB, SHA `a890d19`, S33)           |
| `.claude/skills/` (32 skills)      | Skills Jarvis — déclenchement auto par description         |
| `.claude/agents/` (3 sub-agents)   | **CLI-only** (Cowork desktop ne charge pas — testé S75/76) |
| `.claude/hooks/check-secrets.sh`   | Hook PreToolUse — renfort technique Règle 0 (S72)          |
| `.mcp.json` (racine)               | Connecteurs MCP — Gmail / HA / pdf-toolkit / etc.          |
| `Wiki/` (vault Obsidian)           | **Connaissance pure uniquement** (ADR-A004 S81)            |
| `Projets/` (racine)                | Initiatives temporaires (Hardware_Upgrade, Cookbook…)      |
| `Archives/` (racine)               | Anciens fichiers + backups pre-migration                   |

### 11.1 Sub-agents `.claude/agents/` (CLI uniquement)

| Sub-agent              | Modèle | Skill associée       | Usage                    |
|------------------------|--------|----------------------|--------------------------|
| `audit-securite-ha`    | opus   | (aucune)             | Audit posture sécurité HA en lecture seule stricte |
| `redacteur-email`      | sonnet | `redaction-email`    | Brouillons Gmail à partir d'un brief              |
| `debannissement-ip`    | sonnet | `debannissement-ip`  | Diagnostic + résolution ban IP avec confirmation  |

> ⚠ **Cowork desktop ne charge PAS les sub-agents custom** (testé S75 + S76).
> Pour usage Cowork : utiliser les sub-agents builtin (`Explore`, `Plan`,
> `general-purpose`).

### 11.2 Connecteurs MCP

| Connecteur              | Mode  | Cowork | CLI | Notes                                |
|-------------------------|-------|--------|-----|--------------------------------------|
| `home-assistant` (ha-mcp) | HTTP/SSE | OUI | OUI | URL publique avec secret (rotation S70) |
| `gmail` (Anthropic)     | HTTP/SSE | OUI | OUI | Lecture + drafts + labels uniquement |
| `gmail-mcp-local`       | stdio | NON    | OUI | Écriture Gmail (modify/batch/filter) |
| `pdf-toolkit`           | stdio/HTTP | OUI | OUI | 21 outils + 14 invites (S35)         |
| Claude in Chrome        | inclus Cowork | OUI | NON | Brave automation (Outlook web, etc.) |

Détail : `memory/reference_mcp_connecteurs.md`.

### 11.3 Hook PreToolUse `check-secrets.sh` (S72)

Bloque (exit 2) toute tentative d'accès aux fichiers/commandes contenant
des secrets : credentials Gmail OAuth, `.env*`, `secrets.yaml`, clés SSH
privées, `settings.local.json`, `.mcp.json` en Edit/Write, patterns API
keys (OpenRouter, Google, ha-mcp, AWS, GitHub).

7 règles, 14/14 tests OK. Configuration : `.claude/settings.json`.
Détail : `memory/reference_hooks_securite_p2.md`.

## 12. Vault Obsidian (`Wiki/`)

Vault de connaissance pure depuis ADR-A004 S81 (30/04/2026). 3 dossiers
top-level autorisés : `00_Index/`, `10_Domaines/`, `30_References/`.

Pas de projets ni archives ni verbatim conversations dans `Wiki/`. Les
projets vivent dans `Projets/` racine, les archives dans `Archives/` racine.

Plugins gratuits utilisés : Dataview, Templater, Excalidraw, Git.

## 13. Repo GitHub publié (`mightIA`)

| Repo                                    | Visibilité | Usage                              |
|-----------------------------------------|------------|------------------------------------|
| `mightIA/hermes-agent-rtx3090-cookbook` | Public MIT | Cookbook install Hermès Agent RTX 3090 (S64) |

Email noreply : `278813549+mightIA@users.noreply.github.com`.
Procédure push standard : skill `git-github-push` (5 pièges S69 documentés).

## 14. Points importants à retenir

- **Règle 0** (CLAUDE.md §0) : arrêt systématique avant accès à toute
  donnée sensible. Renfort technique par hook `check-secrets.sh` (S72).
- **Mode par défaut PC/Cowork** (S24) — réponses détaillées autorisées
  (markdown, tableaux, blocs de code). Mode iPhone seulement si Mickael
  écrit explicitement « je suis sur iPhone ».
- **Titre conv FR en début de session** (S53) — proposer immédiatement un
  titre clair (5-10 mots, format `<Domaine> — <Action>`).
- **Label application sur blocs de code** (S48/S53) — toujours étiqueter
  Ubuntu / WSL2 bash / PowerShell / HA UI / Brave / etc.
- **Pas-à-pas avec attente retour** (S53) — pour toute procédure
  impliquant des manipulations Mickael, livrer UNE étape à la fois.
- **WebSocket** : toujours `hass.callWS` pour lire/écrire config Lovelace.
- **Reload scripts** : Paramètres → Outils dev → YAML → Scripts.
- **Reload config** : Recharger Configuration entière après modif
  `configuration.yaml`.
- **Ban IP** : permanent — skill `debannissement-ip` +
  `Ressources/Protocoles/IP_Bans.md`.
- **Cowork + MCP stdio** : INCOMPATIBLE. Pattern brain (Cowork) + hands
  (CLI) pour toute écriture Gmail.
- **Confidentialité** : données (IP, tokens, config) strictement
  confidentielles.

---

*Fin de CONTEXTE.md — version 2.0 — 1 mai 2026 (S82 refresh complet
post-architecture S70→S81 : ha-mcp via `mcp.might.ovh`, 32 skills, 3
sub-agents CLI-only, hook check-secrets, vault Obsidian connaissance pure,
Hermès Agent local, repo GitHub mightIA).*
