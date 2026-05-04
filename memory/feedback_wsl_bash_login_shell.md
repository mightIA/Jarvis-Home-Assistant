---
name: wsl bash -c lance un shell non-interactif sans PATH user
description: Pour exécuter des binaires user (hermes, npm globals, ~/.local/bin/*) depuis PowerShell via wsl, utiliser `wsl bash -lc` (login shell) au lieu de `wsl bash -c` (sinon command not found)
type: feedback
session_capitalized: S112
related_tasks: [T#94]
---

# `wsl bash -c` ≠ `wsl bash -lc` : login shell vs non-interactif

## Règle

Pour exécuter un binaire **user** (hermes, npm globals, scripts dans `~/.local/bin/`, venv Python activés via `.profile`, etc.) depuis PowerShell via WSL, utiliser `wsl bash -lc "..."` (login shell) et **pas** `wsl bash -c "..."`.

## Why

`wsl bash -c "..."` lance un shell **non-interactif et non-login**. Conséquence : ni `~/.bashrc` ni `~/.profile` ne sont chargés → PATH minimal restreint à `/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin` (ou équivalent système).

Tout ce qui est dans `~/.local/bin/`, les npm globals user-scope, les venvs Python activés via `.profile` → **invisibles**.

Erreur typique S112 sur Hermès Agent :
```
PS> wsl bash -c "hermes mcp test ha-mcp"
bash: line 1: hermes: command not found
```

## How to apply

Toujours préférer `-lc` (login shell) pour les commandes user :

```powershell
# ❌ MAUVAIS — PATH système minimal
wsl bash -c "hermes mcp test ha-mcp"

# ✅ BON — charge ~/.profile, PATH user complet
wsl bash -lc "hermes mcp test ha-mcp"
```

Pour les commandes **système pure** (ls, grep, sed, awk, cat, etc.), `bash -c` suffit — pas besoin de `-l`.

## Diagnostic rapide

Si une commande qui marche en interactif WSL2 (terminal `might@Might-1000D:~$`) plante en `command not found` via `wsl bash -c` depuis PowerShell, basculer sur `-lc` :

```powershell
wsl bash -lc "which hermes ; type hermes ; echo \$PATH"
```

Si `which hermes` retourne `/home/might/.local/bin/hermes` → confirmé piège PATH non-login.

## Voir aussi

- Récit S112 : `memory/historique/2026-05-05_session_112_t94_1bis_path_token_cleanup.md`
- `feedback_terminologie_ubuntu.md` — préférer "Ubuntu (bash)" dans les blocs à coller (S70).
