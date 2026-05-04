---
id: 59
title: "Investigation après vérif négative S40"
status: open
priority: P3
session_opened: S40
tags: [ha-mcp, hermes, gmail, pdf, mcp, cowork]
source: "Session 40 / Vérif négative post-S39"
---

# T#59 — Investigation après vérif négative S40

## Description

**[NOUVELLE session 40 — install serveur MCP GitHub côté Cowork Desktop]** Investigation après vérif négative S40 : le connecteur Cowork natif "Intégration GitHub" (installé S39) n'expose **aucun outil `github__*`** malgré GitHub App `Claude` validée. Le serveur MCP GitHub officiel `github/github-mcp-server` (MIT, 29k ⭐, publié sur `github.com/mcp`) est un produit **distinct** à installer en plus — mais son bouton Install du MCP registry ne supporte aujourd'hui que VS Code / VS Code Insiders, pas Cowork. **3 pistes à évaluer** (à tête reposée après recherche internet) : **(A)** install manuel dans Cowork via URL remote hosted (`https://api.githubcopilot.com/mcp/` ou équivalent) → **Paramètres Cowork → Personnaliser → Connecteurs → bouton "+"** : chercher option "Ajouter un MCP server par URL" (équivalent ajout ha-mcp S16). Si option présente, coller URL + flow OAuth. **(B)** `.mcp.json` à la racine projet Jarvis : tenter entrée `"type": "http"` ou `"type": "streamable-http"` + URL remote hosted (non validé Cowork, seul HTTP publique ha-mcp confirmé fonctionnel — stdio confirmé non supporté S26). **(C)** attendre évolution connecteur Cowork natif (Anthropic branchera peut-être automatiquement à terme). **Recherche internet prérequise** : forum Anthropic, issues GitHub `github/github-mcp-server`, doc communautaire (`omankz/Hermes-Agent---Claude-Cowork`, reddit r/ClaudeAI, etc.) pour trouver procédure exacte. **Usage cible** : lire/backup repos perso `mightIA`, versionner Jarvis sur repo privé, créer issues/PRs ponctuels. **Règle 0** : démarrer en read-only si scope sélectionnable à l'install. **Pas de bloquant Jarvis entretemps** — ha-mcp + Gmail + Google Drive + Claude in Chrome + PDF Tools couvrent le périmètre opérationnel quotidien. Références : auto-memories `reference_github_mcp_registry.md` + `feedback_github_app_authorize_vs_install.md` + `reference_compte_github_might.md`. Archive `memory/historique/2026-04-25_session_40_github_mcp_registry_verif.md`.

## Source / Échéance

Session 40 / Vérif négative post-S39

## Statut

À investiguer (session future après recherche internet)
