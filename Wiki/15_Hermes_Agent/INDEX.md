---
title: Hermes Agent — Index domaine (MOC)
created: 2026-04-27
migrated_from: (synthèse Projets/Jarvis_Hermes_Projet/ + auto-memories Cowork)
type: moc
domaine: Hermes_Agent
status: phase-1bis-d-en-cours
phase_actuelle: 1bis-d β1
bloqueur_principal: ecriture-HA-bug-empty-after-tool-calls (resolu S63)
verdict_courant: qwen35-agent V1 valide 3/3 scenarios
tags: [hermes, agent, nous-research, ollama, mcp, ha, moc, index]
---

# Hermès Agent — Map of Content

Domaine de l'**orchestrateur multi-LLM** Hermes Agent (Nous Research, MIT, sortie 02/2026), positionné dans le projet Jarvis comme **co-cerveau local** complémentaire à Claude / Cowork.

## Verdict une ligne (S63 27/04/2026)

**Hermès Agent + Ollama + RTX 3090 24 Go suffit pour le Mode Réactif** (1 alerte/jour, latence acceptable 60 s à 5 min). Validé sur 3 scénarios variés via le modèle `qwen35-agent` V1 post `hermes update`. **NO-GO confirmé** sur upgrade hardware urgent (~2 410 €). **Bascule cloud LLM Haiku 4.5 annulée** — local viable, OpenRouter reste exception ~5 %.

## Documents du domaine

| Document | Sujet | Statut |
|---|---|---|
| [`01_Rapport_Phase1.md`](01_Rapport_Phase1.md) | Vision projet S36 — pattern LLM Wiki Karpathy + découverte Hermès | stable, daté 24/04/2026 |
| [`02_Plan_Phase1bis.md`](02_Plan_Phase1bis.md) | Phasage A→G + détail des 4 phases (1, 1bis, 2, 3) | stable |
| [`03_Decision_Q1-Q8.md`](03_Decision_Q1-Q8.md) | 4 points de décision Mickael (Ch.6.3 source) | en attente Mickael |
| [`Cookbook_RTX3090/`](Cookbook_RTX3090/_Index.md) | Cookbook public GitHub MIT — RTX 3090 + Hermès + ha-mcp | publié S64 |

## Stack validée (S63)

| Composant | Version / Modèle | Note |
|---|---|---|
| GPU | NVIDIA RTX 3090 24 Go | Offload CPU 20 / 80 nécessaire pour 27B Q5 + ctx 65 k |
| Hermes Agent | v0.11.0 commit ≥ `087e74d4` (post 26/04/2026) | Inclut le fix critique `reasoning_content` |
| Ollama | dernière version stable | `ollama serve` actif dans WSL2 |
| Modèle principal | `qwen3.5:27b` (Q5_K_M) + Modelfile durci `num_ctx 65536` | Validé sur 3 scénarios variés |
| MCP HA | add-on `homeassistant-ai/ha-mcp` v7.3.0+ | `enable_tool_search: false` (87 outils en clair) |
| OS | Windows 11 Pro + WSL2 Ubuntu 24.04 LTS | `.wslconfig` 28 GB pour 70B Q3 si besoin |

## Phasage Phase 1bis (selon plan source S36)

| Phase | Statut | Session |
|---|---|---|
| **1bis-a** Obsidian vault setup | ✅ FAIT | S41 |
| **1bis-b** Mistral Doc AI test | ✅ CLÔTURÉE | S46 |
| **1bis-c** Hermes Agent install | ✅ CLÔTURÉE 100 % | S48 |
| **1bis-d β1** `enable_tool_search` ON | ✅ ON côté add-on, KO côté écriture | S53 |
| **1bis-d** retest post `hermes update` | ✅ VALIDÉ V1 3/3 | S63 |

## Latences mesurées (S63 post-update)

| Scénario | Tool calls | Latence | Sémantique |
|---|---|---|---|
| Action simple (`create notification`) | 1 | **5 m 06 s** | OK direct |
| Lecture multi-sensors + comparaison | 1 | **2 m 40 s** | Excellent |
| Multi-step (lecture → condition → action) | 2 | **2 m 57 s** | Parfait |

Comparatif S62 V1 vs S63 (config strictement identique sauf `hermes update`) : **−75 % de latence** sans aucune modif Modelfile / config / hardware.

## Auto-memories Cowork liées (à charger en début de conv Hermès)

```text
memory/reference_hermes_agent.md                       ← fiche technique produit
memory/reference_modelfile_qwen3_durci.md              ← Modelfile validé S57+S63
memory/reference_qwen35_agent_v1_postupdate_validated.md ← verdict V1 S63
memory/reference_hermes_update_fix_reasoning_content.md ← détail 4 commits fix
memory/reference_pattern_audit_methodologique_2.md     ← méthodo niveau 2
memory/feedback_audit_communautaire_avant_verdict.md   ← méthodo niveau 1
memory/feedback_kv_cache_27b_calcul_vram.md            ← règle calcul VRAM
memory/reference_wslconfig_28gb_pattern.md             ← pattern .wslconfig 28 GB
memory/reference_hermes_provider_openrouter_correct.md ← convention OpenRouter
memory/reference_openrouter_setup_garde_fous.md        ← clé Hermes-Jarvis $5/mois
```

## Liens transverses

- [PC MIGHT-1000D](../10_Domaines/Hardware/PC_MIGHT-1000D.md) — RTX 3090 utilisée par Hermès local
- [Hardware_Upgrade (projet)](../20_Projets/Hardware_Upgrade/README.md) — projet T#73, Phase A bloque sur Hermès
- [08_Audit_S63 (vault)](../20_Projets/Hardware_Upgrade/08_Audit_S63_et_re_evaluation_hardware.md) — ré-évaluation post-S63

## Bloqueurs et points ouverts

- **T#11** — décision Mickael sur 3 patterns sensibles (secret_path ha-mcp, etc.)
- **T#76** — retest 4 modèles antérieurs avec Hermès post-update
- **T#77** — Hermes 4 70B HuggingFace bonus comparatif

## Source de référence

`Projets/Jarvis_Hermes_Projet/` :
- `Projet_Complet.md` (~598 lignes, 24/04/2026, S36) — copie complète dans `01_Rapport_Phase1.md`
- `Rapport_Phase1.md` (~503 lignes) — étude LLM Wiki Karpathy
- `Projet_Complet.pdf` + `Projet_Complet_v2.pdf` — versions PDF générées
