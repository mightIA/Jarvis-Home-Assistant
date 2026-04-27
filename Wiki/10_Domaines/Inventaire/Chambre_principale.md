---
title: Inventaire — Chambre principale
created: 2026-04-27
tags: [inventaire, chambre, principale]
status: coquille
domaine: Inventaire
remplissage_attendu: Mickael
---

# Inventaire — Chambre principale

> **Template à remplir.** Mickael complétera lors d'une session dédiée.

## Équipements connectés (HA / Zigbee / WiFi)

| Nom | Type | Marque/Modèle | Entité HA | Pile | Notes |
|---|---|---|---|---|---|
| Caméra chambre | Caméra IP | Dahua (MAC `c4:aa:c4:4b:68:40`) | (`onvif`) | — | Voir [[10_Domaines/Cameras/_Index]] |
| MightTab | Tablette | (à préciser modèle) | (`mobile_app` MightTab) | — | Compte HA secondaire — à restreindre `local_only` (TASKS #9) |
| Prise fixe PC Chambre | Prise connectée | (à préciser) | `switch.prise_fixe_pc_chambre` | — | Child lock HomeKit Bridge `Prise fixe PC Chambre Child lock:21070` |
| ... | ... | ... | ... | ... | ... |

## Équipements non connectés

| Nom | Type | Marque/Modèle | Date achat | Garantie | Notes |
|---|---|---|---|---|---|
| ... | ... | ... | ... | ... | ... |

## Mobilier / éléments fixes

- Lit : ...
- Armoire / dressing : ...
- Tables de nuit : ...
- Volets / stores : ...

## Liens internes

- [[10_Domaines/Cameras/_Index]] (caméra chambre)
- [[Reseau_Maison]] (IP MightTab + caméra)

## Sources de remplissage à venir

- Photos chambre (vue d'ensemble + zoom MightTab + prises)
- Modèle exact MightTab (à confirmer)
- Capture écran dashboard HA chambre principale si existe
