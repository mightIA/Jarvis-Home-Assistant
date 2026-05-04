---
id: 30
title: "Pairer le MCP ha-mcp dans l'**app Claude iOS** (Paramètres > Connecteurs > aj..."
status: done
priority: P2
session_opened: S17
session_closed: S17
tags: [ha-mcp, mcp, cowork]
source: "Session 17 / Plan mobilite"
---

# T#30 — Pairer le MCP ha-mcp dans l'**app Claude iOS** (Paramètres > Connecteurs > aj...

## Description

**[NOUVELLE session 17 — mobilite]** Pairer le MCP ha-mcp dans l'**app Claude iOS** (Paramètres > Connecteurs > ajouter URL `https://mcp.might.ovh/private_[REDACTED-OLD-SECRET-S70]`, auth OAuth DCR). But : piloter HA à distance depuis iPhone sans que le PC soit allumé. Même URL / même flow que volet Cowork web de Task #27.

## Source / Échéance

Session 17 / Plan mobilite

## Statut

**FAIT automatiquement (session 17, 20/04/2026) par sync compte** — l'app Claude iOS ne permet PAS d'ajouter un connecteur MCP custom depuis l'iPhone (UI lecture seule). Mais en ajoutant "Jarvis HA" cote Cowork web (Task #27 volet Cowork), le connecteur est **paire au niveau du compte Anthropic** et apparait automatiquement dans la liste Connecteurs de l'app Claude iOS. Mickael aura acces a HA depuis l'iPhone des qu'il ouvre l'app. A re-valider visuellement cote iPhone lors du prochain deplacement.
