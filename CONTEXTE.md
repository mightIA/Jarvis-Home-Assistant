---
title: Contexte Jarvis
owner: Mickael Rubino
location: Seremange-Erzange (57)
last_update: 2026-04-19
---

# Contexte Jarvis — Etat persistant du setup

## 1. Profil Mickael

| Champ          | Valeur                                           |
|----------------|--------------------------------------------------|
| Nom            | Mickael (Seremange-Erzange, 57)                  |
| Niveau IA      | Debutant — decouverte de l'ecosysteme Claude     |
| Profil tech    | Pas developpeur — sait faire du petit code occasionnel |
| Systeme        | Windows (PC allume 24h/24)                       |
| Abonnement     | Claude Max (137 EUR/mois)                        |

## 2. Setup technique

| Element         | Statut                                          |
|-----------------|-------------------------------------------------|
| Cowork          | Installe sur PC Mickael (mode principal)        |
| iPhone Dispatch | App Claude iPhone — pilotage a distance         |
| Navigateur      | **Brave** (Chromium) + extension **Claude in Chrome** |
| Tab ID Brave    | A verifier en debut de session (change a chaque ouverture) |

## 3. Acces reseau Home Assistant

| Parametre              | Valeur                                       |
|------------------------|----------------------------------------------|
| URL locale (priorite)  | http://192.168.1.11:2096/                    |
| URL distante (fallback)| https://ha.might.ovh/  (Cloudflare, OVH)     |
| MCP Server HA          | http://192.168.1.11:2096/mcp_server/sse (OAuth 2.0) |
| Port SSH               | 22 (local uniquement, non expose internet)   |
| Auth SSH               | Mot de passe (a ameliorer : cles SSH)        |

## 4. Cameras Dahua

| Camera       | Entite HA                                             | MAC               |
|--------------|-------------------------------------------------------|-------------------|
| Chambre      | camera.chambre_mediaprofile_channel1_mainstream       | c4:aa:c4:b6:68:40 |
| Cuisine fixe | camera.cuisine_profile100                             | f8:ce:07:b5:5b:f6 |
| Cuisine PTZ  | camera.cuisine_profile000                             | f8:ce:07:b5:5b:f6 |

App mobile : DMSS. Protocole : ONVIF.
Structure medias : `/media/cameras/<camera>/photo/` et `/video/`.
Detail des scripts (snapshot, record, vider) dans la skill `cameras-dahua`
et dans `Ressources/Competences/Home_Assistant.md` section 5.

## 5. Add-ons Home Assistant installes

ESPHome (transmetteurs IR), Zigbee2MQTT (ampoules, prises, capteurs),
EcoFlow River 2 Pro (batterie portable connectee), Frigate
(videosurveillance), HACS (integrations communautaires),
Music Assistant, AdGuard Home, Studio Code Server, Terminal & SSH,
File Editor.

## 6. Integrations HACS notables

| Integration                   | Usage                                 |
|-------------------------------|---------------------------------------|
| dyson_local (shenxn/ha-dyson) | Controle MQTT local du Dyson Purifier |
| Frisquet Connect (TheGui01)   | Pilotage chaudiere Frisquet v2.5.4    |
| Browser Mod (thomasloven)     | Controle navigateur, badges (v2.10.2) |
| EcoFlowCloud                  | Batterie EcoFlow River 2 Pro v1.4.1   |
| iCloud3                       | Suivi localisation iPhone v3.4.3      |
| custom:button-card            | Boutons personnalises Lovelace        |

## 7. Pages dashboard Lovelace

19 onglets actifs, badges universels (Refresh / Back / Forward / Jour / Nuit
/ Capteurs mouvement) sur toutes les vues.

Pages principales :

- **Home** (default_view) — masonry 2 colonnes : meteo + entites Mickael
  (iPhone, Watch, Tablette).
- **Lumieres & Interrupteurs** (lumieres-pieces) — sections 3 colonnes par
  piece.
- **Cameras** (camera) — sections 3 colonnes (Chambre / Cuisine fixe /
  Cuisine PTZ) avec boutons Dossier / Photo / Video / Supprimer + flux
  Frigate.
- **Media** (ordinateur-media) — Samsung Q80 65 pouces + PC-Might.
- **Dyson Purifier** (dyson-purifier) — 3 colonnes (Controles / SVG +
  graphiques / Graphiques supplementaires).
- **Chaudiere Frisquet** — vue masonry, thermostat + 4 boutons presets
  permanents + graphique consommation journaliere.

## 8. Chaudiere Frisquet — entites cles

| Entite                                 | Type        |
|----------------------------------------|-------------|
| climate.maison_zone_1_2                | Thermostat  |
| water_heater.chauffe_eau_maison_2      | Chauffe-eau |
| sensor.maison_alerte_2                 | Alertes     |
| sensor.maison_consommation_chauffage_2 | Conso chauffage cumul (kWh) |
| sensor.maison_consommation_eau_chaude_2| Conso eau chaude cumul (kWh) |
| sensor.maison_temperature_zone_1_2     | Temperature Zone 1 |

Presets permanents : `confort_permanent`, `reduit_permanent`, `hors_gel`,
`vacances`. En mode Auto, changements = derogations temporaires.

## 9. Systeme de gestion des emails

| Boite                  | Outil principal                       | Tache planifiee                     |
|------------------------|---------------------------------------|-------------------------------------|
| might57290@gmail.com   | MCP Gmail (lecture) + Navigateur      | tri-email-gmail-quotidien (5h, 14h) |
| might@live.fr          | Navigateur uniquement (pas de MCP)    | tri-email-outlook-quotidien (5h, 14h) |

Auto-apprentissage : whitelist / blacklist / learning_log dans
`Ressources/Data/gmail_patterns/` et `outlook_patterns/`.
Scores de confiance : 100 = spam evident, 90-99 = suppression auto avec
rapport, 70-89 = validation Mickael, sous 70 = ne pas supprimer.

## 10. Points importants a retenir

- WebSocket : toujours `hass.callWS` pour lire/ecrire config Lovelace.
- Reload scripts : Parametres > Outils dev > YAML > Scripts apres modif
  scripts.yaml.
- Reload config : Recharger configuration entiere apres modif
  configuration.yaml.
- Ban IP : permanent — procedure dans la skill `debannissement-ip`.
- Tab ID Brave : change a chaque session, toujours verifier en debut (extension Claude in Chrome dans Brave).
- Presets Dahua : ONVIF a creer via interface web camera, pas DMSS.
- File Editor : accessible local et distant, utile pour supprimer
  ip_bans.yaml.
- Confidentialite : donnees (IP, tokens, config) strictement confidentielles.

---

*Fin de CONTEXTE.md — derniere mise a jour 19 avril 2026*
