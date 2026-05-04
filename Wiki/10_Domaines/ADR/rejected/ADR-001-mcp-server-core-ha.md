---
title: ADR-001 — mcp_server core HA
created: 2026-04-27
updated: 2026-04-27
tags: [adr, rejected, ha, mcp]
status: rejected
session_origine: S15
---

# ADR-001 — Intégration `mcp_server` core Home Assistant

## Contexte

Home Assistant intègre nativement un composant `mcp_server` censé exposer une interface MCP pour les clients tiers (Cowork, Claude Desktop, etc.). Première tentative d'intégration sessions S08 à S14 : objectif = pairer Cowork directement sur l'endpoint `/mcp_server/sse` exposé via Cloudflare Access (bypass MCP). Plusieurs cycles de debug, multiples bans IP, 5 destinations bypass CF Access créées puis consolidées en 3.

## Décision

**REJETÉE** le 19/04/2026 (S15).

## Raison du rejet

Diagnostic S15 (logs HA DEBUG + curl externe + recherche issues GitHub) : le `mcp_server` core HA **ne supporte PAS le Dynamic Client Registration** (DCR, RFC 7591). Or le standard MCP a adopté OAuth 2.1 + DCR comme convention d'enregistrement client. Cowork (côté Anthropic) **exige** DCR pour s'enregistrer comme client OAuth — il ne supporte pas le mode "client OAuth pré-configuré". Conséquence : Cowork hit `/mcp_server/sse` sans token, HA renvoie 401 + `WWW-Authenticate: Bearer resource_metadata=...`, Cowork ignore l'en-tête (faute de DCR pour s'enregistrer), HA bannit l'IP après 5 tentatives. Issue HA core [homeassistant-ai/ha-mcp#245](https://github.com/homeassistant-ai/ha-mcp/issues/245) référence cette limite. Issue Anthropic [claude-code#26675](https://github.com/anthropics/claude-code/issues/26675) demande le support pré-configuré côté Cowork sans DCR — pas planifié.

## Impact

- **Travail perdu évité** : libère 2h+ de cycles debug répétés sur 7 sessions (S08-S14).
- **Architecture simplifiée** : tâche #23 "sous-domaine isolé `mcp.might.ovh`" devenue obsolète immédiatement.
- **Bans IP évités** : pivot stoppé l'hémorragie (4 bans sur S15 seule, range Anthropic outbound `160.79.104.0/21`).

## Alternative retenue

Add-on communautaire `homeassistant-ai/ha-mcp` v7.3.0 (FastMCP + DCR natif). Voir [[ADR-A002-add-on-ha-mcp]].

## Source

- `memory/historique/2026-04-19_session_15_pivot_ha_mcp_dcr.md`
- Auto-memory `feedback_mcp_server_core_no_dcr.md`
