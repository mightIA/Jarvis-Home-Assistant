---
title: Cookbook Hermes Agent + RTX 3090 — Index (MOC)
created: 2026-04-27
migrated_from: Projets/Cookbook_Hermes_RTX3090/ (racine du projet, pas un fichier source unique)
status: stable
applicabilite: hardware-upgrade-phase-A
gpu_requirement: RTX3090-24GB
verdict: gpu-suffisant
tags: [hermes, cookbook, rtx3090, ollama, ha-mcp, moc, index]
---

# Cookbook Hermes Agent + RTX 3090 — Index

Map of Content (MOC) du cookbook complet, migré depuis `Projets/Cookbook_Hermes_RTX3090/` en S68 (27/04/2026).

Le cookbook est par ailleurs **publié en repo public GitHub** : [`mightIA/hermes-agent-rtx3090-cookbook`](https://github.com/mightIA/hermes-agent-rtx3090-cookbook) (License MIT, commit racine `de7e268` du 26/04/2026 + commit `bc58b15` S65 ajoutant la procédure de publication).

## Verdict une ligne

**RTX 3090 24 GB suffit pour Hermes Agent + Ollama + MCP Home Assistant en mode Mode Réactif** après `hermes update` (4 commits critiques `reasoning_content`). NO-GO sur upgrade hardware ~2400 € confirmé en S63.

## Statut session

| Indicateur | Valeur |
|---|---|
| Modèle principal validé | `qwen3.5:27b` Q5 + Modelfile durci `num_ctx 65536` |
| Latence Mode Réactif | 2 m 40 s à 5 m 06 s selon scénario |
| Hardware | RTX 3090 24 GB + i9-9900K + 32 GB DDR4 + WSL2 28 GB |
| Hermès | v0.11.0 commit ≥ `087e74d4` (post 26/04/2026) |
| Add-on `ha-mcp` | v7.3.0+, `enable_tool_search: false` (87 outils en clair) |

## Documents

| # | Document | Quand le lire |
|---|---|---|
| 1 | [`README.md`](README.md) | Vue d'ensemble + TL;DR + stack + latences mesurées. **Point d'entrée.** |
| 2 | [`docs/journey-s57-s63.md`](docs/journey-s57-s63.md) | Récit chronologique : 5 modèles KO, audit méthodologique 2, fix `reasoning_content`, validation. **À lire pour comprendre le fond du problème.** |
| 3 | [`docs/audit-methodologique.md`](docs/audit-methodologique.md) | Pattern réutilisable « audit niveau 2 » à appliquer dès **5+ modèles consécutifs KO**. Plan en 6 phases avec heuristique de stop. **À lire si tu rencontres une série de KO.** |
| 4 | [`docs/troubleshooting.md`](docs/troubleshooting.md) | Catalogue symptôme → cause → fix : 9 symptômes documentés (`Model returned empty`, hallucination `write_file`, latence 70B, KV cache OOM, `<think>` parasites, `mcp add` non persistant, etc.). **À lire si tu as un bug précis à résoudre.** |
| 5 | [`docs/configs.md`](docs/configs.md) | Configs reproductibles : Modelfile Qwen 3.5 durci, extrait `~/.hermes/config.yaml`, `.wslconfig` 28 GB, paramètres add-on `ha-mcp`. **À lire pour copier-coller.** |
| 6 | [`docs/publication-s64.md`](docs/publication-s64.md) | Procédure d'init repo public GitHub en 7 étapes (caviardage triple grep, garde-fous email no-reply, OAuth Browser GCM). **Reproductible pour publier d'autres cookbooks.** |

## Liens externes utiles

- Repo public : [`mightIA/hermes-agent-rtx3090-cookbook`](https://github.com/mightIA/hermes-agent-rtx3090-cookbook)
- [Hermes Agent](https://github.com/NousResearch/hermes-agent) (Nous Research, MIT, 02/2026)
- [Ollama](https://ollama.com/)
- [`homeassistant-ai/ha-mcp`](https://github.com/homeassistant-ai/ha-mcp)
- Issues Ollama tool calling : [#11662](https://github.com/ollama/ollama/issues/11662) [#14601](https://github.com/ollama/ollama/issues/14601) [#11135](https://github.com/ollama/ollama/issues/11135) [#14745](https://github.com/ollama/ollama/issues/14745) [#14617](https://github.com/ollama/ollama/issues/14617)

## Auto-memories Cowork liées

- `reference_modelfile_qwen3_durci.md` — pattern Modelfile validé S57 (réhabilité S63 post-update)
- `reference_qwen35_agent_v1_postupdate_validated.md` — verdict S63 qwen3.5:27b validé 3/3 scénarios
- `reference_hermes_update_fix_reasoning_content.md` — détail des 4 commits critiques fix S63
- `feedback_audit_communautaire_avant_verdict.md` — méthodo niveau 1
- `reference_pattern_audit_methodologique_2.md` — méthodo niveau 2 (`hermes update` priorité 1)
- `feedback_kv_cache_27b_calcul_vram.md` — règle de calcul VRAM avant pull
- `reference_wslconfig_28gb_pattern.md` — pattern `.wslconfig` 28 GB pour 70B Q3

## Mémoires projet liées

- `project_hardware_upgrade.md` — projet hardware T#73, statut Phase 0, NO-GO confirmé S63
- `project_phase1bisd_b1_resultats.md` — Phase 1bis-d β1 enable_tool_search S53

## Documents projet liés (vault)

- [Hardware_Upgrade — README](../../20_Projets/Hardware_Upgrade/README.md) — projet hardware T#73
- [08_Audit_S63_et_re_evaluation_hardware](../../20_Projets/Hardware_Upgrade/08_Audit_S63_et_re_evaluation_hardware.md) — ré-évaluation post-S63
