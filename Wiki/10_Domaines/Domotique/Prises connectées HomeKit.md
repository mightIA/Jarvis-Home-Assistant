---
title: Prises connectées HomeKit
created: 2026-04-29
updated: 2026-05-02
tags: [atome, domotique, domotique/prises, ha, ha/integration, ha/homekit]
status: actif
source: MCP HA (ha_get_integration / ha_search_entities) — S86
---

# Prises connectées (Child lock HomeKit)

Lot de **5 prises connectées** intégrées à Home Assistant via le **HomeKit Controller**, exposant chacune une fonction Child lock (verrou parental). Le verrou empêche l'allumage/extinction de la prise depuis HomeKit ou Home Assistant tant qu'il est actif.

## Identification

- **Marque / modèle** : prises connectées compatibles HomeKit (modèle exact à compléter selon facture — vérifier dans `Inventaire/Garanties_Factures` ou photo des prises)
- **Nombre d'unités** : **5 prises**
- **Mode d'intégration HA** : **HomeKit Controller** (mode `accessory`, source HA reçoit les accessoires HomeKit comme appareils natifs)
- **Domain HA** : `homekit`
- **État** : configuré et fonctionnel (toutes les entrées d'intégration en `state: loaded`)

## Inventaire des 5 prises

| # | Nom HomeKit | Pièce / Usage | Entry ID HA | Child lock actuel |
|---|---|---|---|---|
| 1 | `Prise fixe cuisine porte Child lock:21067` | Cuisine — porte | `01J8ZTHKA0YYAJNSMH2PY928KY` | off |
| 2 | `Prise mobile 1 Child lock:21068` | Mobile (déplacement libre) | `01J8ZTHKA1MWZRAZ5HA5J48YTT` | off |
| 3 | `Prise mobile Climatiseur Child lock:21069` *(ex « Prise mobile 2 »)* | Climatiseur | `01J8ZTHKA3S0PK81QTH94W2FVE` | **on 🔒** |
| 4 | `Prise fixe PC Chambre Child lock:21070` | Chambre — PC fixe | `01J8ZTHKA5557JVPCF579RMJ4G` | off |
| 5 | `PC-Might Child lock` | Bureau — PC Might (fixe) | *(à confirmer)* | **on 🔒** |

## Entités principales (Child lock)

| Entité | Type | Description |
|---|---|---|
| `switch.prise_fixe_cuisine_porte_child_lock` | switch | Verrou prise cuisine porte |
| `switch.prise_mobile_1_child_lock` | switch | Verrou prise mobile 1 |
| `switch.prise_mobile_climatiseur_child_lock` | switch | Verrou prise climatiseur (actif) |
| `switch.prise_fixe_pc_chambre_child_lock` | switch | Verrou prise PC chambre |
| `switch.pc_might_child_lock` | switch | Verrou prise PC Might (actif) |

> **Note** : ce sont les entités du **verrou**. Les entités on/off de la prise elle-même (alimentation) sont sur le même device — typiquement `switch.<nom_prise>` sans le suffixe `_child_lock`. À compléter au fil de l'eau si besoin.

## Services / Scripts

| Service | Paramètres | Usage |
|---|---|---|
| `switch.turn_on` / `switch.turn_off` | `entity_id: switch.<prise>_child_lock` | Activer / désactiver le verrou parental |
| `switch.toggle` | `entity_id: switch.<prise>_child_lock` | Bascule du verrou |

## Automations associées

| Automation | Trigger | Action |
|---|---|---|
| *(aucune répertoriée)* | — | À documenter si Mickael en crée |

> Idée d'automation envisageable : verrouillage automatique du climatiseur la nuit (entre minuit et 6 h) pour éviter une mise en route accidentelle.

## Visualisation Lovelace

À documenter — page concernée et type de carte (Entities, Tile, Glance ?). Probablement intégrées au dashboard "Sécurité" ou "Prises".

## Dépannage

- **Si une prise disparaît de HA** : vérifier dans `Paramètres → Appareils & services → HomeKit Controller` que l'entrée est toujours `loaded`. En cas de `setup_retry`, redémarrer la prise (débrancher 10 s).
- **Re-pairage HomeKit** : si une prise est physiquement retirée puis remise, il faut souvent supprimer et re-pairer l'accessoire HomeKit dans HA (entry_id change).

## Notes liées

- [[_Index|Hub Domotique]]
- [[../HomeAssistant/_Index|Domaine Home Assistant]]
- [[../Inventaire/Cuisine|Inventaire Cuisine]] (prise cuisine porte)
- [[../Inventaire/Chambre_principale|Inventaire Chambre]] (prise PC chambre)
- [[../Inventaire/Bureau|Inventaire Bureau]] (PC-Might)

---

*Fiche complétée S86 (2026-05-02) — T#80. Source MCP HA : `ha_get_integration(query="homekit")` + `ha_search_entities(query="child lock")`.*
