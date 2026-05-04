---
id: 90
title: "Résoudre setup_retry Moonraker — souci Klipper imprimante 3D Creality"
status: open
priority: P3
session_opened: S86
tags: [imprimante3d, moonraker, klipper, ha-mcp]
source: "Session 86 / T#80 documentation hub Domotique — setup_retry détecté lors de l'inspection MCP HA"
---

# T#90 — Résoudre `setup_retry` Moonraker / Klipper

## Contexte

Lors de la documentation de la fiche `Wiki/10_Domaines/Domotique/Imprimante 3D Creality Ender 3 S1 Pro.md` en S86 (T#80), l'inspection MCP HA via `ha_get_integration(query="moonraker")` a révélé :

- Intégration `moonraker` (entry_id `01K2WKS5ZP9C4M3P8NZ9XJJRH4`) en état **`setup_retry`**.
- Mickael a confirmé : *« soucis avec klipper »* côté firmware imprimante.
- L'imprimante est physiquement dans l'atelier (area HA `atelier`).
- Conséquence : aucune entité `creality_ender_3_s1_pro_*` ni `spad_7737_*` n'est mise à jour temps réel — toutes les automations imprimante 3D sont KO.

## Diagnostic à mener

1. **Joignabilité réseau host Moonraker** :
   - Identifier l'IP du Pi/MKS qui héberge Klipper+Moonraker (probablement statique sur le LAN — vérifier `Inventaire/Reseau_Maison`).
   - `ping <ip-moonraker>` depuis Might-1000D.
   - `curl http://<ip-moonraker>:7125/printer/info` → doit retourner JSON Klipper.

2. **État service Klipper** :
   - SSH sur le host : `sudo systemctl status klipper`
   - Si `failed` : consulter `~/printer_data/logs/klippy.log` pour l'erreur exacte.
   - Causes fréquentes : modif `printer.cfg` invalide, MCU déconnecté (USB câble), endstop bloqué.

3. **État service Moonraker** :
   - `sudo systemctl status moonraker`
   - Si `failed` : `~/printer_data/logs/moonraker.log`.

4. **Refresh côté HA** :
   - Une fois Klipper réparé : `Paramètres → Appareils & services → Moonraker → Reconfigurer` (ou bouton « Rechercher des défauts »).

## Critères de done

- Intégration `moonraker` repasse en `state: loaded` dans HA.
- Entités `sensor.creality_ender_3_s1_pro_printer_state` et `sensor.creality_ender_3_s1_pro_extruder_temperature` ont des valeurs valides (pas `unavailable`).
- Test impression test (vase ou cube de calibration) → `sensor.creality_ender_3_s1_pro_progress` évolue correctement.

## Lien

- Fiche Wiki : [[Wiki/10_Domaines/Domotique/Imprimante 3D Creality Ender 3 S1 Pro]]
- Tâche source : T#80 (S86, archivée)

## Statut

🟢 `open` — P3, à traiter quand Mickael aura accès physique à l'imprimante (atelier).
