---
id: 65
title: "La doc S48 mentionne une régénération de secret_path en `private_Q49aOxbSlqki..."
status: cancelled
priority: P2
session_opened: S53
session_closed: S83
tags: [ha-mcp, security, mcp, cowork]
source: "Session 53 / Découverte divergence"
---

# T#65 — La doc S48 mentionne une régénération de secret_path en `private_Q49aOxbSlqki...

## Description

**[NOUVELLE session 53 — décision rotation secret_path ha-mcp]** La doc S48 mentionne une régénération de secret_path en `private_Q49aOxbSlqkilVOMVrlE4g` (21 surfaces "patchées"), mais le test curl S53 prouve que cette régénération n'a jamais été appliquée côté add-on (HTTP 404 pour le nouveau, HTTP 405 pour l'ancien `private_[REDACTED-OLD-SECRET-S70]`). 2 options : **A** — Refaire la vraie rotation (suivre auto-memory `reference_ha_mcp_secret_regeneration` étape par étape, vérifier curl AVANT propagation, garder les 21 surfaces synchronisées) ; **B** — Annuler la rotation S48 dans la doc : repatcher les 21 surfaces avec l'ancien secret + ajouter un disclaimer dans CLAUDE.md "rotation S48 documentée mais non appliquée". Voir auto-memory `feedback_secret_path_s48_jamais_applique`. **Pré-requis option A** : faire d'abord tâche #63 (sinon on casse Cowork pendant la rotation). **Pré-requis option B** : grep des 21 surfaces, sed parallèle, vérification cross-références. **Durée estimée** : ~30 min option A (faisable en session) ou ~45 min option B (lourd à propager mais plus durable si on ne veut pas vraiment rotater). **Recommandation** : option A si la sécurité a une vraie valeur ajoutée immédiate (sinon on garde le secret 130 bits actuel jusqu'à #60 niveau 1 Service Token CF qui rendra le secret obsolète de toute façon).

## Source / Échéance

Session 53 / Découverte divergence

## Statut

❌ `cancelled` S83 (01/05/2026) — divergence doc/réalité S48 résolue indirectement par la **rotation effective S70** (CLAUDE.md §6) qui a établi le secret_path actuel sur lequel Cowork + Hermès tournent. T#60 niveau 1 (header CF Access via Service Token) rendra le path-token totalement obsolète à terme. Pas de valeur ajoutée à attaquer cette tâche aujourd'hui.
