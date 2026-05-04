---
name: add-task
description: Crée un nouveau fichier tasks/task_NNN.md avec frontmatter YAML + template, en auto-incrémentant le numéro à partir du max existant (ouvertes + archivées). À déclencher quand Mickael ou Jarvis dit "nouvelle tâche", "ajoute une tâche", "crée tâche", "ajoute T#XX". Ouvre l'éditeur sur le fichier créé puis lance regen-tasks-index pour MAJ TASKS.md.
---

# Skill — Ajouter une nouvelle tâche

## Quand utiliser

- *"ajoute une tâche : ..."*
- *"crée tâche pour ..."*
- *"nouvelle tâche : ..."*
- Spontanément quand Mickael ou Jarvis identifie un travail à faire qui ne tient pas dans la session courante.

## Procédure

1. **Identifier le prochain numéro libre** (script auto) : max(id) + 1 sur l'ensemble `tasks/*.md` + `tasks/archive_2026-Q2/*.md`.
2. **Demander à Mickael** (si pas déjà fourni) : titre court, priorité (P0-P3), tags pertinents.
3. **Créer le fichier** `tasks/task_NNN.md` (zero-pad 3) avec frontmatter complet + sections vides.
4. **Lancer la skill `regen-tasks-index`** pour mettre à jour `TASKS.md`.

## Lancement script (Ubuntu / sandbox bash Cowork)

> ⚠ Le path `/sessions/<sandbox>/mnt/...` change à chaque session Cowork.
> Détecter dynamiquement le mount avant exécution — ne **jamais** hardcoder.

```bash
COWORK_DIR="$(find /sessions -maxdepth 4 -type d -name 'Jarvis - Home Assistant' 2>/dev/null | head -1)"
cd "$COWORK_DIR"
python3 .claude/skills/add-task/scripts/add_task.py \
  --title "Titre court" \
  --priority P2 \
  --tags "ha-mcp,security" \
  --session "S71"
```

## Lancement script (PowerShell)

```powershell
cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
python .claude\skills\add-task\scripts\add_task.py `
  --title "Titre court" `
  --priority P2 `
  --tags "ha-mcp,security" `
  --session "S71"
```

## Frontmatter généré

```yaml
---
id: 89                          # Auto-incrémenté
title: "Titre court"
status: open                    # Toujours "open" à la création
priority: P2
session_opened: S71
tags: [ha-mcp, security]
source: "Session 71 / Demande Mickael"
---
```

## Après création

Le script affiche le chemin du fichier créé et lance automatiquement `rebuild_tasks_index.py`. À toi (ou Mickael) d'ouvrir le fichier pour enrichir les sections **Description**, **Source / Échéance**, **Statut** si besoin.

## Convention rappel

- **IDs append-only** : T#89 reste `task_089.md` à vie, même après archivage.
- **Pad 3 chiffres** par défaut (`task_001`...`task_999`). Pour scaling > 999, le script bascule auto en pad 4.
- **Suffixes alpha autorisés** (`task_050a.md`, `task_050b.md`) si tu veux dériver une sous-tâche.

## Création manuelle (sans script)

Si le script n'est pas dispo (skill non chargée ou cas spécial) :

1. `ls tasks/task_*.md tasks/archive_2026-Q2/task_*.md | sed -E 's|.*task_0*([0-9]+).*|\1|' | sort -n | tail -1` → numéro max actuel.
2. Créer `tasks/task_<num+1>.md` avec frontmatter copié depuis un fichier existant.
3. Lancer `regen-tasks-index`.
