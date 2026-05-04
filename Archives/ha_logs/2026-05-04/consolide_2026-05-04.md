# Logs HA -- 2026-05-04 (archive quotidienne)

**Periode archivee** : 24 hours back from 2026-05-04T00:00:42.705225+00:00
**Fenetre logbook reelle** : 2026-05-03T00:14:56.852771+00:00 -> 2026-05-03T23:55:07.315733+00:00
**Tailles brutes** :
- `raw_logbook_2026-05-04.json` : 752.5 KB (5140 entrees, fusion de 11 pages MCP)
- `raw_system_errors_2026-05-04.json` : 8.9 KB (8 erreurs distinctes + 6 warnings distincts)
**Genere le** : 2026-05-04 00:07 UTC (skill ha-logs-archive v2 -- mode quotidien automatique)

> La fenetre `start_time`/`end_time` MCP couvre 24h pleines mais les entrees disponibles s'arretent a ~01:55 UTC du 04/05 (collecte demarree pendant l'archivage). Volume normal pour 24h sur cette installation (~5000 events lies en majorite aux capteurs de mouvement Chambre/Cuisine).

## Top 5 erreurs recurrentes

| # | Composant | Message (extrait) | Occurrences |
|---|-----------|-------------------|-------------|
| 1 | `custom_components.frigate.api` (Frigate recurrent, non bloquant) | Error fetching information from http://ccab4aaf-frigate-fa:5000/api/stats: Cannot connect to host ccab4aaf-frigate-fa:50... | **292** |
| 2 | `moonraker_api.websockets.websocketclient` -- **T#90 Moonraker** | Websocket connection error: Cannot connect to host 192.168.1.81:7125 ssl:default [Connect call failed ('192.168.1.81', 7... | **281** |
| 3 | `frontend.js.modern.202603258` (collision custom-element-registry HACS tabbed-card vs advanced-camera-card) | Uncaught error from Chrome 147.0.0.0 on Windows 10.0 Error: Failed to execute 'define' on 'CustomElementRegistry': the n... | **8** |
| 4 | `homeassistant.components.homekit.util` (TV media_player sans features HomeKit) | media_player.decodeur_tv_uhd does not support any media_player features... | **6** |
| 5 | `homeassistant.components.homekit` (HomeKit child_lock entities not yet available -- transitoire boot) | HomeKit Prise mobile 1 Child lock cannot startup: entity not available: {'exclude_domains': [], 'exclude_entities': [], ... | **4** |

## Bans IP detectes

**Aucun ban detecte sur la fenetre.** Recherches MCP executees :
- `ha_get_logs source=system search="banned"` -> 0 entree
- `ha_get_logs source=system search="invalid authentication"` -> 0 entree

> Ne couvre pas les bans 401/403 silencieux cote firewall HA -- pour audit complet voir `system_log` UI Settings > System > Logs (workaround `error_log` 404 piege S91).

## Reboots HA detectes

**1 boot HA Core detecte dans la fenetre** :

| Date (Paris) | Trigger probable | Indices |
|--------------|------------------|---------|
| 2026-05-03 19:34 Paris | Restart HA Core | Salve d'erreurs HomeKit boot (port 2096 already in use, child_lock entities not yet available, pyhap thermostat invalid value) groupees sur ~0,3 s -- typique d'un demarrage |

> **Compteur `system_log` reset a chaque restart** (piege S91 #5). Les `count` ci-dessus refletent uniquement l'activite depuis ce boot (~5h30 environ avant l'archivage).

## Extraits stack traces (3 max)

### 1. HomeKit -- port 2096 already in use (CRITIQUE boot)

```
Traceback (most recent call last):
  File "/usr/src/homeassistant/homeassistant/components/homekit/__init__.py", line 395, in _async_start_homekit
    await homekit.async_start()
  File "/usr/src/homeassistant/homeassistant/components/homekit/__init__.py", line 892, in async_start
    await self.driver.async_start()
  File "/usr/local/lib/python3.14/site-packages/pyhap/accessory_driver.py", line 382, in async_start
    await self.http_server.async_start(self.loop)
  File "/usr/local/lib/python3.14/site-packages/pyhap/hap_server.py", line 50, in async_start
    self.server = await loop.create_server(
                  ^^^^^^^^^^^^^^^^^^^^^^^^^
    ...<3 lines>...
    )
    ^
  File "/usr/local/lib/python3.14/asyncio/base_events.py", line 1627, in create_server
    raise OSError(err.errno, msg) from None
OSError: [Errno 98] error while attempting to bind on address ('::', 2096, 0, 0): [errno 98] address in use
```

**Analyse** : HA Core a tente de redemarrer le service HomeKit alors que le port `2096` etait deja occupe (probablement par l'instance precedente non terminee). Erreur unique au boot, non bloquante pour HA mais HomeKit indisponible jusqu'au prochain restart propre. **A surveiller** : si recurrent, desactiver HomeKit ou migrer vers un autre port.

### 2. Frigate API unreachable (recurrent -- 292 occ.)

```
Error fetching information from http://ccab4aaf-frigate-fa:5000/api/stats: Cannot connect to host ccab4aaf-frigate-fa:5000 ssl:False [Connect call failed ('172.30.33.7', 5000)]
```

**Analyse** : integration `custom_components.frigate` ne joint pas l'add-on a `ccab4aaf-frigate-fa:5000` (IP supervisor `172.30.33.7`). Soit l'add-on Frigate est arrete, soit le proxy Docker supervisor a perdu sa resolution DNS interne. **Action** : verifier etat add-on Frigate (Settings > Add-ons).

### 3. Moonraker websocket (recurrent -- 281 occ., T#90)

```
Websocket connection error: Cannot connect to host 192.168.1.81:7125 ssl:default [Connect call failed ('192.168.1.81', 7125)]
```

**Analyse** : integration Moonraker tente une websocket vers `192.168.1.81:7125` (imprimante 3D Klipper). 281 retries depuis le boot. **Tache connue T#90** : imprimante eteinte / hors ligne -- l'integration retry indefiniment. A documenter dans `tasks/task_090.md` ou desactiver l'integration en attendant.

## Warnings notables

| Composant | Message (extrait) | Occurrences | Action |
|-----------|-------------------|-------------|--------|
| `homeassistant.components.homekit` | Cannot add sensor.fsc_bp104e_4787_estimated_distance as this would exceed the 150 device l... | **877** | HomeKit limite **150 devices** atteinte -- filtrer les entites non essentielles (estimated_distance des trackers BLE notamment) |
| `custom_components.moonraker` | Cannot configure moonraker instance... | **281** | cf. T#90 Moonraker |
| `homeassistant.components.light.reproduce_state` | Unable to find entity light.ampoule_couloir_escalier_haut... | **5** | Anciennes entites lumiere inexistantes -- purger les scenes/automations qui les referencent |
| `custom_components.hacs` | You have 'custom-cards/bar-card' installed with HACS this repository has been removed from... | **2** | **HACS** : `bar-card` + `simple-thermostat` abandonnes -- remplacer ou supprimer |
| `homeassistant.util.logging` | Module homeassistant.components.homekit is logging too frequently. 200 messages since last... | **1** | HomeKit logue trop frequemment (corollaire des 877 warnings 150-limit) |
| `homeassistant.components.homekit` | The bridge Home Assistant Bridge has entity camera.chambre_mediaprofile_channel1_mainstrea... | **1** | HomeKit limite **150 devices** atteinte -- filtrer les entites non essentielles (estimated_distance des trackers BLE notamment) |

## Activite logbook -- top entites

**5140 events** sur la fenetre, domines par les capteurs de mouvement Chambre/Cuisine.

| Domaine | Events | % |
|---------|--------|---|
| `binary_sensor` | 3784 | 73.6% |
| `switch` | 281 | 5.5% |
| `sensor` | 223 | 4.3% |
| `select` | 222 | 4.3% |
| `number` | 197 | 3.8% |
| `device_tracker` | 99 | 1.9% |
| `media_player` | 92 | 1.8% |
| `light` | 60 | 1.2% |
| `update` | 38 | 0.7% |
| `automation` | 24 | 0.5% |

**Top 15 entites les plus actives** :

| # | Entity | Events |
|---|--------|--------|
| 1 | `binary_sensor.chambre_cell_motion_detection` | 1656 |
| 2 | `binary_sensor.chambre_motion_alarm` | 1656 |
| 3 | `binary_sensor.cuisine_motion_alarm_2` | 136 |
| 4 | `binary_sensor.cuisine_motion_alarm` | 95 |
| 5 | `device_tracker.pc_328` | 60 |
| 6 | `sensor.seremange_erzange_next_rain` | 46 |
| 7 | `sensor.might_iphone_audio_output` | 34 |
| 8 | `binary_sensor.capteur_fenetre_chambre_contact` | 32 |
| 9 | `media_player.tv_samsung_q80_series_65` | 29 |
| 10 | `sensor.might_iphone_last_update_trigger` | 27 |
| 11 | `media_player.samsung_q80_series_65_2` | 24 |
| 12 | `media_player.salle_de_bain` | 21 |
| 13 | `binary_sensor.capteur_porte_entree_contact` | 17 |
| 14 | `sensor.might_iphone_storage` | 17 |
| 15 | `number.siren_duration` | 14 |

## Notes archivage

- 3 fichiers generes : `raw_logbook_*.json`, `raw_system_errors_*.json`, `consolide_*.md`
- Logbook 24h : 5140 entrees agregees via 11 pages MCP (limit serveur cap = 500/appel)
- Aucun ban IP, aucune perte d'auth detectee
- HomeKit reste bruyant (877+ warnings 150-limit) -- candidat a filter option
- Moonraker (T#90) et Frigate continuent de retry sans throttling
- Pieges S91 #1, #2, #4, #5 confirmes (endpoint error_log 404, end_time ignore sur system, output > 25KB sauvegarde tmp, count reset au reboot)
