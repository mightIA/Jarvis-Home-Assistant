---
title: Skills Mode Réactif
created: 2026-04-27
updated: 2026-04-28
tags: [atome, skill, mode-reactif, alerting]
status: actif
domaine: Skills_Jarvis
---

# Skills Mode Réactif

Catégorie regroupant les 2 skills du **Mode Réactif Jarvis v1.1** (architecture validée S22, 21/04/2026).

> Pipeline complet : HA → email avec préfixe `[JARVIS-ALERT]` → label Gmail `Jarvis-Alert` → scheduled task Windows toutes les 30 min → `check-jarvis-alert` → action selon niveau d'autonomie + log → rapport PDF quotidien à 23h30.

## Skills incluses

### `check-jarvis-alert`

- **Déclencheur** :
  - **Automatique** : Task Scheduler Windows `Jarvis-CheckAlert` toutes les **30 minutes** (script `scripts/check-jarvis-alert-launcher.ps1`)
  - **Manuel** : "vérifie les alertes" depuis Claude Code CLI
- **Rôle** : traiter les alertes `[JARVIS-ALERT]` reçues par mail (label Gmail `Jarvis-Alert`), lire le niveau d'autonomie depuis HA (`input_select.jarvis_niveau_autonomie`), appliquer l'action, archiver, logger.
- **Dépendances** :
  - MCP `gmail-mcp-local` (stdio, **CLI uniquement** — Cowork ne charge pas stdio)
  - MCP `ha-mcp` (lire `input_select.jarvis_niveau_autonomie` + appeler scripts HA dédiés)
  - Filtre Gmail auto-label `Jarvis-Alert`
  - Helper HA `input_select.jarvis_niveau_autonomie`
  - Dossier de log `memory/historique_reactif/`
  - Task Scheduler Windows `Jarvis-CheckAlert`
- **Détail exécutable** : `.claude/skills/check-jarvis-alert/SKILL.md`
- **Liens vault** : [[10_Domaines/Email/Tri Gmail automatise|Tri Gmail automatisé]], [[10_Domaines/Procedures/_Index|Procédures]]

### `rapport-journalier-reactif`

- **Déclencheur** :
  - **Automatique** : Task Scheduler Windows `Jarvis-RapportJournalier` chaque jour à **23h30** (script `scripts/rapport-journalier-reactif-launcher.ps1`)
  - **Manuel** : "génère le rapport du jour" depuis Claude Code CLI
- **Rôle** : produire un PDF synthétique de l'activité Mode Réactif, l'archiver localement (sync OneDrive passif), notifier Mickael par mail avec lien vers le PDF.
- **Dépendances** :
  - Service HA `notify.might57290_gmail_com` pour l'envoi du mail (pattern S27 — pas de scope `gmail.send`)
  - Logs de `check-jarvis-alert` dans `memory/historique_reactif/`
  - Génération PDF (ReportLab Python ou outil équivalent)
  - OneDrive sync passif (dossier surveillé)
  - Task Scheduler Windows `Jarvis-RapportJournalier`
- **Détail exécutable** : `.claude/skills/rapport-journalier-reactif/SKILL.md`
- **Liens vault** : [[Email_Tri_Auto]] (pattern envoi via HA)

## Patterns d'usage transversaux

### Niveaux d'autonomie

Helper HA `input_select.jarvis_niveau_autonomie` détermine ce que `check-jarvis-alert` est autorisé à faire :

- **Surveillance** : log uniquement, pas d'action
- **Suggestion** : log + email à Mickael avec proposition d'action
- **Action automatique** : log + exécution directe + email récap

### Pattern CLI headless dans le quota Max

Les scheduled tasks lancent `claude -p` headless avec `settings.local.json` allowlist. Les tokens consommés comptent dans le quota **Plan Max** (pas en facturation API). Planifier les runs en heures creuses si possible (cf. auto-memory `reference_plan_max_includes_cli`).

### Archivage des logs

Chaque exécution écrit un log dans `memory/historique_reactif/` (un fichier par alerte traitée). Le rapport quotidien agrège ces logs en PDF. Synchronisation OneDrive passive (le dossier est dans le sync OneDrive).

## Statut Phase 1

Référence générale : `Ressources/Competences/Mode_Reactif.md`.

- **Phase 0** : livrée S22 (skills + scripts + helper HA)
- **Phase 1** : tasks `#36` / `#37` / `#38` toujours pending (activation scheduled tasks + tests bout-en-bout)
- Update auto reporté **v1.2 post-Proxmox** (cf. [[10_Domaines/Hardware/_Index|projet upgrade Hardware]])

## Voir aussi

- [[_Index]] — MOC Skills Jarvis
- `Ressources/Competences/Mode_Reactif.md` — architecture et procédures
- `memory/historique_reactif/` — logs par alerte
- Auto-memory `proje