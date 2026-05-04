---
id: 29
title: "Retablir `ip_ban_enabled: true` et retirer `login_attempts_threshold: -1` de ..."
status: done
priority: P2
session_opened: S15
session_closed: S18
tags: [ha-mcp, mcp]
source: "Session 15"
---

# T#29 — Retablir `ip_ban_enabled: true` et retirer `login_attempts_threshold: -1` de ...

## Description

**[NOUVELLE session 15]** Retablir `ip_ban_enabled: true` et retirer `login_attempts_threshold: -1` de `configuration.yaml` section `http:` apres validation #27 reussie. Config temporairement desactivee pendant les tests ha-mcp pour eviter les bans en boucle.

## Source / Échéance

Session 15

## Statut

**FAIT (session 18, 20/04/2026)** — `ip_ban_enabled: true` + `login_attempts_threshold: 3` (actif, seuil 3 tentatives) dans bloc `http:`. Lignes SSL laissees commentees (certif gere par CF). Check_config OK, restart HA reussi, `state: RUNNING`.
