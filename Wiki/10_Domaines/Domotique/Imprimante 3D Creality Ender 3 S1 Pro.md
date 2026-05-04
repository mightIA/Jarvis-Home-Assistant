---
title: Imprimante 3D Creality Ender 3 S1 Pro
created: 2026-04-29
updated: 2026-05-02
tags: [atome, domotique, domotique/imprimante3d, ha, ha/integration]
status: actif
source: MCP HA (ha_get_integration / ha_get_device) — S86
---

# Imprimante 3D Creality Ender 3 S1 Pro (Klipper + Moonraker)

Imprimante 3D **Creality Ender 3 S1 Pro** flashée avec firmware **Klipper**, contrôlée via **Moonraker** (API HTTP/WebSocket Klipper) et intégrée à Home Assistant via le composant officiel `moonraker`.

## Identification

- **Modèle imprimante** : Creality Ender 3 S1 Pro
- **Firmware** : Klipper + Moonraker (host probablement Raspberry Pi ou MKS Pad)
- **Mode d'intégration HA** : intégration native `moonraker` (pas HACS)
- **Domain HA** : `moonraker`
- **Entry ID HA** : `01K2WKS5ZP9C4M3P8NZ9XJJRH4`
- **Device ID** : `c8a0f0a6ddb67dd9309029755c04c26a`
- **Area HA** : `atelier` ✅
- **État actuel** : ⚠️ **`setup_retry`** — l'intégration n'arrive pas à joindre Moonraker (souci Klipper en cours, cf. ci-dessous)

## ⚠️ Problème en cours

État `setup_retry` au moment de la rédaction (S86, 02/05/2026). Mickael a noté un **souci avec Klipper** côté firmware imprimante. L'intégration HA réessaie périodiquement de se connecter mais échoue.

**Pistes de diagnostic** :

1. Vérifier que le host Moonraker (Raspberry Pi / MKS Pad) est allumé et joignable sur le réseau (ping IP).
2. Vérifier le service Klipper sur le host : `sudo systemctl status klipper` (souvent `failed` après modif `printer.cfg`).
3. Consulter les logs Klipper : `~/printer_data/logs/klippy.log`.
4. Vérifier le service Moonraker : `sudo systemctl status moonraker`.
5. Tester l'API Moonraker manuellement : `curl http://<ip-pi>:7125/printer/info` (doit retourner JSON).
6. Une fois Klipper réparé, dans HA : `Paramètres → Appareils & services → Moonraker → Reconfigurer`.

## Entités principales (préfixe `creality_ender_3_s1_pro_*` — nouveau nom à privilégier)

> **Note importante** : Mickael a confirmé qu'on **ignore le préfixe `spad_7737_*`** (ancien hostname Klipper, doublon résiduel). Toujours utiliser les entités préfixées `creality_ender_3_s1_pro_*`.

### État impression (sensor)

| Entité | Description |
|---|---|
| `sensor.creality_ender_3_s1_pro_printer_state` | État global imprimante (ready / printing / paused / error / offline) |
| `sensor.creality_ender_3_s1_pro_printer_message` | Message statut Klipper |
| `sensor.creality_ender_3_s1_pro_current_print_state` | État impression en cours |
| `sensor.creality_ender_3_s1_pro_current_print_message` | Message impression |
| `sensor.creality_ender_3_s1_pro_current_display_message` | Message affiché à l'écran imprimante |
| `sensor.creality_ender_3_s1_pro_filename` | Nom du fichier en cours d'impression |
| `sensor.creality_ender_3_s1_pro_progress` | Progression % |
| `sensor.creality_ender_3_s1_pro_print_eta` | ETA fin impression (datetime) |
| `sensor.creality_ender_3_s1_pro_print_time_left` | Temps restant impression |
| `sensor.creality_ender_3_s1_pro_print_duration` | Durée impression écoulée |
| `sensor.creality_ender_3_s1_pro_print_projected_total_duration` | Durée totale projetée |
| `sensor.creality_ender_3_s1_pro_filament_used` | Filament utilisé (mm/g) |
| `sensor.creality_ender_3_s1_pro_total_layer` / `..._current_layer` | Total couches / couche en cours |
| `sensor.creality_ender_3_s1_pro_object_height` | Hauteur de l'objet imprimé |

### Températures et puissances (sensor)

| Entité | Description |
|---|---|
| `sensor.creality_ender_3_s1_pro_bed_temperature` / `..._bed_power` | Température / puissance lit chauffant |
| `sensor.creality_ender_3_s1_pro_extruder_temperature` / `..._extruder_power` | Température / puissance hotend (extrudeuse) |
| `sensor.creality_ender_3_s1_pro_my_nozzle_fan` | Vitesse ventilateur buse |

### Position toolhead (sensor)

| Entité | Description |
|---|---|
| `sensor.creality_ender_3_s1_pro_toolhead_position_x` | Position X (mm) |
| `sensor.creality_ender_3_s1_pro_toolhead_position_y` | Position Y (mm) |
| `sensor.creality_ender_3_s1_pro_toolhead_position_z` | Position Z (mm) |

### Système host Moonraker (sensor)

| Entité | Description |
|---|---|
| `sensor.creality_ender_3_s1_pro_system_load` | Load CPU host Moonraker |
| `sensor.creality_ender_3_s1_pro_memory_used` | RAM utilisée host |
| `sensor.creality_ender_3_s1_pro_mcu_load` / `..._mcu_awake` | Load et awake MCU Klipper |

### Statistiques cumulées (sensor)

| Entité | Description |
|---|---|
| `sensor.creality_ender_3_s1_pro_totals_jobs` | Nombre total d'impressions |
| `sensor.creality_ender_3_s1_pro_totals_print_time` | Temps total d'impression cumulé |
| `sensor.creality_ender_3_s1_pro_totals_filament_used` | Filament total utilisé |
| `sensor.creality_ender_3_s1_pro_longest_print` | Plus longue impression |
| `sensor.creality_ender_3_s1_pro_queue_state` / `..._jobs_in_queue` | État file / nombre jobs en queue |

### Réglages (number)

| Entité | Description |
|---|---|
| `number.creality_ender_3_s1_pro_bed_target` | Température cible lit (°C) |
| `number.creality_ender_3_s1_pro_extruder_target` | Température cible hotend (°C) |
| `number.creality_ender_3_s1_pro_speed_factor` | Facteur de vitesse (%) |
| `number.creality_ender_3_s1_pro_fan_speed` | Vitesse ventilateur (%) |

### Capteur filament (binary_sensor)

| Entité | Description |
|---|---|
| `binary_sensor.creality_ender_3_s1_pro_filament_sensor` | Présence filament (on = présent / off = absent) |

### Boutons d'action (button) — critiques

| Entité | Action |
|---|---|
| `button.creality_ender_3_s1_pro_emergency_stop` | 🚨 **Arrêt d'urgence Klipper** |
| `button.creality_ender_3_s1_pro_pause_print` | Pause impression |
| `button.creality_ender_3_s1_pro_resume_print` | Reprendre impression |
| `button.creality_ender_3_s1_pro_cancel_print` | Annuler impression |
| `button.creality_ender_3_s1_pro_start_print_from_queue` | Démarrer impression depuis la file |

### Boutons de contrôle (button) — homing et services

| Entité | Action |
|---|---|
| `button.creality_ender_3_s1_pro_home_x_axis` / `..._y_axis` / `..._z_axis` / `..._all_axes` | Homing axes |
| `button.creality_ender_3_s1_pro_macro_g29` | Macro G29 (auto-bed leveling) |
| `button.creality_ender_3_s1_pro_stop_klipper` / `..._start_klipper` / `..._restart_klipper` | Service Klipper systemd |
| `button.creality_ender_3_s1_pro_stop_klipper_mcu` / `..._start_klipper_mcu` / `..._restart_klipper_mcu` | Service Klipper MCU |
| `button.creality_ender_3_s1_pro_server_restart` / `..._host_restart` / `..._firmware_restart` / `..._host_shutdown` | Restart serveur Moonraker / host / firmware / shutdown host |
| `button.creality_ender_3_s1_pro_machine_update_refresh` | Refresh updates Moonraker |

### Caméra (camera)

| Entité | Description |
|---|---|
| `camera.creality_ender_3_s1_pro_creality_cam` | Webcam imprimante (stream Mainsail/Fluidd) |

## Services / Scripts utilisables

| Service HA | Cible | Usage |
|---|---|---|
| `button.press` | Boutons d'action (emergency_stop, pause, resume, cancel, home_*) | Déclencher action one-shot |
| `number.set_value` | `number.creality_ender_3_s1_pro_bed_target` | Régler température lit |
| `number.set_value` | `number.creality_ender_3_s1_pro_extruder_target` | Régler température hotend |

## Automations envisageables

| Automation | Trigger | Action |
|---|---|---|
| Notif fin impression | `sensor.creality_ender_3_s1_pro_progress` = 100 | `notify.mobile_app_might_iphone` (ATTENTION : T#88 push payload vide à résoudre avant) |
| Alerte erreur thermique | `sensor.creality_ender_3_s1_pro_extruder_temperature` > 280 °C | `button.press` sur emergency_stop + notif urgente |
| Alerte filament absent | `binary_sensor.creality_ender_3_s1_pro_filament_sensor` = off pendant impression | `button.press` sur pause_print + notif |
| Alerte intégration KO | `state` integration `moonraker` = `setup_retry` plus de 30 min | Notif (cas actuel S86) |

## Visualisation Lovelace

À documenter — typiquement page **Atelier** avec :

- Carte caméra (`picture-entity` sur `camera.creality_ender_3_s1_pro_creality_cam`)
- Carte gauge progression
- Tile températures bed/extruder + cibles
- Boutons emergency_stop / pause / resume / cancel

## Notes liées

- [[_Index|Hub Domotique]]
- [[../HomeAssistant/_Index|Domaine Home Assistant]]
- [[../Inventaire/Garage_Cave|Inventaire Atelier (à créer si distinct du Garage)]]

## Liens externes utiles

- Klipper docs : <https://www.klipper3d.org/>
- Moonraker docs : <https://moonraker.readthedocs.io/>
- Mainsail UI : <http://<ip-pi>/> (interface web Klipper)

---

*Fiche complétée S86 (2026-05-02) — T#80. Source MCP HA : `ha_get_integration(query="moonraker")` + `ha_get_device(integration="moonraker", detail_level="full")`. État noté `setup_retry` au moment de la rédaction — souci Klipper côté firmware à résoudre par Mickael.*
