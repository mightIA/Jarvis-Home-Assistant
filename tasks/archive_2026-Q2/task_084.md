---
id: 84
title: "Vérifier puis supprimer .claude/hooks.json annoté OBSOLETE S74"
status: done
priority: P3
session_opened: S76
session_closed: S77
tags: [hooks, cleanup]
source: "Session S76 / Demande Mickael (2026-04-29)"
---

# T#84 — Vérifier puis supprimer .claude/hooks.json annoté OBSOLETE S74

## Description

Vérifier que `.claude/hooks.json` (annoté OBSOLETE en S74) est bien
remplacé par `.claude/settings.json` (config hooks officielle Claude Code),
puis supprimer le fichier obsolète.

## Source / Échéance

Session S76 / Demande Mickael (2026-04-29)

## Statut

Fait S77 (29/04/2026) — **résolution naturelle, aucune suppression
nécessaire** :
- `.claude/hooks.json` **déjà absent** sur le filesystem (vérifié
  `ls .claude/` → présents : `jarvis-config.json`, `settings.json`,
  `settings.local.json`).
- `.claude/settings.json` (394 octets, 28/04 19:26) bien en place comme
  remplaçant officiel.
- Fichier probablement supprimé entre S74 et S77 lors d'un ménage non
  documenté ou via le hook `check-secrets.sh` lui-même.
- Aucune validation explicite Mickael nécessaire : il n'y avait rien à
  supprimer.
