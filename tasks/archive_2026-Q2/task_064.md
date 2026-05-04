---
id: 64
title: "qwen3:32b en Hermès v0"
status: done
priority: P2
session_opened: S53
session_closed: S58
tags: [ha-mcp, hermes, openrouter, mode-reactif, mcp]
source: "Session 53 / Phase 1bis-d β1 verdict"
---

# T#64 — qwen3:32b en Hermès v0

## Description

**[NOUVELLE session 53 — fiabiliser écriture HA via Hermès]** qwen3:32b en Hermès v0.11.0 + ha-mcp en mode `enable_tool_search` (depuis S53) bloque sur l'écriture HA : "Model returned empty after tool calls — nudging to continue" en boucle. Lecture OK, écriture KO. Voir auto-memory `feedback_qwen3_32b_ecriture_bloquee`. **Modèles à benchmarker** (changer `model.default` dans `~/.hermes/config.yaml`, restart Hermès, retester "Allume light.ampoule_chambre à 50%") : (a) **mistral-nemo:12b** (déjà installé S47-S48, utilisé en compression auxiliaire) — le plus rapide à tester, ~7 Go ; (b) **Llama 3.3 70B Q3** (~40 Go VRAM, RTX 3090 24 Go suffit en Q3 mais swap CPU possible — vérifier perfs) ; (c) **Gemma 4** (mentionné dans recherche S53 comme ayant "function calling tokens natifs" plus fiables) — à pull si dispo Ollama ; (d) **OpenRouter Claude Haiku 4.5** (bypass total du problème, dépend tâche #62 cap budgétaire). **Critère de succès** : Hermès appelle l'outil ET répond à l'utilisateur en moins de 2 min ET la lampe change physiquement. **Sortie attendue** : tableau benchmark + reco du modèle Hermès par défaut pour usage mixte lecture+écriture HA. **Durée estimée** : ~1h (4 modèles × ~15 min chacun). **MAJ S55 (26/04/2026)** : option (d) OpenRouter Claude Haiku 4.5 désormais **débloquée** — clé `Hermes-Jarvis` $5/mois injectée dans `~/.hermes/.env` (cf. T#62 partiel S55 + T#69 nouvelle). Reste à modifier `~/.hermes/config.yaml` pour ajouter provider OpenRouter + bascule modèle (→ T#69). **MAJ S58 (26/04/2026)** : verdicts options (a) et (b) acquis. **(a) mistral-nemo:12b ❌ KO** sous Ollama+Hermès (Modelfile durci `mistral-nemo-agent` créé, sed bascule appliqué) — inversion de rôle + SYSTEM ignoré + hallucination Node.js. Famille bug template chat Ollama. Auto-memory `feedback_mistral_nemo_template_casse.md`. **(b) Llama 3.3 70B Q3_K_M ❌ KO sévère** (pull 34 Go + Modelfile durci `llama3.3-agent` + bascule + fix WSL2 RAM via `.wslconfig` 28GB) — JSON tool call dans content + malformé + 10m52s warm/tour pour 80 tokens (~0.12 tok/s effectif). Latence éliminatoire pour Mode Réactif. Auto-memory `feedback_llama3_3_70b_q3_inutilisable.md` + `reference_wslconfig_28gb_pattern.md`. **Reste option (d) à tester S59** via T#69 (config.yaml déjà patché en S58). Option (c) Gemma 4 reportée (probablement obsolète si Haiku OK).

## Source / Échéance

Session 53 / Phase 1bis-d β1 verdict

## Statut

**PARTIEL S58** — options (a)+(b) testées KO ; option (d) patch fait, test S59
