---
name: ha-status
description: Recuperer le statut des appareils Home Assistant (lumieres, thermostat, cameras, prises, capteurs). Utilise le MCP Server natif HA via OAuth. Repond a des questions du type "donne-moi le statut de X", "qu'est-ce qui est allume", "temperature actuelle", "presence dans la maison".
---

# Skill : Statut Home Assistant

## Quand cette skill est declenchee

- Question sur l'etat d'un appareil precis ("est-ce que la lumiere de la
  chambre est allumee ?").
- Question sur l'etat global de la maison ("qu'est-ce qui est allume ?",
  "y a-t-il quelqu'un ?").
- Question sur les capteurs (temperature, humidite, presence).
- Demande de snapshot ou record d'une camera.

## Connexion

| Priorite | Source                                                    |
|----------|-----------------------------------------------------------|
| 1        | MCP Server natif HA via .mcp.json (OAuth 2.0)             |
| 2        | http://192.168.1.11:2096/ (REST API + token, fallback)    |
| 3        | https://ha.might.ovh/ (REST distant, dernier recours)     |

## Entites les plus consultees

### Lumieres et interrupteurs
- `light.ampoule_chambre` (Chambre)
- `light.ampoule_couloir_escalier_bas` (Couloir / escalier)
- `light.cuisine_1a4` (Cuisine — groupe ampoules 1 a 4)
- `light.ampoule_stockage` (Stockage)
- `light.miroirs` (Salle de bain)
- `light.ampoule_wc` (WC)
- `light.toutes_ampoules` (Groupe global)
- `input_boolean.interrupteurs_general` (Interrupteurs Entree / Haut / Bas)

### Climat et chaudiere
- `climate.maison_zone_1_2` — thermostat principal Frisquet
- `water_heater.chauffe_eau_maison_2` — chauffe-eau (modes MAX, Eco, Eco
  Timer, Stop)
- `sensor.maison_temperature_zone_1_2`
- `sensor.maison_alerte_2` — alertes chaudiere

### Cameras
- `camera.chambre_mediaprofile_channel1_mainstream`
- `camera.cuisine_profile100` (fixe)
- `camera.cuisine_profile000` (PTZ)

### Dyson Purifier
- `fan.dyson_purifier`
- `sensor.dyson_purifier_temperature`
- `sensor.dyson_purifier_humidity`
- `sensor.dyson_purifier_volatile_organic_compounds`
- `sensor.dyson_purifier_particulate_matter_2_5`

### Presence et localisation
- `device_tracker.iphone_mickael` (presence)
- `device_tracker.tablette_might`

## Actions courantes

Pour chaque action, utiliser `home_assistant.call_service` avec le service
approprie (`light.turn_on`, `climate.set_temperature`, `script.<nom>`).

## Regles de securite

- Toute action irreversible (extinction generale, redemarrage HA) demande
  confirmation a Mickael.
- Si MCP HA echoue 2-3 fois de suite : suspendre et verifier ban IP via
  la skill `debannissement-ip`.
- Jamais executer un script qui n'est pas dans la liste connue (voir
  skill `ha-scripts` ou `Ressources/Competences/Home_Assistant.md`).

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` pour la liste complete
des entites, scripts, et procedures HA.
