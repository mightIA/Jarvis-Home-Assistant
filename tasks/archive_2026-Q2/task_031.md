---
id: 31
title: "Activer/tester **Claude Code Remote** (feature doc Claude Code"
status: done
priority: P2
session_opened: S17
session_closed: S19
tags: [mcp]
source: "Session 17 / Plan mobilite"
---

# T#31 — Activer/tester **Claude Code Remote** (feature doc Claude Code

## Description

**[NOUVELLE session 17 — mobilite]** Activer/tester **Claude Code Remote** (feature doc Claude Code : "Continue a local session from my phone or another device"). But : depuis iPhone en déplacement, reprendre la main sur la session Claude Code qui tourne sur le PC allumé 24/24. Accès complet au dossier Jarvis + MCP + PowerShell. Vérifier conditions (même compte Anthropic, réseau local vs distant, tunnel éventuel).

## Source / Échéance

Session 17 / Plan mobilite

## Statut

**FAIT (session 19, 20/04/2026)** — Claude Code Remote active sur PC via `/remote-control` (CLI 2.1.114). Test en conditions reelles iPhone 5G (WiFi OFF, cellular only) : commande "liste fichiers Jarvis + version Claude Code" executee sur le PC et reponse recue cote iPhone. Feature officielle Anthropic du 24/02/2026 (session reste 100% locale sur PC, sync via claude.ai, aucun code cloud).
