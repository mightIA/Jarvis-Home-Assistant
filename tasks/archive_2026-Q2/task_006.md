---
id: 6
title: "Menu Frigate dedie (buffer 60s, clips a la demande)"
status: cancelled
priority: P2
session_closed: S82
tags: [frigate]
source: "Historique"
---

# T#6 — Menu Frigate dedie (buffer 60s, clips a la demande)

## Description

Menu Frigate dedie (buffer 60s, clips a la demande)

## Source / Échéance

Historique

## Statut

**Annulée S82 (01/05/2026)** — Mickael juge la tâche redondante :
l'interface Frigate est déjà accessible via le panneau latéral HA
(intégration ingress de l'add-on Frigate), avec timeline + clips +
événements natifs. Pas besoin de doubler avec un onglet Lovelace
custom (`custom:frigate-card` ou autre). Si besoin d'agrégat ou de
filtre custom apparaît plus tard, ré-ouvrir via skill `add-task`.
