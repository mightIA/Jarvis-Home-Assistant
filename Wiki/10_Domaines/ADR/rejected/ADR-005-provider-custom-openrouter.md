---
title: ADR-005 — provider custom Hermès pour OpenRouter
created: 2026-04-27
tags: [adr, rejected, hermes, openrouter, config]
status: rejected
session_origine: S60
---

# ADR-005 — Configurer OpenRouter dans Hermès via `provider: custom` + `base_url`

## Contexte

S58 : préparation bascule Hermès vers Haiku 4.5 OpenRouter (Phase B étape 3). Patch chirurgical lignes 1-6 de `~/.hermes/config.yaml` :

```yaml
model:
  default: anthropic/claude-haiku-4.5
  provider: custom
  base_url: https://openrouter.ai/api/v1
  context_length: 200000
  api_key: ${OPENROUTER_API_KEY}
```

Logique apparente : Hermès supporte `provider: custom` pour Ollama local (`base_url: http://localhost:11434/v1`), donc même schéma transposé pour OpenRouter. Patch validé visuellement S58, test repoussé S59-S60.

## Décision

**REJETÉE** le 26/04/2026 (S60).

## Raison du rejet

Audit méthodologique S60 (suite à 3 modèles consécutifs KO) : découverte de [Hermes Agent Issue #12146](https://github.com/NousResearch/hermes-agent/issues/12146) "Agent runs fall back to openrouter despite model.provider=custom". OpenRouter est en réalité un **first-class provider Hermès** au même titre qu'Anthropic ou OpenAI direct — la convention officielle est `provider: openrouter` SEUL (pas de `base_url`, pas de `api_key`, Hermès lit `OPENROUTER_API_KEY` automatiquement depuis `~/.hermes/.env`). Le `provider: custom` est réservé aux backends self-hosted **non listés en first-class** : Ollama local, LiteLLM, vLLM, llama.cpp, SGLang, LocalAI. Utiliser `provider: custom` sur OpenRouter déclenche le bug du fallback silencieux.

## Impact

- **Test Haiku S60 sauvé** : patch correctif appliqué (`provider: openrouter` seul, suppression `base_url` + `api_key`), test réussi (8 round-trips, 6 tool calls, $0.136 dépensés).
- **Pattern méthodologique capitalisé** : auto-memory `reference_hermes_provider_openrouter_correct.md` documente la convention officielle.
- **Audit niveau 2 systématisé** : règle `feedback_audit_communautaire_avant_verdict.md` (déclencher audit après 5+ échecs consécutifs au lieu de continuer à empiler les tentatives).

## Alternative retenue

```yaml
model:
  default: anthropic/claude-haiku-4.5
  provider: openrouter   # first-class
  context_length: 200000
```

Clé `OPENROUTER_API_KEY` dans `~/.hermes/.env` lue automatiquement.

## Source

- `memory/historique/2026-04-26_session_60_audit_bugs_haiku_partiel.md`
- Auto-memory `reference_hermes_provider_openrouter_correct.md`
- [Hermes Agent Issue #12146](https://github.com/NousResearch/hermes-agent/issues/12146)
