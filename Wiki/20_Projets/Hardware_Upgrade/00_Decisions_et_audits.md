---
title: 00 — Décisions Mickael & résultats audits pré-achat
created: 2026-04-27
migrated_from: Projets/Hardware_Upgrade/00_Decisions_et_audits.md
status: en-attente-phase-A-Hermes
phase: 0
budget_target: 2410 EUR
bloqueur: hermes-phase-1bis-d
tags: [projet, hardware, proxmox, ryzen]
---

# 00 — Décisions Mickael & résultats audits pré-achat

**Session source** : S55 Cowork — 26/04/2026
**Statut** : verrouillé, prêt pour BoM finalisée

---

## 1. Décisions Mickael (5 questions du 26/04)

| # | Question | Décision retenue | Conséquence BoM |
|---|---|---|---|
| 1 | Budget | **2500 € en un coup** | Pas de phasage achat, livraison groupée |
| 2 | Hermès local 100% ou hybride | **Ryzen 9 dans tous les cas** (PC haut de gamme + anticipation future) | Pas de bridage CPU, on prend la gamme top AM5 |
| 3 | Caméras Frigate | **3 actuellement → 5 ou 6 à terme** | Coral USB suffit, pas besoin GPU passthrough Frigate |
| 4 | Dongle Zigbee Pi5 | **Oui, à passer en passthrough** (cf Audit 2) | 2 dongles physiques migrent en l'état |
| 5 | Onduleur | **APC Smart-UPS 2200 + APC Back-UPS Pro 900 déjà possédés** | Pas d'achat onduleur, juste config NUT |

**Marge interprétation** : "Ryzen 9 dans tous les cas" → choix entre 7900X / 7950X / 9950X. Reco BoM : **7950X** (rapport perf/prix optimal, AM5 garantit upgrade futur vers 9950X3D sans changement plateforme).

---

## 2. Audit 1 — Carte mère actuelle

**Commande lancée** : `Get-CimInstance -ClassName Win32_BaseBoard | Select-Object Manufacturer, Product, Version`

| Champ | Valeur | Verdict |
|---|---|---|
| Manufacturer | ASUSTeK COMPUTER INC. | OK |
| Product | **ROG MAXIMUS XI HERO (WI-FI)** | Top tier Z390 |
| Version | Rev 1.xx | OK |

### Pourquoi c'est important pour Proxmox

| Capacité | Valeur | Impact projet |
|---|---|---|
| Chipset | Z390 | IOMMU/VT-d propre, groupes IOMMU bien séparés |
| Slots DIMM | 4× DDR4 jusqu'à 64 Go | Plan 4×16 Go validé |
| M.2 NVMe | 2 slots PCIe 3.0 x4 | Système Proxmox + cache éventuel |
| SATA | 6 ports | HDD Frigate + spare |
| LAN | 2× Intel (I219-V + I211-AT) | Bonus : redondance réseau Proxmox possible |
| WiFi | Intel 9560 802.11ac | Inutile pour serveur (à désactiver BIOS) |
| USB | 8× rear + headers | 2× Zigbee + Coral + clavier/souris OK sans hub |
| Audio | SupremeFX S1220 | Désactiver BIOS (économie ressources) |

### Conséquence

**Aucun achat carte mère nécessaire** pour le Proxmox. Réutilisation 100%. La BoM Proxmox add-ons reste à 350 € (RAM + 2 disques).

---

## 3. Audit 2 — Dongles Zigbee Pi5

**Méthode** : UI Home Assistant → Settings → Devices & Services + lecture symlinks `/dev/serial/by-id/`

### Inventaire

| Port HA | Modèle | Numéro de série | Usage |
|---|---|---|---|
| `ttyUSB0` | ITead Sonoff Zigbee 3.0 USB Dongle Plus | `b0ceb8bea7dbed118dd6f22d62c613ac` | Réseau **Zigbee** classique (intégration ZHA) |
| `ttyUSB1` | ITead Sonoff Zigbee 3.0 USB Dongle Plus | `0c02a8a414a6ed11b263e8a32981d5c7` | Réseau **Matter / Thread** (firmware reflashé en RCP OpenThread) |

### Architecture détectée

```
Pi5 actuel
  ├── ZHA (Zigbee Home Automation)
  │     └── ttyUSB0 (Sonoff ZBDongle-P, firmware Zigbee Texas Instruments CC2652P)
  │           └── ~30 devices Zigbee appairés
  │
  └── OpenThread Border Router (Matter)
        └── ttyUSB1 (Sonoff ZBDongle-P, firmware OpenThread RCP)
              └── Devices Matter / Thread

Visible dans capture HA :
  - "Zigbee Home Automation" intégration active
  - "Open Thread Border Router" intégration active
  - "Matter" intégration active
  - "Thread" intégration active
```

### Conséquences pour la migration

| Point | Détail |
|---|---|
| **Migration physique** | Les 2 dongles passent du Pi5 au i9-9900K Proxmox (USB) |
| **Network keys** | Stockées dans flash dongle → **aucun réappairage** des ~30 devices |
| **Firmwares** | Aucun reflash nécessaire, on conserve l'état actuel |
| **Passthrough Proxmox** | Cible VM HA OS, identification via numéro de série (stable) |
| **`udev rules`** | À créer dans la VM HA OS pour pin `/dev/zigbee_main` et `/dev/zigbee_thread` |

### Commande passthrough Proxmox (à utiliser Phase 5)

```bash
# Sur Proxmox host, identifier les dongles
lsusb | grep -i sonoff
# Obtenir vendor:product (typique ITead = 1a86:7523)

# Passthrough USB par numéro de série (stable)
qm set <VMID> -usb0 host=1a86:7523,serial=b0ceb8bea7dbed118dd6f22d62c613ac
qm set <VMID> -usb1 host=1a86:7523,serial=0c02a8a414a6ed11b263e8a32981d5c7
```

---

## 4. Audit 3 — Onduleurs

### APC Smart-UPS 2200

| Caractéristique | Valeur |
|---|---|
| Modèle exact | **SMT2200IC** (Smart Connect 2200VA LCD 230V) |
| Technologie | Line Interactive |
| Puissance | 2200 VA / ~1500 W |
| Manageable | **Oui** (USB + RJ45 + SmartSlot) |
| Évolutif | Non (batterie unique) |
| Prises | 8× IEC C13 |
| Driver NUT recommandé | `apc_modbus` (USB Modbus, plus précis que `usbhid-ups`) |

### APC Back-UPS Pro 900

| Caractéristique | Valeur |
|---|---|
| Modèle exact | **BR900G-FR** (BR900G-FR, version FR avec prises hybrides) |
| Technologie | Line Interactive |
| Puissance | 900 VA / 540 W |
| Manageable | USB seulement |
| Driver NUT recommandé | `usbhid-ups` |

### Plan d'affectation

```
SMT2200IC (1500W, manageable RJ45)
  ├── Serveur Proxmox (i9-9900K) — charge typique ~250W
  ├── Switch 2.5G TP-Link — ~10W
  ├── Box Orange Livebox — ~15W
  ├── Pi5 standby (allumé en rollback chaud) — ~5W
  └── (optionnel) Caméras IP PoE — selon switch
TOTAL typique : ~300W → autonomie estimée ~30-40 min sur batterie

BR900G-FR (540W)
  ├── PC bureau Ryzen — idle 150W, peak 750W
  └── Écran(s)
TOTAL typique idle : ~200W → autonomie ~10-15 min
TOTAL pleine charge : 750W > 540W → mais transitoire, OK pour shutdown gracieux
```

### Configuration NUT côté Proxmox (à détailler dans 05_Onduleurs_NUT.md)

```bash
# Installer NUT sur Proxmox host
apt install nut nut-client nut-server

# Driver SMT2200IC
# /etc/nut/ups.conf
[smt2200]
    driver = usbhid-ups
    port = auto
    desc = "APC SMT2200IC Server"

# Mode serveur sur Proxmox, clients = VM HA + PC Ryzen
# /etc/nut/upsd.conf — listener sur LAN
LISTEN 192.168.1.11 3493
```

### Note SmartSlot (optionnel, futur)

Le SMT2200IC a un **SmartSlot vide**. Si plus tard tu veux SNMP au lieu d'USB :
- Carte **AP9631 Network Management Card 2** (~250 €)
- Avantages : monitoring distant indépendant de l'host Proxmox, alertes mail directes, événements snmp-trap
- Pas prioritaire pour le projet actuel, à garder en tête

---

## 5. Synthèse — feu vert achat

| Audit | Résultat | Bloquant ? |
|---|---|---|
| CM actuelle | ROG MAXIMUS XI HERO Z390 | Non |
| Dongles Zigbee | 2× Sonoff ZBDongle-P, migrables tels quels | Non |
| Onduleurs | SMT2200IC + BR900G-FR, NUT supportés | Non |

**Feu vert pour finaliser la BoM** → voir `02_BoM_finalisee.md`.

---

## Source originale conservée

Fichier source intact : `Projets/Hardware_Upgrade/00_Decisions_et_audits.md` (lecture seule pour ce vault).
