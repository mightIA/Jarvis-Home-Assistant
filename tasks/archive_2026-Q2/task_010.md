---
id: 10
title: "Ajouter un CSP via Cloudflare (mode report-only d'abord)"
status: done
priority: P2
session_closed: S20
tags: [cloudflare, security]
source: "Audit secu — 10 min"
---

# T#10 — Ajouter un CSP via Cloudflare (mode report-only d'abord)

## Description

Ajouter un CSP via Cloudflare (mode report-only d'abord)

## Source / Échéance

Audit secu — 10 min

## Statut

**Phase 1 FAIT (session 20, 20/04/2026)** — règle Transform Response Header `CSP-Report-Only-HA` déployée sur `might.ovh` (filtre `http.host eq "ha.might.ovh"`). Header `Content-Security-Policy-Report-Only` confirmé via fetch JS sur `/manifest.json`. Politique permissive de démarrage : `default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data: blob: https:; connect-src 'self' wss://ha.might.ovh https://ha.might.ovh; font-src 'self' data:; frame-ancestors 'self'`. **Phase 2** : collecte 1-2 semaines (Mickael navigue normalement, violations visibles en F12 Console), puis affiner. **Phase 3** : basculer sur `Content-Security-Policy` (actif).
