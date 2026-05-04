---
name: regen-tasks-index
description: Régénère l'index TASKS.md à partir des frontmatters YAML de tasks/*.md. À déclencher quand Mickael ajoute, modifie, clôture ou archive une tâche, ou demande "régénère l'index des tâches" / "rebuild tasks" / "tri auto des tâches" / "MAJ TASKS.md". Lit tasks/*.md (ouvertes) + tasks/archive_2026-Q2/*.md (clôturées sauf si exclues), trie par priorité (P0→P3) puis statut (in_progress→open→pending→testing→deferred→done), écrit TASKS.md avec en-tête AUTO-GENERATED. Compatible Obsidian Dataview.
---

# Skill — Régénération de l'index TASKS.md

## Quand utiliser cette skill

À déclencher dès que :

- Mickael ou Jarvis **ajoute** un nouveau fichier `tasks/task_NNN.md` (nouvelle tâche)
- Mickael ou Jarvis **modifie le frontmatter** d'une tâche (statut, priorité, titre, tags)
- Une tâche **passe en `done`** : la déplacer manuellement vers `tasks/archive_2026-Q2/` puis lancer la skill (le script ne déplace pas les fichiers, il ne fait que reconstruire l'index)
- Mickael demande explicitement : *"régénère l'index"*, *"rebuild tasks"*, *"tri auto"*, *"MAJ TASKS.md"*, *"refais TASKS.md"*

**Quand NE PAS utiliser** :
- Si tu n'as pas modifié `tasks/*.md` dans la session courante (rien à régénérer).
- Si Mickael te demande juste de lire une tâche (utilise `Read` sur `tasks/task_NNN.md` directement).

## Architecture du système de tâches

```
Jarvis - Home Assistant/
├── TASKS.md                    ← INDEX AUTO-GENERATED (ne pas éditer à la main)
├── tasks/
│   ├── task_001.md             ← 1 fichier par tâche ouverte
│   ├── task_002.md
│   ├── ...
│   └── archive_2026-Q2/
│       ├── task_001.md         ← Tâches clôturées (status: done|cancelled)
│       └── ...
└── .claude/skills/regen-tasks-index/
    ├── SKILL.md                ← Ce fichier
    └── scripts/
        └── rebuild_tasks_index.py
```

## Frontmatter YAML attendu (par tâche)

```yaml
---
id: 88                          # Numéro tâche (peut être "3b", "50a", "50b" etc.)
title: "Titre court (≤80 chars)"
status: open                    # open | in_progress | testing | pending | deferred | done | cancelled
priority: P1                    # P0 (critique) | P1 (haute) | P2 (moyenne) | P3 (basse)
session_opened: S69             # Optionnel
session_closed: S70             # Optionnel (uniquement pour done|cancelled)
tags: [security, ha-mcp]        # Optionnel
source: "Session 69 / Demande Mickael"
---

# T#88 — Titre court

## Description
... (texte long, autant de détail que voulu)

## Source / Échéance
...

## Statut
... (historique multi-MAJ, références sessions, décisions)
```

## Procédure d'exécution

### 1. Vérifier l'environnement

```bash
# Path Cowork dynamique (change à chaque session) :
COWORK_DIR="$(find /sessions -maxdepth 4 -type d -name 'Jarvis - Home Assistant' 2>/dev/null | head -1)"
cd "$COWORK_DIR"
ls tasks/*.md | wc -l                        # tâches ouvertes
ls tasks/archive_2026-Q2/*.md | wc -l        # tâches archivées
```

### 2. Lancer le script Python

À coller dans **Ubuntu (sandbox bash Cowork)** :

```bash
# Path Cowork dynamique (change à chaque session) :
COWORK_DIR="$(find /sessions -maxdepth 4 -type d -name 'Jarvis - Home Assistant' 2>/dev/null | head -1)"
cd "$COWORK_DIR"
python3 .claude/skills/regen-tasks-index/scripts/rebuild_tasks_index.py
```

À coller côté **PowerShell** (lancement manuel hors session Cowork) :

```powershell
cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
python .claude\skills\regen-tasks-index\scripts\rebuild_tasks_index.py
```

### 3. Sortie attendue

```
[regen-tasks-index] Lecture de tasks/ et archives/
[regen-tasks-index]   - 41 tâches ouvertes
[regen-tasks-index]   - 34 tâches archivées
[regen-tasks-index] Tri par priorité (P0→P3) puis statut
[regen-tasks-index] Écriture TASKS.md (X.X KB, NN lignes)
[regen-tasks-index] OK — index régénéré le 2026-MM-DD HH:MM
```

### 4. Vérifications post-régénération

- `wc -c TASKS.md` doit donner **< 15 KB** (idéalement < 10 KB)
- `head -20 TASKS.md` montre l'en-tête AUTO-GENERATED + tableau des tâches HAUTE
- Diff Git : un seul fichier modifié = `TASKS.md`

## Règles importantes

1. **Append-only sur les IDs** : T#88 reste `task_088.md` à vie. **Ne jamais renuméroter** une tâche, même après archivage.
2. **Index = lecture seule** : ne jamais éditer `TASKS.md` à la main. Toute modification doit passer par un fichier `tasks/task_NNN.md` puis régénération.
3. **Archive trimestrielle** : déplacer `tasks/task_NNN.md` → `tasks/archive_2026-Q2/task_NNN.md` quand `status: done` (ou `cancelled`). Au 1er juillet, créer `tasks/archive_2026-Q3/`. Pattern aligné sur `memory/historique/<scope>_archive_YYYY-Qn.md`.
4. **Pas de suppression** : un fichier de tâche n'est jamais supprimé, seulement déplacé en archive (préserve historique Git via `git mv`).
5. **Ajout d'une nouvelle tâche** : créer `tasks/task_NNN.md` (NNN = max(id) + 1, pad 3), avec frontmatter complet, puis lancer cette skill.

## Backup et rollback

- Le script garde un backup `TASKS.md.previous` avant chaque écriture.
- En cas de souci, restaurer : `cp TASKS.md.previous TASKS.md`.
- Backup initial intégral S71 : `memory/_decongestion_backup_s71/TASKS.md.bak` (109 KB, 74 tâches au format pre-éclatement).

## Évolutions possibles (v2+)

- Pre-commit hook Git pour régénérer automatiquement à chaque commit modifiant `tasks/*.md`
- Filtre `--prio P0,P1` pour générer un index réduit
- Export Dataview natif (Obsidian) en complément du `TASKS.md` markdown
- Détection automatique des tâches `done` non encore déplacées (alerte)

## Références

- Skill créée S71 (28/04/2026) suite décongestion TASKS.md (106 KB → ~5 KB)
- Pattern inspiré de [Backlog.md](https://github.com/MrLesk/Backlog.md) (1 MD par tâche + index auto)
- Aligné sur convention `memory/historique/<scope>_archive_YYYY-Qn.md` du projet
