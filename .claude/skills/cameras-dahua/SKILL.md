---
name: cameras-dahua
description: Gestion des 3 cameras Dahua (Chambre, Cuisine fixe, Cuisine PTZ) — snapshots, enregistrements video 120s, pilotage PTZ (presets Fav 1 a 5), organisation des medias dans /media/cameras/. App mobile DMSS, protocole ONVIF. Integration native HA avec Frigate pour le flux live.
---

# Skill : Cameras Dahua

## Quand cette skill est declenchee

- Demande de photo ou video d'une camera.
- Question sur le pilotage PTZ (cuisine PTZ).
- Probleme d'affichage d'une camera.
- Question sur la structure des medias.

## Cameras installees

| Camera       | Entite HA                                             | MAC               |
|--------------|-------------------------------------------------------|-------------------|
| Chambre      | camera.chambre_mediaprofile_channel1_mainstream       | c4:aa:c4:b6:68:40 |
| Cuisine fixe | camera.cuisine_profile100                             | f8:ce:07:b5:5b:f6 |
| Cuisine PTZ  | camera.cuisine_profile000                             | f8:ce:07:b5:5b:f6 |

## Structure des medias

```
/media/cameras/
  chambre/photo/
  chambre/video/
  cuisine_fixe/photo/
  cuisine_fixe/video/
  cuisine_ptz/photo/
  cuisine_ptz/video/
```

## Scripts (voir skill `ha-scripts` pour la liste exhaustive)

- `script.cam_snapshot_<camera>` — photo instantanee
- `script.cam_record_<camera>` — enregistrement 120 s
- `script.cam_vider_<camera>` — vidage specifique
- `shell_command.vider_<camera>` — commande shell associee

## PTZ — Cuisine — favoris

| Bouton HA | Token ONVIF | Favori DMSS | Statut                            |
|-----------|-------------|-------------|-----------------------------------|
| Fav 1     | preset 1    | Favori 1    | OK                                |
| Fav 2     | preset 2    | Favori 2    | OK                                |
| Fav 3     | preset 3    | Favori 3    | OK                                |
| Fav 4     | preset 4    | Favori 4    | OK                                |
| Fav 5     | preset 5    | Favori 5    | A verifier — preset non enregistre|

**Important :** les points favoris DMSS sont stockes localement dans l'app.
Pour creer un vrai preset ONVIF (utilisable par HA) : interface web camera
(IP directe) > PTZ > Presets. Pas via DMSS.

Cuisine retournee : **fleches inversees** (LEFT=RIGHT, UP=DOWN).

## Page Lovelace Cameras

Vue `sections` a 3 colonnes (Chambre | Cuisine fixe | Cuisine PTZ). Chaque
section contient :
- **Ligne 1** : 4 boutons (Dossier, Photo, Video, Supprimer avec confirmation)
- **Titre** : nom de la camera
- **Flux video** : carte Frigate
- **Cuisine PTZ** : controles PTZ supplementaires (Fav 1-5, fleches
  directionnelles)

## Diagnostic

- Camera ne s'affiche pas : rafraichir la page, verifier connectivite
  reseau, verifier ONVIF dans integrations HA.
- Flux qui freeze : redemarrer l'addon Frigate.

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` section 5.
