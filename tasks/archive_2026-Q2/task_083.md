---
id: 83
title: "Tests unitaires sur rebuild_tasks_index.py (bug t fm latent)"
status: done
priority: P2
session_opened: S76
session_closed: S77
tags: [tests, scripts, tasks-system]
source: "Session S76 / Demande Mickael (2026-04-29)"
---

# T#83 — Tests unitaires sur rebuild_tasks_index.py (bug t fm latent)

## Description

Couvrir par tests unitaires les 3 fonctions pures du script de regen
TASKS.md (parcours `tasks/*.md` + frontmatter parsing + tri) :

- `parse_frontmatter` — parser YAML interne minimal (15+ cas).
- `sort_key` — tri prio/statut/ID avec garde-fou anti-régression bug
  latent S76 (`t["frontmatter"]` au lieu de `t["fm"]`).
- `status_emoji` — mapping statut → emoji (7 statuts + inconnus).
- Constantes `STATUS_ORDER` / `PRIO_ORDER` — exhaustivité.

## Source / Échéance

Session S76 / Demande Mickael (2026-04-29)

## Statut

Fait S77 (29/04/2026) :
- Fichier `.claude/skills/regen-tasks-index/scripts/test_rebuild_tasks_index.py`
  créé (~7 KB, 30 tests).
- **30/30 tests OK en 0.003s** (Python 3 / unittest).
- Test anti-régression `test_reads_fm_key_not_frontmatter` ajouté
  spécifiquement pour le bug `t["frontmatter"]` corrigé S76.
- Lancement : `python3 .claude/skills/regen-tasks-index/scripts/test_rebuild_tasks_index.py`
