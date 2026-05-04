---
name: Qwen 3.6 sortie avril 2026 — testé S98, NO-GO upgrade
description: S98 — Phase 1 T#76 close. qwen3.6:27b brut + 35B-A3B MoE + qwen3.6-agent custom testés. Aucun ne bat baseline qwen35 2m40s Test B. MoE KO sémantique. Namespace corrigé (qwen3.6:27b, qwen3.6:35b-a3b, sans préfixe batiai/).
type: project
---

# Qwen 3.6 sortie avril 2026 — ratée par la veille manuelle

## Fait

Deux nouvelles variantes Qwen sorties en avril 2026, **ratées par la
veille manuelle Jarvis** (~2 semaines de retard sur la sortie) :

- **Qwen 3.6-27B** — sortie 22/04/2026, 27B dense, Apache 2.0,
  multimodal text+image+vidéo, contexte natif 262K → 1M extensible,
  SWE-bench Verified 77.2 % (-3.7 pts vs Claude Opus 4.6).
  Tool calling Ollama validé toutes quants (`"think": false` au call).
  Successeur direct du `qwen3.5:27b` (qwen35-agent actuel).

- **Qwen 3.6-35B-A3B** — sortie 16/04/2026, MoE 35B total /
  **3B actifs par token**. Tool calling + thinking sur Ollama.
  Benchmarks : 92.7 AIME26, 86.0 GPQA, 85.2 MMLU-Pro, 73.4 SWE-bench.
  Potentiellement très rapide grâce aux 3B actifs malgré la taille
  totale.

Disponibilité Ollama : `batiai/qwen3.6-27b` et `batiai/qwen3.6-35b`.

## Why this matters

1. **Validation T#91** (veille auto hebdo écosystème MCP/modèles/plugins) :
   confirme empiriquement la valeur de la veille automatisée. La
   surveillance manuelle de l'écosystème LLM est trop chronophage et
   on rate des sorties majeures (Qwen est un acteur tier-1, sortie
   couverte par r/LocalLLaMA + arXiv + HuggingFace + GitHub).

2. **Réouverture T#76** (retest 4 modèles historiques sur Hermès
   v0.12.0) : enrichie de 4 → 6 modèles avec ces 2 Qwen 3.6.
   Test à faire en session dédiée. Si Qwen 3.6-27B bat la référence
   `qwen35` à 2m40s sur Test B S63 → upgrade direct candidat. Si
   Qwen 3.6-35B-A3B est plus rapide grâce au MoE → bascule
   architecturale envisageable.

## How to apply

- Pour T#91 (veille auto) : ajouter Qwen / Alibaba dans la liste des
  acteurs surveillés (HuggingFace `Qwen/`, GitHub `QwenLM/`,
  Ollama `library/qwen*` + `batiai/qwen*`). Fréquence hebdo dimanche
  04h00 suffisante pour ne pas rater plus d'1 semaine.

- Pour T#76 (retest 6 modèles) : Qwen 3.6-27B en priorité 1 (le plus
  prometteur pour remplacer qwen35-agent), Qwen 3.6-35B-A3B en
  priorité 2 (MoE expérimental, latence à mesurer).

## Lien

- T#76 enrichi : `tasks/task_076.md`
- T#91 veille auto : `tasks/task_091.md`
- Archive session S93 : `memory/historique/2026-05-03_session_93_hermes_v012_p1_p2_tts_pause.md`

## Sources web (S93)

- [QwenLM/Qwen3.6 GitHub](https://github.com/QwenLM/Qwen3.6)
- [Qwen3.6-35B-A3B HuggingFace](https://huggingface.co/Qwen/Qwen3.6-35B-A3B)
- [batiai/qwen3.6-27b Ollama](https://ollama.com/batiai/qwen3.6-27b)
- [Qwen3.6 Unsloth](https://unsloth.ai/docs/models/qwen3.6)
