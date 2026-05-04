---
id: 69
title: "Cœur de l'objectif fiabilité écriture HA"
status: cancelled
priority: P2
session_opened: S55
session_closed: S63
tags: [ha-mcp, hermes, openrouter, pdf, mcp]
source: "grep -i haiku` AVANT modif), (d) attention aux 9 sections `auxiliary.*` qui héritent du modèle principal (cf. auto-memory `feedback_hermes_auxiliary_models_inherit` S48) — décider override ou héritage"
---

# T#69 — Cœur de l'objectif fiabilité écriture HA

## Description

**[NOUVELLE session 55 — bascule modèle Hermès vers OpenRouter Claude Haiku]** Cœur de l'objectif fiabilité écriture HA. Pré-requis bouclé S55 : clé OpenRouter `Hermes-Jarvis` $5/mois injectée dans `~/.hermes/.env`. **Étapes** : (a) lire `~/.hermes/config.yaml` (sauvegarder en `.bak` horodaté avant modif), (b) ajouter section provider OpenRouter avec env var `${OPENROUTER_API_KEY}` (pas la clé en dur — Règle 0), (c) remplacer `model.default` actuel (qwen3:32b) par `anthropic/claude-haiku-4-5` via OpenRouter (vérifier nom exact via `curl https://openrouter.ai/api/v1/models

## Source / Échéance

grep -i haiku` AVANT modif), (d) attention aux 9 sections `auxiliary.*` qui héritent du modèle principal (cf. auto-memory `feedback_hermes_auxiliary_models_inherit` S48) — décider override ou héritage par section, (e) `hermes restart` puis test bout-en-bout : "Allume `light.ampoule_chambre` à 50%" → vérifier appel outil + retour utilisateur < 2 min + lampe physiquement allumée à 50%, (f) si OK → bascule définitive, sinon rollback `.bak` + retour qwen3:32b en attendant T#64 benchmark complet (mistral-nemo:12b + autres). **Critère de succès** : 3 tests d'écriture consécutifs réussis sans "Model returned empty after tool calls". **Durée estimée** : ~30-45 min. **Coût attendu** : ~$0.20-0.50 USD par test bout-en-bout (Haiku 4.5 ~$1/M input ~$5/M output, contexte ha-mcp ~5K tokens grâce `enable_tool_search` β1 S53). Bien sous le cap mensuel $5. **Référence connexe** : T#64 (benchmark autres modèles), T#62 (cap budgétaire FAIT), `feedback_qwen3_32b_ecriture_bloquee`, `reference_openrouter_setup_garde_fous`. **MAJ S58 (26/04/2026)** : étapes (a) backup `.bak.S58_llama33` + (b) section provider OpenRouter via interpolation `${OPENROUTER_API_KEY}` + (c) `model.default = anthropic/claude-haiku-4.5` + `base_url = https://openrouter.ai/api/v1` + `context_length = 200000` **FAIT** (patch chirurgical lignes 1-5 → 1-6 via `head` + heredoc + `tail -n +6`, diff 4 changes + 1 ajout, reste config intact). **Reste à exécuter S59** : (e) `hermes restart` + vérif banner Haiku + scénario test S58 identique aux KO précédents (titre `Test S59 haiku-4.5`) + (f) si OK validation 3 tests consécutifs → bascule définitive. Convention `${VAR}` dans yaml à valider au premier démarrage (sinon ajuster syntaxe Hermès). **MAJ S63 (26/04/2026)** : tâche **ANNULÉE**. Audit méthodologique 2 phase 1 a débloqué qwen35-agent local sur RTX 3090 (3 scénarios test OK, latence 2m 40s à 5m 6s). Bascule définitive Haiku non requise — OpenRouter doit rester l'exception ~5% PDF v2 (Hermès local 75% + Claude délégation 20% + OpenRouter 5%). Cf. archive S63 + auto-memory `reference_qwen35_agent_v1_postupdate_validated`.

## Statut

Session 55 / Suite directe setup OpenRouter | **ANNULÉ S63**
