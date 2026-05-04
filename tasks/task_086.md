---
id: 86
title: "Explorer le marketplace Cowork (Compétences / Connecteurs / Plugins) à tête reposée"
status: open
priority: P3
session_opened: S83
tags: [cowork, marketplace, exploration]
source: "Session 83 / Revue T#56 — repérage candidats marketplace"
---

# T#86 — Explorer le marketplace Cowork à tête reposée

## Description

Lors de la revue T#56 S83 (paramètres avancés Cowork Desktop), parcours rapide du marketplace Cowork (Paramètres → Application bureau → Extensions → Parcourir les extensions). Marketplace riche en Compétences (skills Anthropic), Connecteurs (MCP) et Plugins, mais aucun installé hors besoin précis.

**Candidats repérés S83 à creuser sans urgence** :

| Item | Type | Cas d'usage Jarvis potentiel |
|---|---|---|
| **Windows-MCP** | Connecteur | Si le sandbox bash Cowork ne suffit pas pour interactions Windows OS (rare) |
| **/web-artifacts-builder** | Compétence Anthropic | Construire un dashboard matin Jarvis (état HA + mails + météo) — pertinent si on attaque T#52 sérieusement |
| **/canvas-design** | Compétence Anthropic | Créer PDF/illustrations Jarvis (fiches d'audit HA imprimables, bonus) |
| **/doc-coauthoring** | Compétence Anthropic | Rédiger docs structurées (mémoires HA, rapports d'audit) |

**Doublons identifiés à NE PAS installer** :
- `pdf-viewer` (Anthropic) — fait doublon avec MCP `pdf-toolkit` déjà en place (S35)
- `Control Chrome` — fait doublon avec extension `Claude in Chrome` déjà active dans Brave

**Pas pertinents pour Jarvis** : Lseg, Sp global, Box, Adobe, Figma, Atlan, Searchfit, Brightdata, /algorithmic-art, /slack-gif-creator, /internal-comms, /brand-guidelines, /theme-factory, /mcp-builder (sauf futur lointain où Mickael voudrait dev son propre MCP).

## Approche recommandée

**Ne rien installer impulsivement**. Chaque ajout marketplace = surface d'attaque + charge mentale supplémentaires. Trigger d'installation = besoin concret émergent dans une autre tâche, pas curiosité.

Workflow proposé pour cette tâche quand on la fera :
1. Décliner l'attaque T#52 (tri auto 04h15) ou autre tâche utilisant un dashboard
2. Si dashboard nécessaire : installer `/web-artifacts-builder` à ce moment-là
3. Évaluer après usage : garder ou désinstaller
4. Idem pour les 3 autres candidats au cas par cas

## Source / Échéance

Session 83 / Repérage Mickael lors revue T#56.

## Statut

🟢 `open` — exploration au cas par cas, pas de session dédiée à prévoir. À déclencher si besoin concret apparaît (en lien avec T#52, T#54, T#74, etc.).
