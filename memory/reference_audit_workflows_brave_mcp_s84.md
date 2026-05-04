---
name: Audit workflows Brave/Chrome → MCP (S84, T#49)
description: Tableau récap des 8 skills + 1 doc qui passent par Brave/Claude in Chrome, avec MCP candidat, gain tokens estimé et statut migration. Source de vérité pour la règle CLAUDE.md « MCP > Brave ».
type: reference
session: S84 (2026-05-02)
related_tasks: [T#48, T#49, T#86, T#87]
---

# Audit workflows Brave/Chrome → MCP (S84)

Audit transverse mené en S84 (T#49) pour identifier toutes les skills actives qui passent par Brave + Claude in Chrome, et proposer un remplacement MCP. Méthode : grep `Brave|Claude in Chrome|browser_batch|mcp__Claude_in_Chrome` sur `.claude/skills/`.

## Méthodologie

```bash
# Skills concernées (panorama)
grep -r -l "Brave\|Claude in Chrome\|browser_batch\|mcp__Claude_in_Chrome" .claude/skills/

# Périmètre confirmé
grep -r -l "screenshot\|navigate\|browser_batch\|form_input" .claude/skills/
```

8 skills concernées + 1 doc (sur 32 skills actives).

## Tableau récap

| # | Skill | Workflow Brave actuel | MCP candidat | Gain tokens | Statut |
|---|-------|----------------------|--------------|-------------|--------|
| 1 | `tri-email-outlook` | Brave + Chrome (screenshots tri Outlook live.fr) | MCP communautaire Outlook (T#48) | ~10× | 🔵 Bloqué T#48 |
| 2 | `tri-email-outlook-priorites` | idem | idem | ~10× | 🔵 Bloqué T#48 |
| 3 | `redaction-email` (Outlook) | Brave + screenshot brouillon → clic envoi | idem | ~5-10× | 🔵 Bloqué T#48 |
| 4 | `redaction-email` (Gmail tiers) | Fallback Brave (rare) | Gmail MCP `create_draft` (préféré) | déjà acquis | 🟢 Migré S25-S27 |
| 5 | `cloudflare-access-ha` | Brave dashboard CF + vidage cache cookies | **MCP Cloudflare officiel** `bindings.mcp.cloudflare.com` | ~5-10× sur configs | 🟡 À tester (T#87) |
| 6 | `browser-mod` | Pilotage onglets Brave HORS HA | — (skill par essence, screenshot dashboard HA) | N/A | ⚪ Non migrable |
| 7 | `git-github-push` | Popup OAuth Brave (1er push) + lien repo | — (OAuth manuel obligatoire) | N/A | ⚪ Non migrable |
| 8 | `install-claude-code-windows` | Mention navigateur défaut pour OAuth Anthropic | — | N/A | ⚪ Non migrable (one-shot) |
| 9 | `debannissement-ip` | Méthode 1 SSH local via Brave | **Méthode 2 MCP fallback** (`shell_command.ha_clear_all_ip_bans`) | déjà acquis | 🟢 Migration partielle S73 |

## Recherche MCP registry (S84)

- ✅ **Cloudflare Developer Platform** : `bindings.mcp.cloudflare.com`, 24+ outils (accounts, KV, Workers, R2…). Couverture **CF Access / Tunnel** à valider via T#87.
- ❌ **Microsoft 365 MCP officiel** (`microsoft365.mcp.claude.com`) : `outlook_email_search` lecture uniquement, orienté entreprise (pas live.fr). T#48 reste pertinent → MCP communautaire requis pour live.fr + écriture (`move`, `delete`, `mark_read`, `create_filter`).

## Cas non migrables — Justifications

- **`browser-mod`** : skill conçue pour pilote dashboard HA en screenshot. Le MCP `Claude in Chrome` est l'outil natif. Pas d'alternative (par essence visuelle).
- **`git-github-push`** : popup OAuth Git Credential Manager → `mightIA` GitHub se fait obligatoirement par navigateur, une seule fois. MCP GitHub existe mais ne couvre pas le bootstrap auth.
- **`install-claude-code-windows`** : OAuth Anthropic au premier `claude login`. One-shot, pas un workflow récurrent.

## Synthèse impact

- **3 migrations à venir, gros impact** : T#48 (Outlook MCP) débloque skills #1, #2, #3 → gain le plus important.
- **1 migration à tester** : T#87 (MCP Cloudflare) pour skill #5.
- **3 skills déjà migrées ou partiellement** : #4, #9 + Gmail tri général (S25-S27).
- **3 cas non migrables** documentés.

## Lien règle CLAUDE.md

Règle « MCP > Brave » ajoutée en `CLAUDE.md` §4 (Mode de travail) le 02/05/2026. Voir bullet « RÈGLE MCP > BRAVE (T#49, session 84) ».

## Sessions précédentes pertinentes

- **S25-S27** : migration Gmail tri (GongRzhe Gmail MCP).
- **S70** : rotation `mcp.might.ovh` (path-token) pour MCP HA add-on.
- **S73** : sub-agent CLI `debannissement-ip` (Méthode 2 MCP fallback).
- **S84** : audit transverse T#49 (ce document).
