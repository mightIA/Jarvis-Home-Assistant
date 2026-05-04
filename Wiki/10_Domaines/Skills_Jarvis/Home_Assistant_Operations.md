---
title: Skills Home Assistant — Opérations
created: 2026-04-27
updated: 2026-04-28
tags: [atome, skill, home-assistant]
status: actif
domaine: Skills_Jarvis
---

# Skills Home Assistant — Opérations

Catégorie regroupant les 11 skills qui touchent à Home Assistant (statut, scripts, devices, dashboards, automations, sécurité accès).

## Skills incluses

### `ha-status`

- **Déclencheur** : question sur l'état d'un appareil ("est-ce que la lumière de la chambre est allumée ?"), état global ("qu'est-ce qui est allumé ?"), capteurs (temp/humidité/présence), demande de snapshot caméra.
- **Dépendances** :
  - MCP `ha-mcp` (add-on `homeassistant-ai/ha-mcp` exposé via `https://mcp.might.ovh/<secret_path>`)
  - OAuth 2.0 DCR
- **Détail exécutable** : `.claude/skills/ha-status/SKILL.md`
- **Liens vault** : [[10_Domaines/Reseau/_Index|Réseau & Sécurité]], [[10_Domaines/Hardware/_Index|Hardware]]

### `ha-scripts`

- **Déclencheur** : demande d'action via script HA ("prends une photo de la chambre", "enregistre une vidéo", "vide les médias"), mode capteurs mouvement, réglage angle Dyson.
- **Dépendances** :
  - MCP `ha-mcp` (`ha_call_service` sur domaine `script`)
  - Liste blanche de scripts validés — ne jamais exécuter un script hors liste sans validation explicite Mickael
- **Détail exécutable** : `.claude/skills/ha-scripts/SKILL.md`

### `chaudiere-frisquet`

- **Déclencheur** : question chauffage / température salon / preset (confort, réduit, hors_gel, vacances, confort_permanent, reduit_permanent), chauffe-eau (MAX, Eco, Eco Timer, Stop), consommation.
- **Dépendances** :
  - Intégration HACS `Frisquet Connect` v2.5.4
  - MCP `ha-mcp` (read state + call_service climate)
  - Distinction dérogation temporaire (mode Auto) vs changement permanent
- **Détail exécutable** : `.claude/skills/chaudiere-frisquet/SKILL.md`

### `cameras-dahua`

- **Déclencheur** : demande photo/vidéo caméra, pilotage PTZ (cuisine PTZ, presets Fav 1-5), problème d'affichage caméra, structure médias.
- **Dépendances** :
  - 3 caméras Dahua (Chambre + Cuisine fixe + Cuisine PTZ)
  - Frigate pour le flux live
  - Protocole ONVIF / app DMSS
  - Stockage `/media/cameras/`
- **Détail exécutable** : `.claude/skills/cameras-dahua/SKILL.md`
- **Liens vault** : [[10_Domaines/Hardware/_Index|Hardware]]

### `dyson-purifier`

- **Déclencheur** : question Dyson / qualité air / oscillation / vitesse, réglage angles min/max, capteurs (PM2.5, COV, formaldéhyde, NO2, PM10).
- **Dépendances** :
  - Intégration HACS `dyson_local` (MQTT local)
  - Service `set_angle`
  - Visualisation SVG `/homeassistant/www/dyson_angle_viz.html`
- **Détail exécutable** : `.claude/skills/dyson-purifier/SKILL.md`

### `debannissement-ip`

- **Déclencheur** : 2-3 erreurs 401/403 consécutives sur HA, Mickael ne peut plus accéder à HA, après tentatives d'auth ratées.
- **Dépendances** :
  - **Méthode 1** : Terminal SSH local (priorité)
  - **Méthode 2** : File Editor distant (fallback)
  - **Méthode 3 (fallback ultime)** : `shell_command.ha_clear_all_ip_bans` via MCP `ha-mcp` (utile quand Brave bloqué ou iPhone seul)
  - Fichier `ip_bans.yaml` (non sensible, exception à la Règle 0)
  - Voir `Ressources/Protocoles/IP_Bans.md`
- **Détail exécutable** : `.claude/skills/debannissement-ip/SKILL.md`
- **Liens vault** : [[10_Domaines/Reseau/_Index|Réseau & Sécurité]], [[10_Domaines/Procedures/_Index|Procédures]]

### `browser-mod`

- **Déclencheur** : refresh Lovelace (F5 réel), navigation back/forward, popup/notification depuis HA, badges universels sur les 19 vues Lovelace.
- **Dépendances** :
  - Intégration HACS `browser_mod` (thomasloven) v2.10.2
  - MCP `ha-mcp` (call_service `browser_mod.*`)
- **Détail exécutable** : `.claude/skills/browser-mod/SKILL.md`

### `home-assistant-best-practices`

- **Déclencheur** : création/édition d'automation, scripts, scenes, dashboards. Choix template sensor vs helper. Triggers/conditions/modes. Boutons Zigbee (ZHA ou Z2M). Renommage entité, migration `device_id` → `entity_id`. Lookup card types.
- **Dépendances** :
  - MCP `ha-mcp` (`ha_get_skill_home_assistant_best_practices`)
- **Détail exécutable** : `.claude/skills/home-assistant-best-practices/SKILL.md`

### `home-assistant-manager`

- **Déclencheur** : gestion experte de la config HA via SSH + `hass-cli` + git/scp, vérification automation, log analysis, choix reload vs restart, dashboards tablette.
- **Dépendances** :
  - SSH local sur `192.168.1.11` (remplacer `homeassistant.local` par l'IP)
  - `hass-cli`
  - Source amont communautaire : `https://github.com/komal-SkyNET/claude-skill-homeassistant` (MIT)
- **Détail exécutable** : `.claude/skills/home-assistant-manager/SKILL.md`

### `lovelace-edit`

- **Déclencheur** : modification dashboard (ajout carte, section, réorganisation), création vue/page, ajout badge, correction carte cassée.
- **Dépendances** :
  - API WebSocket `hass.callWS` (jamais éditer les fichiers dashboard directement)
  - MCP `ha-mcp` (`ha_config_get_dashboard` / `ha_config_set_dashboard`)
  - Toujours proposer une sauvegarde avant modification significative
- **Détail exécutable** : `.claude/skills/lovelace-edit/SKILL.md`

### `yaml-automation`

- **Déclencheur** : "je voudrais une automation qui fait X", modification d'une automation existante, création scène/routine/déclencheur temporisé.
- **Dépendances** :
  - MCP `ha-mcp` (`ha_config_set_automation`)
  - Toujours proposer un test après modification
  - Préciser reload simple vs redémarrage complet (cf. `Ressources/Competences/Home_Assistant.md` § 4)
- **Détail exécutable** : `.claude/skills/yaml-automation/SKILL.md`

## Patterns d'usage transversaux

### Endpoint MCP HA unique

Toutes les skills HA s'appuient sur l'add-on `ha-mcp` exposé via Cloudflare Tunnel sur `https://mcp.might.ovh/<secret_path>`. Bypass CF Access obligatoire (jamais Allow+MFA, voir auto-memory `feedback_cf_mcp_bypass_not_allow`).

### Reload vs restart

Avant toute modif config (configuration.yaml, scripts.yaml, Lovelace, automations.yaml), préciser si **rechargement simple** ou **redémarrage complet** est nécessaire. Tableau détaillé : `Ressources/Competences/Home_Assistant.md` § 4.

### `enable_tool_search` ON

Toggle activé S53 dans add-on ha-mcp pour réduire le contexte idle (87 → 20 outils côté client). Compatible Anthropic deferred tools (cf. `reference_ha_enable_tool_search_active`).

### Toujours fournir les liens HA

Lors de toute modif HA, fournir l'URL cliquable (local `http://192.168.1.11:2096/` + distant `https://ha.might.ovh/` si pertinent), cf. auto-memory `feedback_toujours_liens_modifs`.

## Voir aussi

- [[_Index]] — MOC Skills Jarvis
- [[10_Domaines/Reseau/_Index|Réseau & Sécurité]] — domaine Réseau & Sécurité
- [[10_Domaines/Hardware/_Index|Hardware]] — domaine Hardware
- [[10_Domaines/Procedures/_Index|Procédures]] — procédures (rotation secret_path, débans, etc.)
- `Ressources/Competences/Home_Assistant.md` — référence HA complète
- `Ressources/Competences/Home_Assistant_Inven