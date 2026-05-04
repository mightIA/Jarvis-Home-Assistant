---
title: Metriques Jarvis
last_update: 2026-05-04 (S108 — ccusage CLI + hook destructif R8/R9/R10 + T#96 backup PC + push massif S70→S108 commit 971d838)
version: 7.7 (post-S108)
---

# METRIQUES — Suivi de l'agent

> ⚠ **Fichier vivant réinjecté à chaque tour.** Cible : <5 KB. Si dépasse 10 KB → exécuter skill `decongestion-fichiers-vivants`. Pour la narration historique des sessions et événements, voir `memory/historique/`.

## Compteurs globaux

| Compteur | Valeur | Mise à jour |
|---|---|---|
| Sessions enregistrées | 108 (S1→S108) | 04/05/2026 |
| Première session | 12/04/2026 | — |
| Dernière session | S108 — ccusage CLI + hook check-secrets.sh étendu R8/R9/R10 + T#96 créée (backup PC migration) + push massif 328 fichiers (commit 971d838) | 04/05/2026 |
| Date migration architecture Jarvis | 19/04/2026 | — |
| Version CLAUDE.md courante | 4.0 | 28/04/2026 (S75) — note S84 : §4 enrichi règle MCP>BRAVE |
| Skills actives | 32 | 04/05/2026 |
| Sub-agents actifs | 3 (CLI-only) | 29/04/2026 (S76 — bandeau CLI-only) |
| Tâches ouvertes | 31 | 04/05/2026 (T#78 close S108, T#96 ouvre S108) |
| Tâches archivées | 62 (Q2) | 04/05/2026 |
| ADR vault | 4 accepted (A001 superseded_by_partial A004 + A002 + A003 + A004) + 7 rejected | 30/04/2026 (S81) |

**Pointeurs détail** :
- Index narratif sessions S20→S70 : [`memory/historique/METRIQUES_archive_2026-Q2.md`](memory/historique/METRIQUES_archive_2026-Q2.md)
- Archives par session : `memory/historique/AAAA-MM-JJ_session_NN_titre.md`
- Index sessions S75+ : [`memory/historique/INDEX_sessions.md`](memory/historique/INDEX_sessions.md)
- Index mémoire : [`memory/MEMORY.md`](memory/MEMORY.md)
- Tâches : [`TASKS.md`](TASKS.md) + `tasks/task_NNN.md`

## Jalons récents (S72→S98)

Liste compacte des événements structurants. Détail dans les archives session correspondantes.

- **S72** (28/04) — audit architecture P1 décongestion METRIQUES + P2 hooks §0
- **S73** (28/04) — P3 sub-agents (3 créés `.claude/agents/`)
- **S74** (28/04) — audit structure, 7 anomalies corrigées (P0+P1), T#81 créée
- **S75** (28/04) — refonte CLAUDE.md option C, footer externalisé, T#81 fermée
- **S76** (29/04) — P4 skills enrichies (13 SKILL.md sur 4 critères) + test sub-agents Cowork KO
- **S78** (29/04) — refonte skill redaction-email, T#46 closed
- **S79** (30/04) — hub Domotique vault, T#80 in_progress (3/6 fiches MCP HA)
- **S80** (30/04) — audit vault correctif (chemins 25 fichiers + tags tripartite + RAG vidéo)
- **S81** (30/04) — épuration vault Phases A→E (-25 fichiers, -37%, ADR-A004) + peaufinage P1→P4
- **S82** (01/05) — refonte instructions Mode Chat/Cowork + CONTEXTE.md v2.0 + ménage P1+P2
- **S83** (01/05) — revue P2 ménage : 11 P2 traitées + scope T#60 ajusté
- **S84** (02/05) — suite revue P2 : T#49 (règle MCP>Brave), T#24 cancelled, T#53 Piper TTS done
- **S85** (02/05) — T#89 Étape 3 HA-side done (chaînage TTS niveau+gravité)
- **S86** (02/05) — T#79 done + T#80 done (3 fiches Domotique finales) + T#90 créée
- **S87** (02/05) — solo déplacement : T#48 runbook MCP Outlook, T#34 ha-logs-archive testing
- **S88** (02/05) — abandon T#66 R3 (artifact MCP redondant), 2 auto-memories Cowork
- **S89** (03/05) — T#16 closed (Permissions-Policy-HA via Cloudflare, audit B→A)
- **S90** (03/05) — T#74 v1.1 AI Prompt Design (90 fichiers, branche vidéo créée, PDF v1.1)
- **S91** (03/05) — T#44 done (Cowork autostart) + T#34 test bout-en-bout + scheduled task créée
- **S91b** (03/05) — T#89 Test 0 (HomePod OK + TV Q80 DLNA solution), T#88 reconfirmé
- **S92** (03/05) — T#48 itérations Plan A/C/B/I (4 plans softeria), bascule Plan D
- **S93** (03/05) — T#48 abandon + T#91 veille auto hebdo créée + cleanup système 8 actions
- **S93b** (03/05) — Hermès v0.12 (978 commits) + T#92 TTS bibliothèque + bug Wyoming Piper
- **S94** (03/05) — Hardware upgrade BoM v3 finale (3290 €, +32% vs 2500 € initial)
- **S96** (04/05) — Ménage scheduled tasks Cowork+Windows, 2 obsolètes supprimées
- **S97** (04/05) — Optim coût quota Max sur 3 launchers CLI Mode Réactif (gain ~9× mensuel)
- **S98** (04/05) — T#76 Phase 1 Qwen 3.6 NO-GO + skill `benchmark-modele-hermes`
- **S99** (04/05) — Consolidation memory (124→95 entrées) + décongestion METRIQUES (20→6 KB) + skill `decongestion-fichiers-vivants` refondue + correction verdict T#76 (qwen3.6-agent qualité OK confirmée par capture UI Mickael, latence +76% reste NO-GO)
- **S100** (04/05) — Rebascule Hermès qwen3.6-agent → qwen35-agent (TODO #2 S99 traité, modèles qwen3.6 conservés pour investigation future) + T#34 `ha-logs-archive` done (run auto 02h00 OK 1er jour J+1 + 3 fichiers livrés 04/05) + diag capteur cuisine (suspicion pile HS confirmée, remplacement reporté faute de pile)
- **S101** (04/05) — Hardware Upgrade BoM v4 finalisée prête à commander 3 662,44 € (panier Amazon 6 articles 3 403,44 € + RAM DDR4 PC domo Schnaeppchen-Schuppen 259 € déjà commandée) ; 4 décisions clés (WC 2 boucles 1000D, RAM 96 Go Z36 = meilleur deal marché DDR5 cassé, CM Hero standard pas BTF/Extreme, CPU sécurisé Amazon direct vs Abracadabra23 70% positives) ; alim HX1500i Shift NEUF + ancienne HX1000i descend en PC domo ; PDF + markdown livrés `Projets/Hardware_Upgrade/10_*` (supersede 09 BoM v3 S94) ; T#73 reste cancelled (BoM hors tâche)
- **S103** (04/05) — Panne connecteur Cowork "Jarvis HA" post-migration Service Token (T#60 S102) : diagnostic complet 11 étapes (HA UI OK, add-on ha-mcp démarré, tunnel CF OK, Service Token OK = `curl HEAD` HTTP 405 attendu) → cause = **limite UI Cowork desktop** (pas de support headers HTTP custom MCP, formulaire propose ID/Secret mais via OAuth standard pas CF-Access-*, config interne en LevelDB binaire non éditable) ; **3 options évaluées** : (A) bascule CLI refusée (CLI réservé Hermès tri email à terme), (B) désactiver CF Access refusée (régression sécu inutile), (C) **proxy local choisie reportée post-Proxmox** ; livrables : T#95 P3 créée (`tasks/task_095.md`), auto-memory `feedback_cowork_no_custom_http_headers_mcp.md` (Cowork) + index MEMORY.md MAJ, `.mcp.json` ligne 32 corrigée (`_task_27_note` obsolète → `_task_95_note` avec contexte limite Cowork), TASKS.md régénéré via skill regen-tasks-index (31 ouvertes / 61 archivées), commit `d9b9f99` (2 fichiers, +211/-117) ; **3 pièges** : (P1) hook check-secrets bloque Edit `.mcp.json` côté Cowork → bascule CLI Claude Code, (P2) lock orphelin `.git/index.lock` 0-byte 8h (piège connu skill `git-github-push` S69), (P3) Cowork CRLF auto sur task_*.md (autocrlf=true Windows, non-bloquant) ; pour besoin immédiat (état chaudière Frisquet) : HA UI direct, Mode Réactif CLI 04h00/23h30 inchangé
- **S108** (04/05) — **ccusage CLI + hook check-secrets.sh étendu R8/R9/R10 + T#96 backup PC + push massif Jarvis privé + push Cookbook public** : Chantier 1 T#78 close (decongestion MEMORY.md projet — refonte S71 a fait le job, plus de warning Cowork) ; Chantier 2 T#66 R1 ccusage statusline (`npm install -g ccusage` 18.0.11 + clé `statusLine` `~/.claude/settings.json` → status bar live `🤖 Opus 4.7 | 💰 $5.93 today | 🔥 $1.54/hr`) ; Chantier 3 T#96 P2 créée (script backup PC migration BoM v4) + protocole figé `Ressources/Protocoles/Backup_PC_Migration.md` v1.0 (6 catégories B.1→B.6 avec criticité 🔴🟡🟢) + auto-memory Cowork `project_backup_pc_migration_t96.md` ; Chantier 4 T#66 R2 hook étendu Option B (R8 suppressions Bash + R9 git destructif + R10 système — 178→304 lignes, 8/8 tests OK WSL2 Ubuntu Noble + jq 1.7.1) + doc S72 7→10 règles ; Chantier 5 push GitHub Jarvis privé big bang (328 fichiers, commit `971d838`, range `2dc2aa6..971d838`, 821.64 KiB) + mini-push post-archive `bf97b6c` (3 fichiers, 3.36 KiB) ; **Chantier 6 push repo Cookbook public** (`mightIA/hermes-agent-rtx3090-cookbook`, dormant depuis 27/04, +dossier `tests/` registry benchmarks Hermès — `prompts.yaml` 178 lignes + `results.csv` 9 lignes ; **caviardage Test_G ligne 140** : `might57290@gmail.com` → variable `${GMAIL_ACCOUNT}` documentée + `prompt_variables` ; commit `9007fe4`, range `bc58b15..9007fe4`, 3.91 KiB) ; **6 pièges** : BOM UTF-8 PS 5.1 sur `Set-Content -Encoding UTF8` (cosmétique git log), hook protégé Edit direct par Cowork (workaround Write outputs/ + Copy-Item PS user-side), `git mv` échoue silencieusement sur untracked, jq absent WSL2 user (sandbox Cowork l'a, pas l'user), erreur numérotation S103↔S108 corrigée via AskUserQuestion, P4 réaffirmé (Mickael a tenté de coller un extrait YAML illustratif en PS — ne jamais montrer code multiline copyable hors bloc commande à coller) ; **11 livrables** dont 1 nouvelle auto-memory `feedback_set_content_utf8_bom_ps51.md` + auto-memory `reference_cookbook_hermes_repo.md` enrichie ; **31 ouvertes / 62 archivées** (T#78 close, T#96 ouvre)

## Activité par mois

| Mois | Sessions | Bans IP gérés |
|---|---|---|
| Avril 2026 | 73 (S1→S73) | 4 |
| Mai 2026 | 35 (S74→S108) | 0 |

## Tri email + Bans IP

> Tableaux détaillés externalisés S76 (T#82) → [`memory/historique/METRIQUES_archive_2026-Q2.md`](memory/historique/METRIQUES_archive_2026-Q2.md) section « Tri email + Bans IP ».
>
> **Cumul rapide** : Gmail 2 sessions / 8 spam / 6 supprimés. Outlook 2 sessions / 29 spam / 30 supprimés / 29 gardés. Bans IP : 4 cas (S5+S18+2×S19), tous résolus.

## Modifications HA significatives

> 78 modifications HA tracées entre S5 (12/04/2026) et S26 (22/04/2026) — archivées dans [`memory/historique/METRIQUES_archive_2026-Q2.md`](memory/historique/METRIQUES_archive_2026-Q2.md). Modifications S27+ : voir archives session correspondantes.

---

*Décongestion P1 appliquée S72 (28/04/2026) — pattern « pointer, don't embed ». Voir [`memory/feedback_decongestion_seuils.md`](memory/feedback_decongestion_seuils.md).*

*Décongestion P2 appliquée S98 (04/05/2026) — narration sessions S96/S97/S98 ré-externalisée vers archives, jalons S72→S98 condensés en liste 1 ligne. Avant : 20 KB. Après : ~5 KB.*

*Décongestion P3 appliquée S99 (04/05/2026) — skill `decongestion-fichiers-vivants` refondue (seuils alignés warning fichier : Vert <5 KB / Jaune 5-10 / Orange 10-20 / Rouge >20 KB par fichier ; périmètre élargi auto-memory Cowork ; règle 6 « narration jamais dans fichier vivant »). Auto-memory Cowork consolidée 31 → 11 KB (124→95 entrées). 2 nouvelles règles capitalisées : `feedback_pattern_stockage_data_fichiers_vivants` + `feedback_ha_persistent_notification_not_in_states`. Voir [`memory/historique/2026-05-04_session_99_consolidation_memory_decongestion.md`](memory/historique/2026-05-04_session_99_consolidation_memory_decongestion.md).*
