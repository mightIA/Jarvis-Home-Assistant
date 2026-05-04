---
id: 28
title: "Apres validation #26+#27, decider si desinstaller le `mcp_server` core HA (in..."
status: done
priority: P2
session_opened: S15
session_closed: S19
tags: [mcp]
source: "Session 15"
---

# T#28 — Apres validation #26+#27, decider si desinstaller le `mcp_server` core HA (in...

## Description

**[NOUVELLE session 15]** Apres validation #26+#27, decider si desinstaller le `mcp_server` core HA (integration "Model Context Protocol Server" dans Parametres > Appareils et services). Coexistence OK mais inutile. Nettoyage optionnel pour proprete.

## Source / Échéance

Session 15

## Statut

**FAIT (session 19, 20/04/2026)** — config entry `01KPJ1CDZ8X7CYKBZRTKCZV2D4` (domain `mcp_server`, titre "Assist", state `loaded`) supprime via `ha_delete_config_entry(confirm=true)`. `require_restart: false`. Verification post-suppression : `ha_get_integration(query="mcp")` renvoie 0 entries. Add-on ha-mcp seul actif, `ha_get_state("light.ampoule_chambre")` OK (state ON, brightness 3, same payload qu'avant). Nettoyage OK.
