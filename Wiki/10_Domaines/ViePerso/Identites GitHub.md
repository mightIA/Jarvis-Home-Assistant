---
title: Identités GitHub Mickael
created: 2026-04-25
tags: [vieperso/github, identite]
parent: "[[_Index]]"
status: actif
---

# Identités GitHub

Source de vérité pour toute action GitHub côté Cowork.

## Compte principal

**`mightIA`** — identifié S39 (25/04/2026) lors du débogage du
connecteur Cowork "Intégration GitHub".

Visible sur la page détail "Authorized GitHub Apps → Claude" :
*"Claude can access your account **mightIA** to ..."*

## À ne pas confondre

| Identité | Type | Usage |
|---|---|---|
| **`mightIA`** | GitHub | **Compte GitHub principal** Cowork |
| `might57290@gmail.com` | Gmail | Email principal (tri auto, alertes Mode Réactif) |
| `mighthomeassistant@gmail.com` | Gmail | HA dédié (Brave only) |
| `mickael.rubino@gmail.com` | Gmail | Perso (Brave only) |
| `might@live.fr` | Outlook | Perso Outlook (Brave only) |

## GitHub App installée

- **Nom** : `Claude` (par anthropics)
- **Date d'install** : 25/04/2026 (S39)
- **Compte cible** : `mightIA`
- **URL d'install directe** : [github.com/apps/claude/installations/new](https://github.com/apps/claude/installations/new)

## Procédure d'ajout d'autres comptes

Si Mickael possède d'autres comptes GitHub (perso vs pro éventuel) à
exposer aussi à Cowork :

1. Ouvrir [github.com/apps/claude/installations/new](https://github.com/apps/claude/installations/new)
2. Choisir le compte ou l'orga concerné
3. Sélectionner les repos à exposer (All repos / Selected repos)
4. **Nouvelle conversation Cowork** pour que les outils MCP propagent
   (les MCP servers ne se chargent qu'au démarrage de session).

## Authorize ≠ Install (piège S39)

Quand le badge Cowork affiche "Connecté" mais **aucun outil MCP
exposé** : vérifier sur GitHub Settings → **Applications** :

| Onglet | Statut requis |
|---|---|
| **Installed GitHub Apps** | Doit lister `Claude` ✅ |
| **Authorized OAuth Apps** | Vide normal (Cowork utilise GitHub App, pas OAuth user-to-server) |
| **Authorized GitHub Apps** | Doit lister `Claude` ✅ |

Si **Authorized mais pas Installed** → install via URL directe ci-dessus
(auto-memory `feedback_github_app_authorize_vs_install` — règle
transposable à Atlassian, Linear, Notion, Slack…).

## MCP registry GitHub (découverte S40)

`github.com/mcp` = catalogue public de serveurs MCP officiels (≈ 20
serveurs : Markitdown, Netdata, Context7, Chrome DevTools MCP,
Playwright, **GitHub by github 29 231 ⭐**, Serena, Notion, Stripe,
Tavily, etc.).

Le **serveur MCP officiel** `github/github-mcp-server` (MIT, Go A+)
est **distinct du connecteur Cowork natif** "Intégration GitHub" — il
expose ~50 outils `github__*` riches mais le bouton **Install** ne
propose actuellement que **VS Code / VS Code Insiders**, pas Cowork
natif.

**Voie d'install Cowork à explorer** (TASKS.md #59 priorité BASSE) :
manuel via URL remote hosted ou ajout `.mcp.json` `"type": "http"`.

## Règle transposable (auto-memory `feedback_github_app_authorize_vs_install`)

Quand un connecteur Cowork natif dit "Connecté" mais aucun outil
exposé : séquence systématique de débogage =

1. `ToolSearch` mots-clés du connecteur
2. Page de gestion service tiers avec **tous les onglets séparés**
   (pas seulement le 1er vide)
3. Si Authorized mais pas Installed → install URL directe ou
   déconnect/reconnect
4. **Toujours nouvelle conv Cowork** après correction

## Liens

- Auto-memory compte : `reference_compte_github_might`
- Auto-memory règle : `feedback_github_app_authorize_vs_install`
- Auto-memory registry : `reference_github_mcp_registry`
- Tâche TASKS.md : #59 "Investiguer install MCP GitHub hosted Cowork"
