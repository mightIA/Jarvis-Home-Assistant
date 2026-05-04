---
name: Sandbox Cowork bash bloque toutes les opérations Git (CLI local)
description: Le sandbox Linux Cowork ne peut ni écrire dans .git/ ni lire un .git/config créé par PowerShell — toutes les commandes Git doivent passer par PowerShell côté Mickael
type: feedback
session: 42
date: 2026-04-25
---

# Sandbox Cowork bash bloque toutes les opérations Git

## Règle

Quand un repo Git est dans un dossier mounté Cowork (workspace Mickael),
**toutes les commandes `git`** doivent passer par PowerShell côté
Mickael, pas par `mcp__workspace__bash`.

## Pourquoi

| Cas | Symptôme | Cause |
|---|---|---|
| `git init` côté bash sandbox | `.git/config` créé tronqué (3 lignes au lieu de 7+) puis devient protégé | Sandbox ne finit pas l'écriture, `Operation not permitted` au cleanup |
| `git status` après `git init` PowerShell | `fatal: unknown error occurred while reading the configuration files` | PS écrit `.git/config` en UTF-16 LE BOM, bash le lit en UTF-8 |
| `Write` tool sur `.git/config` | « Write on `.git/...` is blocked in this session — protected location » | Cowork interdit les writes système dans `.git/` |

## Pattern à appliquer

1. **Préparer les fichiers projet** (`.gitignore`, `.mcp.json.template`,
   `.gitkeep`) via Write tool — OK, pas dans `.git/`.
2. **Donner à Mickael un bloc PowerShell autonome** :
   ```powershell
   cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
   git init -b main
   git config user.name "Mickael"
   git config user.email "might57290@gmail.com"
   git status --short
   ```
3. **Vérifs pré-commit côté PowerShell** : `git check-ignore -v <fichier>`
   sur chaque pattern sensible. Le sandbox bash ne peut pas le faire.
4. **Commit côté PowerShell** : `git commit -m "header" -m "body"`
   (double `-m` = format Git canonique).
5. **Validation finale côté PowerShell** : `git log --oneline` + `git log
   -1 --stat`.

## Si on doit lire le repo côté sandbox

- `Read` tool sur les fichiers tracked → fonctionne.
- `mcp__workspace__bash` UNIQUEMENT pour `ls` / `cat` / `wc -l` sur les
  fichiers du projet (pas sur `.git/`).
- Ne **jamais** appeler `git <commande>` côté bash après un init
  PowerShell.

## Importance

Sans cette règle, on peut perdre 5-10 min à essayer de réparer un
`.git/config` qui ne sera jamais réparable côté sandbox. Bascule
rapidement sur PowerShell dès qu'une commande `git` est nécessaire.

## Notes liées

- `reference_git_jarvis_repo.md` (init S42)
- Pattern brain (Cowork Plan/Read/Write) + hands (PowerShell Mickael),
  même architecture que pattern brain+hands stdio S26-S31 pour
  Gmail-MCP.
- Pour les commandes simples Git via Claude Code CLI directement : OK,
  le CLI n'utilise pas le sandbox Cowork.

---

*Source : décisions S42 (25/04/2026) — réplique CLI local de l'auto-memory Cowork web.*
