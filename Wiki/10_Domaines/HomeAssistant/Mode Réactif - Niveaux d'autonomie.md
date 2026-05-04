---
title: Mode Réactif — 5 niveaux d'autonomie
created: 2026-04-25
updated: 2026-04-25
tags: [atome, ha/mode-reactif, jarvis/autonomie]
status: actif
---

# Mode Réactif — 5 niveaux d'autonomie

Fichier de config local : `config/autonomie.yaml`
Helper HA : `input_select.jarvis_niveau_autonomie` (state actif lu à
chaque exécution de la skill `check-jarvis-alert`)

Niveau **par défaut** au démarrage : **3 (Prudent)**.

## Les 5 niveaux

| Niveau | Nom | Comportement |
|:---:|:---|:---|
| **5** | Max auto | Jarvis agit sur tous les événements classés *safe*, propose le reste |
| **4** | Équilibré | Actions *safe* auto, le reste en mode propose |
| **3** | Prudent *(défaut)* | Tout en mode propose, **sauf** débannissement IP (exception validée) |
| **2** | Signalement | Jarvis alerte uniquement, aucune action prise |
| **1** | Off réactif | Mode réactif éteint, seul le mode conversation reste actif |

La classification *safe / non-safe* est définie événement par événement
dans `config/reactif_events.yaml`.

## Triple kill switch

Trois niveaux de désactivation — cf. `Ressources/Competences/Mode_Reactif.md` §6 :

| Niveau | Helper / Fichier | Action |
|---|---|---|
| Global HA | `input_boolean.jarvis_mode_reactif` | OFF → automations HA n'envoient plus de mail |
| Curseur | `input_select.jarvis_niveau_autonomie` | Lu à chaque run, modifie le comportement |
| Par événement | `config/reactif_events.yaml` | Champ `enabled: true/false` par event |

## État Phase 1 (au 22/04/2026)

| Helper | État S29 |
|---|---|
| `input_boolean.jarvis_mode_reactif` | ON (kill switch) |
| `input_boolean.jarvis_event_ban_ip` | ON |
| `input_boolean.jarvis_event_log_erreur_critique` | OFF (probable garde-fou spam zigbee) |
| `input_select.jarvis_niveau_autonomie` | « 3 - Prudent » |
| `counter.jarvis_alertes_jour` | live |
| `input_text.jarvis_derniere_alerte` | live |
| `input_number.jarvis_alertes_attente` | 0 |

## Notes liées

- [[Mode Réactif - Vue d'ensemble]]
- [[Mode Réactif - Pipeline alertes]]
- [[Mode Réactif - Décisions S31 CLI]]

---

*Source : `Ressources/Competences/Mode_Reactif.md` §3 + §6.*
