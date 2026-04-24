---
name: ha-scripts
description: Execution des scripts Home Assistant (snapshots cameras, enregistrements video, vidage des dossiers medias, scripts Dyson, scripts Frisquet). Liste de scripts validee — ne jamais executer un script hors liste sans validation explicite de Mickael.
---

# Skill : Execution de scripts Home Assistant

## Quand cette skill est declenchee

- Demande d'action via script HA ("prends une photo de la chambre",
  "enregistre une video de la cuisine", "vide les medias de la chambre").
- Demande d'execution du mode capteurs mouvement.
- Demande de reglage d'angle Dyson.

## Scripts disponibles

### Cameras — snapshots

| Script | Action | Entite source |
|--------|--------|---------------|
| `script.cam_snapshot_chambre` | Capture photo | camera.chambre_mediaprofile_channel1_mainstream |
| `script.cam_snapshot_cuisine_fixe` | Capture photo | camera.cuisine_profile100 |
| `script.cam_snapshot_cuisine_ptz` | Capture photo | camera.cuisine_profile000 |

Sortie : `/media/cameras/<camera>/photo/`.

### Cameras — enregistrements video (120 s)

| Script | Action | Duree |
|--------|--------|-------|
| `script.cam_record_chambre` | Enregistre video | 120 s |
| `script.cam_record_cuisine_fixe` | Enregistre video | 120 s |
| `script.cam_record_cuisine_ptz` | Enregistre video | 120 s |

Sortie : `/media/cameras/<camera>/video/`.

### Cameras — vidage medias

| Script | Action |
|--------|--------|
| `script.cam_vider_dossier` | Efface tout (dossiers conserves) |
| `script.cam_vider_chambre` | Efface chambre uniquement |
| `script.cam_vider_cuisine_fixe` | Efface cuisine_fixe uniquement |
| `script.cam_vider_cuisine_ptz` | Efface cuisine_ptz uniquement |

Demander confirmation avant execution.

### Shell commands associes

| Commande | Action |
|----------|--------|
| `shell_command.vider_cameras` | Supprime tout `/media/cameras/*/photo/*` et `*/video/*` |
| `shell_command.vider_chambre` | Supprime `/media/cameras/chambre/photo/*` et `video/*` |
| `shell_command.vider_cuisine_fixe` | Supprime `/media/cameras/cuisine_fixe/photo/*` et `video/*` |
| `shell_command.vider_cuisine_ptz` | Supprime `/media/cameras/cuisine_ptz/photo/*` et `video/*` |

### Dyson — reglage angles

| Script | Action |
|--------|--------|
| `script.dyson_angle_low_plus` | Diminue angle_low de 10 (agrandit le cone) |
| `script.dyson_angle_low_minus` | Augmente angle_low de 10 (reduit le cone) |
| `script.dyson_angle_high_plus` | Augmente angle_high de 10 (agrandit le cone) |
| `script.dyson_angle_high_minus` | Diminue angle_high de 10 (reduit le cone) |

Logique Min inversee : le bouton + agrandit le cone (diminue la valeur min).

### Scripts scenes et capteurs

| Script / Scene | Action |
|----------------|--------|
| `scene.jour` | Active la scene Jour |
| `scene.nuit` | Active la scene Nuit |
| `script.capteurs_de_mouvement_on` | Active les capteurs mouvement |
| `script.capteurs_de_mouvement_off` | Desactive les capteurs mouvement |

## Regles de securite

- **Jamais** executer un script qui n'est pas dans la liste ci-dessus sans
  validation explicite de Mickael.
- Confirmation demandee avant tout script destructif (vidage medias).
- Verifier que HA est joignable avant execution (via la skill `ha-status`).

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` sections 5, 6, 9.
