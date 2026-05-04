---
name: ha-scripts
description: Execution des scripts Home Assistant valides (allowlist). DECLENCHEURS : 'lance le script', 'execute script.X', 'snapshot camera', 'enregistre video', 'vide medias', 'reglage angle Dyson', 'active capteurs mouvement', 'scene jour/nuit'. Couvre snapshots/records cameras, vidage medias, scripts Dyson, scenes, capteurs mouvement. Liste blanche stricte — JAMAIS executer un script hors liste sans validation explicite Mickael.
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


## Exemples d'invocation utilisateur

- « Lance le snapshot de la chambre » → `script.cam_snapshot_chambre` via `script.turn_on` ou MCP `ha_call_service` domain=script service=cam_snapshot_chambre.
- « Active la scene Nuit » → `scene.turn_on` entity_id=scene.nuit.
- « Coupe les capteurs de mouvement » → `script.capteurs_de_mouvement_off`.
- « Vide tous les medias cameras » → CONFIRMATION puis `script.cam_vider_dossier`.
- « Diminue l'angle min Dyson de 10 » → `script.dyson_angle_low_minus`.

## Quand NE PAS utiliser

- Pour creer ou modifier un script — utiliser la skill `home-assistant-manager` ou editer `scripts.yaml`.
- Pour executer un service HA brut (sans script wrapper) — utiliser directement `ha_call_service`.
- Pour les scripts Frisquet (gestion preset chaudiere) — passer par `chaudiere-frisquet` qui utilise `climate.set_preset_mode` directement.

## Pieges connus

- **Allowlist stricte** : refuser tout script absent du tableau (meme si Mickael le nomme). Demander confirmation explicite + verifier qu'il existe avant.
- **Confirmation destructive** : `cam_vider_*` et `shell_command.vider_*` sont IRREVERSIBLES — toujours confirmer.
- **HA injoignable** : echec silencieux possible. Verifier statut avant via skill `ha-status` (ou MCP `ha_get_state`).
- **Logique Dyson Min inversee** : le bouton + agrandit le cone (diminue valeur min). Le repreciser meme si la skill Dyson le mentionne aussi.
- **Scenes** : `scene.turn_on` pas `script.turn_on`. Confondre les deux echoue silencieusement.

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` sections 5, 6, 9.
