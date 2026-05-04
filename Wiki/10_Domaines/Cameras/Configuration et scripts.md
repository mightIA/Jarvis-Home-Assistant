---
title: Caméras — Configuration et scripts
created: 2026-04-25
updated: 2026-04-25
tags: [atome, domotique/cameras, ha/scripts]
status: actif
---

# Caméras — Configuration et scripts

## Structure médias

```
/media/cameras/
├── chambre/photo/
├── chambre/video/
├── cuisine_fixe/photo/
├── cuisine_fixe/video/
├── cuisine_ptz/photo/
└── cuisine_ptz/video/
```

## Scripts caméras (10)

### Snapshots & enregistrements

| Script | Action | Durée |
|---|---|---|
| `cam_snapshot_chambre` | `camera.snapshot` → `chambre/photo/` | — |
| `cam_snapshot_cuisine_fixe` | `camera.snapshot` → `cuisine_fixe/photo/` | — |
| `cam_snapshot_cuisine_ptz` | `camera.snapshot` → `cuisine_ptz/photo/` | — |
| `cam_record_chambre` | `camera.record` → `chambre/video/` | 120 s |
| `cam_record_cuisine_fixe` | `camera.record` → `cuisine_fixe/video/` | 120 s |
| `cam_record_cuisine_ptz` | `camera.record` → `cuisine_ptz/video/` | 120 s |

### Vidage

| Script | Action |
|---|---|
| `cam_vider_dossier` | Efface tout (dossiers conservés) |
| `cam_vider_chambre` | Efface `chambre/` uniquement |
| `cam_vider_cuisine_fixe` | Efface `cuisine_fixe/` uniquement |
| `cam_vider_cuisine_ptz` | Efface `cuisine_ptz/` uniquement |

## Shell commands associés

| Commande | Action |
|---|---|
| `shell_command.vider_cameras` | Supprime `/media/cameras/*/photo/*` et `*/video/*` |
| `shell_command.vider_chambre` | Supprime `/media/cameras/chambre/photo/*` et `video/*` |
| `shell_command.vider_cuisine_fixe` | Supprime `/media/cameras/cuisine_fixe/photo/*` et `video/*` |
| `shell_command.vider_cuisine_ptz` | Supprime `/media/cameras/cuisine_ptz/photo/*` et `video/*` |

## PTZ Favoris (Cuisine PTZ uniquement)

| Bouton HA | Token ONVIF | Favori DMSS | Statut |
|---|---|---|---|
| Fav 1 | `preset 1` | Favori 1 | ✅ |
| Fav 2 | `preset 2` | Favori 2 | ✅ |
| Fav 3 | `preset 3` | Favori 3 | ✅ |
| Fav 4 | `preset 4` | Favori 4 | ✅ |
| Fav 5 | `preset 5` | Favori 5 | ⚠️ à vérifier |

## Notes liées

- [[_Index]] — vue d'ensemble
- [[Page Lovelace]] — UI

---

*Source : `Ressources/Competences/Home_Assistant.md` §5.2-5.4 + §5.6.*
