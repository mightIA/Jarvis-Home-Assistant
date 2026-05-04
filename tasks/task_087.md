---
id: 87
title: "Tester MCP Cloudflare officiel (couverture Zero Trust / Tunnel / DNS)"
status: open
priority: P3
session_opened: S84
tags: [cloudflare, mcp, security, zero-trust]
source: "Session 84 / Audit T#49 — alternative workflow Brave dashboard CF"
---

# T#87 — Tester MCP Cloudflare officiel

## Description

Issu de l'audit T#49 (S84). Le MCP officiel Cloudflare existe sur le registry :
`bindings.mcp.cloudflare.com` — 24+ outils (accounts, KV, Workers, R2…).

Objectif : valider sa couverture sur les workflows Cloudflare actuels de Jarvis,
qui passent aujourd'hui par **Brave + Claude in Chrome** (skill `cloudflare-access-ha`).

## Périmètre à tester

Workflows actuels de la skill `cloudflare-access-ha` qui pourraient bénéficier du MCP :

1. **CF Access (Zero Trust)** — gestion policies, applications protégées, identity providers.
   - Aujourd'hui : dashboard CF via Brave + screenshots + clic.
   - À tester : outils MCP `access_*` ou équivalent.

2. **Cloudflare Tunnel (cloudflared)** — config tunnels, hostnames publics, ingress rules.
   - Aujourd'hui : dashboard CF via Brave (Networks → Tunnels).
   - À tester : outils MCP `tunnel_*` ou équivalent.

3. **DNS records** — modif CNAME, A records, TXT (HSTS, CAA).
   - Aujourd'hui : dashboard CF via Brave.
   - À tester : outils MCP `dns_*` (probable, MCP Cloudflare = orienté API REST).

## Méthode

1. **Pre-check** : lister les 24 outils du MCP via `mcp__mcp-registry__suggest_connectors`
   sans encore connecter, pour vérifier le périmètre.
2. Si CF Access / Tunnel couverts → connecter le MCP en mode Cowork, tester sur 1
   action lecture-seule (ex : `access_apps_list` sur `ha.might.ovh`).
3. Si concluant → mettre à jour skill `cloudflare-access-ha` (ajouter section
   « Méthode 2 — MCP Cloudflare » à côté de la méthode Brave).
4. Si non concluant (pas de couverture Zero Trust) → documenter dans
   `memory/reference_audit_workflows_brave_mcp_s84.md` et garder Brave par défaut.

## Bénéfice attendu

- Gain tokens estimé ~5-10× sur opérations config CF (vs screenshots dashboard 4K).
- Possibilité d'automatiser audits posture sécurité CF (sub-agent dédié envisageable
  à très long terme).

## Risques

- **Tokens API Cloudflare** : nécessite création d'un API token CF avec scope minimal
  (lecture Zone:Read + Access:Read pour démarrer).
- **Règle 0 (CLAUDE.md)** : token CF = donnée sensible, validation explicite Mickael
  obligatoire avant accès / stockage.

## Source / Échéance

Session 84 / Audit T#49 — pas urgent. À déclencher si nouveau besoin config CF
(rotation cert, ajout tunnel, modif policy Access).

## Statut

🟢 `open` — P3, pas bloquant.
