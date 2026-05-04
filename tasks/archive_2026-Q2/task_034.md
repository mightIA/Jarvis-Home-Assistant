---
id: 34
title: "Skill `ha-logs-archive`"
status: done
priority: P3
session_opened: S20
session_closed: S100
tags: [ha-mcp, mcp]
source: "Session 20 / Demande Mickael"
---

# T#34 — Skill `ha-logs-archive`

## Description

**[NOUVELLE session 20]** Skill `ha-logs-archive` : sauvegarder regulierement les logs HA (`home-assistant.log` + rotations) avant chaque formatage potentiel. Stockage `Archives/ha_logs/AAAA-MM/` en 2 niveaux (brut `.log` + consolide `.md` extract erreurs/bans/reboots). Combinaison mensuelle + zip annuel (regle section 9 CLAUDE.md). Declenchement manuel avant formatage + tache planifiee mensuelle. Outil : MCP `ha_get_logs` add-on ha-mcp. **Refaire un point ensemble avant implementation** pour valider design final (decoupage fichiers, niveau de detail consolide, frequence).

## Design validé S87 (mai 2026)

Aligné avec Mickael en début S87. Les 5 questions de design ont reçu :

- **Q1 Granularité** → mensuelle (pas hebdo, pas par jour) — **REVISÉ S91 : quotidien Option D**
- **Q2 Sources brutes** → garder les 3 (`error_log` + `system` + `logbook`)
  pour flexibilité ; comparaison/épuration post-stabilisation modèle —
  **REVISÉ S91 : `error_log` retiré (404), reste `system` + `logbook`**
- **Q3 Niveau détail consolidé** → 4 sections (Top erreurs / Bans IP /
  Reboots HA / Extraits stack traces) + Warnings notables
- **Q4 Trigger auto** → scheduled task Windows mensuelle (1er du mois
  02h00) sur Might-1000D — **REVISÉ S91 : quotidien 02h00**
- **Q5 .gitignore** → couvert via `Archives/*` existant (ligne 51)

## Livrables S87

- `.claude/skills/ha-logs-archive/SKILL.md` v1 — procédure complète
  (mensuelle + annuelle + sécurité + pièges + évolutions) — **REMPLACÉE
  par v2 S91, v1 sauvegardée en `SKILL.md.v1-backup-S91`**
- `.claude/skills/ha-logs-archive/scripts/rotate_annual.py` — helper
  rotation annuelle (zip + vérif intégrité + purge dossiers mensuels
  uniquement après validation, support `--dry-run` et `--keep-monthly`) —
  **À adapter pattern quotidien AAAA-MM-JJ au lieu de mensuel AAAA-MM**
- `memory/SKILLS_INDEX.md` — entrée ajoutée (section Maintenance/archives
  S87, 31 skills au total)

## Test bout-en-bout S91 (2026-05-03)

✅ **Mécanique skill validée en mode manuel** :

- Test bout-en-bout réalisé via MCP HA depuis Cowork desktop. 3 fichiers
  produits dans `Archives/ha_logs/2026-05-03_test_S91_manuel/` :
  - `raw_logbook_2026-05-03.json` (71 KB, 599 entrées state changes)
  - `raw_system_errors_2026-05-03.json` (4.8 KB, 6 erreurs + 5 warnings)
  - `consolide_2026-05-03.md` (5.2 KB, 7 sections enrichies)

⚠️ **5 pièges découverts pendant le test, intégrés dans SKILL v2** :
1. `source=error_log` retourne **404** dans cette version HA → endpoint retiré
2. `end_time` ignoré sur `source=system` (warning explicite MCP, fonctionne uniquement sur `logbook`)
3. `purge_keep_days` HA initial était à **1 jour** → modifié à **35** S91
   pour permettre les fenêtres > 24h (recommandé >= 7 par la skill v2)
4. Logbook 24h dépasse 25 KB output MCP → pattern `find tmp + cp` obligatoire
5. Compteurs `system_log` reset à chaque restart HA Core → archiver AVANT restart majeur

✅ **Refonte SKILL v2 livrée S91** : mode mensuel abandonné → quotidien
Option D (fenêtre safe 24h roulants), 360 lignes vs 269 v1, +91 lignes,
section "Bascule éventuelle vers hebdo" prête pour activation dans 7-10j
si recorder à 35j tient.

✅ **Scheduled task Windows créée S91** :
- Nom : `Jarvis-HA-Logs-Archive-Quotidien`
- Trigger : chaque jour à 02h00
- Action : `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\scripts\ha_logs_archive_run.bat`
- Login : `MIGHT-1000D\Might` (Interactive)
- État : Ready
- Fichiers livrés : `scripts/ha_logs_archive_run.bat` (1.1 KB) +
  `scripts/register_scheduled_task_ha_logs.ps1` (3.2 KB) +
  `Archives/ha_logs/_run_logs/.gitkeep`

⚠️ **Blocage sandbox Claude Code CLI sur `Archives/`** :
Test immédiat scheduled task révélé que **claude CLI v2.1.119 bloque
l'écriture dans `Archives/ha_logs/` car le dossier `Archives/` est dans
`.gitignore`** (même avec `dangerouslyDisableSandbox`). Message claude :
*"Le sandbox bloque la création du dossier `Archives/ha_logs/2026-05-03/`
(même avec `dangerouslyDisableSandbox`). Le dossier `Archives/` est
explicitement listé dans `.gitignore` ce qui peut expliquer le blocage
de la sandbox."*

→ Auto-memory créée : `feedback_claude_code_cli_sandbox_archives.md`.

## Reste à faire (avant clôture done)

1. **Débloquer la sandbox Claude Code CLI** sur `Archives/ha_logs/` —
   Mickael préfère NE PAS bidouiller `.claude/settings.json` à l'aveugle
   (S91, 2026-05-03). À investiguer en prochaine session avec une
   approche plus simple : (a) sortir `Archives/ha_logs/` du `.gitignore`
   (perte de la sécurité gitignored), (b) chercher un flag CLI dédié
   (ex `--allow-write Archives/`), (c) reloger l'archive vers un dossier
   non-gitignored (ex `_cache/ha_logs/` exclu via autre mécanisme), (d)
   utiliser `--dangerously-skip-permissions` (risqué mais simple).
2. **Adapter le prompt skill pour mode non-interactif** — actuellement
   claude CLI demande "Quelle option ?" quand un dossier du jour existe
   déjà. Le `.bat` ne peut pas répondre via stdin vide. Reformuler le
   prompt pour spécifier un comportement par défaut (ex "Si dossier du
   jour existe, le compléter sans question.").
3. **Adapter `scripts/rotate_annual.py`** au pattern quotidien
   AAAA-MM-JJ (actuellement écrit pour AAAA-MM).
4. **Premier run auto réussi** — attendre que demain 02h00 produise
   effectivement un dossier `Archives/ha_logs/2026-05-04/` complet
   (3 fichiers + JSON valides).

## Source / Échéance

Session 20 / Demande Mickael — design + code livré S87, refonte v2 +
test bout-en-bout S91 (mai 2026)

## Validation finale S100 (2026-05-04)

✅ **Premier run automatique scheduled task validé** ce matin 02h00 Paris :

- **Run log** : `Archives/ha_logs/_run_logs/run_2026-05-04_02-00.txt`
  - `claude.exe` v2.1.126 trouvé et exécuté
  - exit code 0
  - skill `ha-logs-archive` chargée et exécutée headless via
    `--dangerously-skip-permissions` (piste (a) S95 confirmée en run auto)
- **3 fichiers livrés** dans `Archives/ha_logs/2026-05-04/` :
  - `raw_logbook_2026-05-04.json` (752.5 KB, 5140 entrées 24h, fusion 11 pages MCP)
  - `raw_system_errors_2026-05-04.json` (8.9 KB, 8 erreurs distinctes + 6 warnings distincts)
  - `consolide_2026-05-04.md` (8.6 KB, 6 sections enrichies)
- **JSON validés**, helpers `_tmp_*` + `_merge.py` nettoyés automatiquement
- **Faits saillants logs (bonus diagnostic)** :
  - 0 ban IP sur 24h
  - 1 restart HA Core 2026-05-03 19:34 Paris (probable update add-on
    ha-mcp 7.4.0 → 7.4.1)
  - Top 3 erreurs : Frigate API 292 (add-on injoignable, à creuser ?),
    Moonraker 281 (T#90 connue), HomeKit port 2096 already in use (boot)
  - 877 warnings "HomeKit 150 device limit" (filtre à envisager)
  - 73.6% events logbook = capteurs mouvement Chambre/Cuisine (nominal)

Les 4 blocages listés en S91 sont tous résolus ou contournés :

1. ✅ Sandbox Claude Code CLI sur `Archives/` → débloquée S95 par
   combo `.gitignore` négation `!Archives/ha_logs/` + `.bat` chemin
   absolu claude.exe + `--dangerously-skip-permissions` accepté en
   interactif lors du 1er usage (cf. `feedback_dangerously_skip_permissions_first_use.md`)
2. ✅ Prompt mode non-interactif → fonctionne, le skill complète
   sans question le dossier du jour s'il existe déjà (réécriture overwrite)
3. ⏭ `scripts/rotate_annual.py` adaptation pattern quotidien
   AAAA-MM-JJ → reportée à la rotation de fin d'année 2026 (T#X à
   créer ou tâche annuelle calendaire séparée), non bloquant pour
   passer en done
4. ✅ Premier run auto réussi 04/05 02h00

## Statut

✅ `done` (S100) — skill `ha-logs-archive` v2 opérationnelle en mode
automatique quotidien. Scheduled task `Jarvis-HA-Logs-Archive-Quotidien`
tourne tous les jours à 02h00 Paris sans intervention.
