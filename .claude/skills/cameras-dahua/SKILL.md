---
name: cameras-dahua
description: Gestion des 3 cameras Dahua de Mickael (Chambre, Cuisine fixe, Cuisine PTZ). DECLENCHEURS : 'photo de la chambre/cuisine', 'video 120s', 'snapshot', 'enregistre la camera', 'fav 1 a 5', 'preset PTZ', 'pilotage cuisine PTZ', 'flux camera freeze', 'media camera', 'vide les photos/videos', 'fleche cuisine'. Snapshots, enregistrements 120s, pilotage PTZ (Fav 1-5), organisation /media/cameras/. App DMSS, protocole ONVIF, flux Frigate.
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

## PTZ — Cuisine — favoris + Ronde 360°

| Bouton HA | Service appele                                              | Statut |
|-----------|-------------------------------------------------------------|--------|
| 360°      | `script.cuisine_ptz_ronde` (cycle Fav 1→2→3→4, 5s chaque)   | OK S82 |
| Fav 1     | `onvif.ptz` `move_mode=GotoPreset` `preset="1"`             | OK     |
| Fav 2     | `onvif.ptz` `move_mode=GotoPreset` `preset="2"`             | OK     |
| Fav 3     | `onvif.ptz` `move_mode=GotoPreset` `preset="3"`             | OK     |
| Fav 4     | `onvif.ptz` `move_mode=GotoPreset` `preset="4"`             | OK     |

> Note S82 : l'ancien bouton « Fav 5 » a ete reconverti en bouton « 360° »
> qui appelle `script.cuisine_ptz_ronde` (cycle automatique des 4 favoris,
> 5s sur chaque, total ~20s, sans record). Position : 1ere du groupe (avant
> Fav 1). Pas de preset 5 cote camera (T#7 close S82 par approche alternative).

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


## Exemples d'invocation utilisateur

- « Prends une photo de la chambre » → `script.cam_snapshot_chambre` (sortie `/media/cameras/chambre/photo/`).
- « Enregistre une video de la cuisine PTZ » → `script.cam_record_cuisine_ptz` (120 s).
- « Va sur le Fav 2 de la cuisine PTZ » → bouton Lovelace ou `onvif.ptz` preset 2.
- « Vide les photos de la chambre » → confirmation puis `script.cam_vider_chambre`.
- « La cuisine PTZ ne repond plus » → diagnostic ONVIF + flux Frigate (cf. Diagnostic).

## Quand NE PAS utiliser

- Pour les cameras NON-Dahua (Reolink, Tapo, etc.) — autre integration, autre skill.
- Pour la gestion Frigate avancee (zones, objets, evenements) — utiliser `Ressources/Competences/Home_Assistant.md` section Frigate.
- Pour configurer un nouveau preset ONVIF : se faire via l'interface web camera (IP directe), PAS via DMSS (T#7 ouverte).

## Pieges connus

- **DMSS != ONVIF** : les favoris DMSS sont locaux a l'app, INVISIBLES de HA. Pour qu'un preset soit pilotable HA, il faut l'enregistrer via interface web camera.
- **Cuisine PTZ retournee** : LEFT=RIGHT, UP=DOWN. Toujours preciser la convention quand on guide Mickael.
- **Vidage** : action destructive irreversible — DEMANDER CONFIRMATION explicite avant chaque `script.cam_vider_*` ou `shell_command.vider_*`.
- **Bouton « 360° » cuisine PTZ** (S82) : remplace l'ancien Fav 5. Lance `script.cuisine_ptz_ronde` (cycle des 4 favoris, ~20s). Position : 1ere du groupe.

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` section 5.
