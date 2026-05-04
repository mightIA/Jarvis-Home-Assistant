---
id: 23
title: "~~Migrer le MCP Server vers sous-domaine dedie `mcp"
status: done
priority: P2
session_opened: S11
session_closed: S15
tags: [mcp]
source: "Session 11 + 14"
---

# T#23 — ~~Migrer le MCP Server vers sous-domaine dedie `mcp

## Description

~~Migrer le MCP Server vers sous-domaine dedie `mcp.might.ovh` sans CF Access~~

## Source / Échéance

Session 11 + 14

## Statut

**OBSOLETE (session 15) — remplace par #27 (add-on ha-mcp).** Le bug DCR du mcp_server core rend le sous-domaine isole inutile, car le probleme n'etait pas l'archi reseau mais la compatibilite MCP. L'add-on ha-mcp expose son propre endpoint avec secret path auto-genere et coexiste avec le core.
