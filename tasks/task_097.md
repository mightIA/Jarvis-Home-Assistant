---
id: 97
title: "Linter longueur min sur tasks/*.md dans rebuild_tasks_index.py (anti-troncature silencieuse)"
status: open
priority: P3
session_opened: S109
tags: [linter, quality, regen-tasks-index, anti-recidive]
source: "Session 109 / Incident troncature silencieuse task_076.md (frontmatter intact, corps coupé)"
---

# T#97 — Linter longueur min sur tasks/*.md (anti-troncature silencieuse)

## Description

Suite incident S109 : `tasks/task_076.md` retrouvé tronqué à 34 lignes (corps coupé en plein header de tableau Phase 1, frontmatter intact). Cause probable : hook destructif S108 ou Edit interrompu. La skill `regen-tasks-index` n'a rien détecté car elle ne lit que le frontmatter pour produire `TASKS.md` — le corps n'est jamais contrôlé.

**Objectif** : ajouter un check de longueur minimum dans le script `rebuild_tasks_index.py` pour détecter automatiquement les futures troncatures silencieuses lors de chaque régénération.

## Spécification

Modifier `.claude/skills/regen-tasks-index/scripts/rebuild_tasks_index.py` pour :

1. **Mesurer la taille en bytes** de chaque `tasks/task_NNN.md` lors du parcours.
2. **Lever un warning console** (et idéalement section "anomalies" en tête de TASKS.md) si :
   - `wc -c < 500` bytes ET status ∈ {`testing`, `in_progress`, `open`} sur tâche complexe
   - `wc -l < 30` lignes ET status ∈ {`testing`, `in_progress`}
3. **Seuil ajustable** via constante en tête de script (`MIN_BYTES = 500`, `MIN_LINES_TESTING = 30`).
4. **Ne pas bloquer la régénération** — warning seulement (la tâche peut être légitimement courte).
5. **Output** : `[regen-tasks-index] ⚠ task_076.md (34 lignes / 1234 bytes / status=testing) — POSSIBLE TRONCATURE`

## Lien T#85

T#85 (Linter type cclint sur CLAUDE.md/TASKS.md/incohérences auto) couvre une portée plus large. Ce T#97 est un sous-ensemble ciblé spécifiquement sur le check de longueur des `tasks/*.md` — peut être absorbé dans T#85 ou traité indépendamment plus rapide.

## Pré-requis

- Aucun (pure modif Python script existant)

## Livrables attendus

- (a) Modification `rebuild_tasks_index.py` avec check + warning console
- (b) Tests : régénérer `TASKS.md` après modif → confirmer 0 warning sur état actuel (sauf si vraies tâches courtes restent)
- (c) MAJ SKILL.md `regen-tasks-index` section "Vérifications post-régénération" avec note sur le warning

## Liens

- Auto-memory anti-récidive : [`memory/feedback_troncature_silencieuse_task_files.md`](../memory/feedback_troncature_silencieuse_task_files.md)
- Skill cible : [`.claude/skills/regen-tasks-index/SKILL.md`](../.claude/skills/regen-tasks-index/SKILL.md)
- Tâche apparentée : [T#85 Linter type cclint](task_085.md)
- Incident source : reconstruction `task_076.md` S109 (cf. récit session)
