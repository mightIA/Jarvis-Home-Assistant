#!/usr/bin/env python3
"""
rebuild_tasks_index.py — Régénération de l'index TASKS.md

Parcourt tasks/*.md (ouvertes) + tasks/archive_2026-Q2/*.md (archivées),
extrait le frontmatter YAML de chaque, trie, et écrit TASKS.md.

Aucun argument requis. Lance-moi depuis la racine du projet.

Compatible Python 3.7+ (parser YAML interne minimal, pas de dépendance externe).
"""

from __future__ import annotations
import sys
import re
from pathlib import Path
from datetime import datetime


def find_project_root(start: Path) -> Path:
    cur = start.resolve()
    for _ in range(10):
        if (cur / "tasks").is_dir() or (cur / "TASKS.md").exists():
            return cur
        if cur.parent == cur:
            break
        cur = cur.parent
    return start.resolve()


ROOT = find_project_root(Path(__file__).parent)
TASKS_DIR = ROOT / "tasks"
ARCHIVE_DIRS = sorted(TASKS_DIR.glob("archive_*")) if TASKS_DIR.is_dir() else []
INDEX_FILE = ROOT / "TASKS.md"
BACKUP_FILE = ROOT / "TASKS.md.previous"


def parse_frontmatter(text):
    """Parser YAML minimal pour les frontmatters."""
    if not text.startswith("---"):
        return {}
    parts = text.split("---", 2)
    if len(parts) < 3:
        return {}
    fm_text = parts[1].strip()
    out = {}
    for line in fm_text.splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        m = re.match(r'^([\w_-]+)\s*:\s*(.*)$', line)
        if not m:
            continue
        key, val = m.group(1), m.group(2).strip()
        if val.startswith("[") and val.endswith("]"):
            inner = val[1:-1].strip()
            out[key] = [x.strip().strip('"').strip("'") for x in inner.split(",")] if inner else []
        elif (val.startswith('"') and val.endswith('"')) or (val.startswith("'") and val.endswith("'")):
            out[key] = val[1:-1]
        elif val.lower() in ("true", "false"):
            out[key] = val.lower() == "true"
        elif re.match(r'^-?\d+$', val):
            out[key] = int(val)
        else:
            out[key] = val
    return out


def collect_tasks():
    open_tasks = []
    archived_tasks = []
    if TASKS_DIR.is_dir():
        for f in sorted(TASKS_DIR.glob("task_*.md")):
            try:
                fm = parse_frontmatter(f.read_text(encoding="utf-8"))
                if fm:
                    open_tasks.append({"fm": fm, "path": f.relative_to(ROOT), "archived": False})
            except Exception as e:
                print(f"  WARN lecture {f.name}: {e}", file=sys.stderr)
    for adir in ARCHIVE_DIRS:
        for f in sorted(adir.glob("task_*.md")):
            try:
                fm = parse_frontmatter(f.read_text(encoding="utf-8"))
                if fm:
                    archived_tasks.append({"fm": fm, "path": f.relative_to(ROOT), "archived": True})
            except Exception as e:
                print(f"  WARN lecture {f.name}: {e}", file=sys.stderr)
    return open_tasks, archived_tasks


STATUS_ORDER = {"in_progress": 0, "open": 1, "testing": 2, "pending": 3, "deferred": 4, "done": 5, "cancelled": 6}
PRIO_ORDER = {"P0": 0, "P1": 1, "P2": 2, "P3": 3}


def sort_key(task):
    fm = task["fm"]
    prio = PRIO_ORDER.get(fm.get("priority", "P3"), 99)
    status = STATUS_ORDER.get(fm.get("status", "open"), 99)
    raw_id = str(fm.get("id", "999"))
    m = re.match(r'^(\d+)([a-z]?)$', raw_id)
    id_num = int(m.group(1)) if m else 999
    id_suffix = m.group(2) if m else ""
    return (prio, status, id_num, id_suffix)


def status_emoji(status):
    return {"in_progress": "🔄", "open": "🟢", "testing": "🧪", "pending": "⏸️",
            "deferred": "⏭️", "done": "✅", "cancelled": "❌"}.get(status, "❓")


def render_index(open_tasks, archived_tasks):
    now = datetime.now().strftime("%Y-%m-%d %H:%M")
    out = []
    out.append("---")
    out.append("title: Jarvis — Index des tâches")
    out.append(f"last_update: {now} (régénéré par .claude/skills/regen-tasks-index)")
    out.append("version: 3.0")
    out.append("auto_generated: true")
    out.append("---")
    out.append("")
    out.append("<!-- ⚠ AUTO-GENERATED par la skill `regen-tasks-index` — ne pas éditer à la main. -->")
    out.append("<!-- Pour modifier : éditer tasks/task_NNN.md puis lancer la skill. -->")
    out.append("")
    out.append("# TASKS — Index")
    out.append("")
    out.append(f"**{len(open_tasks)} tâches ouvertes** + **{len(archived_tasks)} archivées (Q2 2026)**.")
    out.append("")
    out.append("Détail de chaque tâche : `tasks/task_NNN.md`. Régénération : skill `regen-tasks-index`.")
    out.append("")

    open_sorted = sorted(open_tasks, key=sort_key)
    by_prio = {}
    for t in open_sorted:
        prio = t["fm"].get("priority", "P3")
        by_prio.setdefault(prio, []).append(t)

    prio_labels = {"P0": "🔴 P0 — Critique", "P1": "🟠 P1 — Haute",
                   "P2": "🟡 P2 — Moyenne", "P3": "⚪ P3 — Basse"}

    out.append("## Tâches ouvertes")
    out.append("")
    for prio in ["P0", "P1", "P2", "P3"]:
        if prio not in by_prio:
            continue
        out.append(f"### {prio_labels.get(prio, prio)}")
        out.append("")
        out.append("| # | Statut | Titre | Tags | Fichier |")
        out.append("|---|--------|-------|------|---------|")
        for t in by_prio[prio]:
            fm = t["fm"]
            tid = fm.get("id", "?")
            status = fm.get("status", "open")
            emoji = status_emoji(status)
            title = str(fm.get("title", "(sans titre)")).replace("|", "\\|")
            if len(title) > 70:
                title = title[:67] + "..."
            tags = fm.get("tags", [])
            if isinstance(tags, list):
                tags_str = ", ".join(tags[:4])
                if len(tags) > 4:
                    tags_str += f", +{len(tags)-4}"
            else:
                tags_str = str(tags)
            path = str(t["path"]).replace("\\", "/")
            out.append(f"| **T#{tid}** | {emoji} `{status}` | {title} | {tags_str} | [→]({path}) |")
        out.append("")

    out.append("## Archivées (Q2 2026)")
    out.append("")
    out.append(f"<details><summary>{len(archived_tasks)} tâches clôturées — déplier pour voir la liste</summary>")
    out.append("")
    out.append("| # | Statut | Titre | Session close | Fichier |")
    out.append("|---|--------|-------|---------------|---------|")
    archived_sorted = sorted(archived_tasks, key=sort_key)
    for t in archived_sorted:
        fm = t["fm"]
        tid = fm.get("id", "?")
        status = fm.get("status", "done")
        emoji = status_emoji(status)
        title = str(fm.get("title", "(sans titre)")).replace("|", "\\|")
        if len(title) > 60:
            title = title[:57] + "..."
        s_close = fm.get("session_closed", "—")
        path = str(t["path"]).replace("\\", "/")
        out.append(f"| T#{tid} | {emoji} | {title} | {s_close} | [→]({path}) |")
    out.append("")
    out.append("</details>")
    out.append("")
    out.append("## Légende statuts")
    out.append("")
    out.append("- 🔄 `in_progress` — en cours")
    out.append("- 🟢 `open` — à faire")
    out.append("- 🧪 `testing` — à tester / vérifier")
    out.append("- ⏸️ `pending` — en attente d'un pré-requis ou décision")
    out.append("- ⏭️ `deferred` — reportée volontairement")
    out.append("- ✅ `done` — terminée (archivée)")
    out.append("- ❌ `cancelled` — annulée (archivée)")
    out.append("")
    out.append("---")
    out.append("")
    # Détection gaps d'IDs (convention append-only S71 D4)
    all_ids = []
    for t in open_tasks + archived_tasks:
        tid = str(t["fm"].get("id", ""))
        if tid.isdigit():
            all_ids.append(int(tid))
    if all_ids:
        gaps = sorted(set(range(min(all_ids), max(all_ids) + 1)) - set(all_ids))
        if gaps:
            out.append(f"*IDs jamais matérialisés (append-only D4 S71) : {', '.join(f'T#{g}' for g in gaps)}*")
            out.append("")
    out.append(f"*Index régénéré automatiquement le {now}.*")
    out.append("")
    out.append("*Skill : `.claude/skills/regen-tasks-index/`*")
    out.append("")
    out.append(f"*Source : {len(open_tasks)} fichiers `tasks/*.md` + {len(archived_tasks)} fichiers `tasks/archive_2026-Q2/*.md`*")
    return "\n".join(out)


def main():
    print(f"[regen-tasks-index] Racine projet : {ROOT}")
    print(f"[regen-tasks-index] Lecture de tasks/ et archives/")
    open_tasks, archived_tasks = collect_tasks()
    print(f"[regen-tasks-index]   - {len(open_tasks)} tâches ouvertes")
    print(f"[regen-tasks-index]   - {len(archived_tasks)} tâches archivées")
    if not open_tasks and not archived_tasks:
        print("[regen-tasks-index] WARN Aucune tâche trouvée. Abandon.", file=sys.stderr)
        return 1
    print("[regen-tasks-index] Tri par priorité (P0->P3) puis statut (in_progress->done)")
    content = render_index(open_tasks, archived_tasks)
    if INDEX_FILE.exists():
        BACKUP_FILE.write_text(INDEX_FILE.read_text(encoding="utf-8"), encoding="utf-8")
        print(f"[regen-tasks-index] Backup cree : {BACKUP_FILE.name}")
    INDEX_FILE.write_text(content, encoding="utf-8")
    size_kb = len(content.encode("utf-8")) / 1024
    nlines = content.count("\n") + 1
    print(f"[regen-tasks-index] Ecriture TASKS.md ({size_kb:.1f} KB, {nlines} lignes)")
    print(f"[regen-tasks-index] OK - index regenere le {datetime.now().strftime('%Y-%m-%d %H:%M')}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
