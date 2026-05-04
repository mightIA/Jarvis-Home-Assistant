---
name: ha-status
description: Recuperer le statut des entites Home Assistant. DECLENCHEURS : 'donne le statut de X', 'qu'est-ce qui est allume ?', 'temperature actuelle', 'humidite chambre', 'qui est a la maison ?', 'presence Mickael', 'la lumiere Y est-elle ON ?', 'capteur de mouvement', 'etat porte/fenetre', 'overview HA'. Lecture seule via MCP HA (`ha_get_state`, `ha_get_overview`, `ha_search_entities`) avec fallback REST 192.168.1.11:2096 puis ha.might.ovh. Couvre lumieres, climat, cameras, presence, capteurs Dyson.
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


## Exemples d'invocation utilisateur

- « La lumiere de la chambre est allumee ? » → `ha_get_state` entity_id=light.ampoule_chambre.
- « Quelle temperature dans le salon ? » → `ha_get_state` entity_id=sensor.maison_temperature_zone_1_2.
- « Qui est a la maison ? » → `ha_get_state` entity_id=person.mickael (+ device_tracker associes).
- « Donne moi un overview » → `ha_get_overview` detail_level=minimal.
- « Toutes les ampoules allumees » → `ha_search_entities` domain=light state=on.

## Quand NE PAS utiliser

- Pour MODIFIER un etat (allumer/eteindre) → utiliser `ha-scripts` ou directement `ha_call_service`.
- Pour les entites NON HA (capteur externe non integre, app tierce) — pas dans le perimetre.
- Pour les logs / historique long terme — utiliser `ha_get_history` (skill `home-assistant-manager`).
- Pour le diagnostic d'un ban IP — basculer sur skill `debannissement-ip` apres 2-3 erreurs 401/403.

## Pieges connus

- **Suffixe `_2`** sur les entites Frisquet (climate.maison_zone_1_2, water_heater.chauffe_eau_maison_2, sensor.maison_temperature_zone_1_2, sensor.maison_alerte_2). Eviter les anciennes versions sans `_2` — orphelines.
- **MCP HA peut renvoyer 144 entites `unavailable`** sur `sensor` (vu en S75). C'est normal sur l'install Mickael, ne pas alerter sauf si entite SPECIFIQUE attendue.
- **Limite contexte** : `ha_get_overview` detail_level=full peut renvoyer >1000 entites. Toujours commencer en `minimal` avec `limit:5-20`.
- **Fallback REST** = dernier recours. Si le MCP HA echoue 2 fois, NE PAS retomber automatiquement sur REST sans verifier d'abord ban IP.

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` pour la liste complete
des entites, scripts, et procedures HA.
