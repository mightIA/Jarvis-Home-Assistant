---
name: Claude Code CLI sandbox bloque Archives gitignored
description: claude CLI v2.1.119 refuse d'écrire dans les dossiers listés dans .gitignore (ex Archives/), même avec dangerouslyDisableSandbox. Pattern à connaître pour skills futures.
type: feedback
---

# Claude Code CLI — sandbox bloque les écritures dans dossiers gitignored

## Règle découverte (S91, 2026-05-03)

**claude CLI v2.1.119 (Claude Code) refuse l'écriture/mkdir dans les chemins listés dans `.gitignore`** du projet courant, **même avec `dangerouslyDisableSandbox` activé**. Constaté lors du test bout-en-bout T#34 (skill `ha-logs-archive`) où la skill devait créer `Archives/ha_logs/2026-05-03/` :

> *"Le sandbox bloque la création du dossier `Archives/ha_logs/2026-05-03/` (même avec `dangerouslyDisableSandbox`). Le dossier `Archives/` est explicitement listé dans `.gitignore` ce qui peut expliquer le blocage de la sandbox."* (claude CLI S91)

## Why

Probablement une mesure de sécurité Claude Code : éviter qu'un agent autonome écrive accidentellement dans des dossiers explicitement marqués comme "hors scope projet" (caches, secrets, archives non versionnées, etc.). Le sandbox respecte donc le `.gitignore` même si le user a "désactivé" le sandbox.

## How to apply

**Pour toute skill qui doit écrire dans un dossier** :

1. **Vérifier d'abord** que le dossier cible n'est PAS dans `.gitignore`
2. Si dans `.gitignore`, **NE PAS supposer** qu'un flag CLI ou setting va débloquer
3. Solutions à envisager (ordre de simplicité croissante de complexité) :
   - **A** : Sortir le dossier du `.gitignore` (ex `Archives/!ha_logs/`) — mais perd la sécurité
   - **B** : Reloger l'écriture vers un dossier non-gitignored (ex `_cache/<scope>/`)
   - **C** : Chercher un flag CLI dédié (ex `--allow-write Archives/` — à vérifier doc)
   - **D** : Configurer `.claude/settings.json` whitelist explicite (à creuser)
   - **E** : Utiliser `--dangerously-skip-permissions` — bypass total (risqué pour auto)

## Skills concernées

- `ha-logs-archive` v2 (T#34) — bloquée par ce pattern, à débloquer avant clôture done
- Toutes futures skills qui voudraient écrire dans `Archives/`, `_cache/`, ou tout dossier `.gitignore`

## Cowork desktop vs CLI

⚠️ **Cowork desktop écrit normalement dans Archives/** (test S91 manuel = 3 fichiers créés sans souci côté Cowork). C'est uniquement le **claude CLI** qui a cette restriction. Skills déclenchées en mode Cowork interactif → OK. Skills déclenchées via scheduled task `claude -p` → bloquées.

## Référence

- Test S91 (2026-05-03), `memory/historique/2026-05-03_session_91_t34_skill_ha_logs_archive_v2.md`
- claude CLI v2.1.119, Opus 4.7 (1M context), Claude Max
- Mickael préfère solution simple, pas de bidouillage `.claude/settings.json` à l'aveugle
