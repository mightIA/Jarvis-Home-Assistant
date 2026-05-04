---
title: Issues GitHub a suivre
created: 2026-04-27
updated: 2026-04-27
tags: [atome, veille, github, issues, monitoring]
status: actif
---

# Issues GitHub a suivre

Catalogue des issues upstream qui impactent directement la stack Jarvis
(Hermes Agent, Ollama, add-on ha-mcp, autres MCP). A re-checker
chaque semaine ou avant chaque session de test LLM local.

## Contexte

Le **pattern d'audit communautaire** (cf. auto-memory
`feedback_audit_communautaire_avant_verdict`) impose de croiser tout
verdict KO avec les issues upstream avant elimination. Ce catalogue
centralise les issues actives et les fix qui ont debloque la stack
S57 a S63 (cf. Cookbook RTX 3090).

## Tableau de suivi

### Hermes Agent (NousResearch/hermes-agent)

| Issue | URL | Statut suivi | Impact projet | Derniere check |
|---|---|---|---|---|
| #12146 — provider custom fallback openrouter | https://github.com/NousResearch/hermes-agent/issues/12146 | RESOLU S60 | OpenRouter doit etre `provider: openrouter` SEUL, pas `custom`+base_url. Sinon agent runs fall back. | 2026-04-26 (S60) |
| Commits fix `has_reasoning guard` (5ae60815, f93d4624, 63bf7a29, 9daa0620) | https://github.com/NousResearch/hermes-agent/commits/main | INTEGRES fin avril 2026 | Resout `Model returned empty after tool calls` sur Qwen 3.x / DeepSeek-R1 / Kimi. **`hermes update` obligatoire avant tout debug.** | 2026-04-26 (S63) |
| #4172 (release v0.11.0 23/04/2026) | https://github.com/NousResearch/hermes-agent/releases | A SURVEILLER | Bugs frais probables sur les nouvelles releases. Toujours faire `hermes update` avant test. | 2026-04-26 |

### Ollama (ollama/ollama) — famille tool calling Qwen 3

| Issue | URL | Statut suivi | Impact projet | Derniere check |
|---|---|---|---|---|
| #11662 | https://github.com/ollama/ollama/issues/11662 | OUVERTE | Qwen3 tool calling broken — pattern `<think>` parasite. Mitige via Modelfile durci ou `hermes update`. | 2026-04-26 (S57) |
| #14601 | https://github.com/ollama/ollama/issues/14601 | OUVERTE | Tool calling /api/chat malformed sur Qwen3. Meme mitigation. | 2026-04-26 (S57) |
| #11135 | https://github.com/ollama/ollama/issues/11135 | OUVERTE | Symptomes voisins tool calling Qwen3. | 2026-04-26 (S57) |
| #14745 | https://github.com/ollama/ollama/issues/14745 | OUVERTE | Symptomes voisins tool calling Qwen3. | 2026-04-26 (S57) |
| #14617 | https://github.com/ollama/ollama/issues/14617 | OUVERTE | Disable thinking via Modelfile — pattern documente. | 2026-04-26 (S57) |
| #6713 | https://github.com/ollama/ollama/issues/6713 | OUVERTE | Talking to Mistral-Nemo via OpenAI tool calling fails. Confirme verdict KO mistral-nemo en moteur principal. | 2026-04-26 (S60) |

### Add-on Home Assistant (homeassistant-ai/ha-mcp)

| Issue | URL | Statut suivi | Impact projet | Derniere check |
|---|---|---|---|---|
| Bug DCR core HA mcp_server | repo HA core | CONTOURNE | Core HA `mcp_server` ne supporte pas DCR (RFC 7591). Solution : add-on `homeassistant-ai/ha-mcp` v7.3.0+ avec FastMCP+DCR. | 2026-04-19 (S15) |
| `enable_tool_search` toggle | https://github.com/homeassistant-ai/ha-mcp | ACTIVE S53 | 87 outils -> 20 outils via meta-recherche. Necessaire pour modeles <= 14B. Compromis sur modeles 27-32B (a tester). | 2026-04-26 (S53) |

### Autres MCP

| Issue | URL | Statut suivi | Impact projet | Derniere check |
|---|---|---|---|---|
| GongRzhe/Gmail-MCP-Server `list_filters` bug | https://github.com/GongRzhe/Gmail-MCP-Server | OUVERTE | `create_filter` OK mais `list_filters` renvoie vide. Verifier UI Gmail avant retenter (risque doublons). | 2026-04-22 (S27) |

## Procedure de check hebdo

1. `hermes update` (depuis WSL2) puis `hermes --version` — verifier qu'on
   est sur le dernier hash upstream.
2. Visiter les pages issues ci-dessus, regarder les commentaires recents.
3. Si une issue critique passe en RESOLU : tester sur la stack Jarvis et
   mettre a jour la colonne `Statut suivi` + auto-memory si pertinent.
4. Si nouveau bug apparait sur la stack : creer une entree ici AVANT de
   conclure KO.

## Sources

- Cookbook RTX 3090 — `Projets/Cookbook_Hermes_RTX3090/docs/troubleshooting.md`
- Cookbook RTX 3090 — `Projets/Cookbook_Hermes_RTX3090/docs/audit-methodologique.md`
- Auto-memory `feedback_audit_communautaire_avant_verdict.md`
- Auto-memory `reference_hermes_provider_openrouter_correct.md`
- Sessions S57, S58, S60, S63 (memory/historique/)

## Liens internes

- [[_Index]] — Hub Veille
- [[Modeles_LLM_A_Tester]]
- [[Provider_Benchmarks]]
