---
title: Install Claude Code — env dev Windows
created: 2026-04-25
tags: [outils/claude-code, install]
parent: "[[_Index]]"
status: actif
---

# Install Claude Code — skill `install-claude-code-windows`

Procédure complète d'installation de l'environnement dev Claude Code
sur Windows 11 (machine Mickael MIGHT-1000D). Couvre Node.js, Git Bash,
Claude Code CLI, Python (pour scripts de validation skills).

## Ordre d'installation

1. **Node.js LTS** (https://nodejs.org) — défauts GUI, fermer/rouvrir PowerShell.
2. **ExecutionPolicy PowerShell** : `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser`.
3. **Git pour Windows** (https://git-scm.com/downloads/win) — choix critique : **Adjusting PATH** = "Git from the command line and also from 3rd-party software" + Initial branch name = **main** override.
4. **Claude Code** — 2 méthodes :
   - **A (recommandée S17) — natif Windows** : `irm https://claude.ai/install.ps1 | iex` → binaire dans `C:\Users\<user>\.local\bin\claude.exe`. ⚠️ **PATH utilisateur à ajouter manuellement** (l'installateur ne le fait pas).
   - **B (legacy) — via npm** : `npm install -g @anthropic-ai/claude-code` (PATH géré auto par npm, mais dépend Node.js + ExecutionPolicy).
5. **Python 3.12+** (https://www.python.org/downloads/) — ⚠️ **cocher "Add Python to PATH"** pendant l'install + `pip install pyyaml`.

## Ajout PATH utilisateur (méthode A)

```powershell
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
$claudePath = "$env:USERPROFILE\.local\bin"
if ($userPath -notlike "*$claudePath*") {
    [Environment]::SetEnvironmentVariable("Path", "$userPath;$claudePath", "User")
    Write-Host "PATH utilisateur mis à jour. Ferme et rouvre PowerShell."
}
```

## Lancement Claude Code

```powershell
cd "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant"
claude
```

Reprendre une conv : `claude --continue`.

## Première session — bilan de chargement

Premier message à coller :

```
salut, lis CLAUDE.md et fais-moi le bilan de la session pour valider que
tout est bien chargé (skills, mémoire, MCP).
```

Jarvis doit confirmer : CLAUDE.md chargé, liste skills, liste serveurs MCP
de `.mcp.json`, état `memory/MEMORY.md`.

## Trust prompt MCP + flow OAuth DCR (cas ha-mcp S17)

1. Au 1er lancement avec un MCP dans `.mcp.json` → prompt **"Trust this MCP server?"** → **Yes, approve**.
2. Si `"auth": "oauth"` (cas add-on ha-mcp) :
   - Onglet navigateur s'ouvre vers `https://mcp.might.ovh/private_<secret>/.well-known/...`
   - Redirection HA → cliquer **Autoriser**
   - Token OAuth stocké côté CLI (PAS dans `.mcp.json`).
3. Si navigateur défaut ≠ Brave : forcer `$env:BROWSER="brave"` puis `claude --continue`.

## Piège URL ha-mcp (confirmé S17)

URL à mettre dans `.mcp.json` **exactement** :

```
https://mcp.might.ovh/private_<secret>
```

- **Pas** de suffixe `/sse` (404)
- **Pas** de suffixe `/mcp` (404)
- **Pas** de trailing slash (307 → http://, piège tunnel CF)

Voir `[[HA MCP add-on]]` pour l'install et l'expo CF Tunnel.

## Troubleshooting fréquent

| Erreur | Cause | Fix |
|---|---|---|
| `claude : n'est pas reconnu` (natif) | PATH user pas mis à jour | Ajouter `C:\Users\<user>\.local\bin`, fermer/rouvrir PS |
| `claude : n'est pas reconnu` (npm) | Pas installé OU PATH pas rechargé | `npm install -g @anthropic-ai/claude-code` |
| `npm.ps1 : exécution désactivée` | ExecutionPolicy stricte | `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser` |
| `Claude Code requires git-bash` | Git pas installé | https://git-scm.com/downloads/win |
| `python : n'est pas reconnu` | "Add Python to PATH" pas coché | Réinstaller en cochant la case |
| `MCP n'est pas chargé` après relance | `.mcp.json` lu une seule fois | `/exit` puis `claude --continue` |

## Liens

- Skill source : `.claude/skills/install-claude-code-windows/SKILL.md`
- Script d'install : `scripts/install-claude-code.ps1`
- Backup OneDrive + Git privé : `Ressources/Protocoles/Backup_Jarvis.md`
- Auto-memory : `reference_install_claude_code_windows`, `reference_plan_max_includes_cli`
