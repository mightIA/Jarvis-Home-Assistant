---
title: ADR-004 — Mammouth AI comme abonnement complémentaire
created: 2026-04-27
updated: 2026-04-27
tags: [adr, rejected, llm, abonnement]
status: rejected
session_origine: S36
---

# ADR-004 — Mammouth AI comme 2e abonnement LLM ~20 €/mois

## Contexte

Phase 1 étude Hermès Agent (S36) : Mickael envisage un 2e abonnement LLM ~20 €/mois pour compléter Claude Max. Mammouth AI envisagé en première intention (acteur français RGPD-friendly, multi-modèles agrégés via UI web, prix flat ~10-12 €/mois). Question Q4 explicite à Jarvis : "Mammouth AI vs OpenRouter, est-ce qu'OpenRouter apporte un plus ?".

## Décision

**REJETÉE** le 24/04/2026 (S36).

## Raison du rejet

Mammouth AI ne propose **pas d'API publique** — uniquement une UI web pour usage humain. Conséquence directe : **inutilisable comme backend Hermès Agent** (qui pilote des modèles via API REST, pas via interface web). Comparatif synthétique :

| Critère | Mammouth AI | OpenRouter |
|---|---|---|
| Cible | Humain (UI chat) | Outils/agents (API REST) |
| API publique | Non | Oui (OpenAI-compatible) |
| Tarif | Flat ~10-12 €/mois | Pay-as-you-go |
| Branchable Hermès | Non | Oui (first-class provider) |
| Use case Mickael | Redondant avec claude.ai mobile | Indispensable Phase 2 |

De plus, redondance avec Claude Max (déjà socle, plan Max 5x inclut UI mobile + 200K contexte). Pas de gain net.

## Impact

- **Économie** ~10-12 €/mois (~120-145 €/an) en évitant l'abonnement.
- **Méthodologique** : règle apprise `feedback_mammouth_vs_openrouter.md` — toujours distinguer UI chat humain (Mammouth, Perplexity, Poe) vs API backend (OpenRouter) AVANT de recommander.
- **Pas de 2e abonnement flat** confirmé par décision D5-S36 (redondance injustifiée avec Claude Max).

## Alternative retenue

OpenRouter en pay-as-you-go (compte créé S55, clé `Hermes-Jarvis` capée $5/mois Monthly, dépôt $20 one-time, CB non sauvegardée). Voir auto-memory `reference_openrouter_setup_garde_fous.md`.

## Source

- `memory/historique/2026-04-24_session_36_etude_llm_wiki_hermes_agent.md` (Phase J + D5-S36)
- Auto-memory `reference_llm_subscriptions_comparison.md`
- Auto-memory `feedback_mammouth_vs_openrouter.md`
