---
title: Modeles LLM a tester
created: 2026-04-27
tags: [veille, llm, modeles, rtx3090]
status: actif
---

# Modeles LLM a tester

Liste des modeles LLM a tester (ou retester) quand une nouvelle version
sort, avec quantization viable RTX 3090 24 GB. Mise a jour mensuelle ou
sur signalement Mickael.

## Contexte hardware

- GPU : NVIDIA RTX 3090 24 GB
- CPU : Intel i9-9900K (8 cores / 16 threads)
- RAM : 32 GB DDR4 (28 GB alloues WSL2 via `.wslconfig`)
- WSL2 Ubuntu + Ollama + Hermes Agent

Reference VRAM : voir Cookbook section `configs.md` §6 (tableau VRAM <->
num_ctx <-> KV cache).

## Tableau de suivi

| Modele | Taille | Quantization viable RTX 3090 | Use case | Statut |
|---|---|---|---|---|
| **Hermes 4 70B** | 70B | Q3 (offload CPU) ou Q2 (degrade) | Agent principal qualite max | A SORTIR Q2-Q3 2026 (Nous Research) |
| **Hermes 4 14B** | 14B | Q5_K_M (rentre VRAM pure) | Agent principal compact | A SORTIR Q2-Q3 2026 (Nous Research) |
| **qwen3.5:27b** | 27B | Q5_K_M (~17 GB poids + KV) | Agent principal **VALIDE S62-S63** | OK post-`hermes update`. Latence 2m40s a 5m06s. |
| **qwen3.5:14b** | 14B | Q5_K_M ou Q6 | Agent compact / fallback | A TESTER (pattern qwen3.5 valide sur 27B) |
| **qwen3.5:32b** (futur Q4 release) | 32B | Q4_K_M | Agent qualite | A SURVEILLER releases Qwen |
| **DeepSeek-R1 14B** | 14B | Q5 (~10 GB) | Reasoning + agent | A TESTER. Note : DeepSeek-R1 ne supporte pas tool calling Ollama (HTTP 400 connu) — verifier upstream. |
| **DeepSeek-R2** (a venir) | ? | ? | Reasoning gen 2 | A SURVEILLER repo DeepSeek-AI |
| **Llama 3.5** (a venir) | 8B / 70B | Q4 / Q3 offload | Agent generaliste | A SURVEILLER releases Meta |
| **Llama 3.3 70B Q3_K_M** | 70B | Q3 (offload CPU obligatoire) | KO actuel | KO S58 (JSON dans content + 10m52s/tour). Hardware upgrade ne resout pas (template Ollama casse). Retest si fix Ollama Llama tool calling. |
| **mistral-small:3** (futur) | 22-24B | Q5 | Agent compact | A SURVEILLER releases Mistral |
| **mistral-nemo:12b** | 12B | Q4 (~7 GB) | KO en principal | KO S58 (template chat casse, inversion de role). OK comme `auxiliary.compression.model`. Retest si fix Ollama #6713 ou template. |
| **qwen2.5-coder:32b** | 32B | Q4-Q5 | Agent code + actions | A TESTER (recommande Hermes officiellement — rate S60). |
| **qwen2.5:32b** | 32B | Q5 | Agent generaliste recommande Hermes | A TESTER (installe depuis S47/S48 jamais teste en moteur principal) |
| **gpt-oss:20b** | 20B | Q5 | Agent leger | A TESTER si OpenAI publie poids |
| **kimi-k2** (Moonshot) | varies | Q4-Q5 | Reasoning + agent | A SURVEILLER, supporte par Hermes |

## Modeles ELIMINES (definitivement, sauf nouvelle info)

- `llama3.1:8b` Q4 — submersion catalogue MCP (>50 outils), hallucinations
  (cf. Cookbook Symptome 7). Mitigation `enable_tool_search: true` testable
  mais peu prometteuse.

## Procedure de test d'un nouveau modele

1. Verifier `hermes update` recent.
2. `ollama pull <modele>:<tag>` puis `ollama show <modele>` pour le template
   chat et les capabilities tool calling.
3. Test discriminant SYSTEM : `qui es-tu en une phrase ?` (cf. Cookbook
   Symptome 3 — verification template chat OK).
4. Modelfile minimal d'abord (cf. `configs.md` §1), Modelfile durci en
   fallback si bug `<think>` ou `has_reasoning guard` reapparait.
5. Scenario test action HA simple (notification persistante via ha-mcp).
6. Scenario test multi-step (lecture capteur + condition + ecriture).
7. Comparer latence + precision semantique au baseline qwen3.5:27b Q5.

## Roadmap testing prioritaire

1. **qwen2.5:32b** + **qwen2.5-coder:32b** — recommandes Hermes, jamais
   testes en moteur principal (erreur S48-S60).
2. **qwen3.5:14b** — version compacte du modele valide S62.
3. **Hermes 4** des sa sortie — modele "natif" Nous Research, optimise
   pour Hermes Agent.
4. **DeepSeek-R1 14B** — verifier statut tool calling Ollama avant test.

## Sources

- Cookbook RTX 3090 — `Projets/Cookbook_Hermes_RTX3090/docs/configs.md`
- Cookbook RTX 3090 — `Projets/Cookbook_Hermes_RTX3090/docs/journey-s57-s63.md`
- Auto-memory `reference_modelfile_qwen3_durci.md`
- Auto-memory `feedback_audit_communautaire_avant_verdict.md`
- Sessions S36, S57, S58, S60, S62, S63 (memory/historique/)

## Liens internes

- [[_Index]] — Hub Veille
- [[Issues_GitHub_A_Suivre]]
- [[Landscape_LLM_2026]]
- [[Provider_Benchmarks]]
