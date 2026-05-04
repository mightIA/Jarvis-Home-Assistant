---
id: 19
title: "Mettre en place un sous-domaine Cloudflare Tunnel (ex"
status: cancelled
priority: P2
session_opened: S10
session_closed: S83
tags: [cloudflare]
source: "Session 10 / Contournement blocage Claude in Chrome IPs privees"
---

# T#19 — Mettre en place un sous-domaine Cloudflare Tunnel (ex

## Description

**[NOUVELLE]** Mettre en place un sous-domaine Cloudflare Tunnel (ex. `admin.might.ovh`) exposant `/hassio/*` pour permettre a Jarvis de debannir sans assistance humaine

## Source / Échéance

Session 10 / Contournement blocage Claude in Chrome IPs privees

## Statut

❌ `cancelled` S83 (01/05/2026) — motivation initiale (contourner blocage RFC1918 Claude in Chrome pour débannir) résolue par évolution architecture : MCP HA via `mcp.might.ovh` (S70) + sub-agent CLI `debannissement-ip` (S73) qui utilisent `ha_call_service` / `ha_restart` directement, sans besoin de naviguer la page web `/hassio/ip_bans`. URL publique `ha.might.ovh` reste accessible à Claude in Chrome si nav web nécessaire en fallback. Création d'un sous-domaine `admin.might.ovh` dédié plus nécessaire en l'état.
