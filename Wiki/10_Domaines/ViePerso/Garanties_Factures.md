---
title: Garanties & factures
created: 2026-04-27
updated: 2026-04-27
tags: [atome, vie-perso, garanties, factures, coquille]
status: stub
domaine: ViePerso
remplissage_attendu: Mickael
parent: "[[10_Domaines/ViePerso/_Index]]"
---

# Garanties & factures

> **Coquille pré-remplie partiellement** d'après CONTEXTE.md, S36
> (config PC), S56 (onduleurs, dongles Zigbee). Mickael complète les
> dates d'achat, lieux, garanties, fins de garantie.

> **Règle 0** : ne PAS coller les scans de factures complets ici. Juste
> les **références** : date, montant, magasin, n° facture, lieu de
> stockage du scan original (OneDrive `xxx`, classeur physique, etc.).
> Cap : Jarvis n'a besoin que des **dates de fin de garantie** pour
> alerter avant expiration.

## Hardware PC & périphériques

### Tour PC principale (MIGHT-1000D)

| Champ | Valeur |
|---|---|
| Modèle | `[À remplir — boîtier ASUS ?]` |
| Date d'achat / montage | `[À remplir]` |
| Lieu d'achat | `[À remplir]` |
| Garantie globale | `[À remplir si achat assemblé]` |
| Fin de garantie | `[À remplir]` |
| Référence facture | `[À remplir]` |
| Scan facture | `[À remplir — chemin OneDrive]` |

### Composants (source S36 — `reference_pc_config_might`)

| Composant | Modèle | Date achat | Garantie | Fin garantie | Vendeur | Notes |
|---|---|---|---|---|---|---|
| CPU | Intel Core i9-9900K | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Source S36 |
| RAM | 32 Go DDR4 | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Source S36 |
| GPU | **RTX 3090 24 Go** | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Source S36 — clé pour Hermès local |
| Carte mère | ASUS `[modèle ?]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | BIOS 1802 UEFI |
| Alimentation | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| SSD système | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| HDD/SSD secondaire | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Boîtier | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Refroidissement | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |

### Périphériques

| Périphérique | Modèle | Date achat | Fin garantie | Notes |
|---|---|---|---|---|
| Clavier | **Logitech G915** (mécanique) | `[À remplir]` | `[À remplir]` | Source `Macros clavier.md` |
| Souris | **Logitech G502** | `[À remplir]` | `[À remplir]` | Source `Macros clavier.md` |
| Pad gaming | **Razer Tartarus V2** | `[À remplir]` | `[À remplir]` | Source `Macros clavier.md` |
| Écran principal | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Écran secondaire | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Webcam | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Micro / casque | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Imprimante | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |

### Onduleurs (source S56)

| Onduleur | Modèle | Date achat | Fin garantie | Affecté à | Notes |
|---|---|---|---|---|---|
| UPS 1 | **APC SMT2200IC** (1500 W) | `[À remplir]` | `[À remplir]` | Futur Proxmox | Source S56 — driver NUT identifié |
| UPS 2 | **APC BR900G-FR** (540 W) | `[À remplir]` | `[À remplir]` | Futur Ryzen | Source S56 |

### Dongles Zigbee/Matter (source S56)

| Dongle | Modèle | SN | Date achat | Notes |
|---|---|---|---|---|
| Zigbee 1 | Sonoff ZBDongle-P | `b0ceb8be...` | `[À remplir]` | ZHA actuel sur Pi5 |
| Zigbee 2 | Sonoff ZBDongle-P (reflashé OpenThread/Matter) | `0c02a8a4...` | `[À remplir]` | OpenThread/Matter |

## Smartphone / tablette

| Appareil | Modèle | Date achat | Garantie | Fin garantie | Lieu achat | Notes |
|---|---|---|---|---|---|---|
| iPhone | `[À remplir — modèle, capacité]` | `[À remplir]` | `[À remplir — Apple Care+ ?]` | `[À remplir]` | `[À remplir]` | App Claude iPhone, iCloud3 HA |
| Apple Watch | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Entité HA |
| Tablette | `[À remplir — iPad ?]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Entité HA |
| AirPods / écouteurs | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |

## Domotique / IoT

| Appareil | Modèle | Date achat | Garantie | Fin garantie | Notes |
|---|---|---|---|---|---|
| Caméras Dahua x3 | `[À remplir — modèles exacts]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Chambre / Cuisine fixe / Cuisine PTZ |
| Chaudière Frisquet | `[À remplir — modèle]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | v2.5.4 intégration HACS |
| Dyson Purifier | `[À remplir — modèle]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Intégration HACS dyson_local |
| Batterie EcoFlow River 2 Pro | River 2 Pro | `[À remplir]` | `[À remplir]` | `[À remplir]` | Intégration EcoFlowCloud |
| Raspberry Pi 5 | `[À remplir]` | `[À remplir]` | n/a | n/a | Hôte Zigbee2MQTT |
| Ampoules Zigbee | `[À remplir — marques]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Via Z2M |
| Prises Zigbee | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Via Z2M |
| Capteurs Zigbee | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Via Z2M |
| Transmetteurs IR ESPHome | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | Add-on ESPHome |

## TV & audio salon

| Appareil | Modèle | Date achat | Fin garantie | Notes |
|---|---|---|---|---|
| TV | **Samsung Q80 65 pouces** | `[À remplir]` | `[À remplir]` | Source CONTEXTE.md (page Lovelace Media) |
| Barre de son / home cinéma | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Console(s) | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Box TV / décodeur | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |

## Électroménager

| Appareil | Marque/Modèle | Date achat | Garantie | Fin garantie | Lieu achat | Notes |
|---|---|---|---|---|---|---|
| Lave-linge | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Sèche-linge | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Lave-vaisselle | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Réfrigérateur | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Four | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Plaque cuisson | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Hotte | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Micro-ondes | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Cafetière / machine espresso | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |
| Aspirateur (robot ?) | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` | `[À remplir]` |

## Mobilier & autres

`[À remplir si Mickael souhaite — canapés sous garantie longue, matelas, etc.]`

## Récap & rappels Jarvis

- Garanties expirant dans les 30 jours : `[À calculer une fois rempli]`
- Garanties expirées récemment (réclamation possible si panne) : `[À remplir]`
- Lieu de stockage des factures originales (papier) : `[À remplir]`
- Lieu de stockage des scans (OneDrive `Factures/` ?) : `[À remplir]`

## Liens

- Hub : `[[10_Domaines/ViePerso/_Index]]`
- Lié : `[[10_Domaines/ViePerso/Voiture]]`, `[[10_Domaines/ViePerso/Abonnements]]`
- Auto-memories liées : `reference_pc_config_might`, `reference_zigbee_dongles_might`, `reference_onduleurs_might`
