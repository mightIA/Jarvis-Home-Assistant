# Compétence Home Assistant

> Procédures opérationnelles et compétences techniques — Jarvis (Projet PERSO)
> **Document de référence pour toutes les opérations Home Assistant. À consulter en priorité lors de toute intervention technique.**
>
> Source : Competence_Home_Assistant.pdf — Version 4 — 18 avril 2026

---

## 1. PROTOCOLE DE CONNEXION

### 1.1 Connexion locale (priorité)
- URL : `http://192.168.1.11:2096/`
- Toujours privilégier cette connexion
- Vérifier que le PC est sur le réseau local

### 1.2 Connexion distante (fallback)
- URL : `https://ha.might.ovh/`
- Utiliser si la connexion locale est indisponible
- Fonctionne depuis n'importe où

### 1.3 Règles de connexion
- Si 2-3 erreurs 401/403 consécutives : **STOP** — vérifier si l'IP est bannie
- Ne pas répéter les appels API qui échouent
- Si premier ban de la session : proposer désactivation temporaire du bannissement
- Après débannissement : toujours tester `http://192.168.1.11:2096` et basculer en local

---

## 2. SUPPRESSION BAN IP

### RÈGLES AVANT DE SUPPRIMER UN BAN
- **Règle 1 :** Vérifier l'heure du ban — si plus de 30 minutes, prévenir Mickael
- **Règle 2 :** Vérifier le nombre d'IPs bannies — si plusieurs, prévenir Mickael
- **Règle 3 :** Après débannissement, toujours tester la connexion locale

### 2.1 Méthode 1 (PRIORITÉ) — Terminal SSH local via Brave
À utiliser en premier. Fonctionne sur le réseau local. Procédure testée et validée depuis PC. À retester depuis Dispatch/iPhone (voir TASKS.md #17).

- **Étape 1** — Ouvrir cette URL dans Brave : `http://192.168.1.11:2096/hassio/addon/core_ssh/info`
- **Étape 2** — Cliquer sur le bouton bleu « Ouvrir l'interface utilisateur Web »
- **Étape 3** — Dans le terminal, taper cette commande :

```bash
cat /homeassistant/ip_bans.yaml 2>/dev/null && rm -f /homeassistant/ip_bans.yaml && ha core restart || echo 'Pas de ban IP actif'
```

- **Étape 4** — Attendre 30 secondes puis tester : `http://192.168.1.11:2096`

### 2.2 Méthode 2 — File Editor via URL distante
À utiliser si la connexion locale est impossible.
- Ouvrir : `https://ha.might.ovh/hassio/addon/core_configurator/info`
- Naviguer dans les fichiers, chercher `ip_bans.yaml` dans `homeassistant/`
- Si absent = aucun ban actif. Sinon, supprimer le fichier.

---

## 3. ACCÈS SSH

| Paramètre | Valeur | Statut |
|---|---|---|
| IP locale HA | 192.168.1.11 | Confirmé |
| Port SSH | 22 | Confirmé |
| Authentification | Mot de passe | À améliorer (clés SSH) |
| Exposition internet | Non (local uniquement) | Sûr |
| URL distante HA | https://ha.might.ovh/ | Fonctionnel |

---

## 4. MODIFICATIONS DE CONFIGURATION

### 4.1 Quand recharger vs redémarrer

| Type de modification | Action requise | Comment faire |
|---|---|---|
| scripts.yaml | Rechargement scripts | Paramètres > Outils de dev > YAML > Scripts |
| automations.yaml | Rechargement automations | Paramètres > Outils de dev > YAML > Automations |
| configuration.yaml | Rechargement config entière | Paramètres > Outils de dev > YAML > Recharger |
| shell_command (nouveau) | Redémarrage complet | Paramètres > Système > Redémarrer |
| Lovelace (dashboard) | Aucun rechargement | Modifications via `hass.callWS` en temps réel |
| Ajout intégration | Redémarrage complet | Paramètres > Système > Redémarrer |
| Modification core | Redémarrage complet | Paramètres > Système > Redémarrer |

### 4.2 Lovelace — Lecture/Écriture
Toujours utiliser `hass.callWS` pour lire et écrire la configuration Lovelace. Ne pas modifier les fichiers dashboard directement — utiliser l'API WebSocket.

---

## 5. GESTION DES CAMÉRAS

### 5.1 Configuration

| Caméra | Entité HA | MAC |
|---|---|---|
| Chambre | `camera.chambre_mediaprofile_channel1_mainstream` | c4:aa:c4:b6:68:40 |
| Cuisine fixe | `camera.cuisine_profile100` | f8:ce:07:b5:5b:f6 |
| Cuisine PTZ | `camera.cuisine_profile000` | f8:ce:07:b5:5b:f6 |

### 5.2 Structure médias
```
/media/cameras/
├── chambre/photo/
├── chambre/video/
├── cuisine_fixe/photo/
├── cuisine_fixe/video/
├── cuisine_ptz/photo/
└── cuisine_ptz/video/
```

### 5.3 Scripts caméras

| Script | Action | Durée |
|---|---|---|
| cam_snapshot_chambre | `camera.snapshot` → chambre/photo/ | — |
| cam_snapshot_cuisine_fixe | `camera.snapshot` → cuisine_fixe/photo/ | — |
| cam_snapshot_cuisine_ptz | `camera.snapshot` → cuisine_ptz/photo/ | — |
| cam_record_chambre | `camera.record` → chambre/video/ | 120s |
| cam_record_cuisine_fixe | `camera.record` → cuisine_fixe/video/ | 120s |
| cam_record_cuisine_ptz | `camera.record` → cuisine_ptz/video/ | 120s |
| cam_vider_dossier | Efface tout (dossiers conservés) | — |
| cam_vider_chambre | Efface chambre uniquement | — |
| cam_vider_cuisine_fixe | Efface cuisine_fixe uniquement | — |
| cam_vider_cuisine_ptz | Efface cuisine_ptz uniquement | — |

### 5.4 Shell commands associés

| Commande | Action |
|---|---|
| `shell_command.vider_cameras` | Supprime tout `/media/cameras/*/photo/*` et `*/video/*` |
| `shell_command.vider_chambre` | Supprime `/media/cameras/chambre/photo/*` et `video/*` |
| `shell_command.vider_cuisine_fixe` | Supprime `/media/cameras/cuisine_fixe/photo/*` et `video/*` |
| `shell_command.vider_cuisine_ptz` | Supprime `/media/cameras/cuisine_ptz/photo/*` et `video/*` |

### 5.5 Page Lovelace Caméras (session 18/04/2026)
Vue `sections` à 3 colonnes (Chambre, Cuisine fixe, Cuisine PTZ). Chaque section contient :
- **Ligne 1** : 4 boutons — Dossier (ouvre media browser caméra spécifique) | Photo | Vidéo | Supprimer (avec confirmation, caméra spécifique)
- **Titre** : nom de la caméra
- **Flux vidéo** : carte Frigate
- **Cuisine PTZ** : contrôles PTZ supplémentaires (Fav 1-5, flèches directionnelles)

### 5.6 PTZ Favoris + Ronde 360° (S82)

| Bouton HA | Service appelé                                                  | Statut |
|-----------|-----------------------------------------------------------------|--------|
| 360°      | `script.cuisine_ptz_ronde` (cycle Fav 1→2→3→4, 5s chaque ~20s)  | OK S82 |
| Fav 1     | `onvif.ptz` `move_mode=GotoPreset` `preset="1"`                 | OK     |
| Fav 2     | `onvif.ptz` `move_mode=GotoPreset` `preset="2"`                 | OK     |
| Fav 3     | `onvif.ptz` `move_mode=GotoPreset` `preset="3"`                 | OK     |
| Fav 4     | `onvif.ptz` `move_mode=GotoPreset` `preset="4"`                 | OK     |

**Note S82** : l'ancien bouton « Fav 5 » a été reconverti en bouton « 360° »
qui appelle `script.cuisine_ptz_ronde` (cycle automatique des 4 favoris,
5 s sur chaque, total ~20 s, sans record). Position : 1re du groupe (avant
Fav 1). T#7 fermée S82 par approche alternative (pas de preset 5 côté caméra).

---

## 6. CHAUDIÈRE FRISQUET

### 6.1 Intégration
Intégration HACS : `TheGui01/Frisquet-connect-for-home-assistant` v2.5.4

| Entité | Type | Description |
|---|---|---|
| `climate.maison_zone_1_2` | Thermostat | Zone chauffage principale |
| `water_heater.chauffe_eau_maison_2` | Chauffe-eau | Modes : MAX, Eco, Eco Timer, Stop |
| `sensor.maison_alerte_2` | Capteur | Alertes chaudière |
| `sensor.maison_consommation_chauffage_2` | Capteur | Conso chauffage cumul (kWh) |
| `sensor.maison_consommation_eau_chaude_2` | Capteur | Conso eau chaude cumul (kWh) |
| `sensor.maison_temperature_zone_1_2` | Capteur | Température Zone 1 |

**Note :** Le suffixe `_2` sur les entités est dû à une réinstallation de l'intégration.

### 6.2 Système de dérogation Frisquet
**Mode Auto** = la chaudière suit les cycles programmés (créneaux réduit/confort définis dans l'app Frisquet).

Changer le preset en 'confort' ou 'reduit' depuis HA en mode Auto crée une **dérogation temporaire** qui dure uniquement jusqu'au prochain changement de cycle programmé. Ensuite ça revient automatiquement au planning.

**Pour un changement permanent :**

| Preset | Effet | HVAC mode |
|---|---|---|
| confort_permanent | Reste en confort jusqu'à changement manuel | heat |
| reduit_permanent | Reste en réduit jusqu'à changement manuel | heat |
| hors_gel | Mode hors-gel | off |
| vacances | Mode vacances | off |
| comfort / reduit | Dérogation temporaire (revient au planning) | auto |

### 6.3 Page Lovelace Chaudière
Vue masonry, une seule colonne vertical-stack :
- Thermostat 'Chaudière Frisquet' (température réglable +/-)
- 4 boutons : Confort | Réduit | Hors gel | Auto (avec confirmation)
- Entités : Chauffe-eau, Alerte, Consommation Chauffage, Consommation Eau Chaude, Température Zone 1
- Graphique 'Consommation journalière' (barres, 21 jours, chauffage + eau chaude)

---

## 7. BADGES DE NAVIGATION (toutes les vues)

Badges ajoutés sur les 19 onglets Lovelace (session 18/04/2026) :

| Badge | Icône | Action |
|---|---|---|
| Rafraîchir | `mdi:refresh` | `browser_mod.refresh` (F5 réel) |
| Page précédente | `mdi:arrow-left` | `history.back()` via `browser_mod.javascript` |
| Page suivante | `mdi:arrow-right` | `history.forward()` via `browser_mod.javascript` |
| Jour | `scene.jour` (icône soleil) | Active `scene.jour` |
| Nuit | `scene.nuit` (icône lune) | Active `scene.nuit` |
| Capteurs mouvement | `mdi:motion-sensor` | Active script capteurs |

**Prérequis :** Browser Mod (HACS) doit être installé et configuré.

---

## 8. BROWSER MOD

Intégration HACS : `thomasloven/hass-browser_mod` v2.10.2 — installée le 18/04/2026.

Services utiles :

| Service | Usage |
|---|---|
| `browser_mod.refresh` | Rafraîchir la page (équivalent F5) |
| `browser_mod.javascript` | Exécuter du JavaScript (ex: `history.back()`) |
| `browser_mod.navigate` | Naviguer vers un chemin |
| `browser_mod.popup` | Afficher un popup |
| `browser_mod.notification` | Afficher une notification |

Utilisation dans les badges via `tap_action: fire-dom-event` + `browser_mod`.

---

## 9. DYSON PURIFIER

### 9.1 Intégration dyson_local
Intégration HACS : `shenxn/ha-dyson` via `dyson_local`. Contrôle MQTT local du purificateur Dyson.

| Entité | Type | Description |
|---|---|---|
| `fan.dyson_purifier` | Ventilateur | Entité principale (vitesse, direction, oscillation) |
| `sensor.dyson_purifier_temperature` | Capteur | Température ambiante |
| `sensor.dyson_purifier_humidity` | Capteur | Humidité ambiante |
| `sensor.dyson_purifier_volatile_organic_compounds` | Capteur | COV (Composés Organiques Volatils) |
| `sensor.dyson_purifier_formaldehyde` | Capteur | Formaldéhyde (HCHO) |
| `sensor.dyson_purifier_particulate_matter_2_5` | Capteur | PM2.5 |
| `sensor.dyson_purifier_particulate_matter_10` | Capteur | PM10 |
| `sensor.dyson_purifier_nitrogen_dioxide` | Capteur | NO2 (Dioxyde d'azote) |

### 9.2 Services spécifiques

| Service | Paramètres | Usage |
|---|---|---|
| `dyson_local.set_angle` | angle_low, angle_high | Définir les angles d'oscillation |
| `fan.set_percentage` | percentage | Définir la vitesse du ventilateur |
| `fan.set_direction` | direction (forward/reverse) | Changer le sens du flux d'air |
| `fan.oscillate` | oscillating (true/false) | Activer/désactiver l'oscillation |

### 9.3 Scripts de contrôle des angles
4 scripts créent un contrôle par paliers de 10 degrés avec snap automatique :

| Script | Action |
|---|---|
| `dyson_angle_low_plus` | Diminue angle_low de 10 (agrandit le cône) |
| `dyson_angle_low_minus` | Augmente angle_low de 10 (réduit le cône) |
| `dyson_angle_high_plus` | Augmente angle_high de 10 (agrandit le cône) |
| `dyson_angle_high_minus` | Diminue angle_high de 10 (réduit le cône) |

**Logique Min inversée :** le bouton + agrandit le cône (diminue la valeur min), le bouton − réduit le cône.

### 9.4 Input numbers et automations
2 helpers `input_number` pour les sliders d'angle :

| Helper | Min | Max | Pas | Mode |
|---|---|---|---|---|
| `input_number.dyson_angle_minimum` | 5 | 355 | 10 | slider |
| `input_number.dyson_angle_maximum` | 5 | 355 | 10 | slider |

3 automations de synchronisation bidirectionnelle :

| Automation | Trigger | Action |
|---|---|---|
| `dyson_sync_angle_min_to_fan` | `input_number.dyson_angle_minimum` change | `dyson_local.set_angle` |
| `dyson_sync_angle_max_to_fan` | `input_number.dyson_angle_maximum` change | `dyson_local.set_angle` |
| `dyson_sync_fan_to_sliders` | `fan.dyson_purifier` angle change | Met à jour les 2 input_numbers |

### 9.5 Visualisation SVG
Fichier : `/homeassistant/www/dyson_angle_viz.html`

Affiche un cône d'oscillation en temps réel via WebSocket HA. Thème sombre. Labels Min/Max et amplitude. Orientation conforme à l'app Dyson : Arrière (0°) en haut, Avant (180°) en bas.

### 9.6 Page Lovelace Dyson Purifier (3 colonnes)
- **Colonne 1 — Contrôles** : Thermostat, boutons ventilateur (Auto/Speed-/Speed+/Osciller), carte Vitesse/Sens fusionnée (`custom:button-card`), entités capteurs
- **Colonne 2 — SVG + Graphiques** : iframe SVG angles, affichage angles min/max, graphiques Température, Humidité, COV
- **Colonne 3 — Graphiques** : Formaldéhyde, PM2.5, PM10, NO2

### 9.7 Carte Vitesse/Sens
Carte entities avec 2 lignes `custom:button-card` :
- **Vitesse** : affiche 'Vitesse : XX%' via template JS. Clic ouvre le menu more-info du ventilateur pour régler la vitesse.
- **Sens** : affiche 'Sens : Vers l'avant/arrière' avec icône dynamique. Clic = toggle direction (call-service `fan.set_direction`).

---

## 10. PROCÉDURES DIAGNOSTIQUES

### 10.1 Appareil ne répond plus
- Vérifier si l'appareil est en ligne (ping)
- Vérifier Zigbee2MQTT si appareil Zigbee
- Redémarrer l'add-on Zigbee2MQTT si nécessaire
- Vérifier les piles (transmetteurs IR, capteurs)

### 10.2 Interface HA ne charge pas
- Vérifier la connexion locale `http://192.168.1.11:2096`
- Si 403 : vérifier ban IP → suivre procédure Section 2
- Basculer en distant si nécessaire
- Vérifier les logs HA pour erreurs

### 10.3 Caméra ne s'affiche pas
- Vérifier le flux dans Lovelace
- Tenter un rafraîchissement de la page
- Vérifier la connectivité réseau de la caméra
- Vérifier ONVIF dans les intégrations HA

---

## 11. CRÉATION D'AUTOMATISATIONS EN YAML

### 11.1 Structure type
```yaml
automation:
  - alias: "Nom"
    trigger:
      - platform: ...
    condition: []
    action:
      - service: ...
```

### 11.2 Bonnes pratiques
- Toujours nommer l'automatisation (alias)
- Utiliser des conditions pour éviter les déclenchements indésirables
- Tester après chaque création
- Documenter dans le fil de discussion si important

---

## 12. OUTILS DISPONIBLES (barre latérale)

| Outil | Usage | Accès |
|---|---|---|
| Aperçu (Lovelace) | Dashboards principaux (19 onglets) | Local + distant |
| Calendrier | Calendrier HA | Local + distant |
| File Editor | Modifier fichiers config | Local + distant |
| Studio Code Server | Éditeur avancé (VS Code) | Local |
| Terminal SSH | Commandes système | Local (port 22) |
| Log Viewer | Logs en temps réel | Local + distant |
| Frigate | Caméras, détection mouvement | Local + distant |
| Zigbee2MQTT | Appareils Zigbee | Local + distant |
| HACS | Intégrations communautaires | Interface HA |
| Browser Mod | Contrôle navigateur | Interface HA |
| AdGuard Home | Filtrage DNS/pub | Local |
| ESPHome Builder | Appareils ESPHome | Local |
| Matter Server | Protocole Matter | Local |
| Music Assistant | Gestion musique | Local + distant |
| Médias | Navigateur de médias | Local + distant |
| Outils de dev YAML | Rechargement config | Paramètres HA |
| Historique | Historique des entités | Local + distant |
| Énergie | Suivi énergétique | Local + distant |
| Map | Carte de localisation | Local + distant |

---

*Fin du document Home_Assistant.md — Converti depuis Competence_Home_Assistant.pdf v4 — 18 avril 2026*
