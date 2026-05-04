---
id: 80
title: "Compléter hub Domotique avec 6 équipements TODO"
status: done
priority: P3
session_opened: S72
session_progress: S79 (2026-04-30)
session_closed: S86
tags: [vault, obsidian, domotique]
source: "Session 72 — Audit Vault Obsidian (28/04/2026)"
---

# T#80 — Compléter hub `Domotique/_Index.md`

## Description

Le hub `Wiki/10_Domaines/Domotique/_Index.md` liste 6 équipements **non encore documentés** :

- Prises connectées (Child lock HomeKit)
- Samsung Q80 Series 65 + décodeur TV UHD
- Apple TV salle de bain
- Music Assistant
- EcoFlow River 2 Pro
- Imprimante 3D Creality Ender 3 S1 Pro (intégration Moonraker)

## À fournir par Mickaël (par équipement)

- Marque / modèle exact
- Mode d'intégration HA (HACS plugin nom, intégration native, MQTT, autre)
- État (configuré / partiellement / pas encore)
- Entités HA principales si connues

## Mode opératoire à choisir

- (a) Création coquilles : 1 fichier vide par équipement, à remplir au fil de l'eau (comme `Inventaire/`)
- (b) Documentation complète d'un équipement à la fois après briefing Mickaël

## Source / Échéance

Session 72 / Audit Vault Obsidian — pas urgent, à faire au fil des sessions

## Statut

✅ **done** — closed S86 (2026-05-02). Avant clôture (progression S79+1 — 2026-04-30) :

- ✅ 6 coquilles créées dans `Wiki/10_Domaines/Domotique/` avec
  frontmatter + sections type pré-remplies (mode hybride)
- ✅ `_Index.md` réorganisé : section « Fiches complètes » vs
  « Coquilles à compléter » (plus de TODO orphelin)
- ✅ Fiche **Samsung Q80 + décodeur UHD** complétée à 100 % via MCP HA
  (`ha_search_entities`, `ha_get_device`, `ha_get_state`) — modèle
  exact `QE65Q82RATXXC`, intégration `samsungtv` locale, décodeur
  Orange SoftAtHome via DLNA-DMR
- ✅ Fiche **HomePod Mini salle de bain** complétée à 100 % (renommée
  depuis « Apple TV salle de bain » après vérif MCP `model=HomePod Mini`)
- ✅ Ancien fichier `Apple TV salle de bain.md` supprimé après validation
  explicite Mickaël (S79+1)
- ✅ Fiche **Music Assistant** complétée à 100 % (add-on
  `d5369777_music_assistant` v2.8.6, 3 players, 6 services `mass.*`)
- ✅ Fiche **Prises connectées HomeKit** complétée S86 — 5 prises identifiées via MCP HA (`ha_get_integration(homekit)` + `ha_search_entities(child lock)`) : cuisine porte, mobile 1, mobile climatiseur, PC chambre, PC-Might. Validation Mickael : passer de 4 → 5 prises (PC-Might non listée dans la coquille initiale).
- ✅ Fiche **EcoFlow River 2 Pro** complétée S86 — modèle interne `DELTA_2`, intégration HACS `ecoflow_cloud`, 70+ entités, extension Slave Battery confirmée par Mickael. Action HA bonus : `ha_update_device` → area `chambre` (précédemment `null`).
- ✅ Fiche **Imprimante 3D Creality Ender 3 S1 Pro** complétée S86 — intégration native `moonraker`, ~140 entités préfixées `creality_ender_3_s1_pro_*` (préfixe `spad_7737_*` ignoré sur instruction Mickael — ancien hostname Klipper). État noté `setup_retry` au moment de la rédaction (souci Klipper en cours côté firmware imprimante).

## Résolution (S86 — 02/05/2026)

T#80 fermée : les 6 équipements ont été documentés (3 en S79+1, 3 en S86). Hub `Wiki/10_Domaines/Domotique/_Index.md` MAJ — section « Coquilles à compléter » vidée.

**Note de suivi** : l'intégration Moonraker est en `setup_retry` (souci Klipper côté firmware imprimante 3D). À traiter par Mickael séparément si besoin (création tâche T#90 à voir).
