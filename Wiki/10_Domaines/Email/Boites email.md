---
title: Boîtes email de Mickael
created: 2026-04-25
updated: 2026-04-25
tags: [atome, email, email/boites, domaine/email]
status: actif
parent: "[[_Index]]"
---

# Boîtes email de Mickael

Mickael possède **4 boîtes email** distinctes. Toujours nommer explicitement
la boîte traitée — ne jamais supposer (règle `feedback_email_boite_explicite`).

## Inventaire

| Boîte                          | Type    | Compte   | Canal de tri (S44)                          | Usage                          |
|--------------------------------|---------|----------|---------------------------------------------|--------------------------------|
| `might57290@gmail.com`         | Gmail   | `u/0`    | gmail-mcp-local stdio CLI (5h + 14h)        | Principal + Mode Réactif       |
| `mighthomeassistant@gmail.com` | Gmail   | `u/1`    | Brave uniquement (pas de MCP)               | Dédié Home Assistant           |
| `mickael.rubino@gmail.com`     | Gmail   | `u/2`    | Brave uniquement (pas de MCP)               | Perso (à préciser)             |
| `might@live.fr`                | Outlook | —        | Brave (skill `tri-email-outlook-priorites`) | Perso Outlook                  |

## Limitation Gmail MCP

Le serveur `gmail-mcp-local` (GongRzhe/Gmail-MCP-Server) est authentifié pour
**une seule boîte** : `might57290@gmail.com` via `credentials.json` dans
`C:\Users\Might\.gmail-mcp\`. Il n'est pas multi-comptes.

Pour exposer en CLI les 2 autres Gmail, il faudrait installer **2 instances
supplémentaires** du même serveur avec **2 Clients OAuth GCP distincts** (un
par boîte). Setup ~30 min par boîte. Voir tâche **#52** (plan tri priorités
multi-boîtes, à implémenter en session PC dédiée).

## Limitation Outlook

Pas de MCP officiel Microsoft Graph côté Cowork actuellement. Le tri Outlook
passe donc par **Brave + Claude in Chrome** (skill
`tri-email-outlook-priorites`). Voir tâche **#48** (MCP Outlook futur).

## Cowork ≠ stdio

Aucune skill de tri Gmail ne tourne dans **Cowork Desktop** : Cowork ne charge
**pas les MCP stdio** (auto-memory `feedback_cowork_no_stdio`). Toute action
de tri Gmail auto passe par **Windows Task Scheduler + Claude Code CLI**.

## Liens

- Détails MCP : [[Gmail MCP custom]]
- Pipeline tri auto : [[Tri Gmail automatise]]
- Tri Outlook : [[Tri Outlook]]
- Source : auto-memory `memory/reference_boites_email.md`

---

*Atome créé S44. Frontière nette entre les 4 boîtes — ne jamais confondre.*
