---
id: 4
title: "Miniature derniere photo (cellule camera) — sans cache"
status: cancelled
priority: P1
session_opened: S1
session_closed: S82
tags: [camera]
source: "Historique session 1"
---

# T#4 — Miniature derniere photo (cellule camera) — sans cache

## Description

Miniature derniere photo (cellule camera) — sans cache

## Source / Échéance

Historique session 1

## Statut

**Annulée S82 (01/05/2026)** — Mickael abandonne l'idée. Tentative S82 :
sensors `command_line` + caméras `local_file` + automations MAJ file_path.
Bloqueurs : (1) intégration `local_file` dépréciée en YAML depuis HA 2024.x
(passage obligatoire en config flow UI), (2) refus création UI sur path
placeholder inexistant, (3) chaîne globale jugée trop complexe par Mickael
pour le bénéfice. Rollback config.yaml fait dans la même session.
