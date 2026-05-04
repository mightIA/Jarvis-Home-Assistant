---
title: EcoFlow River 2 Pro
created: 2026-04-29
updated: 2026-05-02
tags: [atome, domotique, domotique/batterie, ha, ha/integration, ha/hacs, hermes]
status: actif
source: MCP HA (ha_get_integration / ha_get_device) — S86
---

# EcoFlow River 2 Pro

Batterie portable connectée **EcoFlow River 2 Pro** (768 Wh nominal) + **extension batterie** (Slave Battery), intégrée à Home Assistant via le composant HACS `ecoflow_cloud`.

## Identification

- **Nom commercial** : EcoFlow River 2 Pro
- **Modèle interne firmware** : `DELTA_2` *(alias technique chez EcoFlow Cloud — la River 2 Pro et la DELTA 2 partagent la même base logicielle côté API EcoFlow)*
- **Manufacturer** : EcoFlow
- **Capacité** : 768 Wh (River 2 Pro seule) + extension Slave Battery (capacité additionnelle ~768 Wh, à confirmer si modèle Extra Battery)
- **Mode d'intégration HA** : HACS `ecoflow_cloud` (cf. `Ressources/Competences/Home_Assistant.md` §6 HACS)
- **Domain HA** : `ecoflow_cloud`
- **Entry ID HA** : `01JNV464NH8B2D6PNG2AQCE3PA`
- **Device ID** : `8b0600e570f85b15cb9d8ae97dd31abe`
- **Area HA** : `chambre` *(assignée S86 — précédemment `null`)*
- **État** : configuré et fonctionnel (`state: loaded`)

## Entités principales

### Capteurs (sensor)

| Entité | Description |
|---|---|
| `sensor.river_2_pro_battery_level` | Niveau de charge global (%) |
| `sensor.river_2_pro_main_battery_level` | Niveau batterie principale (%) |
| `sensor.river_2_pro_slave_battery_level` | Niveau extension batterie (%) |
| `sensor.river_2_pro_total_in_power` / `..._total_out_power` | Puissance totale entrée / sortie (W) |
| `sensor.river_2_pro_ac_in_power` / `..._ac_out_power` | Puissance AC entrée / sortie (W) |
| `sensor.river_2_pro_ac_in_volts` / `..._ac_out_volts` | Tension AC entrée / sortie (V) |
| `sensor.river_2_pro_solar_in_power` | Puissance entrée panneau solaire (W) |
| `sensor.river_2_pro_dc_out_power` | Puissance sortie DC (W) |
| `sensor.river_2_pro_charge_remaining_time` / `..._discharge_remaining_time` | Temps restant charge / décharge (min) |
| `sensor.river_2_pro_battery_temperature` | Température batterie principale (°C) |
| `sensor.river_2_pro_inv_out_temperature` | Température sortie inverter (°C) |
| `sensor.river_2_pro_cycles` / `..._slave_cycles` | Nombre de cycles batterie principale / extension |
| `sensor.river_2_pro_state_of_health` / `..._slave_state_of_health` | SoH batterie principale / extension (%) |
| `sensor.river_2_pro_status` | Statut général (online / offline) |
| `sensor.river_2_pro_battery_charging_state` | État charge (charging / discharging / idle) |

### Energie cumulée (sensor)

| Entité | Description |
|---|---|
| `sensor.river_2_pro_total_in_energy` / `..._total_out_energy` | Energie totale cumulée IN / OUT (Wh) |
| `sensor.river_2_pro_ac_in_energy` / `..._ac_out_energy` | Energie AC cumulée IN / OUT (Wh) |
| `sensor.river_2_pro_solar_in_energy` | Energie solaire cumulée IN (Wh) |

### Actionneurs (switch)

| Entité | Description |
|---|---|
| `switch.river_2_pro_ac_enabled` | Activer / couper la sortie AC |
| `switch.river_2_pro_dc_12v_enabled` | Activer / couper la sortie DC 12V (allume-cigare) |
| `switch.river_2_pro_usb_enabled` | Activer / couper toutes les sorties USB |
| `switch.river_2_pro_x_boost_enabled` | Activer X-Boost (surcharge sortie AC pour gros appareils) |
| `switch.river_2_pro_ac_always_on` | AC toujours allumée (pas de mise en veille) |
| `switch.river_2_pro_prio_solar_charging` | Prioriser charge solaire vs AC |
| `switch.river_2_pro_backup_reserve_enabled` | Activer mode "réserve de secours" |
| `switch.river_2_pro_beeper` | Activer / couper le bip sonore |

### Réglages (number)

| Entité | Description |
|---|---|
| `number.river_2_pro_max_charge_level` | Niveau de charge max (%) — pour préserver la batterie |
| `number.river_2_pro_min_discharge_level` | Niveau de décharge min (%) |
| `number.river_2_pro_backup_reserve_level` | Seuil de réserve de secours (%) |
| `number.river_2_pro_ac_charging_power` | Puissance de charge AC max (W) |
| `number.river_2_pro_generator_auto_start_level` / `..._stop_level` | Seuils auto-démarrage / arrêt générateur (%) |

### Sélecteurs (select)

| Entité | Options |
|---|---|
| `select.river_2_pro_dc_12v_charge_current` | Courant max charge DC 12V (A) |
| `select.river_2_pro_screen_timeout` | Timeout écran |
| `select.river_2_pro_unit_timeout` | Timeout unité (auto-shutdown) |
| `select.river_2_pro_ac_timeout` | Timeout AC |
| `select.river_2_pro_dc_12v_timeout` | Timeout DC 12V |

### Action (button)

| Entité | Action |
|---|---|
| `button.river_2_pro_reconnect` | Force la reconnexion EcoFlow Cloud (utile si statut `offline`) |

## Automations associées

| Automation | Trigger | Action |
|---|---|---|
| *(aucune répertoriée)* | — | À documenter au fil de l'eau |

> Idées d'automations envisageables :
>
> - Notification iPhone quand `battery_level < 20 %` (autonomie restante < 1 h)
> - Couper sortie AC quand `battery_level > 90 %` ET solaire actif (préserver cycles)
> - Tracking énergie solaire dans tableau de bord Énergie HA

## Visualisation Lovelace

À documenter — typiquement sur la page **Énergie** (utilisation des `*_energy` cumulés pour les graphes HA Energy Dashboard) et/ou page **Salon/Chambre** pour le suivi état temps réel.

## Dépannage

- **Status `offline`** : appuyer sur `button.river_2_pro_reconnect` ou redémarrer manuellement l'app EcoFlow sur iPhone.
- **HACS `ecoflow_cloud` ne charge plus** : vérifier credentials EcoFlow Cloud dans `Paramètres → Appareils & services → EcoFlow Cloud` (token API peut expirer).

## Lien Hermes Agent (Phase 1bis-c)

Données pertinentes pour l'agent Hermès : prédiction de l'autonomie restante (ML léger sur les `_remaining_time`), arbitrage charge solaire vs AC selon météo. Tag `hermes` ajouté.

## Notes liées

- [[_Index|Hub Domotique]]
- [[../HomeAssistant/_Index|Domaine Home Assistant]]
- [[../Inventaire/Chambre_principale|Inventaire Chambre]]

---

*Fiche complétée S86 (2026-05-02) — T#80. Source MCP HA : `ha_get_integration(query="ecoflow")` + `ha_get_device(integration="ecoflow_cloud", detail_level="full")`. Action HA : `ha_update_device` → area `chambre` (S86).*
