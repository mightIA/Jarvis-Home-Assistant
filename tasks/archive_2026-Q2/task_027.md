---
id: 27
title: "Tester le pairage avec l'add-on ha-mcp via URL `https://mcp"
status: done
priority: P2
session_opened: S15
session_closed: S17
tags: [ha-mcp, pdf, mcp]
source: "Session 15"
---

# T#27 — Tester le pairage avec l'add-on ha-mcp via URL `https://mcp

## Description

**[PRIORITE — nee session 15]** Tester le pairage avec l'add-on ha-mcp via URL `https://mcp.might.ovh/private_[REDACTED-OLD-SECRET-S70]` (secret path auto-genere). Depend de #26. Ensuite executer les 7 tests de validation post-migration (cf. outputs/2026-04-19_checklist_validation.pdf).

## Source / Échéance

Session 15

## Statut

**FAIT (session 17, 20/04/2026) pour les DEUX volets** — volet **CLI Claude Code** : curl qualification endpoint, `.mcp.json` mis a jour, OAuth DCR OK, 80+ outils MCP charges, `ha_get_state("light.ampoule_chambre")` reussi. Volet **Cowork web** : connecteur personnalise "Jarvis HA" ajoute via claude.ai/customize/connectors, OAuth DCR OK, 80+ outils `ha_*` charges cote Cowork, validation bout-en-bout `ha_get_state` depuis Cowork renvoie le MEME payload que cote CLI (state ON, brightness 254, RGB 205/255/204, Last changed 05:42 UTC). **Reste les 7 tests checklist** (cf. outputs/2026-04-19_checklist_validation.pdf) a executer en prochaine session HA.
