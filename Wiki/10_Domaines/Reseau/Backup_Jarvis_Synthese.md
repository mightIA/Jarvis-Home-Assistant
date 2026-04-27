---
title: Backup Jarvis — synthèse rapide
created: 2026-04-27
tags: [reseau, securite, backup]
status: actif
domaine: Reseau
sources: [Ressources/Protocoles/Backup_Jarvis.md]
---

# Backup Jarvis — synthèse rapide

> ⚠️ **Source de vérité** : `Ressources/Protocoles/Backup_Jarvis.md`
> (protocole complet avec 3 options A/B/C détaillées, scripts, tests
> de restauration). Cette note est juste un résumé pour rappel express.

## En 5 lignes

1. **Quoi sauvegarder** : `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant`
   entier (tous `.md`, `.claude/`, `memory/`, `Ressources/`, `.mcp.json`).
2. **Quoi exclure** : `.claude/settings.local.json` (tokens/secrets) +
   tokens OAuth dans `C:\Users\Might\.claude\`.
3. **Recommandation Mickael** : Option A (OneDrive sync continu) +
   Option C (Git privé GitHub commit par session).
4. **Repo Git racine** : créé S42 25/04/2026, branche `main`, commit
   `3a63421` (130 fichiers), `.gitignore` strict, `.mcp.json.template`
   versionné, push GitHub `mightIA` (auto-memory `reference_git_jarvis_repo`).
5. **Sandbox bash Cowork** ne peut PAS écrire dans `.git/` — toutes les
   opérations git passent par PowerShell côté Mickael (auto-memory
   `feedback_git_sandbox_cowork_bloque`).

## Liens internes

- Source complète : `Ressources/Protocoles/Backup_Jarvis.md`
- Skill source : `.claude/skills/install-claude-code-windows/SKILL.md`
  (procédure de restauration post-format)
- Auto-memory `reference_install_claude_code_windows`
- Auto-memory `reference_git_jarvis_repo`
- Auto-memory `feedback_git_sandbox_cowork_bloque`

## Sources

- `Ressources/Protocoles/Backup_Jarvis.md` (~240 lignes)
