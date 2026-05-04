---
name: lovelace-edit
description: Edition Lovelace via WebSocket `hass.callWS` (jamais editer fichiers dashboard directement). DECLENCHEURS : 'ajoute carte/section/badge', 'cree page Lovelace', 'modifie le dashboard', 'reorganise les cartes', 'corrige carte qui s'affiche pas', 'masonry/sections/stack', 'custom:button-card', 'theme dashboard', 'edite vue Y'. Couvre creation cartes, sections, onglets, badges, button-card, themes. Toujours proposer SAUVEGARDE config avant modification significative.
---

# Skill : Edition Lovelace

## Quand cette skill est declenchee

- Demande de modification d'une page Lovelace (ajout de carte, section,
  reorganisation).
- Demande de creation d'une nouvelle vue / page.
- Demande d'ajout d'un badge sur une ou plusieurs vues.
- Correction d'une carte qui ne s'affiche pas correctement.

## Regle d'or

**Toujours utiliser `hass.callWS`** pour lire et ecrire la configuration
Lovelace. Ne jamais editer les fichiers dashboard directement.

### Lire la config

```js
hass.callWS({
  type: "lovelace/config",
  url_path: null  // null = dashboard principal, ou ID du dashboard
})
```

### Ecrire la config

```js
hass.callWS({
  type: "lovelace/config/save",
  url_path: null,
  config: { /* config complete modifiee */ }
})
```

## Bonnes pratiques

1. **Lire avant d'ecrire** : toujours recuperer la config actuelle
   complete, la modifier, puis la re-ecrire. Ne jamais ecrire un fragment.
2. **Sauvegarde mentale** : avant modification significative, proposer a
   Mickael d'exporter la config via l'interface (3 points en haut a droite
   > Ouvrir le fichier brut > copier-coller).
3. **Tester immediatement** : apres modification, rafraichir la page
   (Browser Mod `refresh`) et verifier visuellement.

## Patterns de mise en page

- **Masonry** : disposition flexible par colonnes auto (preferable pour pages
  a cartes heterogenes : Home, Chaudiere).
- **Sections** : grille de colonnes numerotees, `max_columns: 3` typique
  (Lumieres, Cameras, Dyson Purifier).
- **Vertical-stack / horizontal-stack** : empilement rigide, utile pour
  regrouper des cartes apparentees.

## Cartes frequemment utilisees

| Carte                  | Usage                                              |
|------------------------|----------------------------------------------------|
| `entities`             | Liste d'entites avec etat                          |
| `glance`               | Vue compacte d'entites                             |
| `button`               | Bouton simple                                      |
| `custom:button-card`   | Bouton personnalise avancé (template, styles)      |
| `thermostat`           | Controle climat / water_heater                     |
| `gauge`                | Jauge pour capteurs numeriques                     |
| `history-graph`        | Graphique d'historique                             |
| `statistics-graph`     | Graphique de statistiques long terme               |
| `picture-glance`       | Image de fond + badges (utile pour flux cameras)   |
| `markdown`             | Texte riche                                        |
| `iframe`               | Page web integree (ex : SVG Dyson)                 |
| `media-control`        | Controle media (TV, Music Assistant)               |

## Badges universels

Voir la skill `browser-mod` pour la creation de badges fonctionnels
(Refresh, Back, Forward, Scenes, Capteurs mouvement).

## Regles de securite

- **Aucun rechargement HA** requis pour modifier Lovelace — les changements
  sont live via callWS.
- Ne pas ecraser une vue sans avertissement.
- Proposer un test visuel apres chaque modification.


## Exemples d'invocation utilisateur

- « Ajoute une carte Dyson sur la page Salon » → lire config via `lovelace/config`, modifier, ecrire via `lovelace/config/save`.
- « Refais la page Lumieres en 3 colonnes » → modifier `views[N].sections` ou utiliser layout `sections` avec `max_columns:3`.
- « La carte camera ne s'affiche pas » → diagnostic via console navigateur + verif entite source via `ha-status`.
- « Sauvegarde le dashboard avant modif » → `hass.callWS({type:"lovelace/config", url_path:null})` puis copier-coller pour Mickael.

## Quand NE PAS utiliser

- Pour modifier une AUTOMATION ou un SCRIPT — utiliser `yaml-automation` ou `home-assistant-manager`.
- Pour creer un NOUVEAU dashboard (pas une vue) — passer par UI HA `Settings > Dashboards > Create dashboard` (la callWS exige un dashboard deja existant).
- Pour le theme global HA — utiliser `themes.yaml` + reload, pas Lovelace.

## Pieges connus

- **Lire AVANT d'ecrire** : toujours recuperer la config COMPLETE actuelle, modifier, re-ecrire. Ecrire un fragment ECRASE le reste.
- **`url_path: null`** = dashboard principal. Pour un dashboard nomme : `url_path: "energy"` ou autre slug. Confondre les deux ECRASE le mauvais dashboard.
- **Pas de rechargement HA** requis : Lovelace est live via callWS. Si Mickael propose `ha_reload_core` apres edit Lovelace, refuser (inutile).
- **JSON vs YAML** : `hass.callWS` attend du JSON. Si Mickael fournit du YAML il faut convertir avant.
- **Sauvegarde avant** : pour toute modification > 1 carte, proposer export config par 3-points > Raw editor > copier-coller (rollback humain).

## Reference longue

Voir `Ressources/Competences/Home_Assistant.md` sections 4.2, 7, 9.
