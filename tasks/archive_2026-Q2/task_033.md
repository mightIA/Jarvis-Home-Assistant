---
id: 33
title: "Methode MCP fallback pour debannissement"
status: done
priority: P2
session_opened: S18
session_closed: S18
tags: [ha-mcp, security, mcp, cowork, deban-ip]
source: "Session 18 / Fallback Chrome bloque"
---

# T#33 — Methode MCP fallback pour debannissement

## Description

**[NOUVELLE session 18 — securite]** Methode MCP fallback pour debannissement : `shell_command.ha_clear_all_ip_bans` ajoute dans `configuration.yaml` (truncate `/config/ip_bans.yaml`). Permet a Jarvis de vider tous les bans IP via MCP ha-mcp sans sortir de Cowork, utile quand Claude in Chrome est bloque (policy org). Skill `debannissement-ip` + protocole `Ressources/Protocoles/IP_Bans.md` mis a jour avec Methode 3.

## Source / Échéance

Session 18 / Fallback Chrome bloque

## Statut

**FAIT (session 18, 20/04/2026)** — service charge (valide via `ha_list_services`), test a vide OK (`returncode: 0`). Version parametree `sed -i '/{{ ip }}/d'` refusee pour risque d'injection shell. Pour IP ciblee, rester sur Methode 1 (SSH) ou 2 (File Editor).
