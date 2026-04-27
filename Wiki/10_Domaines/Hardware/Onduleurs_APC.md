---
title: Onduleurs APC — SMT2200IC + BR900G-FR
created: 2026-04-27
migrated_from: memory/reference_onduleurs_might.md (auto-memory Cowork)
type: atome
domaine: Hardware
deja_possedes: true
tags: [hardware, onduleur, ups, apc, nut, apcupsd]
---

# Onduleurs Mickael — APC

Identifiés session 56 (26/04/2026) pour le projet Hardware_Upgrade. **Déjà possédés**, pas d'achat à prévoir.

## Inventaire

| Onduleur | Modèle exact | VA / W | Connectique | Driver recommandé |
|---|---|---|---|---|
| **APC Smart-UPS 2200** | **SMT2200IC** (SmartConnect 2200VA LCD 230V) | 2200 / 1500 W | USB-B + RJ45 + SmartSlot (vide) | NUT `usbhid-ups` ou `apc_modbus` |
| **APC Back-UPS Pro 900** | **BR900G-FR** (Line Interactive, version FR) | 900 / 540 W | USB seulement | NUT `usbhid-ups` ou `apcupsd` |

Tous deux **Line Interactive**, manageable, **APC**.

## Plan d'affectation (projet Hardware_Upgrade)

### SMT2200IC → Serveur Proxmox (i9-9900K)

Branchements secteur :
- Proxmox host i9-9900K (~250 W)
- Switch TP-Link TL-SG108-M2 (~10 W)
- Box Orange Livebox (~15 W)
- Pi5 standby rollback (~5 W)
- Caméras IP PoE selon switch (~30 W)

**Total typique** : ~300 W → **autonomie ~30-40 min** sur batterie.

Communication via USB-B vers Proxmox host, NUT serveur (mode netserver, listener LAN 3493 pour clients VM HA + PC Ryzen).

### BR900G-FR → PC Ryzen + écrans

- Idle ~200 W → autonomie 10-15 min
- Peak Ryzen 9 + RTX 3090 ~750 W (>540 W) mais transitoire OK pour shutdown gracieux

Côté Windows 11 Ryzen : **PowerChute Personal Edition** (officiel APC, simple) recommandé. Alternative `apcupsd` Windows si besoin scripts.

## Évolution future (optionnelle)

Le **SmartSlot vide** du SMT2200IC peut accueillir une carte **APC AP9631 Network Management Card 2** (~250 €) pour passer en SNMP indépendant de Proxmox host (monitoring résilient, alertes mail natives).

## Liens

- [`_Index.md`](_Index.md) — MOC Hardware
- [`Wiki/20_Projets/Hardware_Upgrade/05_Onduleurs_NUT.md`](../../20_Projets/Hardware_Upgrade/05_Onduleurs_NUT.md) — config NUT détaillée + automation HA
- Documentation NUT HCL : https://networkupstools.org/stable-hcl.html
