---
title: Music Assistant
created: 2026-04-29
updated: 2026-04-30
tags: [atome, domotique/music, ha/addon, music_assistant]
status: actif
source: Ressources/Competences/Home_Assistant.md §5 (add-ons), MCP HA
---

# Music Assistant

Add-on Home Assistant **Music Assistant Server** (multiroom audio, gestionnaire de bibliothèque musicale opensource). Connecte plusieurs services de streaming et broadcast vers tous les players réseau détectés (DLNA, AirPlay, Chromecast, etc.).

## Identification add-on

| Champ | Valeur |
|---|---|
| **Slug HA** | `d5369777_music_assistant` |
| **Repository** | `d5369777` (custom repo) |
| **Version installée** | **2.8.6** |
| **État** | `started` ✅ |
| **Auto-update** | activé (`update.music_assistant_server_mise_a_jour`) |
| **URL admin** | accessible via barre latérale HA (panneau Music Assistant) ou ingress add-on |

## Players détectés (3 actifs)

Music Assistant a auto-découvert 3 cibles audio sur le réseau et créé des `media_player.*_2` correspondants :

| Player MA | Cible physique | État | Volume | Source |
|---|---|---|---|---|
| `media_player.salle_de_bain_2` | [[HomePod Mini salle de bain]] (AirPlay) | `idle` | 20 % | Music Assistant Queue |
| `media_player.samsung_q80_series_65_2` | [[Samsung Q80 + décodeur