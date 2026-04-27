---
title: Dongles Zigbee — 2× Sonoff ZBDongle-P
created: 2026-04-27
migrated_from: memory/reference_zigbee_dongles_might.md (auto-memory Cowork)
type: atome
domaine: Hardware
host_actuel: Pi5 (HA OS)
host_cible: Proxmox VM HA OS (Phase E projet hardware)
tags: [hardware, zigbee, matter, thread, sonoff, ha-os, passthrough]
---

# Dongles Zigbee — inventaire

Découverte session 56 (26/04/2026), via UI HA → Settings → Devices & Services + symlinks `/dev/serial/by-id/` côté HA OS.

## Inventaire

| Port HA | Modèle physique | Numéro de série complet | Usage |
|---|---|---|---|
| `ttyUSB0` | ITead Sonoff Zigbee 3.0 USB Dongle Plus (chipset CC2652P) | `b0ceb8bea7dbed118dd6f22d62c613ac` | Réseau **Zigbee** classique (intégration ZHA, ~30 devices appairés) |
| `ttyUSB1` | ITead Sonoff Zigbee 3.0 USB Dongle Plus (chipset CC2652P) | `0c02a8a414a6ed11b263e8a32981d5c7` | Réseau **Matter / Thread** (firmware reflashé en RCP **OpenThread**, intégration "Open Thread Border Router") |

> Note règle 0 sécurité : ces numéros de série physiques sont **non sensibles** (équivalents MAC, gravés dans le silicium dongle). Voir aussi `Plan_Reprise.md` du projet de migration vault, exception explicite.

## Implication migration Pi5 → Proxmox (projet Hardware_Upgrade)

- Les **2 dongles physiques migrent en l'état** (pas de reflash)
- Network keys stockées dans flash dongle → **aucun réappairage** des ~30 devices Zigbee
- Passthrough USB Proxmox vers VM HA OS via **numéro de série** (stable, pas par port USB qui peut permuter au reboot)
- Vendor:Product typique = `1a86:7523` (CH340 driver)

## Commandes passthrough Proxmox (Phase E)

```bash
# VM HA OS = ID 101 dans la nomenclature projet
qm set 101 -usb0 host=1a86:7523,serial=b0ceb8bea7dbed118dd6f22d62c613ac
qm set 101 -usb1 host=1a86:7523,serial=0c02a8a414a6ed11b263e8a32981d5c7

# Reboot pour appliquer
qm reboot 101
```

> ⚠️ Si plusieurs dongles ont le **même** vendor:product (1a86:7523 ici), le matching par `serial` est OBLIGATOIRE.

## Vérification post-passthrough

```bash
# Dans la VM HA OS (Proxmox)
ls -la /dev/serial/by-id/
# Doit afficher les 2 lignes :
# usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_b0ceb8bea7dbed118dd6f22d62c613ac-if00-port0 -> ../../ttyUSB0
# usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_0c02a8a414a6ed11b263e8a32981d5c7-if00-port0 -> ../../ttyUSB1
```

```yaml
UI HA OS VM :
  Settings → Devices & Services :
    - "Zigbee Home Automation" → status OK, ~30 devices Online
    - "Open Thread Border Router" → status OK
    - "Matter" → status OK
```

## Liens

- [`_Index.md`](_Index.md) — MOC Hardware
- [`Wiki/20_Projets/Hardware_Upgrade/06_Migration_HA_Pi5_Proxmox.md`](../../20_Projets/Hardware_Upgrade/06_Migration_HA_Pi5_Proxmox.md) — section 6 Passthrough USB
- [`Wiki/10_Domaines/Domotique/`](../Domotique/) — domaine Zigbee + ZHA + Matter (atomes hub)
