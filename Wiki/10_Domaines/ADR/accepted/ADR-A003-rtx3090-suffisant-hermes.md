---
title: ADR-A003 — RTX 3090 24 GB suffisant pour Hermès Agent + MCP HA
created: 2026-04-27
updated: 2026-04-28
tags: [adr, accepted, hardware, gpu, hermes, llm]
status: accepted
session_origine: S57-S63
---

# ADR-A003 — RTX 3090 24 GB suffisant pour Hermès Agent + MCP Home Assistant en Mode Réactif

## Contexte

Phase B Hermès (T#73) : 5 modèles consécutifs KO (mistral-nemo, Llama 3.3 70B Q3, Haiku 4.5, qwen2.5-agent, qwen3.5-27B Q5) sur RTX 3090 24 GB en avril 2026. Verdict transversal apparent : "le tool calling local est cassé sur RTX 3090, il faut un cloud LLM ou plus de VRAM". Décision T#73 (Hardware Upgrade Ryzen 7950X + carte 48 GB, BoM 2 410 €) en attente du verdict GO/NO-GO. Audit méthodologique 2 lancé S62-S63 après 5+ KO consécutifs (pattern `feedback_audit_communautaire_avant_verdict.md`).

## Décision

**ACCEPTÉE** le 26/04/2026 (Cookbook S57-S63). RTX 3090 24 GB validée comme hardware suffisant pour Hermès Agent + Ollama + MCP HA en Mode Réactif (1 alerte/jour). Hardware Upgrade T#73 (2 410 €) **annulé**.

## Conséquence

- **Économie immédiate 2 410 €** : pas d'achat Ryzen 7950X + carte 48 GB.
- **Cause racine identifiée** : bug `has_reasoning guard` dans Hermes Agent v0.11.0 lui-même (pas les modèles). Fix par `hermes update` (131 commits, post-26/04/2026, commit ≥ `087e74d4`).
- **Latences validées post-fix** (qwen3.5:27b Q5_K_M + Modelfile durci num_ctx 65536, RTX 3090 24 GB + offload CPU 20/80) :
  - Action simple (notification HA) : 5 m 06 s (vs 20 m 01 s avant fix, **−75 %**)
  - Lecture multi-sensors + comparaison sémantique : 2 m 40 s
  - Multi-step (lecture → condition `>22°C` → notification) : 2 m 57 s
- **Verdict cas d'usage** : viable pour Mode Réactif Jarvis (60 s à 5 min acceptable). Pas adapté à un usage interactif synchrone (chat humain) — pour ce dernier cas, déléguer à Haiku 4.5 OpenRouter reste pertinent (~$0.14/prompt avec optimisations).
- **Pattern méthodologique transversal** : "audit niveau 2" capitalisé dans le repo public (Cookbook publié 26/04/2026, repo `mightIA/hermes-agent-rtx3090-cookbook`, License MIT).
- **Heuristique de stop** : déclencher audit communautaire (issues GitHub upstream + grep doc officielle + clone shallow repo) après 5+ KO consécutifs au lieu de continuer à empiler les tentatives.

## Alternative écartée

- **Hardware Upgrade Ryzen 7950X + carte 48 GB (T#73, 2 410 €)** : annulé après identification de la cause racine côté Hermès (pas hardware).
- **Bascule définitive Haiku 4.5 OpenRouter en moteur principal** : reste utile pour usage interactif chat humain, pas obligatoire pour Mode Réactif.

## Leçons des rejets antérieurs (ADR-002, ADR-003 rejected)

Avant le verdict S63, plusieurs ADR rejected avaient déjà tenté de clore la question du moteur principal sans pointer la vraie cause racine :

- [[10_Domaines/ADR/rejected/ADR-002-mistral-nemo-principal|ADR-002 (rejected)]] — `mistral-nemo:12b` comme principal écarté (perf insuffisante, mais cause racine `has_reasoning guard` non identifiée à l'époque).
- [[10_Domaines/ADR/rejected/ADR-003-llama33-70b-q3|ADR-003 (rejected)]] — Llama 3.3 70B Q3 écarté pour mêmes symptômes apparents (timeout/empty), même cause racine masquée.

**Leçon transversale** : 5 KO consécutifs sur 5 modèles différents auraient dû déclenc