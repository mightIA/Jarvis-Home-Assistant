---
id: 66
title: "Liste consolidée d'améliorations identifiées via recherche web S53 (ccusage, ..."
status: open
priority: P2
session_opened: S53
tags: [hermes, gmail, email, openrouter, security, mode-reactif, mcp, cowork, dashboard]
source: "Session 53 / Demande Mickael — recherche web améliorations Cowork"
---

# T#66 — Liste consolidée d'améliorations identifiées via recherche web S53 (ccusage, ...

## Description

**[NOUVELLE session 53 — améliorations conversation Cowork (top 10 + 3 recos)]** Liste consolidée d'améliorations identifiées via recherche web S53 (ccusage, ccstatusline, awesome-claude-code, Claude Cowork power user guides). **Décisions Mickael S53** : items 1+2+3 = config plus tard (suivre recos prioritaires) ; items 4+6+7+8+9+10 = étude approfondie avant tout test ; item 5 (`/compact` vs bascule) = règle de comportement enregistrée en auto-memory `feedback_compact_vs_bascule_proposition.md` (ne plus apparaître dans cette tâche) ; recos 1+2+3 priorisées par Jarvis = à exécuter en premier. **PHASE A — À CONFIGURER (recos prioritaires Jarvis)** : **(R1) ccusage côté Claude Code CLI** — installer `ccstatusline` ou `ccusage statusline` dans le terminal CLI (pattern hands), affiche modèle / tokens / quota Max / burn rate / context bar en bas de fenêtre. Refs : [ccusage statusline](https://ccusage.com/guide/statusline) + [ccstatusline GitHub](https://github.com/sirmalloc/ccstatusline) + [Claude Code statusline docs](https://code.claude.com/docs/en/statusline). Durée ~15 min, gain visuel direct sur les runs `claude -p` headless 4h du matin. **(R2) Hook PreToolUse sécurité** — formaliser la Règle 0 et la règle "jamais supprimer sans validation" dans des hooks Cowork (`PreToolUse` sur `Bash`, `Write`, `Edit`, `file_delete`). Confirmation systématique forcée, plus uniquement reposer sur la discipline Jarvis. Référence : doc Cowork hooks. Durée ~30 min. **(R3) Artifact persistant Dashboard Jarvis matin** — page HTML rouvrable dans la sidebar Cowork via `mcp__cowork__create_artifact`, appelle `mcp__948f...__ha_get_overview` + autres outils ha_* à chaque ouverture pour afficher : état chaudière, alertes Mode Réactif en cours, file d'attente, dernières IPs bannies, quota Max consommé, 3 prochaines tâches HAUTES TASKS.md. Vue snapshot fraîche le matin. Durée ~1h. **PHASE B — À CONFIGURER PLUS TARD (items 1, 2, 3 du top 10)** : **(I1) Statusline custom Claude Code CLI** — chevauche R1, à fusionner. **(I2) Hook PreToolUse pour actions destructives** — chevauche R2, à fusionner. **(I3) Slash commands custom pour routines** — créer `/tri-gmail`, `/status-ha`, `/backup-ha`, `/deban-ip`, `/check-jarvis` dans `.claude/commands/` qui déclenchent des suites prédéfinies. Durée ~45 min après stabilisation des 8-10 actions récurrentes. **PHASE C — À ÉTUDIER PROFONDÉMENT AVANT TEST (items 4, 6, 7, 8, 9, 10)** : **(I4) Plugin `claude-mem`** — mémoire long-terme renforcée avec récupération sémantique automatique entre conv. **À évaluer** s'il complète ou est redondant avec le système maison `MEMORY.md` + auto-memories (probablement redondant, mais à vérifier). **(I6) Extended thinking toggle** — Settings → Capacités → activation ponctuelle pour tâches lourdes (architecture HA, debug Hermès, audit sécu). Différence qualitative significative sur raisonnement multi-étapes mais consomme plus de tokens. **À étudier** : critères de déclenchement vs forfait Max. **(I7) Sub-agents `.claude/agents/` spécialisés** — agents `audit-securite`, `redacteur-email`, `verificateur-yaml-ha`, etc. avec contexte isolé, lançables en parallèle. **À étudier** : différence avec skills, intérêt vs duplication. **(I8) Artifacts persistants** — chevauche R3 mais usage plus large : dashboards Mode Réactif, vue conso OpenRouter (#62), monitoring HA temps réel. **À étudier** : limites de l'API artifact (combien d'appels MCP par chargement, refresh rate, persistance cross-session). **(I9) Plugins marketplace `connect-apps`, etc.** — étudier `connect-apps` (500+ services) + marketplaces Dan Ávila / Seth Hobson pour DevOps/docs/PM. Refs : [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) + [10 top plugins 2026 Composio](https://composio.dev/content/top-claude-code-plugins). **À étudier** : matrice utilité réelle / risque sécu / dépendances. **(I10) Hook PostToolUse pour auto-MAJ MEMORY.md / METRIQUES.md** — incrémentation auto compteurs `METRIQUES.md` à chaque tri Gmail réussi / déban IP / session marquée. Évite la skill `session-closure` manuelle. **À étudier** : design hooks triggers + risque double comptage. **PRÉ-REQUIS PHASE B** : faire R1+R2+R3 d'abord. **PRÉ-REQUIS PHASE C** : créer note d'étude `Ressources/Competences/Cowork_Ameliorations.md` puis remonter conclusions ici avant test. **Durée totale estimée** : Phase A ~1h45, Phase B ~1h, Phase C ~3h étude + tests à chiffrer après.

## Source / Échéance

Session 53 / Demande Mickael — recherche web améliorations Cowork

## Mise à jour S87 (02/05/2026)

**R3 abandonné.** Tentative V1 HA-only effectuée en S87 : artifact `dashboard-jarvis-matin` créé via `mcp__cowork__create_artifact`, 4 cartes (chaudière, Mode Réactif, événements, système). **Bug format MCP côté runtime artifact** (`window.cowork.callMcpTool` retourne probablement `{content:[{text:"..."}]}` à parser, pas le format chat `{data:{states:...}}`) → cartes vides au chargement. **Décision Mickael après honnête bilan d'utilité** : V1 HA-only redondante avec app HA iPhone + Lovelace + notifs Mode Réactif. Vraie valeur du dashboard = quota Claude Max + tâches HAUTES TASKS.md (cross-systèmes, n'existent nulle part ailleurs) — mais nécessitent R1 (ccusage CLI) en pré-requis. Artifact supprimé, fichier scratchpad supprimé, T#91 V2 supprimée (devenue sans objet). **Reste à faire** : R1 (ccusage statusline, ~15 min) + R2 (audit hook PreToolUse sécurité, dont une partie déjà faite S72 via `check-secrets.sh`, ~30 min). Phase A se réduit à R1+R2.

## Statut

✅ **Phase A bouclée S108** (R1 + R2 done). Phase B et C restent à étudier.

## Mise à jour S108 (04/05/2026) — R2 DONE

**R2 (audit hook PreToolUse + extension R8/R9/R10) installée et opérationnelle.**

Phase 1 (audit) — état initial :
- Hook S72 `check-secrets.sh` (178 lignes, 7 règles Règle 0) ✅
- Config `.claude/settings.json` avec matcher `Read|Edit|Write|MultiEdit|NotebookEdit|Bash` ✅
- 14/14 tests S72 historiques toujours valides

Phase 2 (gaps identifiés) :
- 🔴 Suppressions Bash (rm -rf, Remove-Item -Recurse/-Force) non bloquées
- 🔴 Git destructif (reset --hard, clean -fd, push --force) non bloqué — risque concret vu ~150 fichiers untracked dans le repo
- 🟡 Système destructif (wsl --unregister, ollama rm, npm uninstall -g, Format/shutdown) non bloqué — risque perte Hermès/ccusage

Phase 3 (décision Mickael) : **Option B** retenue — étendre le hook existant avec R8 + R9 + R10.

Phase 4 (implémentation) :
- `check-secrets.sh` patché de 178 → 304 lignes (3 nouvelles règles)
- Backup horodaté du fichier original conservé (`.bak-yyyymmdd-HHMMSS`)
- 8/8 tests OK en WSL2 Ubuntu Noble + jq 1.7.1 :
  - R8 BLOCK rm -rf : exit 2 ✅
  - R8 PASS rm simple : exit 0 ✅
  - R9 BLOCK clean -fd : exit 2 ✅
  - R9 PASS git status : exit 0 ✅
  - R10 BLOCK wsl --unregister : exit 2 ✅
  - R10 PASS wsl --shutdown : exit 0 ✅
  - R1 BLOCK credentials (non-régression) : exit 2 ✅
  - R7 BLOCK sk-or-v1- (non-régression) : exit 2 ✅
- Doc S72 (`memory/reference_hooks_securite_p2.md`) mise à jour : 7→10 règles, section S108 ajoutée

⚠ **Activation** : le hook est figé en snapshot au démarrage de chaque session. Les nouvelles règles s'activent dès la prochaine session Cowork ou terminal `claude` CLI relancé.

**Phase B reste à étudier** : I3 (slash commands custom `/tri-gmail`, `/status-ha`, etc., ~45 min après stabilisation 8-10 actions récurrentes).

**Phase C reste à étudier** (6 items I4-I10) : claude-mem, extended thinking, sub-agents custom, artifacts persistants, plugins marketplace, hook PostToolUse audit log.

## Mise à jour S108 (04/05/2026) — R1 DONE

**R1 (ccusage statusline) installée et opérationnelle.**

Étapes réalisées :
1. `npm install -g ccusage` (Node v24.15.0 + npm 11.12.1) → ccusage 18.0.11 dans le PATH user.
2. Ajout clé `statusLine` dans `C:\Users\Might\.claude\settings.json` (backup horodaté `.bak-yyyymmdd-HHMMSS` créé) :
   ```json
   "statusLine": {
     "type": "command",
     "command": "ccusage statusline"
   }
   ```
3. Test visuel `claude` interactif → status bar affichée correctement, format :
   `🤖 <modèle> | 💰 $X session / $Y today / $Z block (Nh Mm left) | 🔥 $W/hr | 🧠 N (X%)`

Bénéfice acquis : visibilité directe modèle/conso/burn rate/quota Max sur **toutes** les sessions Claude Code CLI (y compris `claude -p` headless Mode Réactif 04h00 + tri Gmail 05h00 + rapport 23h30).

**Reste R2** : audit hook PreToolUse sécurité (partie déjà faite S72 via `check-secrets.sh`, ~30 min de complément à chiffrer).
