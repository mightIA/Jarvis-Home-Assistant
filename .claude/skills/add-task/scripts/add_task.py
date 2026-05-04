#!/usr/bin/env python3
"""
add_task.py — Crée un nouveau fichier tasks/task_NNN.md avec frontmatter YAML.

Usage :
  python3 add_task.py --title "Titre court" --priority P2 --tags "tag1,tag2" --session "S71"

Le numéro est auto-incrémenté à partir du max existant (ouvertes + archivées).
Lance ensuite rebuild_tasks_index.py pour MAJ TASKS.md.
"""
from __future__ import annotations
import argparse
import re
import sys
import subprocess
from pathlib import Path
from datetime import date


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


def get_next_id() -> int:
    max_id = 0
    candidates = list(TASKS_DIR.glob("task_*.md"))
    for adir in ARCHIVE_DIRS:
        candidates.extend(adir.glob("task_*.md"))
    for f in candidates:
        m = re.search(r'task_(\d+)', f.stem)
        if m:
            max_id = max(max_id, int(m.group(1)))
    return max_id + 1


def main():
    p = argparse.ArgumentParser(description="Crée une nouvelle tâche dans tasks/")
    p.add_argument("--title", required=True, help="Titre court (≤80 chars)")
    p.add_argument("--priority", default="P2", choices=["P0", "P1", "P2", "P3"])
    p.add_argument("--tags", default="", help="Tags séparés par virgule")
    p.add_argument("--session", default="", help="Session d'ouverture (ex. S71)")
    p.add_argument("--source", default="", help="Source / Échéance")
    p.add_argument("--no-regen", action="store_true", help="Ne pas relancer rebuild_tasks_index après")
    args = p.parse_args()

    next_id = get_next_id()
    pad_width = 4 if next_id > 999 else 3
    fname = f"task_{next_id:0{pad_width}d}.md"
    target = TASKS_DIR / fname

    if target.exists():
        print(f"[add-task] ERREUR : {target.name} existe déjà.", file=sys.stderr)
        return 1

    title_clean = args.title.replace('"', "'")[:80]
    tags = [t.strip() for t in args.tags.split(",") if t.strip()]
    today = date.today().isoformat()
    session = args.session or "?"
    source = args.source or f"Session {session} / Demande Mickael ({today})"

    fm = ["---", f"id: {next_id}", f'title: "{title_clean}"', "status: open", f"priority: {args.priority}"]
    if args.session:
        fm.append(f"session_opened: {args.session}")
    if tags:
        fm.append(f"tags: [{', '.join(tags)}]")
    fm.append(f'source: "{source}"')
    fm.append("---")
    fm.append("")

    body = [
        f"# T#{next_id} — {title_clean}",
        "",
        "## Description",
        "",
        "*(à enrichir)*",
        "",
        "## Source / Échéance",
        "",
        source,
        "",
        "## Statut",
        "",
        "À faire",
        "",
    ]
    target.write_text("\n".join(fm + body), encoding="utf-8")
    print(f"[add-task] Créé : {target.relative_to(ROOT)}")

    if not args.no_regen:
        regen_script = ROOT / ".claude/skills/regen-tasks-index/scripts/rebuild_tasks_index.py"
        if regen_script.exists():
            print(f"[add-task] Lancement rebuild_tasks_index...")
            r = subprocess.run([sys.executable, str(regen_script)], capture_output=True, text=True)
            for line in r.stdout.splitlines():
                print(f"  {line}")
            if r.returncode != 0:
                print(f"[add-task] WARN regen exit code {r.returncode}", file=sys.stderr)
                print(r.stderr, file=sys.stderr)
        else:
            print(f"[add-task] WARN script regen introuvable : {regen_script}", file=sys.stderr)
    return 0


if __name__ == "__main__":
    sys.exit(main())
