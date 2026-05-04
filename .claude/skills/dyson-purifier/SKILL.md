---
name: dyson-purifier
description: Controle du purificateur Dyson Mickael via integration HACS dyson_local (MQTT local). DECLENCHEURS : 'qualite air', 'PM2.5', 'COV', 'formaldehyde', 'NO2', 'Dyson', 'purificateur', 'angle min/max', 'oscillation', 'allume/eteint le ventilo', 'change la vitesse', 'inverse le sens', 'ouvre/ferme le cone', 'temperature/humidite chambre Dyson'. Pilotage vitesse, sens, oscillation, angles min/max via service set_angle. Lecture capteurs qualite air. Visualisation SVG temps reel via /homeassistant/www/dyson_angle_viz.html.
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


## Exemples d'invocation utilisateur

- « Quelle est la qualite de l'air dans la chambre ? » → lecture PM2.5/COV/HCHO/NO2.
- « Mets le Dyson sur 5 » → `fan.set_percentage` avec percentage=50 (echelle 0-100).
- « Ferme l'angle a 100-180 » → `dyson_local.set_angle` avec angle_low=100, angle_high=180.
- « Inverse le sens du ventilo » → `fan.set_direction` direction=reverse.

## Quand NE PAS utiliser

- Si Mickael parle d'un autre purificateur ou capteur de qualite air NON-Dyson (autre integration).
- Pour les filtres / consommables Dyson : pas couvert ici, voir l'app Dyson directement.
- Pour les reglages avances MQTT (topics, retain) : passer par la skill `home-assistant-manager`.

## Pieges connus

- **Logique Min inversee** : le bouton + agrandit le cone (DIMINUE la valeur min). Toujours expliquer a Mickael avant d'appliquer.
- **percentage 1-100** : `fan.set_percentage` attend 1 a 100, pas 1 a 10. Diviser/multiplier selon contexte.
- **Bouton Auto** : il existe sur le Dyson, mais a tester avant de promettre — sur certains modeles `Auto` est un mode sur `select.dyson_purifier_mode` plutot qu'une vitesse.
- **Visualisation SVG** : depend de WebSocket actif. Si l'iframe ne se rafraichit pas, verifier `/api/websocket` cote HA.

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` section 9.
