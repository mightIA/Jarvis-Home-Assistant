---
title: ADR-007 — Plugin Smart Connections Obsidian payant
created: 2026-04-27
updated: 2026-04-27
tags: [adr, rejected, obsidian, plugin, vectorisation]
status: rejected
session_origine: S38
---

# ADR-007 — Plugin de vectorisation propriétaire Obsidian (Smart Connections / payant)

## Contexte

Phase 1bis Hermès Agent (S38) : vidéo ParlonsIA (`owyUIFwULWg`) recommande le plugin de vectorisation propriétaire Obsidian (payant) pour atteindre une "vraie" recherche sémantique au-delà du `[[wikilink]]` regex natif. Le créateur va même jusqu'à suggérer (sans preuve) que Karpathy aurait fait un coup marketing pour pousser ce plugin payant. Question implicite : doit-on inclure ce plugin dans la stack Phase 1bis-a (vault Obsidian) ?

## Décision

**REJETÉE** le 25/04/2026 (S38), réaffirmée S41 (D3-S41).

## Raison du rejet

Triple raison :
1. **Plugin payant** — viole la règle générale "pas de plugin payant" (D4-S38, confirmée D3-S41).
2. **Stack S36 fait déjà mieux gratuitement** : Hermès Agent + Qwen 3 Embedding 4B/8B local sur RTX 3090 (Phase 1bis-c) couvre BM25 + embeddings + reranking nativement. Tourne sur 6 Go VRAM (RTX 3090 large).
3. **Spéculation marketing Karpathy non fondée** — pas de lien public entre Karpathy et l'éditeur Obsidian. Le plugin payant existe, mais le pattern LLM Wiki Karpathy fonctionne sans (regex `[[wikilink]]` + structure PARA + `index.md` + `log.md` suffisent pour <100 articles ; au-delà, sub-agents Claude Code + vectorisation locale via Hermès prennent le relais).

De plus, la solution finale du créateur de la vidéo (sub-agents `context fork` + base vectorielle locale BM25 + Qwen 3 Embedding + reranking) est **un sous-ensemble exact de notre stack S36** déjà décidée. Pas de valeur ajoutée du plugin payant pour notre cas d'usage.

## Impact

- **Économie** ~10 $/mois récurrents si le plugin avait été pris (~120 $/an).
- **Indépendance fournisseur** : pas de dépendance à un éditeur tiers pour la couche sémantique du vault.
- **Cohérence stack** : Hermès Agent reste l'unique point d'orchestration LLM (principe affirmé S36).

## Alternative retenue

4 plugins gratuits installés S41 (Dataview, Templater, Excalidraw, Git). Vectorisation différée en Phase 1bis-c (Hermès Agent + Ollama RTX 3090 + Qwen 3 Embedding 4B). Voir [[ADR-A001-vault-obsidian-sandbox]].

## Source

- `memory/historique/2026-04-25_session_38_phase1bis_sous_etapes.md`
- `memory/historique/2026-04-25_session_41_phase1bisa_obsidian.md` (D3-S41)
- Vidéo référencée : YouTube `owyUIFwULWg` (ParlonsIA / @iaexpliquee)
