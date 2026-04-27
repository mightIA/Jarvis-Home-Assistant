---
name: Délai 5-7s du premier rendu vue type sections après save
description: Lorsqu'une vue Lovelace passe de masonry (cards[]) à type sections (sections[]) avec badges browser_mod, le premier reload après save peut afficher une page vide pendant 5-7 secondes ou freeze le renderer brièvement. Ne pas rollback prématurément.
type: feedback
created: 2026-04-25
session: 50
---

# Délai 5-7 s du 1er rendu vue `type: sections` + badges

**Règle** : après avoir saved une vue Lovelace qui passe de `cards[]`
(layout masonry historique) à `type: sections` + `sections[]` (layout
2024+), avec `badges:` browser_mod préservés (style 11 badges scènes/
shortcuts), **le premier reload de la page peut afficher une vue vide
pendant 5-7 s, voire freeze brièvement le renderer Brave** (screenshot
timeout 30s observé).

**Ne pas rollback prématurément** : naviguer vers une autre vue (ex:
Aperçu) pour libérer le tab, puis revenir sur la vue cible — le rendu
sera alors immédiat et complet.

## Why

- Le moteur Lovelace doit recompiler le layout côté frontend (basculer
  d'un système de cellules masonry à un système de sections grid avec
  `max_columns`).
- Les badges browser_mod déclenchent des callbacks DOM (refresh,
  history.back, scènes) qui sollicitent la WebSocket et JS asynchrone
  au mount initial.
- Le rendu sections + badges + history-graph (qui doit puller 24h de
  données depuis le recorder) peut additionner les latences.
- Le timeout screenshot Cowork (30 s) déclenche avant que la page soit
  rendue, donnant l'illusion d'un crash.

## How to apply

1. Après un `hass.callWS save` qui change `type: cards/masonry` →
   `type: sections`, faire un 1er reload mais **ne pas conclure d'un
   échec si la page reste vide 5-10 s**.
2. Si le screenshot timeout après 30 s, le tab n'est probablement pas
   crashé — naviguer vers une autre URL HA (ex: `/lovelace/default_view`)
   pour libérer le tab, attendre 4 s, screenshot.
3. Re-naviguer vers la vue cible — cette fois le rendu sera immédiat
   et complet.
4. Si après 2-3 re-navigations toujours vide, alors envisager un
   rollback réel (objet `window.__jarvis_old_view` sauvegardé en
   amont, `lovelace/config/save` avec l'ancienne config).

## Validé S50 sur

Refonte vue Réseaux (`/lovelace/reseaux`) après save via `hass.callWS` :
1er reload → page vide 3 s + screenshot timeout 30 s. Navigation vers
`/lovelace/default_view` (4 s wait) puis retour `/lovelace/reseaux` →
rendu parfait des 2 sections (Internet + Zigbee/Matter) + 11 badges +
history-graph 24h Débits.

## Lien connexe

`feedback_hass_callws_bypass_mcp.md` (procédure de bypass MCP HA via
JavaScript Brave qui produit ce délai au premier rendu).
