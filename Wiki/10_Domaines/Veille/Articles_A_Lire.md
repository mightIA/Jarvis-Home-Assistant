---
title: Articles a lire
created: 2026-04-27
updated: 2026-04-27
tags: [atome, veille, articles, backlog, lecture]
status: actif
---

# Articles & ressources a lire

Backlog d'articles techniques pertinents pour le projet Jarvis. Mise a
jour au fil de l'eau, lecture quand creneau dispo.

Convention : statut LU / EN COURS / NON LU + date d'ajout.

## A lire — Priorite haute

| Article | URL | Raison de l'interet | Statut | Ajoute |
|---|---|---|---|---|
| **Karpathy LLM Wiki gist** | https://gist.github.com/karpathy/442a6bf555914893e9891c11519de94f | Pattern original LLM Wiki — base conceptuelle Phase 1 etude S36. Reconstruit via WebSearch, lecture directe pas faite. | NON LU | 2026-04-24 (S36) |
| **Anthropic Cookbook — Context Engineering** | https://github.com/anthropics/anthropic-cookbook | Bonnes pratiques engineering du contexte (token optimization, prompt design, agents). Directement applicable a Jarvis. | NON LU | 2026-04-26 |
| **Build To Launch — Token optimization 2026** | A retrouver via WebSearch | Decongestion CLAUDE.md, MEMORY.md, patterns "pointer don't embed" (cf. S49-S52). | NON LU | 2026-04-25 |

## A lire — Hermes Agent / agents locaux

| Article | URL | Raison de l'interet | Statut | Ajoute |
|---|---|---|---|---|
| **Hermes Agent — site officiel** | https://hermes-agent.nousresearch.com/ | Doc complete produit Nous Research. | EN COURS | 2026-04-24 (S36) |
| **Hermes Agent — providers** | https://hermes-agent.nousresearch.com/docs/integrations/providers/ | Verifier convention par provider (notamment OpenRouter convention SEULE). | LU partiellement | 2026-04-26 (S60) |
| **Hermes Agent — gateways** | https://hermes-agent.nousresearch.com/docs/integrations/gateways/ | Telegram, HA, Discord, Slack, WhatsApp pour Phase 2 mobile. | NON LU | 2026-04-24 (S36) |
| **Jsong Medium — Built LLM Wiki with Hermes Agent** | https://medium.com/@jsong_49820/how-i-built-a-self-improving-llm-wiki-with-hermes-agent-and-why-im-not-using-obsidian-1e9a7fa438c1 | Argumentaire "pourquoi pas Obsidian" + retour terrain Hermes. | NON LU | 2026-04-24 (S36) |
| **omankz — Hermes Agent + Claude Cowork + Notion + Obsidian** | https://github.com/omankz/Hermes-Agent---Claude-Cowork---Notion---Obsidian | Stack Mickael-compatible, reference architecturale. | NON LU | 2026-04-24 (S36) |
| **AeroLex Playbooks — Connect Claude Cowork to Obsidian** | https://github.com/aodhanzm/AeroLex-AI-Playbooks/blob/main/playbooks/How-to-Connect-Claude-Cowork-to-Obsidian.md | Recettes operationnelles. | NON LU | 2026-04-24 (S36) |

## A lire — Retours terrain critiques (pattern d'echec)

| Article | URL | Raison de l'interet | Statut | Ajoute |
|---|---|---|---|---|
| **Aaron Fulkerson — LLM Wiki in Production** | https://aaronfulkerson.com/2026/04/12/karpathys-pattern-for-an-llm-wiki-in-production/ | Retour negatif (23 orphans + 11 broken refs). Limite d'echelle. | NON LU | 2026-04-24 (S36) |
| **Zafer Dace — Karpathy Obsidian wiki broke at 100 articles** | https://earezki.com/ai-news/2026-04-17-karpathys-obsidian-wiki-broke-at-100-articles-rag-fixed-it/ | Confirme limite ~100-200 pages. Justification choix RAG. | NON LU | 2026-04-24 (S36) |

## A lire — Hardware & RTX 3090

| Article | URL | Raison de l'interet | Statut | Ajoute |
|---|---|---|---|---|
| **keturk/llm_on_rtx_3090** | https://github.com/keturk/llm_on_rtx_3090 | Battle-tested guide LLM RTX 3090. | NON LU | 2026-04-24 (S36) |
| **Modelfit RTX 3090 LLM benchmarks 2026** | https://modelfit.io/gpu/rtx-3090/ | Benchmarks tok/s recents. | NON LU | 2026-04-24 (S36) |
| **IntuitionLabs — Local LLM Deployment on 24GB GPUs** | https://intuitionlabs.ai/articles/local-llm-deployment-24gb-gpu-optimization | Optimisations 24 GB strict. | NON LU | 2026-04-24 (S36) |

## A lire — MCP & ecosystem

| Article | URL | Raison de l'interet | Statut | Ajoute |
|---|---|---|---|---|
| **Specification MCP officielle** | https://modelcontextprotocol.io/ | Reference protocole. | NON LU | 2026-04-25 (S40) |
| **HA Community — Filesystem MCP Karpathy LLM wiki** | https://community.home-assistant.io/t/filesystem-mcp-server-expose-your-local-directory-to-claude-karpathy-llm-wiki-for-home-assistant/1005762 | Add-on HA dedie wiki LLM. | NON LU | 2026-04-24 (S36) |

## Newsletters / sources de veille reguliere

- **Anthropic news** — https://www.anthropic.com/news (Claude releases).
- **Nous Research blog** — https://nousresearch.com/ (Hermes Agent updates).
- **Ollama releases** — https://github.com/ollama/ollama/releases (fixes
  tool calling).
- **r/LocalLLaMA** — Reddit, retours communautaires modeles locaux.

## Procedure d'ajout

1. Quand un article apparait en cours de session, ajouter une ligne
   dans le tableau approprie avec date d'ajout.
2. Quand article LU, basculer statut + ajouter 2-3 lignes de notes
   dans une section dediee si insights cles.
3. Si insight critique : creer aussi auto-memory + entree dans
   l'atome concerne (Modeles_LLM_A_Tester, Provider_Benchmarks, etc.).

## Sessions sources

- S36 (24/04/2026) — etude Phase 1 LLM Wiki + decouverte Hermes Agent.
- S40 (25/04/2026) — registry MCP github.com/mcp.
- S49-S52 (25/04/2026) — decongestion CLAUDE.md/TASKS.md/MEMORY.md
  (pattern token optimization).
- S60 (26/04/2026) — verdict provider OpenRouter Hermes.

## Liens internes

- [[_Index]] — Hub Veille
- [[Modeles_LLM_A_Tester]]
- [[MCP_Ecosystem]]
