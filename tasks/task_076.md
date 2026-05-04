---
id: 76
title: "Retest modèles Hermès — Phase 1 Qwen 3.6 NO-GO, Phase 2/3 + modèles modernes 2026"
status: testing
priority: P3
session_opened: S63
session_phase1_closed: S98
tags: [hermes, mode-reactif, modeles-llm, benchmark]
source: "Session 63 / Verdict audit méthodologique 2 — enrichi S98"
---

# T#76 — Retest modèles Hermès Agent

## Description

Évaluation continue des modèles LLM locaux sur stack Hermès Agent +
ha-mcp + RTX 3090 24 GB. Baseline qwen35-agent (qwen3.5:27b custom
Modelfile) sur 3 tests référence S63 :

| Test | Latence baseline | Description |
|------|------------------|-------------|
| A | 5m06s | Action simple write (notification persistante) |
| B | 2m40s | Lecture multi-sensors + comparaison sémantique |
| C | 2m57s | Multi-step conditionnel (read + write conditionnel) |

Protocole détaillé : `memory/reference_protocole_tests_modeles_hermes.md`
Registre prompts canoniques : `Projets/Cookbook_Hermes_RTX3090/tests/prompts.yaml`
Log résultats append-only : `Projets/Cookbook_Hermes_RTX3090/tests/results.csv`

## Phase 1 — Qwen 3.6 (S98 04/05/2026) — NO-GO upgrade

3 variantes Qwen 3.6 testées sur Test B + Test C (qwen3.6-agent uniquement) :

| Modèle | Test B | Test C | Verdi