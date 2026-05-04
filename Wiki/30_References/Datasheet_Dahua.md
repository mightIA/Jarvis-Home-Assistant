---
title: Datasheet caméras Dahua — Référence externe
created: 2026-04-30
updated: 2026-04-30
tags: [reference, dahua, camera, datasheet, stub]
status: stub
---

# Datasheet caméras Dahua — Référence externe

> 📄 **Stub de référence** — les datasheets PDF ne sont pas encore importées dans le vault. Cette note recense les liens fabricants utiles en attendant.

## Caméras Mickael

| Pièce | Entité HA | MAC |
|---|---|---|
| Chambre | `camera.chambre_mediaprofile_channel1_mainstream` | `c4:aa:c4:b6:68:40` |
| Cuisine fixe | `camera.cuisine_profile100` | `f8:ce:07:b5:5b:f6` |
| Cuisine PTZ | `camera.cuisine_profile000` | `f8:ce:07:b5:5b:f6` |

App mobile : DMSS. Protocole : ONVIF.

## Liens fabricants

- Site officiel : [https://www.dahuasecurity.com](https://www.dahuasecurity.com)
- Datasheets / spec sheets : [https://www.dahuasecurity.com/products](https://www.dahuasecurity.com/products) (recherche par modèle)
- Support / firmware : [https://dahuawiki.com](https://dahuawiki.com)
- DMSS app : iOS / Android (Dahua Mobile Surveillance Software)

## Modèles à identifier

Modèles précis à confirmer côté Mickael (regarder les caméras physiques ou DMSS).
Candidats fréquents : IPC-T2A20-PV, IPC-HFW2531T-AS, IPC-HDBW2531R-ZS-S2, etc.

## Si tu importes les datasheets

Quand les PDF arrivent :
1. Déposer dans `Wiki/30_References/PDF/Datasheet_Dahua_<modele>.pdf`
2. Ajouter un lien `[Datasheet IPC-T2A20-PV](PDF/...)` par modèle
3. Compléter le tableau ci-dessus avec le modèle exact par caméra
4. Retirer le tag `stub`

## Voir aussi

- [[10_Domaines/Cameras/_Index|Domaine Caméras]]
- [[10_Domaines/Cameras/Configuration et scripts|Configuration & scripts caméras]]
- [[10_Domaines/Cameras/Page Lovelace|Page Lovelace caméras]]
- `Ressources/Competences/Home_Assistant.md` § 5 caméras
