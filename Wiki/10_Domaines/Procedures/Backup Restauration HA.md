---
title: Backup Restauration HA
created: 2026-04-27
tags: [procedure, backup, ha]
status: actif
domaine: Procedures
sources: [S17]
detail_executable: Ressources/Protocoles/Backup_Jarvis.md
---

# Backup et restauration HA / projet Jarvis

## Quand utiliser

- **Avant** une mise a jour HA (Core, Supervisor, OS).
- **Avant** une manipulation risquee (config.yaml massif, suppression d'integration, rotation secret).
- **Avant** un test de Phase nouvelle (Hermes, Phase D hardware, etc.).
- **Periodique** : sync OneDrive continue + commit git apres chaque session importante.
- **Trimestriel** : exercice de restauration test (sinon le backup n'en est pas un).

## Pourquoi

Le dossier `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant` contient
**tout le capital projet** : CLAUDE.md, CONTEXTE.md, TASKS, METRIQUES,
`.claude/skills/`, `memory/`, `Ressources/`, `.mcp.json`, scripts. La
reinstallation Claude Code prend 10-15 min, mais reconstituer ce dossier
a la main = impossible. Cote HA, un snapshot pre-update permet le rollback
si update casse une integration ou un add-on.

## Vue d'ensemble (3 cibles + snapshot HA)

1. **Snapshot HA** (avant update Core/OS) : Parametres -> Systeme -> Sauvegardes -> Creer
   (full backup). Nommage convention `Pre_<Phase>_<Action>_YYYY-MM-DD`
   (ex. `Pre_B1_EnableToolSearch_2026-04-26`, S53).
2. **Option A — OneDrive** (continu) : sync auto via `Copy-Item` ou `robocopy /MIR`
   vers `C:\Users\Might\OneDrive\Jarvis-Backup\`. Versioning 30 jours natif.
3. **Option B — Disque externe** (hebdo) : tache planifiee Windows
   `robocopy ... /MIR /XF settings.local.json` chaque dimanche 22h00.
4. **Option C — Git prive GitHub** (per-session) : commit + push apres chaque
   session importante. Repo prive `mightIA` avec `.gitignore` strict.

Recommandation Mickael : **A + C** (OneDrive auto + Git per-session).
B en option pour vraie regle 3-2-1.

## Pieges connus

- **EXCLURE absolument** :
  - `.claude/settings.local.json` (tokens HA LLAT, credentials Gmail, secrets).
  - `credentials.json` Google OAuth Gmail (Runtime/).
  - Tokens OAuth Claude Code CLI dans `C:\Users\Might\.claude\` (hors dossier projet).
- **Sensibilite moderee** : `.mcp.json` contient le secret_path ha-mcp
  `private_<24chars>`. OK pour OneDrive/disque chiffre, **interdit en repo public**.
- **Git sandbox Cowork bloque** : sandbox Linux Cowork ne peut pas ecrire
  dans `.git/` ni lire un `.git/config` cree par PowerShell (encodage). Toutes
  commandes git via PowerShell cote Mickael (auto-memory `feedback_git_sandbox_cowork_bloque`).
- **GitHub email** : utiliser `278813549+mightIA@users.noreply.github.com`
  (jamais `might57290@gmail.com`) + toggles "Keep my email private" + "Block
  command line pushes that expose my email" ON (S64).
- **Snapshot HA avant tout enable_tool_search / enable_dangerous_tools / rotation secret** : reflexe S53.

## Detail executable

Voir : `Ressources/Protocoles/Backup_Jarvis.md` (3 strategies completes avec
scripts PowerShell `robocopy`, planification Task Scheduler, `.gitignore`
modele, procedures de restauration post-format).

## Sources

- `memory/historique/2026-04-20_session_17_install_cli_validation_mcp.md`
- `memory/historique/2026-04-25_session_42_git_init_vault_alimentation.md`
- `memory/historique/2026-04-26_session_64_repo_cookbook_publie.md`
- Auto-memories : `feedback_git_sandbox_cowork_bloque`, `feedback_github_noreply_email`, `reference_install_claude_code_windows`
