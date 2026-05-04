---
id: 98
title: "Audit add-ons + connecteurs Hermès/Cowork + enrichissement TUI Hermès Agent (statusline)"
status: open
priority: P2
session_opened: S109
tags: [hermes, cowork, audit, mcp, addons, statusline, ui]
source: "Session 109 / Demande Mickael — préparer la suite après T#94 et T#76"
---

# T#98 — Audit add-ons + connecteurs Hermès/Cowork + enrichissement TUI Hermès Agent

## Description

Chantier en 2 axes pour finaliser l'environnement Hermès Agent comme assistant principal local et améliorer son confort d'usage au niveau de Claude Code CLI.

**Axe A — Audit add-ons + connecteurs (Hermès + Cowork)**
Inventorier ce qui est actif, inactif, cassé, ou manquant des deux côtés. Vérifier que chaque MCP / add-on / connecteur fait bien son job et est aligné avec les besoins courants.

**Axe B — Enrichissement TUI Hermès Agent**
Améliorer l'interface CLI/TUI Hermès façon statusline Claude Code (modèle, tokens consommés, contexte restant, coût session). **Choix acté** : pas de WebUI séparé (Open WebUI / LibreChat), enrichir le TUI Hermès Agent existant — accessible en ligne avec protection maximale via CF Access Service Token (cf. [`memory/feedback_interface_hermes_agent_choice.md`](../memory/feedback_interface_hermes_agent_choice.md)).

## Pré-requis

- T#94 (path-token cleanup + IP allowlist + rate limiting CF Access) terminée — durcissement Hermès Agent stabilisé
- T#76 Phase 2 lancée (champion ou maintien qwen35-agent confirmé)
- Hermès Agent à jour (`hermes update`)
- `~/.hermes/config.yaml` versionné/backupé

## Plan détaillé

### Axe A — Audit add-ons + connecteurs

#### A.1 Inventaire Hermès (côté WSL2)

- **MCP servers** branchés à `~/.hermes/config.yaml` `mcp_servers:` — lister, tester chacun (1 outil par MCP)
- **Modèles Ollama** disponibles (`ollama list`) vs modèles référencés dans `~/.hermes/config.yaml`
- **Skills bundled** Hermès Agent (85 skills S98) — vérifier celles utilisées vs inutiles
- **Tools internes** (117 post-update v0.12.0) — toggle `enable_tool_search` ON/OFF impact

#### A.2 Inventaire Cowork desktop

- **Connecteurs UI** actifs (Paramètres → Personnaliser → Connecteurs) — Gmail, Drive, Jarvis HA, Claude in Chrome, etc.
- **MCP servers** dans `.mcp.json` — pour chaque : auth OK, outils accessibles, dernière utilisation
- **Hooks** dans `.claude/settings.json` (check-secrets actif S72, autres ?)
- **Skills CLI** (32 actives) vs skills builtin Cowork — repérer doublons / oubliés

#### A.3 Comparaison + livrables

- Matrice "outil × Hermès × Cowork × Verdict" (actif / cassé / inutile / manquant)
- Recommandations : à brancher / débrancher / mettre à jour / corriger

### Axe B — Enrichissement TUI Hermès Agent

#### B.1 État actuel TUI Hermès

- Bannière au lancement : version + tools count + skills count + warnings
- Pas de statusline persistante pendant la conv
- Pas d'affichage tokens / contexte / coût par tour
- Pas de compteur d'outils appelés / latence par tour

#### B.2 Cible inspirée Claude Code CLI statusline

Affichage permanent au bas du TUI :
- **Modèle courant** (ex `qwen35-agent` / `qwen3.6-agent`)
- **Tokens contexte** consommés / total (ex `8 234 / 65 536` ou pourcentage)
- **Tokens session** cumulés (input + output)
- **Coût session** estimé (si modèle distant OpenRouter, sinon `local`)
- **Latence dernier tour** (ex `+5.2s`)
- **Tool calls dernier tour** (ex `2 calls`)

#### B.3 Faisabilité technique

- Hermès Agent est open source MIT — patcher le rendu TUI possible (Python ? TS ?)
- Vérifier si déjà supporté nativement en option de config
- Sinon, choisir entre :
  - **Option 1** — fork Hermès local avec patch TUI (forkable cleanly ?)
  - **Option 2** — wrapper externe (script Python qui parse stdout/stderr Hermès et injecte la statusline)
  - **Option 3** — feature request upstream Hermès Agent (Nous Research)

#### B.4 Livrables Axe B

- Décision technique Option 1/2/3 documentée ADR
- Implémentation ou fork prêt
- Documentation côté `Projets/Cookbook_Hermes_RTX3090/`

## Livrables globaux T#98

- (a) Matrice audit add-ons + connecteurs Hermès × Cowork (markdown ou xlsx)
- (b) Liste actions correctives (à brancher / débrancher / mettre à jour)
- (c) Décision technique enrichissement TUI Hermès (ADR ou note Cookbook)
- (d) Implémentation statusline TUI ou fork prêt à tester
- (e) MAJ `Projets/Cookbook_Hermes_RTX3090/` avec section "TUI enrichi"
- (f) MAJ skills `benchmark-modele-hermes` si la statusline impacte le workflow

## Liens

- Choix interface Hermès : [`memory/feedback_interface_hermes_agent_choice.md`](../memory/feedback_interface_hermes_agent_choice.md)
- Hermès Agent fiche tech : [`memory/reference_hermes_agent.md`](../memory/reference_hermes_agent.md)
- Pré-requis T#94 : [Nettoyage path-token + Niveau 2a/2b CF Access](task_094.md)
- Pré-requis T#76 : [Retest modèles Hermès Phase 2/3](task_076.md)
- Cookbook Hermès : `Projets/Cookbook_Hermes_RTX3090/`
- Auto-memory architecture sub-agents (vue d'ensemble) : [`memory/reference_sub_agents_p3.md`](../memory/reference_sub_agents_p3.md)
