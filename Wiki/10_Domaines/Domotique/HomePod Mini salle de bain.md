---
title: HomePod Mini salle de bain
created: 2026-04-30
updated: 2026-04-30
tags: [atome, domotique/audio, ha/integrations, apple, homepod]
status: actif
source: Ressources/Competences/Home_Assistant.md (intégration native apple_tv)
---

# HomePod Mini salle de bain

Enceinte connectée Apple **HomePod Mini** installée dans la salle de
bain. Pilotée par Home Assistant via l'intégration native `apple_tv`
(qui couvre aussi les HomePod, mêmes protocoles AirPlay/MRP).

> ℹ️ **Renommage S79+1** : cette fiche s'appelait initialement
> *Apple TV salle de bain*. Vérification MCP HA :
> `manufacturer=Apple, model=HomePod Mini`. Ce n'est donc PAS une Apple
> TV mais bien un HomePod Mini.

## Identification

- **Modèle** : Apple HomePod Mini
- **Version logicielle** : 26.4 (audioOS — version récente)
- **MAC** : `4e:87:56:a0:97:aa`
- **Aire HA (entités)** : `salle_de_bain`
- **Aire HA (device)** : non assignée — TODO assigner via `ha_set_entity` ou UI HA
- **Mode d'intégration** : `apple_tv` (natif HA, AirPlay/MRP local)
- **État au briefing** : `idle` (volume actuel **84 %**)

## Entités

| Entité | Plateforme | État | Description |
|---|---|---|---|
| `media_player.salle_de_bain` | `apple_tv` | `idle` | Player principal (volume 0.84, AirPlay) |
| `remote.salle_de_bain` | `apple_tv` | `on` | Télécommande virtuelle (`remote.send_command`) |

## Capacités principales

- ✅ AirPlay 2 (cible de stream depuis tout appareil Apple ou HA via
  Music Assistant)
- ✅ Volume / play / pause / next / previous
- ✅ Source play_media URL (Spotify URL, Apple Music URI, fichier local
  via Music Assistant)
- ✅ Siri / commandes vocales locales (mais hors HA)
- ❌ Pas d'écran → pas de navigation menu apple_tv (commandes `KEY_*` non
  pertinentes)

## Services / Scripts

| Service | Cible | Usage |
|---|---|---|
| `media_player.volume_set` | `media_player.salle_de_bain` | Volume 0.0 → 1.0 |
| `media_player.media_play` / `media_pause` / `media_stop` | idem | Contrôle lecture |
| `media_player.play_media` | idem | Streamer une URL audio (`media_content_type: music`) |
| `media_player.media_next_track` / `media_previous_track` | idem | Skip / précédent |

## Automations associées

- TODO — pas d'automation dédiée recensée à ce jour. Pistes :
  - Réveil progressif (volume monte à partir de 6h, source = playlist
    Spotify favoris).
  - Annonce TTS lors d'un événement HA (sonnette, alerte chaudière).
  - Mute auto la nuit après 22h.

## Visualisation Lovelace

TODO — pas de page dédiée recensée. Suggestion : intégrer une carte
`mini-media-player` sur la page **Media** ou créer une cellule sur la
page Salle de bain si elle existe.

## Notes liées

- [[_Index]]
- [[../HomeAssistant/Intégrations]]
- [[Music Assistant]] (cible AirPlay possible)

---

*Fiche complétée S79+1 (2026-04-30) — T#80 (corrige confusion Apple TV → HomePod Mini).*
*Données sources : `ha_search_entities`, `ha_get_device`, `ha_get_state`.*
