---
title: Provider benchmarks
created: 2026-04-27
tags: [veille, providers, benchmarks, llm]
status: actif
---

# Provider benchmarks — cloud + local

Comparatif des providers LLM (cloud et local) du point de vue projet
Jarvis : prix, latence, qualite tool calling, ecosysteme MCP.

A retester quand un nouveau provider entre dans le perimetre.

## Cloud — pay-as-you-go

| Provider | Modeles cles | Prix indicatif (USD/M tok) | Latence typique | Tool calling | MCP support |
|---|---|---|---|---|---|
| **Anthropic** (direct) | Opus 4.6, Sonnet 4.6, Haiku 4.5 | Opus ~15/75, Sonnet ~3/15, Haiku ~0.8/4 | 1-5s/tour | Excellent (reference) | Natif (protocole maison) |
| **OpenRouter** | 300+ modeles toutes marques | varie selon modele + ~5-8% frais OpenRouter + 20% VAT FR | 2-10s/tour | Bon (depend du modele backend) | Bon (provider Hermes natif) |
| **OpenAI** (direct) | GPT-5 (a venir), GPT-4o, GPT-4o-mini | GPT-4o ~5/15, mini ~0.15/0.6 | 1-3s/tour | Excellent | Natif via SDK |
| **Google** | Gemini 3, Gemini 2.5 | Gemini 3 ~5/15 (estime) | 1-4s/tour | Bon | Via SDK Vertex |
| **Mistral** (direct) | Mistral Large 2, Small 3 | Large ~3/9, Small ~0.5/1.5 | 1-3s/tour | Bon | Natif |

### Notes prix (Mickael / France)
- OpenRouter facture USD avec ~30% frais cumules en France (5-8% service +
  20% VAT). Toujours convertir EUR<->USD avant validation Mickael
  (auto-memory `feedback_openrouter_usd_eur_30pct_frais`).
- Claude Max (forfait Mickael) inclut Cowork + tokens Claude usuels +
  CLI headless dans le quota (auto-memory `reference_plan_max_includes_cli`).

## Local — RTX 3090 24 GB

| Modele | Taille | Quantization | VRAM utilisee | Latence/tour (action HA) | Tool calling | Statut |
|---|---|---|---|---|---|---|
| **qwen3.5:27b** | 27B | Q5_K_M | ~28 GB (offload 20%) | 2m40s a 5m06s | OK post-update Hermes | VALIDE S62 |
| **qwen3:32b** (durci) | 32B | Q4 | ~26 GB (offload 20%) | ~5 min | OK avec Modelfile durci ou Hermes update | OK rehabilite S57 |
| **mistral-nemo:12b** | 12B | Q4 | ~7 GB | rapide | KO en principal | KO S58, OK auxiliaire |
| **llama3.3:70b-q3** | 70B | Q3_K_M | ~34 GB (offload 50%+) | 10m52s/tour | KO (JSON dans content) | KO S58 |
| **llama3.1:8b** | 8B | Q4 | ~5 GB | rapide | Hallucinations sur catalogue >50 outils | Limite, mitige par `enable_tool_search: true` |
| **deepseek-r1:14b** | 14B | Q5 | ~10 GB | rapide | Non supporte (HTTP 400 Ollama) | KO tool calling Ollama |

### Benchmarks tok/s indicatifs (sources S36)
- Qwen 3 32B Q4 : ~35 tok/s
- Llama 3.1 8B : ~112 tok/s
- DeepSeek-R1 14B : ~56 tok/s
- Qwen 2.5 Coder 32B : ~30 tok/s
- MoE divers : jusqu'a ~196 tok/s

## Comparatif fonctionnel — providers cote Hermes

| Critere | OpenRouter | Anthropic direct | Ollama local |
|---|---|---|---|
| Convention Hermes | `provider: openrouter` SEUL | `provider: anthropic` | `provider: ollama` ou `custom` |
| Auth | API key | API key | Pas d'auth (localhost) |
| Cap depenses | OUI (cap mensuel + depot one-time) | OUI (limites compte) | NA |
| Latence reseau | 100-300 ms ajoutes | 100-300 ms ajoutes | Aucune |
| Confidentialite | Donnees vers provider final | Donnees vers Anthropic | 100% local |
| Disponibilite hors ligne | NON | NON | OUI |
| Cout par requete | Variable selon modele | Variable | Cout electrique GPU uniquement |

## MCP support par provider

Voir atome dedie [[MCP_Ecosystem]] pour le detail. Resume :
- Anthropic — protocole natif, MCP est leur creation.
- Hermes Agent — supporte MCP HTTP + stdio nativement (config `mcp_servers:`).
- OpenAI / Google / Mistral — pas de MCP natif a date, integrations via
  wrappers ou SDK.
- Ollama — pas de MCP, mais Hermes fait le pont.

## Critere de choix routing Hermes

Pattern Smart Model Routing (Hermes v0.10+) :
- Tache simple HA (lecture etat, notification) -> modele local Qwen 3.5 27B.
- Tache complexe (raisonnement multi-step, code) -> Claude Haiku 4.5 ou
  Sonnet 4.6 via OpenRouter / Anthropic direct.
- Tache hors ligne ou ultra-frequente -> local Qwen.
- Compression / resumes -> mistral-nemo:12b (auxiliaire).

## Sessions sources

- S36 (24/04/2026) — benchmarks initiaux RTX 3090 + comparatif abonnements.
- S55 (26/04/2026) — setup OpenRouter + frais France.
- S60 (26/04/2026) — verdict convention `provider: openrouter` Hermes.
- S62-S63 (26/04/2026) — validation qwen3.5:27b Q5.

## Liens internes

- [[_Index]] — Hub Veille
- [[Modeles_LLM_A_Tester]]
- [[Landscape_LLM_2026]]
- [[MCP_Ecosystem]]
