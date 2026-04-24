---
title: Projets actifs avec début/fin
created: 2026-04-25
tags: [readme, structure]
---

# 20_Projets/

**Ce qu'on range ici** : tout chantier avec un début, un livrable, et une
fin. Une fois clos, le projet déménage dans `90_Archives/`.

## Convention

Chaque projet est un sous-dossier dédié contenant au minimum un
`_Plan.md` (objectif, sous-étapes, statut) et un `_Journal.md`
(décisions et mises à jour datées).

## Projets prévus / en cours

- `Hermes_Agent/` — Phase 1bis, install Hermes Agent + Ollama RTX 3090
- `Tri_Email_Multi/` — tri auto 4 boîtes 04h15 (#52 TASKS.md)
- `Mode_Reactif/` — Phase 2 events update_ha_dispo + cameras_stockage_plein

## Lifecycle

1. **Créer** : `_Plan.md` + `_Journal.md` minimum
2. **Itérer** : ajouter notes au fil des sessions, MAJ frontmatter `status`
3. **Clore** : changer `status: archived`, déplacer le dossier dans
   `90_Archives/AAAA-MM_NomProjet/`
