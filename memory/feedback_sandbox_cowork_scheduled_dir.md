---
name: sandbox-cowork-scheduled-dir
description: Le sandbox bash Cowork ne mappe pas D:\Might\Claude\Scheduled\, suppression d'une Cowork scheduled task doit passer par UI Cowork ou PowerShell
type: feedback
---

Le sandbox Linux de Cowork desktop expose seulement 3 répertoires accessibles en lecture/écriture :
- workspace projet (`Jarvis - Home Assistant`)
- `outputs/`
- `uploads/` (lecture seule)

Le répertoire des Cowork scheduled tasks `D:\Might\Claude\Scheduled\` n'est **PAS** dans le mapping → impossible de supprimer un dossier de task via `rm` dans Bash. Le tool `mcp__scheduled-tasks__update_scheduled_task` permet seulement de modifier (enabled, cron, prompt, etc.), pas de supprimer. Aucun tool `delete` exposé.

**Why:** Constat S96 (03/05/2026) en supprimant la Cowork `tri-email-gmail-quotidien` (fossile pré-S27 doublon avec `Jarvis-TriGmail-Quotidien` Windows). Bash `find /sessions -name "Scheduled" -type d` confirme l'absence du dossier dans le sandbox.

**How to apply:** Pour supprimer définitivement une Cowork scheduled task, deux options validées en S96 :
1. **UI Cowork** — clic droit sur la card dans Scheduled tasks → Delete. Plus propre, libère le lock que Cowork tient sur le dossier. Testé OK S96 (et S95 / S94 pour les 2 obsolètes Mode Réactif).
2. **PowerShell** (fallback) — `Remove-Item -Path "D:\Might\Claude\Scheduled\<taskId>" -Recurse -Force`. À coller en PowerShell normal (pas besoin admin). Si Cowork est ouvert, peut échouer avec "fichier en cours d'utilisation" → fermer Cowork ou utiliser l'UI.

Avant la suppression, **toujours désactiver** d'abord (`update_scheduled_task` avec `enabled: false`) pour éviter qu'elle se déclenche pendant le ménage.
