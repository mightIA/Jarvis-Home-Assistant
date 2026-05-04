---
name: close-task
description: Clôture une tâche en passant son status à done (ou cancelled), ajoute session_closed, déplace le fichier vers tasks/archive_2026-Q2/ via git mv, puis lance regen-tasks-index. À déclencher quand Mickael ou Jarvis dit "ferme T#XX", "clôture tâche XX", "archive T#XX", "T#XX est fait".
---

# Skill — Clôturer une tâche

## Quand utiliser

- *"ferme T#88"*, *"clôture T#88"*, *"archive T#88"*
- *"T#88 est fait"*, *"T#88 done"*
- À la fin d'une opération qui résout entièrement une tâche existante.

## Procédure

1. **Vérifier que la tâche existe** : `ls tasks/task_NNN.md`. Si elle est déjà dans `archive_2026-Q2/`, c'est qu'elle a déjà été clôturée — pas besoin de refaire.
2. **MAJ le frontmatter** :
   - `status: open` → `status: done` (ou `cancelled` si abandonnée)
   - Ajouter `session_closed: SXX` (session courante)
3. **Enrichir la section Statut** avec un résumé de la résolution (qui, quoi, références session).
4. **Déplacer le fichier** vers archive :

   ```bash
   # Path Cowork dynamique (change à chaque session) :
   COWORK_DIR="$(find /sessions -maxdepth 4 -type d -name 'Jarvis - Home Assistant' 2>/dev/null | head -1)"
   cd "$COWORK_DIR"
   git mv tasks/task_NNN.md tasks/archive_2026-Q2/
   ```

   *Ou si on n'est pas dans un commit Git pendant :* `mv` suffit (pas d'historique préservé).

5. **Régénérer l'index** : lancer la skill `regen-tasks-index` (ou `python3 .claude/skills/regen-tasks-index/scripts/rebuild_tasks_index.py`).

## Cas particuliers

### Tâche partiellement faite

Ne pas la clôturer. Mettre `status: in_progress` et enrichir la section Statut avec ce qui reste. Régénérer l'index.

### Tâche obsolète (le besoin n'existe plus)

`status: cancelled` + ajouter dans Statut la raison ("Plus pertinent depuis SXX car..."). Déplacer en archive.

### Tâche réouverte plus tard

Si on doit ré-ouvrir une tâche archivée :

```bash
git mv tasks/archive_2026-Q2/task_NNN.md tasks/
```

Puis MAJ frontmatter (`status: open`, retirer `session_closed`, ajouter une note dans Statut "Ré-ouverte SXX car..."), puis regen-tasks-index.

## Convention rappel

- **IDs append-only** : T#88 reste `task_088.md` à vie même après archive.
- Une tâche n'est **jamais supprimée**, juste déplacée en archive.
- À chaque trimestre (1er juillet, 1er octobre) : créer `tasks/archive_2026-Q3/`, `tasks/archive_2026-Q4/` etc. Les anciennes archives restent.

## Workflow combiné

```
add-task → tâche en cours → close-task → archive
   ↓                            ↑
   └─────── regen-tasks-index ──┘
```

Les 3 skills `add-task`, `close-task`, `regen-tasks-index` couvrent l'intégralité du cycle de vie d'une tâche dans le projet.
