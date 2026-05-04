---
name: Cowork — 4 toggles "Capacités"
description: Référence des 4 toggles Settings → Capabilities Cowork desktop (Artefacts / Visualisations / Exécution code / Sortie réseau) — impact concret sur les outils MCP de Jarvis et état recommandé
type: reference
---

# Cowork desktop — Section "Capacités" (Settings → Capabilities)

4 toggles ON/OFF qui contrôlent les permissions générales de Jarvis dans l'app Cowork. **Indépendants des connecteurs MCP** (HA, Gmail, etc.) — ils s'appliquent à tout ce que Jarvis fait.

## Tableau de référence

| # | Nom UI | Tool MCP concerné | Impact si OFF | État Mickael (S83) | Recommandation |
|---|---|---|---|---|---|
| 1 | **Artefacts** | `mcp__cowork__create_artifact` | Pas de pages HTML live persistantes (re-pull connecteurs à l'ouverture) | ON | ON — utile pour dashboards récurrents (status HA matin, suivi tâches) |
| 2 | **Visualisations** | `mcp__visualize__show_widget` | Pas de SVG/charts/diagrammes inline en conv | ON | ON — utile pour mockups Lovelace, schémas réseau, charts |
| 3 | **Exécution de code** | `mcp__workspace__bash` | **~28 skills sur 32 cassent** (pdf-toolkit, xlsx, docx, regen-tasks-index, decongestion-fichiers-vivants, etc.) | ON | ON **obligatoire** — non négociable |
| 4 | **Sortie réseau** | `bash` egress (pip/npm/curl/wget) | Bash sandbox coupé d'Internet. WebFetch/WebSearch passent par Anthropic, restent OK. | OFF | OFF par sécurité — aucune skill standard n'en a besoin |

## Différences subtiles

- **Artefacts vs Visualisations** : artefacts = **persistant** (page rouvrable plus tard, re-pull connecteurs) ; visualisations = **jetable** (inline dans le tour courant). Dashboard matin → artefact. Schéma pédagogique ponctuel → visualisation.
- **Exécution code vs Sortie réseau** : indépendants. Le bash tourne sans réseau (lecture/écriture fichiers locaux OK). Couper réseau ne casse aucune skill standard ; couper exécution casse tout.
- **WebFetch/WebSearch ≠ sortie réseau toggle 4** : ces 2 tools passent par l'infra Anthropic (pas par le sandbox), donc fonctionnent même avec toggle 4 OFF.

## Cas où ouvrir temporairement le toggle 4

Très rare. Si une nouvelle skill nécessitait `pip install <package>` dans le sandbox bash. Procédure :
1. Ouvrir toggle 4
2. Lancer la skill (qui fait l'install + l'usage)
3. Refermer toggle 4

Alternative préférable : faire l'install via Claude Code CLI (WSL2, sans cette restriction) et copier le code/fichier généré.

## Origine

Documentation produite S83 (01/05/2026) en clôture T#55 (ouverte S35 23/04/2026). Confirme état observé S27 (auto-memory promise mais jamais créée jusqu'à S83).

## Mise à jour recommandée

Si la section "Capacités" évolue (ajout d'un 5ème toggle, renommage), mettre à jour ce fichier + signaler dans MEMORY.md.
