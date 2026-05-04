---
id: 3
title: "Activer le MCP Server natif HA cote Home Assistant"
status: done
priority: P1
session_closed: S15
tags: [mcp]
source: "Migration 19/04/2026"
---

# T#3 — Activer le MCP Server natif HA cote Home Assistant

## Description

Activer le MCP Server natif HA cote Home Assistant

## Source / Échéance

Migration 19/04/2026

## Statut

**ABANDONNE (session 15) — bug DCR cote core HA.** Diagnostic session 15 : le `mcp_server` core HA ne supporte PAS Dynamic Client Registration (RFC 7591) que Claude.ai/Cowork EXIGE. Cause racine des 7 erreurs `ofid_*` accumulees sessions 8-14, le bypass CF Access n'etait PAS la cause. Verifie via logs HA (Cowork IPs `160.79.106.35`+`.37` hit direct `/mcp_server/sse` sans flow OAuth) et issues GitHub (anthropics/claude-ai-mcp#111, anthropics/claude-code#26675, homeassistant-ai/ha-mcp#245). **Bascule vers add-on `homeassistant-ai/ha-mcp` (FastMCP avec DCR) — voir #27.** App CF Access `HA MCP Server Bypass` conservee avec 3 destinations consolidees (mcp_server, auth, .well-known — `auth/revoke` manquait dans les 5 originales et etait dans discovery OAuth HA).
