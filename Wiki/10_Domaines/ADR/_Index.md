---
title: ADR — Architecture Decision Records
created: 2026-04-27
tags: [moc, adr, decisions]
status: actif
domaine: ADR
---

# ADR — Architecture Decision Records

Un ADR documente une decision d'architecture importante (techno, pattern, fournisseur). Statut **accepted** = decision toujours valide aujourd'hui ; statut **rejected** = piste explorée et écartée, conservée pour ne pas y revenir 6 mois après.

## Conventions

- 1 ADR = 1 fichier, format `ADR-NNN-titre.md` (rejected) ou `ADR-ANNN-titre.md` (accepted).
- Sources : sessions `memory/historique/`, rapports `Projets/`, repos publics.
- Voir [accepted/_README.md](accepted/_README.md) et [rejected/_README.md](rejected/_README.md).

## ADR accepted

- [[ADR-A001-vault-obsidian-sandbox]] — Vault Obsidian Wiki/ comme sandbox Phase 1bis-a (S41)
- [[ADR-A002-add-on-ha-mcp]] — Add-on `homeassistant-ai/ha-mcp` retenu vs `mcp_server` core HA (S15)
- [[ADR-A003-rtx3090-suffisant-hermes]] — RTX 3090 24 GB suffisant pour Hermès Agent + MCP HA (Cookbook S57-S63)

## ADR rejected

- [[ADR-001-mcp-server-core-ha]] — `mcp_server` core HA rejeté (bug DCR, S15)
- [[ADR-002-mistral-nemo-principal]] — `mistral-nemo:12b` en principal Hermès rejeté (template chat cassé, S58)
- [[ADR-003-llama33-70b-q3]] — `Llama 3.3 70B Q3` rejeté (JSON dans content + 10m52s/tour, S58)
- [[ADR-004-mammouth-ai]] — Mammouth AI rejeté (flat sans API, S36)
- [[ADR-005-provider-custom-openrouter]] — `provider: custom` Hermès rejeté (bug Issue #12146, S60)
- [[ADR-006-cerfa-acroform]] — CERFA AcroForm rejeté (dématérialisation cassée, S46)
- [[ADR-007-smart-connections-payant]] — Plugin Smart Connections Obsidian payant rejeté (Karpathy LLM Wiki bat la vectorisation, S38)
