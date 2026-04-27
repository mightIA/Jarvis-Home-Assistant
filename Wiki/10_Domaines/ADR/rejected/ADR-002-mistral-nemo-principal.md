---
title: ADR-002 — mistral-nemo:12b en principal Hermès
created: 2026-04-27
tags: [adr, rejected, hermes, ollama, llm]
status: rejected
session_origine: S58
---

# ADR-002 — `mistral-nemo:12b` comme moteur principal Hermès Agent

## Contexte

Phase B Hermès (T#73) : tester 3 modèles candidats en moteur principal (mistral-nemo:12b + Llama 3.3 70B Q3 + OpenRouter Haiku 4.5) pour trancher GO/NO-GO Hardware Upgrade 2 410 €. Étape 1 = `mistral-nemo:12b` avec Modelfile durci (SYSTEM Jarvis + règles tool calling + auto-récupération `ha_search_tools`). Modèle déjà validé S48 comme `auxiliary.compression.model` Hermès, candidat naturel pour passage en principal (latence faible, 12B paramètres).

## Décision

**REJETÉE** le 26/04/2026 (S58).

## Raison du rejet

Test scénario S58.1.7.a (notification HA via MCP ha-mcp) : **inversion de rôle catastrophique** — modèle joue le rôle utilisateur ("Bonjour, pouvez-vous m'aider à installer Node.js ?"), aucun tool call émis. Test discriminant 1.7.c (chat simple FR) : SYSTEM prompt **complètement ignoré**, description Hermès générique au lieu de Jarvis, mélange linguistique mineur. Cause probable : template de chat Mistral mal mappé sous Ollama+Hermès quand SYSTEM non trivial + catalogue 20 tools simultanés (famille bug Ollama [#11662](https://github.com/ollama/ollama/issues/11662)/[#14601](https://github.com/ollama/ollama/issues/14601), confirmé S60 par [Ollama Issue #6713](https://github.com/ollama/ollama/issues/6713) "Talking to Mistral-Nemo via OpenAI tool calling - fails"). Modelfile durci insuffisant pour compenser.

## Impact

- **Verdict Phase B étape 1 KO** documenté en ~30 min, bascule directe étape 2 sans investigation supplémentaire.
- **Validation complémentaire S60** : qwen2.5:32b (recommandé Hermès) absent depuis S48 — erreur méthodologique majeure révélée par audit S60.
- **mistral-nemo:12b reste valide** comme `auxiliary.compression.model` (override S48 préservé dans `~/.hermes/config.yaml`).

## Alternative retenue

Phase B étape 3 (Haiku 4.5 OpenRouter, S60) puis voie qwen3.5:27b Q5 + fix `reasoning_content` Hermès (Cookbook S57-S63). Voir [[ADR-A003-rtx3090-suffisant-hermes]].

## Source

- `memory/historique/2026-04-26_session_58_phase_b_etapes_1_2.md`
- Auto-memory `feedback_mistral_nemo_template_casse.md`
