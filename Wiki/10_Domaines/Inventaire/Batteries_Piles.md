---
title: Inventaire — Batteries / Piles
created: 2026-04-27
updated: 2026-04-27
tags: [atome, inventaire, piles, batteries, transverse, maintenance]
status: stub
domaine: Inventaire
remplissage_attendu: Mickael
---

# Inventaire — Batteries / Piles

> **Template à remplir.** Mickael complétera lors d'une session dédiée.
>
> Inventaire transverse : tous les équipements alimentés par pile (Zigbee, télécommandes, capteurs, alarmes).
> Permet d'anticiper les remplacements + automatiser des alertes HA quand `battery_level < 20%`.

## Inventaire piles à surveiller

| Équipement | Pièce | Type pile | Quantité | Date dernière recharge / changement | Entité HA `battery` | Notes |
|---|---|---|---|---|---|---|
| Capteur humidité SDB | [[Salle_de_bain]] | (à préciser : CR2032 / AA / lithium 3.7V) | 1 | (à préciser) | (à préciser) | Voir [[Salle_de_bain]] |
| Capteurs Zigbee divers | (à préciser) | CR2032 (probable) | ? | (à préciser) | (à préciser) | Export Zigbee2MQTT à faire |
| Télécommandes TV | [[Salon]] | AA / AAA | ? | (à préciser) | — | Non connecté |
| Télécommandes ampli | [[Salon]] | AA / AAA | ? | (à préciser) | — | |
| Transmetteurs IR ampoules cuisine | [[Cuisine]] | (à préciser — T#13) | ? | (à préciser) | — | Audit T#13 |
| Détecteurs fumée | (à préciser) | 9V ou lithium 10 ans | ? | (à préciser) | — | Obligation légale |
| Détecteur CO | (à préciser) | (à préciser) | ? | (à préciser) | — | |
| ... | ... | ... | ... | ... | ... | ... |

## Stock de piles disponibles

| Type | Quantité | Localisation stock | Notes |
|---|---|---|---|
| AA | ... | ... | ... |
| AAA | ... | ... | ... |
| CR2032 | ... | ... | ... |
| CR2450 | ... | ... | ... |
| 9V | ... | ... | ... |
| Lithium 3.7V (LiPo / 18650) | ... | ... | ... |
| ... | ... | ... | ... |

## Batteries rechargeables

| Modèle | Type | Capacité | Localisation | Notes |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

## Automatisation HA suggérée

- Créer un dashboard "Piles" listant toutes les entités `sensor.*_battery` triées par % croissant.
- Créer une automatisation : `battery_level < 20%` → notification HA `notify.might57290_gmail_com` + push iOS.
- Voir [[10_Domaines/HomeAssistant/_Index]] et skill `home-assistant-best-practices`.

## Liens internes

- [[Salon]]
- [[Cuisine]]
- [[Chambre_principale]]
- [[Autres_chambres]]
- [[Salle_de_bain]]
- [[Bureau]]
- [[Garage_Cave]]
- [[Exterieur]]

## Sources de remplissage à venir

- Export Zigbee2MQTT (CSV avec colonnes battery, last_seen, link_quality)
- Inspection physique des télécommandes et détecteurs
- Audit T#13 ampoules cuisine
