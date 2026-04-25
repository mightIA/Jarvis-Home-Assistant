---
title: Dyson Purifier
created: 2026-04-25
tags: [domotique/dyson, ha/integrations]
status: actif
source: Ressources/Competences/Home_Assistant.md §9
---

# Dyson Purifier

Purificateur Dyson contrôlé via MQTT local (intégration `dyson_local`,
HACS `shenxn/ha-dyson`). Pas de cloud Dyson après la config initiale.

## Entités

| Entité | Type | Description |
|---|---|---|
| `fan.dyson_purifier` | Ventilateur | Entité principale (vitesse, direction, oscillation) |
| `sensor.dyson_purifier_temperature` | Capteur | Température ambiante |
| `sensor.dyson_purifier_humidity` | Capteur | Humidité |
| `sensor.dyson_purifier_volatile_organic_compounds` | Capteur | COV |
| `sensor.dyson_purifier_formaldehyde` | Capteur | Formaldéhyde HCHO |
| `sensor.dyson_purifier_particulate_matter_2_5` | Capteur | PM2.5 |
| `sensor.dyson_purifier_particulate_matter_10` | Capteur | PM10 |
| `sensor.dyson_purifier_nitrogen_dioxide` | Capteur | NO2 |

## Services spécifiques

| Service | Paramètres | Usage |
|---|---|---|
| `dyson_local.set_angle` | `angle_low`, `angle_high` | Définir angles d'oscillation |
| `fan.set_percentage` | `percentage` | Définir vitesse |
| `fan.set_direction` | `direction` (forward/reverse) | Sens du flux |
| `fan.oscillate` | `oscillating` (true/false) | On/Off oscillation |

## Scripts contrôle angles (4)

Pas de 10° avec snap automatique :

| Script | Action |
|---|---|
| `dyson_angle_low_plus` | Diminue `angle_low` de 10 (agrandit le cône) |
| `dyson_angle_low_minus` | Augmente `angle_low` de 10 (réduit le cône) |
| `dyson_angle_high_plus` | Augmente `angle_high` de 10 (agrandit le cône) |
| `dyson_angle_high_minus` | Diminue `angle_high` de 10 (réduit le cône) |

⚠️ **Logique Min inversée** : le bouton **+** agrandit le cône (diminue
la valeur min), le bouton **−** le réduit.

## Helpers `input_number`

| Helper | Min | Max | Pas | Mode |
|---|---|---|---|---|
| `input_number.dyson_angle_minimum` | 5 | 355 | 10 | slider |
| `input_number.dyson_angle_maximum` | 5 | 355 | 10 | slider |

## Automations de synchro bidirectionnelle (3)

| Automation | Trigger | Action |
|---|---|---|
| `dyson_sync_angle_min_to_fan` | `input_number.dyson_angle_minimum` change | `dyson_local.set_angle` |
| `dyson_sync_angle_max_to_fan` | `input_number.dyson_angle_maximum` change | `dyson_local.set_angle` |
| `dyson_sync_fan_to_sliders` | `fan.dyson_purifier` angle change | MAJ les 2 input_numbers |

## Visualisation SVG

Fichier : `/homeassistant/www/dyson_angle_viz.html`

Affiche un cône d'oscillation en temps réel via WebSocket HA. Thème
sombre. Labels Min/Max + amplitude. **Orientation conforme à l'app
Dyson** : Arrière (0°) en haut, Avant (180°) en bas.

## Page Lovelace (3 colonnes)

- **Colonne 1 — Contrôles** : thermostat, boutons ventilateur (Auto /
  Speed-/Speed+/Osciller), carte Vitesse/Sens fusionnée
  (`custom:button-card`), entités capteurs
- **Colonne 2 — SVG + Graphiques** : iframe SVG angles, affichage min/max,
  graphiques Température, Humidité, COV
- **Colonne 3 — Graphiques** : Formaldéhyde, PM2.5, PM10, NO2

### Carte Vitesse/Sens (custom:button-card)

- **Vitesse** : « Vitesse : XX% » via template JS. Clic → menu more-info
  du ventilateur pour régler.
- **Sens** : « Sens : Vers l'avant/arrière » avec icône dynamique. Clic =
  toggle direction (`fan.set_direction`).

## Notes liées

- [[../HomeAssistant/_Index]]
- [[../HomeAssistant/Intégrations]]
- Skill : `.claude/skills/dyson-purifier/`

---

*Source : `Ressources/Competences/Home_Assistant.md` §9.*
