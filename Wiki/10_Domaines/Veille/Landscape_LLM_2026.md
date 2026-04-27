---
title: Landscape LLM 2026
created: 2026-04-27
tags: [veille, llm, marche, landscape]
status: actif
---

# Landscape LLM — avril 2026

Etat du marche LLM cloud + local au 27 avril 2026, du point de vue du
projet Jarvis (orchestration Hermes Agent + ha-mcp + RTX 3090).

A rafraichir trimestriellement.

## Cloud — Frontier

### Anthropic
- **Claude Opus 4.6** — flagship raisonnement complexe, contexte long.
  Utilise via Claude Max (forfait Mickael, socle Cowork).
- **Claude Sonnet 4.6** — milieu de gamme, balance qualite/prix.
- **Claude Haiku 4.5** — modele rapide, candidat agent local Hermes via
  OpenRouter (test partiel S60, a finaliser).
- Tool calling natif fiable (pattern reference industrie).
- MCP : protocole natif Anthropic, tres bien supporte.

### OpenAI
- **GPT-5** (annonce, pas encore release a date).
- **GPT-4o-mini** — alternative low-cost via API ou OpenRouter.
- **gpt-oss:20b** — possible release modele open weights.

### Google
- **Gemini 3** (en cours de deploiement progressif).
- Contexte long (1M+ tokens), bon pour ingestion massive.

### Meta
- **Llama 3.5** — a venir 2026, surveillance en cours.
- Llama 3.3 70B disponible mais tool calling Ollama casse (cf. KO S58).

### Mistral
- **Mistral Large 2** — flagship multilingue, FR natif.
- **Mistral Small 3** — modele compact pour agents.
- **mistral-nemo:12b** — disponible Ollama, mais template chat casse en
  agent (cf. KO S58, OK uniquement compression auxiliaire).

## Local — RTX 3090 viables

### Qwen (Alibaba)
- **qwen3.5:27b** Q5 — agent principal **VALIDE S62-S63** (post-update Hermes).
- qwen3.5:14b — variante compacte a tester.
- qwen2.5:32b / qwen2.5-coder:32b — recommandes officiellement Hermes,
  jamais testes en principal (erreur methodologique S48-S60).

### Hermes (Nous Research)
- **Hermes 4** — a sortir Q2-Q3 2026. Optimise specifiquement pour
  Hermes Agent. Tres attendu cote projet Jarvis.
- Hermes 3 et 2 — anciennes generations, fonctionnent bien.

### DeepSeek
- **DeepSeek-R1 14B** — reasoning local. ATTENTION : ne supporte pas
  tool calling Ollama (HTTP 400 connu).
- DeepSeek V3 — disponible cloud, pas teste local.
- DeepSeek-R2 — a surveiller.

## Aggregateurs et providers tiers

- **OpenRouter** — clef API pay-as-you-go, 300+ modeles. Compte Mickael
  configure S55 (cap $5/mois, depot $20). Convention Hermes :
  `provider: openrouter` SEUL (pas `custom`+base_url, cf. Issue #12146).
- **Mammouth AI** — UI chat humain flat ~10-12 EUR/mois, pas d'API.
  Ecarte (redondance Claude Max).

## Tendances generales avril 2026

1. **Reasoning natif partout** — Qwen 3.x `<think>` blocks, DeepSeek-R1,
   Kimi, OpenAI o1. Cause de bugs tool calling (cf. Cookbook
   Symptome 8 + commits Hermes `has_reasoning guard`).
2. **MCP standardise** — Anthropic MCP devient le protocole agent de
   facto. Cf. atome [[MCP_Ecosystem]].
3. **Open weights forts** — Qwen 3.5, Hermes 4, Llama 3.5 rendent
   l'inference locale serieuse pour les setups RTX 3090+.
4. **Agents locaux 24/7** — pattern Hermes Agent + WSL2 + Ollama
   accessible (RTX 3090 24 GB suffit pour 27-32B Q4-Q5).

## Sessions sources

- S36 (24/04/2026) — etude initiale, decouverte Hermes Agent.
- S55 (26/04/2026) — setup OpenRouter compte Mickael.
- S60 (26/04/2026) — audit methodologique + verdict provider OpenRouter
  natif Hermes (Issue #12146).
- S62 (26/04/2026) — qwen3.5:27b Q5 valide voie G.
- S63 (26/04/2026) — Cookbook RTX 3090 audit methodologique 2 succes.

## Sources externes

- Anthropic models : https://www.anthropic.com/news
- OpenRouter pricing : https://openrouter.ai/models
- Hermes Agent providers : https://hermes-agent.nousresearch.com/docs/integrations/providers/

## Liens internes

- [[_Index]] — Hub Veille
- [[Modeles_LLM_A_Tester]]
- [[Provider_Benchmarks]]
- [[MCP_Ecosystem]]
