---
id: 77
title: "Modèle MAISON Nous Research conçu pour Hermès Agent"
status: open
priority: P3
session_opened: S63
tags: [hermes, pdf]
source: "Session 63 / Audit S57 candidat top 1"
---

# T#77 — Modèle MAISON Nous Research conçu pour Hermès Agent

## Description

**[NOUVELLE session 63 — Test bonus Hermes 4 70B Q3 HuggingFace]** Modèle MAISON Nous Research conçu pour Hermès Agent. Pas sur Ollama Library officielle (Issue [#12119](https://github.com/ollama/ollama/issues/12119)). 3 voies : (A) pull GGUF HuggingFace `NousResearch/Hermes-4-70B` + Modelfile FROM custom ; (B) fallback `ollama pull hermes3:70b` (ancien Nous, possible) ; (C) fork community. **VRAM** : Q3_K_M ≈ 30 GB > 24 GB → offload CPU obligatoire. Avec fix `reasoning_content` post-S63, latence offload pourrait être acceptable (à mesurer). **Pré-requis** : T#76 d'abord (compare avec mistral-nemo:12b / Llama 3.3 / qwen3 / qwen2.5 retestés). **Critère** : qualité supérieure démontrable + latence < 5m. **Si KO** : on garde qwen35-agent. **Si OK** : potentiel bascule pour pattern PDF v2 « Hermès local 75% ». **Durée estimée** : ~90-120 min.

## Source / Échéance

Session 63 / Audit S57 candidat top 1

## Statut

À faire (P3, après T#76)
