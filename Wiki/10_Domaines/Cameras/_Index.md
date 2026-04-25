---
title: Caméras Dahua — Index du domaine
created: 2026-04-25
tags: [moc, domotique/cameras, ha/cameras]
status: actif
source: Ressources/Competences/Home_Assistant.md §5
---

# Caméras Dahua — Index du domaine

Système de 3 caméras IP Dahua pilotées via ONVIF + Frigate dans Home
Assistant. Pilotage Lovelace + scripts snapshot/record.

## Vue d'ensemble

| Caméra | Type | Entité HA |
|---|---|---|
| Chambre | Fixe | `camera.chambre_mediaprofile_channel1_mainstream` |
| Cuisine fixe | Fixe | `camera.cuisine_profile100` |
| Cuisine PTZ | PTZ (orientation) | `camera.cuisine_profile000` |

→ MAC chambre `c4:aa:c4:b6:68:40`, MAC cuisine (les 2) `f8:ce:07:b5:5b:f6`.

## Notes du dossier

- [[Configuration et scripts]] — scripts snapshot/record/vider, structure médias
- [[Page Lovelace]] — vue 3 colonnes + contrôles PTZ

## Intégrations en jeu

- `onvif` Chambre + Cuisine — `loaded`
- `webrtc` WebRTC Camera — `loaded`
- `frigate` `ccab4aaf-frigate-fa:5000` — **setup_retry** ⚠️ à diagnostiquer
- Add-on **Frigate (Full Access)** — NVR détection objets

## Notes liées

- [[../HomeAssistant/_Index]]
- [[../HomeAssistant/Procédures diagnostiques]] — caméra qui ne s'affiche pas
- [[../HomeAssistant/Intégrations]]
- Skill : `.claude/skills/cameras-dahua/`

---

*Source : `Ressources/Competences/Home_Assistant.md` §5.*
