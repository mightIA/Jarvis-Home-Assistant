---
id: 55
title: "Faire le tour complet des 4 toggles de la section 'Capacités' dans les paramè..."
status: done
priority: P2
session_opened: S35
session_closed: S83
tags: [pdf, mcp, cowork]
source: "Session 35 / Demande Mickael"
---

# T#55 — Faire le tour complet des 4 toggles de la section 'Capacités' dans les paramè...

## Description

**[NOUVELLE session 35 — expliquer Capacités Cowork]** Faire le tour complet des 4 toggles de la section "Capacités" dans les paramètres Cowork et expliquer à Mickael quel impact chacun a sur le fonctionnement de Jarvis. **Toggles connus** (état S27 auto-memory `reference_cowork_capacites`) : (1) **Artéfacts** — ON : permet la création d'artéfacts persistants (HTML live) via `mcp__cowork__create_artifact` ; (2) **Visualisations** — ON : permet la création de widgets inline via `mcp__visualize__show_widget` (SVG, charts, diagrams) ; (3) **Exécution de code** — ON : permet l'exécution de code Python/Node dans le sandbox Cowork (utilisé par skills xlsx/docx/pdf pour manipulation fichiers) ; (4) **Sortie réseau** — OFF : **bloque `pip install` / `npm install` / `curl` sortant** dans le sandbox Cowork (les WebFetch/WebSearch Jarvis restent OK, c'est une sortie via Claude pas via sandbox). **Attendus** : (a) préciser les différences subtiles entre chaque capacité, (b) documenter l'impact concret sur Jarvis (ex. "si j'éteins Exécution code, je perds quelles skills ?"), (c) recommander l'état optimal pour notre usage, (d) mettre à jour `reference_cowork_capacites` si les réglages ont bougé depuis S27.

## Source / Échéance

Session 35 / Demande Mickael

## Statut

✅ `done` S83 (01/05/2026) — explication interactive Mickael + auto-memory `memory/reference_cowork_capacites.md` créée. Tableau 4 toggles + impact + recommandations figés.
