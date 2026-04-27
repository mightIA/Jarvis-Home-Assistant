---
title: ADR-003 — Llama 3.3 70B Q3 en principal Hermès
created: 2026-04-27
tags: [adr, rejected, hermes, ollama, llm]
status: rejected
session_origine: S58
---

# ADR-003 — `llama3.3:70b-instruct-q3_K_M` comme moteur principal Hermès Agent

## Contexte

Phase B Hermès étape 2 : après KO `mistral-nemo:12b` (voir [[ADR-002-mistral-nemo-principal]]), test du second candidat `llama3.3:70b-instruct-q3_K_M` (34 Go, quantisation Q3_K_M pour tenir en VRAM 24 Go avec offload). Modelfile durci identique à mistral-nemo-agent pour comparatif équitable. Pré-requis : augmentation RAM WSL2 via `.wslconfig` (28 Go) car défaut Microsoft 50% des 32 Go = 15 Gi seulement, insuffisant pour 20.2 GiB demandés par Ollama.

## Décision

**REJETÉE** le 26/04/2026 (S58).

## Raison du rejet

Test scénario S58.2.5 (notification HA identique S57) : **double échec sévère**.
1. **Tool call émis en *content*** (texte JSON brut) au lieu d'un appel structuré reconnu par Hermès — famille bug Ollama #11662, cette fois sur Llama 3.3.
2. **JSON malformé** : mélange `name: mcp_ha_mcp_ha_call_write_tool` + `service: ha_search_tools` (deux outils confondus), n'aurait pas marché même avec extraction.
3. **Narration explicite** ("Pour la recherche de tools, la commande est :") qui viole la règle 1 du SYSTEM.
4. **Latence catastrophique** : 10 m 52 s pour 80 tokens (~0.12 tok/s effectif), inutilisable pour Mode Réactif.

Vérification HA : aucun script ni notification créée. Confirme bug tool calling pur. Audit S60 confirme : Q3 hors recommandation Hermès (Q4_K_M préconisé) + offload CPU obligatoire à 24 Go VRAM. Hardware upgrade T#73 ne résout pas (RTX 3090 → carte 48 Go ne change pas le tool calling cassé du modèle).

## Impact

- **Verdict Phase B étape 2 KO** documenté.
- **Side effect positif** : pattern `.wslconfig 28GB swap=8GB` capitalisé en auto-memory (`reference_wslconfig_28gb_pattern.md`), réutilisable pour tout futur modèle 70B Q3+.
- **Hardware upgrade T#73 (2 410 €)** : verdict initial NO-GO renforcé (Llama 3.3 70B Q3 inutilisable même avec hardware étendu).

## Alternative retenue

Phase B étape 3 Haiku 4.5 OpenRouter (S60) puis voie qwen3.5:27b Q5 + fix `reasoning_content` Hermès validé Cookbook S57-S63. Voir [[ADR-A003-rtx3090-suffisant-hermes]].

## Source

- `memory/historique/2026-04-26_session_58_phase_b_etapes_1_2.md`
- Auto-memory `feedback_llama3_3_70b_q3_inutilisable.md`
- Auto-memory `reference_wslconfig_28gb_pattern.md`
