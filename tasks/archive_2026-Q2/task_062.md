---
id: 62
title: "Surveiller la consommation OpenRouter directement dans Home Assistant + fixer..."
status: done
priority: P2
session_opened: S50
session_closed: S55
tags: [hermes, gmail, email, openrouter, mode-reactif, dashboard, lovelace]
source: "Session 50 / Demande Mickael après refonte vue Réseaux"
---

# T#62 — Surveiller la consommation OpenRouter directement dans Home Assistant + fixer...

## Description

**[NOUVELLE session 50 — monitoring conso OpenRouter sur HA + cap budgétaire]** Surveiller la consommation OpenRouter directement dans Home Assistant + fixer une limite dure pour éviter les dérives. **Contexte** : OpenRouter retenu S36 pour Hermes Agent Phase 1bis-c (pay-as-you-go ~5-10 $/mois pour GPT/Gemini/DeepSeek/Claude via Hermès). Phase 1bis-c FAIT S48, donc dès que la clé API OpenRouter sera créée par Mickael (Règle 0 : saisie manuelle), il faudra un monitoring + safety net. **Demande Mickael S50** : (1) afficher la conso OpenRouter dans HA (carte Lovelace dédiée), (2) fixer une limite € ou tokens. **Étapes** : **(a) rest sensor HA** — endpoint `https://openrouter.ai/api/v1/auth/key` (retourne `data.usage`, `data.limit`, `data.is_free_tier`) + endpoint alternatif `/api/v1/credits` (crédit restant). Config `configuration.yaml` ou packages : `rest:` avec `authentication: bearer` + `headers: Authorization: Bearer !secret openrouter_api_key` + `scan_interval: 600` (10 min). 3 sensors à exposer : `sensor.openrouter_credits_remaining` ($), `sensor.openrouter_usage_total_tokens` (cumul), `sensor.openrouter_limit_total_dollars` (limite fixée). Clé API stockée dans `secrets.yaml` (Mickael saisit lui-même, Règle 0). **(b) Lovelace** — carte tile `Crédit OpenRouter` avec valeur en $ + jauge + couleur conditionnelle (vert > 50%, orange 20-50%, rouge < 20%) + mini history-graph 7j pour pics. Vue cible : à discuter (vue **Système** existante index 7, ou nouvelle vue `LLM / IA`, ou compléter la vue **Réseaux** refondue S50). **(c) Limite côté OpenRouter** — dashboard openrouter.ai → Settings → Credits → fixer un montant max (ex: 10$ total). Créer 2 clés API séparées (défense en profondeur) : `hermes-prod` (10$/mois cap) et `hermes-test` (2$/mois cap). Quand quota atteint, OpenRouter retourne HTTP 402 Payment Required → Hermès doit gérer le fallback (basculer sur Ollama local Qwen 3 32B Q4 / Llama 3.1 8B / DeepSeek-R1 14B / mistral-nemo:12b — déjà installés S47-S48). **(d) Alerte HA** — automation : si `sensor.openrouter_credits_remaining` < 1$ → notification persistante + email via `notify.might57290_gmail_com` (rappel `data.target` obligatoire bug S27). Cohérence Mode Réactif Jarvis (pattern `[JARVIS-ALERT]` déjà rodé S22+). **Pré-requis** : (1) clé API OpenRouter créée par Mickael (Règle 0, saisie manuelle, stockage 1Password), (2) Hermes Agent opérationnel (Phase 1bis-c ✅ S48), (3) test curl depuis sandbox WSL2 ou HA Terminal pour valider connectivité OpenRouter avant config sensor. **Durée estimée** : ~45 min (15 min rest sensor + secrets + reload HA, 10 min carte Lovelace, 5 min limite côté OpenRouter dashboard, 15 min automation + test alerte). **Bonus** : exposer aussi `sensor.openrouter_models_available` pour visualiser les modèles dispo (catalogue 300+ modèles). **À investiguer côté HACS** : custom_component communautaire `openrouter-ha` ou similaire (peut éviter de coder le rest sensor manuellement) — recherche HACS à faire en début de tâche. **Référence connexe** : tâche #58 Phase 1bis (Hermes Agent), tâche #60 durcissement auth (compatible logique 2 clés API séparées). **PARTIELLEMENT FAIT S55 (26/04/2026, ~1h)** — volet (c) `Limite côté OpenRouter` bouclé : compte `might57290@gmail.com` créé + email vérifié + dépôt $20 USD en mode `Use one-time payment methods` (carte non sauvegardée, auto top-up natif neutralisé) + clé API `Hermes-Jarvis` créée avec `Credit limit=5 USD` `Reset=Monthly` `Expiration=Never`. Préfixe clé `sk-or-v1-148...1a1`. Test endpoint `/auth/key` : `limit=5`, `limit_remaining=5`, `usage=0`, `is_free_tier=false`. Clé injectée dans `~/.hermes/.env` côté WSL2 via pattern `read -s` (jamais révélée à Jarvis), permissions 600 préservées. Backups `.env.bak-20260426-112157` + `.env.bak-20260426-112233`. **Reliquat T#62** : volets (a) rest sensor HA + (b) Lovelace + (d) automation alerte. Voir archive `memory/historique/2026-04-26_session_55_openrouter_setup_garde_fous.md` + auto-memory `reference_openrouter_setup_garde_fous`.

## Source / Échéance

Session 50 / Demande Mickael après refonte vue Réseaux

## Statut

**PARTIEL S55** — volet (c) cap budgétaire FAIT ; reste volets (a)+(b)+(d) intégration HA
