---
title: ADR-A002 — Add-on homeassistant-ai/ha-mcp retenu vs core HA
created: 2026-04-27
updated: 2026-04-27
tags: [adr, accepted, ha, mcp, addon]
status: accepted
session_origine: S15
---

# ADR-A002 — Add-on `homeassistant-ai/ha-mcp` retenu comme serveur MCP HA principal

## Contexte

Suite au rejet du `mcp_server` core HA pour absence de support DCR (voir [[ADR-001-mcp-server-core-ha]]), 3 alternatives évaluées S15 :

- **A. `mcp-remote` proxy local** (Node.js sur PC) — proxy DCR-compliant qui parle au HA en mode pré-configuré derrière.
- **B. Add-on `homeassistant-ai/ha-mcp`** — add-on Supervisor isolé, FastMCP + DCR natif.
- **C. Attendre fix HA core** — délai indéfini, issue [homeassistant-ai/ha-mcp#245](https://github.com/homeassistant-ai/ha-mcp/issues/245) ouverte.

## Décision

**ACCEPTÉE** le 19/04/2026 (S15). Add-on `homeassistant-ai/ha-mcp` v7.3.0 (FastMCP 3.2.3, ha-mcp 7.2.0) installé via repo custom Apps > Dépôts. URL interne `http://192.168.1.11:9583/[REDACTED-SECRET]`. Exposition publique via Cloudflare Tunnel `mcp.might.ovh/<secret>` validée S16 (Phase 3).

## Conséquence

- **Cowork pairé avec succès** S17 (validation 7 tests) après échec sur 7 sessions précédentes (S08-S15) sur le core HA.
- **80+ outils `ha_*`** disponibles côté Cowork + Claude Code CLI (gestion entités, automations, scripts, dashboards, backups, etc.).
- **Isolation Supervisor** : add-on tourne dans un container dédié (pas dans le core HA), 3 feature flags dangereux (`HAMCP_ENABLE_FILESYSTEM_TOOLS`, `ENABLE_YAML_CONFIG_EDITING`, `HAMCP_ENABLE_CUSTOM_COMPONENT_INTEGRATION`) tous **OFF par défaut** et cachés dans l'UI.
- **Mode Réactif Jarvis v1.1** (S22) débloque grâce à cet add-on (pipeline alertes HA → email → Gmail label → scheduled task → Jarvis).
- **Évolutivité** : `enable_tool_search` activable côté add-on (S53) pour passer de 87 tools en clair à 20 tools (réduit ~46K → ~5K tokens idle context, compatible Anthropic deferred tools).

## Alternative écartée

- **A. `mcp-remote` proxy local** : ajoute une dépendance Node.js sur le PC, sync IP locale moins propre.
- **C. Attendre fix HA core** : pas planifié côté HA core, hold-up indéfini.

## Source

- `memory/historique/2026-04-19_session_15_pivot_ha_mcp_dcr.md`
- `memory/historique/2026-04-19_session_16_phase3_expo_mcp.md`
- `.claude/skills/ha-mcp-install/SKILL.md`
- Auto-memory `reference_ha_mcp_addon.md`
