---
id: 7
title: "Creer preset Fav 5 via interface web camera Dahua"
status: done
priority: P2
session_opened: S3
session_closed: S82
tags: [camera]
source: "Historique session 3"
---

# T#7 — Creer preset Fav 5 via interface web camera Dahua

## Description

Creer preset Fav 5 via interface web camera Dahua

## Source / Échéance

Historique session 3

## Statut

**Résolue S82 (01/05/2026)** — Approche alternative finale : pas de preset
PTZ Fav 5 créé côté caméra. À la place, le bouton Fav 5 a été
**reconverti en bouton « 360° »** qui appelle `script.cuisine_ptz_ronde`
(cycle Fav 1 → 2 → 3 → 4, 5s sur chaque, total ~20s, sans enregistrement
vidéo).

Implémentation S82 :
- Script HA `script.cuisine_ptz_ronde` créé via MCP
  (`ha_config_set_script`), service `onvif.ptz` avec `move_mode: GotoPreset`
  et `preset: "1"` à `"4"` séquencés avec `delay: 00:00:05`.
- Bouton dashboard Lovelace renommé manuellement par Mickael
  (« Fav 5 » → « 360° », icône `mdi:rotate-360`, action vers
  `script.cuisine_ptz_ronde`).
- Position dans la rangée échangée avec Fav 1.

Choix de design : éviter de devoir se connecter sur l'interface web
caméra Dahua (IP locale) pour créer un preset ONVIF, et reconvertir le
slot vide en fonction utile (vue d'ensemble rapide de la cuisine).
