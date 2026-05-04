---
id: 49
title: "Systématiquement chercher à remplacer les workflows navigateur (Brave + Claud..."
status: done
priority: P2
session_opened: S29
session_closed: S84
tags: [ha-mcp, gmail, outlook, email, cloudflare, mcp, brave, tri-email, dashboard]
source: "Session 29 / Demande Mickael — optimisation tokens"
---

# T#49 — Systématiquement chercher à remplacer les workflows navigateur (Brave + Claud...

## Description

**[NOUVELLE session 29 — optim tokens]** Systématiquement chercher à remplacer les workflows navigateur (Brave + Claude in Chrome) par des MCP natifs dès qu'un MCP équivalent existe ou peut être installé. Raisonnement : les captures d'écran (surtout 4K) consomment beaucoup de tokens et ralentissent chaque tâche. Un appel MCP est ~5-10× moins gourmand en tokens et ~10× plus rapide. **Périmètre** : audit transverse de toutes les skills actives qui passent par Brave (tri-email-outlook, tri-email-outlook-priorites, cloudflare-access-ha dashboards, browser-mod quand inutile, etc.) et proposer un remplacement MCP pour chaque workflow critique. **Cas connus à traiter** : (a) Outlook → #48 (déjà identifié), (b) Cloudflare dashboard → chercher MCP Cloudflare officiel ou communautaire, (c) Gmail → déjà fait en S25-S27 (GongRzhe Gmail MCP), (d) HA UI → déjà OK (ha-mcp). **Livrable attendu** : un tableau récapitulatif par skill {workflow actuel Brave / MCP équivalent candidat / gain tokens estimé / statut}, et une règle générale ajoutée dans `CLAUDE.md` du type "privilégier MCP > Brave à chaque fois que possible".

## Source / Échéance

Session 29 / Demande Mickael — optimisation tokens

## Statut

✅ **Done — S84 (02/05/2026)**.

Audit transverse mené : 8 skills + 1 doc concernées sur 32 skills actives.
Tableau récap complet dans
[`memory/reference_audit_workflows_brave_mcp_s84.md`](../memory/reference_audit_workflows_brave_mcp_s84.md).

**Synthèse** :
- 3 migrations attendent T#48 (Outlook MCP) — gros impact tokens
- 1 migration à tester via T#87 (MCP Cloudflare officiel)
- 3 skills déjà migrées (Gmail, debannissement-ip)
- 3 cas non-migrables documentés (browser-mod, git-github-push, install-claude-code-windows)

**Livrables** :
- Règle « MCP > Brave » ajoutée dans [`CLAUDE.md` §4](../CLAUDE.md)
- Auto-memory `reference_audit_workflows_brave_mcp_s84.md` indexée dans [`memory/MEMORY.md`](../memory/MEMORY.md)
- Tâche de suivi T#87 créée pour MCP Cloudflare

**Tâches liées** :
- T#48 (P3, ouvert) — MCP Outlook live.fr (bloque 3 skills #1, #2, #3)
- T#87 (P3, ouvert) — Test MCP Cloudflare officiel (skill #5)
