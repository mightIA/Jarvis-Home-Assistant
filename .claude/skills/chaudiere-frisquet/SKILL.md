---
name: chaudiere-frisquet
description: Pilotage de la chaudiere Frisquet via HA (integration HACS Frisquet Connect v2.5.4). Gestion des presets (confort, reduit, hors_gel, vacances, confort_permanent, reduit_permanent), du chauffe-eau, lecture des consommations chauffage et eau chaude, alertes. Comprend la difference entre derogation temporaire (mode Auto) et changement permanent.
---

# Skill : Chaudiere Frisquet

## Quand cette skill est declenchee

- Question sur la chaudiere, le chauffage, la temperature du salon.
- Demande de changement de mode (confort, reduit, eco, vacances).
- Question sur le chauffe-eau (modes MAX, Eco, Eco Timer, Stop).
- Question sur la consommation chauffage / eau chaude.
- Alerte chaudiere a investiguer.

## Integration

`TheGui01/Frisquet-connect-for-home-assistant` v2.5.4 (HACS).

## Entites cles

| Entite                                  | Type        | Description                       |
|-----------------------------------------|-------------|-----------------------------------|
| `climate.maison_zone_1_2`               | Thermostat  | Zone chauffage principale         |
| `water_heater.chauffe_eau_maison_2`     | Chauffe-eau | Modes MAX / Eco / Eco Timer / Stop|
| `sensor.maison_alerte_2`                | Capteur     | Alertes chaudiere                 |
| `sensor.maison_consommation_chauffage_2`| Capteur     | Conso chauffage cumul (kWh)       |
| `sensor.maison_consommation_eau_chaude_2`| Capteur    | Conso eau chaude cumul (kWh)      |
| `sensor.maison_temperature_zone_1_2`    | Capteur     | Temperature Zone 1                |

**Note :** le suffixe `_2` est du a une reinstallation de l'integration.

## Systeme de derogation Frisquet

**Mode Auto** = la chaudiere suit les cycles programmes (creneaux reduit /
confort definis dans l'app Frisquet).

Changer le preset en `confort` ou `reduit` depuis HA en mode Auto cree une
**derogation temporaire** qui dure uniquement jusqu'au prochain changement
de cycle programme. Ensuite ca revient automatiquement au planning.

## Pour un changement permanent

| Preset               | Effet                                                       | HVAC mode |
|----------------------|-------------------------------------------------------------|-----------|
| `confort_permanent`  | Reste en confort jusqu'a changement manuel                  | heat      |
| `reduit_permanent`   | Reste en reduit jusqu'a changement manuel                   | heat      |
| `hors_gel`           | Mode hors-gel                                                | off       |
| `vacances`           | Mode vacances                                                | off       |
| `confort` / `reduit` | Derogation temporaire (revient au planning au prochain cycle)| auto      |

## Page Lovelace dediee

Vue masonry, une seule colonne vertical-stack :
- Thermostat 'Chaudiere Frisquet' (temperature reglable +/-)
- 4 boutons : Confort | Reduit | Hors gel | Auto (avec confirmation)
- Entites : Chauffe-eau, Alerte, Consommation Chauffage, Consommation Eau
  Chaude, Temperature Zone 1
- Graphique 'Consommation journaliere' (barres, 21 jours, chauffage + eau
  chaude)

## Regles de securite

- Toujours confirmer avant de basculer en `vacances` ou `hors_gel`
  (impact sur le confort).
- Si alerte chaudiere active : prevenir Mickael en priorite, ne pas faire
  de changement avant lecture de l'alerte.

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` section 6.
