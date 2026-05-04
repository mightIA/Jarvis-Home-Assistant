---
date: 2026-05-03
mode: quotidien (Option D — fenêtre 24h roulants)
session: S91
generated_by: ha-logs-archive (test bout-en-bout T#34)
---

# Logs HA — 3 mai 2026 (test bout-en-bout T#34)

**Période** : ~24h roulants jusqu'à 2026-05-03 ~10:36 UTC
**Tailles brutes** :
- `raw_logbook_2026-05-03.json` : 71 KB (599 entrées state changes — fenêtre 24h compact)
- `raw_system_errors_2026-05-03.json` : ~5 KB (6 erreurs + 5 warnings — depuis dernier restart HA Core ~11h08 UTC)
- `raw_home-assistant_*.log` : **NON CRÉÉ** (endpoint `error_log` retourne 404 dans cette version HA — voir Pièges)

**Généré le** : 2026-05-03 10:36 UTC (skill `ha-logs-archive`, test bout-en-bout S91)

---

## Top 5 erreurs récurrentes (depuis restart HA Core 11h08 UTC)

| # | Composant | Message | Occurrences |
|---|-----------|---------|-------------|
| 1 | `moonraker_api.websockets.websocketclient` | Websocket connection error: Cannot connect to host 192.168.1.81:7125 (Klipper imprimante 3D Creality) | **6** |
| 2 | `custom_components.frigate.api` | Cannot connect to host ccab4aaf-frigate-fa:5000 (add-on Frigate down) | **6** |
| 3 | `homeassistant.components.homekit.util` | media_player.decodeur_tv_uhd / tv_samsung_q80 — no media_player features | **6** |
| 4 | `homeassistant.components.homekit` | 4 prises mobile/fixe child_lock — entity not available | **4** |
| 5 | `pyhap.characteristic` | TargetHeatingCoolingState: value=0 is an invalid value | **3** |

**Notes** :
- Top 1 (Moonraker) → tâche **T#90** ouverte (setup_retry imprimante 3D)
- Top 2 (Frigate) → add-on à investiguer, peut être down depuis fin mars (compteur pré-restart : 17761 occurrences depuis 2026-03-29)
- Top 3 + 4 + 5 (HomeKit) → bug récurrent au boot, voir warnings ci-dessous

---

## Bans IP détectés

⚠️ **Section non remplissable** — l'endpoint `error_log` qui contient ces patterns n'est pas accessible dans cette version HA (404). Workaround pour la SKILL v2 : utiliser `ha_get_logs source=system search="banned"` ou requêter `automation` `ip_ban`.

Aucun pattern `Banned IP` / `Login attempt or request with invalid authentication` détecté dans les 11 entrées system disponibles.

---

## Reboots HA détectés

✅ **1 reboot détecté** (post-modif `purge_keep_days: 35`) :

| Date | Trigger | Downtime estimé |
|------|---------|-----------------|
| 2026-05-03 ~11:11 UTC | Manuel (Mickael, post-modif `recorder.purge_keep_days` 1→35) | ~30-60 sec |

Détection via timestamp `first_occurred` des erreurs de boot (HomeKit port 2096 already in use, child_lock entities not yet available).

---

## Extraits stack traces (sélection)

### 1. HomeKit boot — port 2096 already in use (1 occurrence)

```
File "/usr/local/lib/python3.14/asyncio/base_events.py", line 1627, in create_server
    raise OSError(err.errno, msg) from None
OSError: [Errno 98] error while attempting to bind on address ('0.0.0.0', 2096): [errno 98] address in use
```

→ HomeKit tente de bind sur le port **2096** (oui, le même port que ton HA local !) au boot. Conflit de port. Probablement un service HA secondaire qui se lance avant HomeKit. À investiguer si HomeKit pose des problèmes.

---

## Warnings notables

- **HomeKit 150 device limit dépassée** : 879 occurrences uniques d'entités refusées (capteurs distance Bluetooth FSC-BP104E, switches Wifi bridge). HomeKit garde max 150 devices par bridge. Solution : ajouter un filtre `include_*` dans la config HomeKit.
- **HomeKit caméras à séparer** : 4 caméras (chambre + cuisine 3 profiles) recommandées en accessory mode dédié au lieu du bridge principal.
- **HACS — 2 cards abandonnées** : `custom-cards/bar-card` (no longer maintained) + `nervetattoo/simple-thermostat` (abandoned). À remplacer ou supprimer.
- **Moonraker WARNING** : "Cannot configure moonraker instance" 6× en parallèle des erreurs websocket (T#90).

---

## Pièges découverts pendant le test bout-en-bout (à documenter dans SKILL v2)

1. **`source=error_log` retourne 404** — endpoint inexistant dans cette version HA. La SKILL doit retirer cette source et basculer sur `source=system` (ERROR + WARNING) ou `source=supervisor`.
2. **`hours_back` ignore `end_time`** sur `source=system` (warning explicite du MCP : `"Parameters end_time only apply to source='logbook'; ignored for source='system'"`). La SKILL doit appeler système toujours en mode "X dernières heures depuis maintenant", pas en fenêtre fixe.
3. **`purge_keep_days: 1` initial** (modifié 1→35 lors du test) — la SKILL doit valider la valeur avant lancement, et déclencher avertissement si < `hours_back / 24`.
4. **Sortie logbook 24h dépasse 25 KB** (72 KB observés) — la SKILL doit utiliser le pattern "fichier tmp Cowork → cp vers archive" plutôt que charger en contexte.
5. **Compteurs system_log reset à chaque restart HA Core** — le `count` total avant restart est perdu. Pour un suivi long terme, archiver AVANT restart majeur.

---

## Statut consolidé

✅ Test bout-en-bout T#34 réussi (mécanique fonctionnelle)
⚠️ SKILL `ha-logs-archive` à patcher v2 (5 pièges ci-dessus)
⏭️ Prochaines étapes : (1) MAJ SKILL.md, (2) création scheduled task quotidienne 02h00 sur 1000D, (3) attente 7+ jours pour valider le mode hebdo si recorder à 35j tient
