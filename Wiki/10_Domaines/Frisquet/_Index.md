---
title: Chaudière Frisquet — Index du domaine
created: 2026-04-25
updated: 2026-04-25
tags: [moc, domotique/chauffage, ha/frisquet]
status: actif
source: Ressources/Competences/Home_Assistant.md §6
---

# Chaudière Frisquet — Index du domaine

Pilotage de la chaudière Frisquet de la maison via Home Assistant.

## Intégration

- HACS : **`TheGui01/Frisquet-connect-for-home-assistant`** v2.5.4
- Domaine HA : `frisquet_connect`
- Compte Frisquet : *Maison*

## Entités

| Entité | Type | Description |
|---|---|---|
| `climate.maison_zone_1_2` | Thermostat | Zone chauffage principale |
| `water_heater.chauffe_eau_maison_2` | Chauffe-eau | Modes : MAX / Eco / Eco Timer / Stop |
| `sensor.maison_alerte_2` | Capteur | Alertes chaudière |
| `sensor.maison_consommation_chauffage_2` | Capteur | Conso chauffage cumulée (kWh) |
| `sensor.maison_consommation_eau_chaude_2` | Capteur | Conso eau chaude cumulée (kWh) |
| `sensor.maison_temperature_zone_1_2` | Capteur | Température Zone 1 |

ℹ️ Le suffixe `_2` provient d'une réinstallation de l'intégration.

## Système de dérogation Frisquet

**Mode Auto** = la chaudière suit les cycles programmés (créneaux
réduit/confort définis dans l'app Frisquet).

Changer le preset en `confort` ou `reduit` depuis HA en mode Auto crée
une **dérogation temporaire** qui dure jusqu'au prochain changement de
cycle programmé. Ensuite ça revient automatiquement au planning.

## Presets disponibles

| Preset | Effet | HVAC mode |
|---|---|---|
| `confort_permanent` | Reste en confort jusqu'à changement manuel | `heat` |
| `reduit_permanent` | Reste en réduit jusqu'à changement manuel | `heat` |
| `hors_gel` | Mode hors-gel | `off` |
| `vacances` | Mode vacances | `off` |
| `comfort` / `reduit` | Dérogation temporaire (revient au planning) | `auto` |

## Page Lovelace Chaudière

Vue **masonry**, une seule colonne `vertical-stack` :

- Thermostat **« Chaudière Frisquet »** (température réglable +/-)
- 4 boutons : Confort / Réduit / Hors gel / Auto (avec confirmation)
- Entités : Chauffe-eau, Alerte, Conso Chauffage, Conso Eau Chaude, Temp Zone 1
- Graphique **« Consommation journalière »** (barres, 21 jours, chauffage + eau chaude)

## Notes liées

- [[../HomeAssistant/_Index]]
- [[../HomeAssistant/Modifications config]] — recharger après modif scripts/Lovelace
- Skill : `.claude/skills/chaudiere-frisquet/`

---

*Source : `Ressources/Competences/Home_Assistant.md` §6 + `Home_Assistant_Inventaire.md` §5.5.*
