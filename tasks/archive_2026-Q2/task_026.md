---
id: 26
title: "Exposer l'add-on ha-mcp (port 9583) en HTTPS publique pour Cowork"
status: done
priority: P2
session_opened: S15
session_closed: S16
tags: [ha-mcp, cloudflare, mcp, cowork]
source: "Session 15 — install ha-mcp v7.3.0 OK Phase 1+2"
---

# T#26 — Exposer l'add-on ha-mcp (port 9583) en HTTPS publique pour Cowork

## Description

**[PRIORITE — nee session 15]** Exposer l'add-on ha-mcp (port 9583) en HTTPS publique pour Cowork. Options : (A) Cloudflare Tunnel via add-on `Cloudflared` existant — ajouter public hostname `mcp.might.ovh` -> `192.168.1.11:9583` sans CF Access (secret path fait auth) ; (B) NGINX HA SSL proxy avec path `/mcp-addon` sur `ha.might.ovh` + 4eme destination bypass CF. Option A preferee (plus propre).

## Source / Échéance

Session 15 — install ha-mcp v7.3.0 OK Phase 1+2

## Statut

**FAIT (session 16, 19/04/2026)** — Option A validee : additional_hosts dans add-on Cloudflared + CNAME manuel `mcp.might.ovh -> e37fbcdc-7943-4bdc-9990-36cce788fe20.cfargotunnel.com` + stop+start add-on. URL publique `https://mcp.might.ovh/private_[REDACTED-OLD-SECRET-S70]` operationnelle (reponse `HA-MCP server is up and running!`). Apprentissages : tunnel local non-migrable CF, additional_hosts = CNAME manuel obligatoire, stop+start > restart, piege trailing slash. Skills MAJ.
