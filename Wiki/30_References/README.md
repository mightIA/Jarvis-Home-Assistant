---
title: Références externes
created: 2026-04-25
updated: 2026-04-25
tags: [reference, readme, structure]
---

# 30_References/

**Ce qu'on range ici** : tout document tiers utile à la maison —
manuels constructeur, datasheets, articles techniques, captures
d'interfaces, exports PDF de procédures.

## Convention

- **Nommage** : `<Source>_<Sujet>_<Année>.<ext>`
  (ex. `Frisquet_ManuelInstallation_2018.pdf`,
  `Cloudflare_HSTS_Guide_2024.md`).
- **Note compagnon** : pour chaque PDF/doc lourd, créer une note
  `<NomDoc>.md` à côté avec résumé + tags + sections clés citées
  (sera consommée par Hermes Agent `wiki_ingestor` plus tard).

## Sous-dossiers conseillés

- `Manuels/` — manuels constructeur (Frisquet, Dahua, Dyson…)
- `Datasheets/` — fiches techniques composants (Zigbee, Z-Wave)
- `Articles/` — articles web copiés (avec URL source dans frontmatter)
- `Captures/` — captures d'interfaces (UniFi, CF, HA Studio Code)

## Hors scope

Les **PDF du projet Jarvis lui-même** (ex. `Projet_Complet_v2.pdf`)
restent dans `Projets/Jarvis_Hermes_Projet/` à la racine du projet,
**pas ici**. Ce dossier est pour les références **externes**.
