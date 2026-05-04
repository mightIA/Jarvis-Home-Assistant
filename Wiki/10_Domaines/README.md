---
title: Domaines de connaissance persistants
created: 2026-04-25
updated: 2026-04-25
tags: [readme, structure]
---

# 10_Domaines/

**Ce qu'on range ici** : tout ce qui a une existence longue et stable
dans la maison de Mickael — pas de notion de début/fin, contrairement
aux projets.

## Sous-dossiers prévus (créer au besoin)

- `HomeAssistant/` — config, automations, scripts, dashboards, helpers
- `Domotique/` — Dyson, Frisquet, Dahua, Tuya, Zigbee, Z-Wave
- `Reseau/` — UniFi, DNS, Cloudflare Tunnel, ports, ban IP
- `Cloudflare/` — Tunnel, Access, SSL/TLS, HSTS, R2, Workers
- `Frisquet/` — chaudière, capteurs, scripts
- `Cameras/` — Dahua IPC, snapshots, records, motion
- `Outils/` — outils CLI, MCP servers, scripts personnels

## Convention

Chaque sous-domaine contient idéalement un `_Index.md` qui sert de MOC
local et liste les notes principales du domaine.

Exemple `HomeAssistant/_Index.md` :

```markdown
---
title: MOC Home Assistant
tags: [moc, ha]
---

## Setup
- [[Setup_HA_Local]]
- [[URL_Locale_Distante]]

## Automations
- [[Automation_Lumiere_Soir]]
...
```
