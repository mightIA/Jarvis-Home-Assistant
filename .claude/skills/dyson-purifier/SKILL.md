---
name: dyson-purifier
description: Controle du purificateur Dyson via integration HACS dyson_local (MQTT local). Pilotage vitesse, sens, oscillation, angles min/max via service set_angle. Lecture des capteurs qualite air (temperature, humidite, COV, formaldehyde, PM2.5, PM10, NO2). Visualisation SVG temps reel via /homeassistant/www/dyson_angle_viz.html.
---

# Skill : Dyson Purifier

## Quand cette skill est declenchee

- Question sur le Dyson, la qualite de l'air, l'oscillation, la vitesse.
- Demande de reglage des angles min/max.
- Lecture des capteurs (PM2.5, COV, formaldehyde).

## Integration

`shenxn/ha-dyson` (HACS) via `dyson_local` — controle MQTT local.

## Entites principales

| Entite                                              | Type        |
|-----------------------------------------------------|-------------|
| `fan.dyson_purifier`                                | Ventilateur |
| `sensor.dyson_purifier_temperature`                 | Temperature |
| `sensor.dyson_purifier_humidity`                    | Humidite    |
| `sensor.dyson_purifier_volatile_organic_compounds`  | COV         |
| `sensor.dyson_purifier_formaldehyde`                | HCHO        |
| `sensor.dyson_purifier_particulate_matter_2_5`      | PM2.5       |
| `sensor.dyson_purifier_particulate_matter_10`       | PM10        |
| `sensor.dyson_purifier_nitrogen_dioxide`            | NO2         |

## Services specifiques

| Service                  | Parametres                | Usage                         |
|--------------------------|---------------------------|-------------------------------|
| `dyson_local.set_angle`  | angle_low, angle_high     | Definir les angles d'oscillation|
| `fan.set_percentage`     | percentage                | Vitesse du ventilateur        |
| `fan.set_direction`      | direction (forward/reverse)| Sens du flux d'air           |
| `fan.oscillate`          | oscillating (true/false)  | Activer/desactiver oscillation|

## Scripts angles (par paliers de 10 degres)

| Script                       | Action                                       |
|------------------------------|----------------------------------------------|
| `dyson_angle_low_plus`       | Diminue angle_low de 10 (agrandit le cone)   |
| `dyson_angle_low_minus`      | Augmente angle_low de 10 (reduit le cone)    |
| `dyson_angle_high_plus`      | Augmente angle_high de 10 (agrandit le cone) |
| `dyson_angle_high_minus`     | Diminue angle_high de 10 (reduit le cone)    |

**Logique Min inversee** : le bouton + agrandit le cone (diminue la valeur min).

## Helpers input_number (sliders)

| Helper                              | Min | Max | Pas | Mode   |
|-------------------------------------|-----|-----|-----|--------|
| `input_number.dyson_angle_minimum`  | 5   | 355 | 10  | slider |
| `input_number.dyson_angle_maximum`  | 5   | 355 | 10  | slider |

## Automations de synchronisation

| Automation                       | Trigger                              | Action |
|----------------------------------|--------------------------------------|--------|
| `dyson_sync_angle_min_to_fan`    | input_number.dyson_angle_minimum change | dyson_local.set_angle |
| `dyson_sync_angle_max_to_fan`    | input_number.dyson_angle_maximum change | dyson_local.set_angle |
| `dyson_sync_fan_to_sliders`      | fan.dyson_purifier angle change      | MAJ des 2 input_numbers |

## Visualisation SVG

Fichier : `/homeassistant/www/dyson_angle_viz.html`

Affiche un cone d'oscillation en temps reel via WebSocket HA. Theme sombre.
Labels Min/Max et amplitude. Orientation conforme a l'app Dyson : Arriere
(0 deg) en haut, Avant (180 deg) en bas.

## Page Lovelace Dyson Purifier (3 colonnes)

- **Col 1** : Thermostat, boutons ventilateur (Auto/Speed-/Speed+/Osciller),
  carte Vitesse/Sens fusionnee (`custom:button-card`), entites capteurs.
- **Col 2** : iframe SVG visualisation angles, affichage angles min/max,
  graphiques Temperature, Humidite, COV.
- **Col 3** : Graphiques Formaldehyde, PM2.5, PM10, NO2.

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` section 9.
