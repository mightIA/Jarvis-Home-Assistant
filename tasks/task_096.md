---
id: 96
title: "Script backup global PC pour migration nouveau hardware (configs hors-projet)"
status: open
priority: P2
session_opened: S108
tags: [backup, migration, pc-hardware, claude-cli, hermes, env-vars, task-scheduler, ollama]
source: "Session S108 (04/05/2026) — anticipation migration BoM v4 S101 (3 662 €). Mickael demande comment sauvegarder ce qui n'est PAS dans le projet Git pour reproduire le setup sur le nouveau PC."
---

# T#96 — Script backup global PC pour migration nouveau hardware

## Contexte

Le BoM v4 S101 (3 662,44 €) est prêt à commander. Au moment de la migration vers le nouveau PC, plusieurs **configurations vivent en dehors du repo Git Jarvis** et seront perdues si non sauvegardées. Cette tâche couvre :

1. L'inventaire complet de ce qu'il faut backuper (figé dans `Ressources/Protocoles/Backup_PC_Migration.md`).
2. Le développement d'un script PowerShell global qui automatise le backup en une commande.
3. La validation du script par un dry-run avant migration réelle.

**Hors scope** (Mickael S108) : la récurrence automatique via Task Scheduler. On reste en exécution manuelle pour le moment, à reconsidérer plus tard.

## Périmètre du script

Le script doit créer un dossier daté `D:\Might\IA\Backups_PC\backup_YYYYMMDD\` contenant :

| Catégorie | Source | Méthode capture |
|---|---|---|
| **Claude Code CLI** | `C:\Users\Might\.claude\` complet | `Copy-Item -Recurse` |
| **Liste npm globaux** | `npm list -g --depth=0` | Redirection vers `.txt` |
| **Hermès Agent config** | WSL2 `/home/agent/.hermes/config.yaml` (perms 600, secrets en clair) | `wsl -- cat ...` ou `Copy-Item` via `\\wsl$\` |
| **Hermès Modelfiles custom** | `ollama show <model> --modelfile` pour chaque custom | Boucle sur liste `qwen35-agent`, etc. |
| **Liste modèles Ollama** | `ollama list` | Redirection vers `.txt` |
| **Variables env user** | `Get-ChildItem Env:` (filtrer CF_ACCESS_*, MISTRAL_*, OPENROUTER_*) | Out-File |
| **Task Scheduler XML** | `schtasks /query /xml ONE /tn "<chaque tâche Jarvis>"` | Export XML par tâche |
| **Cowork desktop `.mcp.json`** | `C:\Users\Might\AppData\Roaming\Claude\local-agent-mode-sessions\<session>\` | `Copy-Item` (path dynamique à résoudre) |

**Pré-requis impératif avant migration** : push GitHub à jour du projet Jarvis (skill `git-github-push`) pour que le repo lui-même soit récupérable côté nouveau PC. Le script de backup ne couvre PAS le projet (déjà censé être en Git).

## Livrables attendus

1. Script `scripts/backup-pc-migration.ps1` qui produit le dossier daté.
2. Test dry-run sur le PC actuel (vérifier que tous les fichiers sont bien capturés, pas d'erreur de path, pas de secret oublié).
3. Procédure de **restauration** documentée dans `Ressources/Protocoles/Backup_PC_Migration.md` (comment réinjecter sur le nouveau PC chaque catégorie).
4. Test de la procédure de restauration en environnement de test (idéalement WSL2 fresh ou compte Windows secondaire) avant la vraie migration.

## Pré-requis avant exécution

- BoM v4 S101 commandé / livré
- Skill `git-github-push` exécutée pour synchroniser le repo Jarvis sur GitHub
- Mickael disponible 1h30-2h pour le dev script + dry-run

## Liens

- Inventaire figé : [`Ressources/Protocoles/Backup_PC_Migration.md`](../Ressources/Protocoles/Backup_PC_Migration.md)
- Tâche source : T#41 (Migration HA Pi → Proxmox), T#73 cancelled (architecture brain/body 2 machines), BoM v4 S101 ([`Projets/Hardware_Upgrade/10_BoM_v4_S101_validee_pour_commande.md`](../Projets/Hardware_Upgrade/10_BoM_v4_S101_validee_pour_commande.md))
- Skill connexe : `git-github-push` (procédure push complète + 5 pièges S69)

## Statut

À faire (P2, à exécuter avant migration PC nouveau hardware)
