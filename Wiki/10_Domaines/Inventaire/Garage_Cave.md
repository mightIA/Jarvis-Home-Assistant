---
title: Inventaire — Garage / Cave
created: 2026-04-27
updated: 2026-04-27
tags: [atome, inventaire, garage, cave, hardware]
status: stub
domaine: Inventaire
remplissage_attendu: Mickael
---

# Inventaire — Garage / Cave

> **Template à remplir.** Mickael complétera lors d'une session dédiée.

## Infrastructure technique (cœur domotique)

| Nom | Type | Modèle | Localisation | Onduleur | Notes |
|---|---|---|---|---|---|
| Raspberry Pi 5 | SBC | Pi 5 (host HA OS) | (à préciser pièce exacte) | (à préciser) | BT `2C:CF:67:6F:5D:03` — voir [[10_Domaines/Hardware/Dongles_Zigbee]] |
| Dongle Zigbee 1 | USB Zigbee | Sonoff ZBDongle-P (ZHA SN `b0ceb8be...`) | Pi 5 | — | Voir [[10_Domaines/Hardware/Dongles_Zigbee]] |
| Dongle Zigbee 2 | USB OpenThread/Matter | Sonoff ZBDongle-P reflashé (SN `0c02a8a4...`) | Pi 5 | — | Voir [[10_Domaines/Hardware/Dongles_Zigbee]] |
| EcoFlow River 2 Pro | Station d'énergie | EcoFlow River 2 Pro | (à préciser) | — | Intégration `ecoflow_cloud` |

## Onduleurs (UPS)

Voir fiche détaillée : [[10_Domaines/Hardware/Onduleurs_APC]]

| Nom | Modèle | Capacité | Périphérique protégé | Driver NUT | Notes |
|---|---|---|---|---|---|
| APC SMT2200IC | Smart-UPS 2200VA | 1500W | Proxmox (futur) | `usbhid-ups` | Phase D/C upgrade hardware |
| APC BR900G-FR | Back-UPS Pro 900VA | 540W | Ryzen (futur) | `usbhid-ups` | Phase D/C upgrade hardware |

## Chauffage

| Nom | Type | Marque/Modèle | Entité HA | Notes |
|---|---|---|---|---|
| Chaudière | Chaudière gaz | Frisquet (modèle à préciser) | `climate.maison` (`frisquet_connect`) | Voir [[10_Domaines/Frisquet/_Index]] et skill `chaudiere-frisquet` |

## Stockage matériel / atelier

| Catégorie | Description | Notes |
|---|---|---|
| Outillage | ... | ... |
| Pièces de rechange | ... | ... |
| Filaments imprimante 3D | ... | Lien vers [[Bureau]] |
| Cartons / matériel | ... | ... |

## Équipements non connectés

| Nom | Type | Marque/Modèle | Date achat | Garantie | Notes |
|---|---|---|---|---|---|
| ... | ... | ... | ... | ... | ... |

## Liens internes

- [[10_Domaines/Frisquet/_Index]] — chaudière Frisquet
- [[10_Domaines/Hardware/Onduleurs_APC]] — onduleurs
- [[10_Domaines/Hardware/Dongles_Zigbee]] — dongles Zigbee
- [[Reseau_Maison]] — IP fixe Pi5 (`192.168.1.11`)
- [[Batteries_Piles]] (si batteries de secours dans la zone)

## Sources de remplissage à venir

- Photos garage / cave (Pi5 + dongles + chaudière + onduleurs)
- Modèle exact chaudière Frisquet (plaque signalétique)
- Factures chaudière + onduleurs + Pi5
