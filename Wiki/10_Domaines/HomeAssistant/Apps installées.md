---
title: HA — Apps installées (add-ons)
created: 2026-04-25
updated: 2026-04-25
tags: [atome, ha/apps, ha/inventaire]
status: actif
---

# HA — Apps installées (add-ons)

Renommage UI 2025+ : *Modules complémentaires / Add-ons* → **Apps**
(icône puzzle jaune 🧩). Le **Boutique** s'appelle désormais **Installer
l'application** (bouton bleu, bas-droite).

État au 21/04/2026 (session 24) — 25 add-ons installés.

## Add-ons clés (ceux que Jarvis touche le plus)

| Add-on | Rôle | Notes |
|---|---|---|
| **Cloudflared** | Tunnel CF pour `ha.might.ovh` et `mcp.might.ovh` | Cf. [[../Cloudflare/_Index]] |
| **File editor** | Édition fichiers HA via UI | Outil Jarvis pour `configuration.yaml`, `ip_bans.yaml` |
| **Studio Code Server** | VSCode intégré | Édition YAML avancée |
| **Terminal & SSH** | Shell HA | Méthode 1 [[Débannissement IP]] |
| **Home Assistant MCP Server** (add-on) | Serveur MCP FastMCP+DCR exposé `mcp.might.ovh/<secret>` | v7.3.0, **utilisé par Cowork** |
| **Frigate (Full Access)** | NVR détection objets caméras | Cf. [[../Cameras/_Index]] |
| **Zigbee2MQTT** | Contrôle Zigbee sans hub fabricant | Préféré à `zha` (not_loaded) |
| **AdGuard Home** | Bloqueur DNS | |
| **Home Assistant Google Drive Backup** | Backups auto vers Google Drive | |
| **MariaDB**, **Mosquitto broker** | Backbone DB SQL + MQTT | |
| **Piper**, **Whisper** | TTS / STT (voix Jarvis future) | TASKS.md #53 |
| **Music Assistant** | Bibliothèque musicale | |

## Autres add-ons installés

NGINX SSL proxy, ESPHome Builder, Matter Server, OpenThread Border Router,
go2rtc (transcoding Intel VAAPI / RPi V4L2), Samba share, ZeroTier One,
ngrok client, ZigStar TI CC2652P/P7 flasher, Get HACS, Log Viewer.

## Dépôts custom (Apps → Dépôts)

| Nom | URL |
|---|---|
| **Home Assistant MCP Server** (S15) | `https://github.com/homeassistant-ai/ha-mcp` |
| AlexxIT addons | `https://github.com/AlexxIT/hassio-addons` |
| Cloudflared (Tobia Brenner) | `https://github.com/brenner-tobias/ha-addons` |
| Frigate Add-ons | `https://github.com/blakeblackshear/frigate-hass-addons` |
| Zigbee2MQTT | `https://github.com/zigbee2mqtt/hassio-zigbee2mqtt` |
| HACS | `https://github.com/hacs/addons` |
| Google Drive Backup | `https://github.com/sabeechen/hassio-google-drive-backup` |
| ZigStar | `https://github.com/mercenaruss/zigstar_addons` |
| Phillip Camp ngrok | `https://github.com/pssc/ha-addon-ngrok` |

## Notes liées

- [[Intégrations]] — les 62 intégrations qui s'appuient sur ces add-ons
- [[Outils sidebar]] — les apps visibles dans la barre latérale
- Skill : `.claude/skills/ha-mcp-install/` (procédure d'install ha-mcp)

---

*Source : `Ressources/Competences/Home_Assistant_Inventaire.md` §3 + §4.*
