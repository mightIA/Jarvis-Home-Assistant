---
title: Inventaire — Extérieur
created: 2026-04-27
updated: 2026-04-27
tags: [atome, inventaire, exterieur, jardin]
status: stub
domaine: Inventaire
remplissage_attendu: Mickael
---

# Inventaire — Extérieur

> **Template à remplir.** Mickael complétera lors d'une session dédiée.

## Caméras

Voir détails : [[10_Domaines/Cameras/_Index]] et [[10_Domaines/Cameras/Configuration et scripts]]

| Nom | Marque/Modèle | Localisation | MAC | Entité HA | Notes |
|---|---|---|---|---|---|
| Caméra extérieure 1 | Dahua | (à préciser façade/jardin/portail) | (à préciser) | (`onvif` / `frigate`) | Frigate `setup_retry` actuellement |
| Caméra extérieure 2 | Dahua | (à préciser) | (à préciser) | (`onvif` / `frigate`) | |
| Caméra extérieure 3 | Dahua | (à préciser) | (à préciser) | (`onvif` / `frigate`) | |
| Caméra extérieure 4 | Dahua | (à préciser) | (à préciser) | (`onvif` / `frigate`) | |

> Note : 4 caméras Dahua au total dans l'installation. 2 caméras intérieures (chambre + cuisine) déjà placées dans [[Chambre_principale]] et [[Cuisine]]. Confirmer avec Mickael l'affectation extérieur vs intérieur.

## Capteurs météo

| Nom | Type | Marque/Modèle | Entité HA | Pile | Notes |
|---|---|---|---|---|---|
| Météo France (intégration) | Service web | — | `weather.seremange_erzange_lorraine_57_fr` | — | Intégration `meteo_france` |
| Capteur extérieur | (à préciser) | (à préciser) | (à préciser) | (à préciser) | Voir [[Batteries_Piles]] |
| ... | ... | ... | ... | ... | ... |

## Jardin

| Nom | Type | Marque/Modèle | Notes |
|---|---|---|---|
| Tondeuse | ... | ... | ... |
| Outils jardin | ... | ... | ... |
| Mobilier jardin | ... | ... | ... |
| Barbecue / plancha | ... | ... | ... |
| Abri de jardin | ... | ... | ... |

## Éclairage extérieur

| Nom | Type | Connecté ? | Entité HA | Notes |
|---|---|---|---|---|
| ... | ... | ... | ... | ... |

## Portail / garage

| Nom | Type | Marque/Modèle | Connecté ? | Notes |
|---|---|---|---|---|
| Portail | ... | ... | ... | ... |
| Porte garage | ... | ... | ... | ... |
| Sonnette | ... | ... | ... | ... |

## Liens internes

- [[10_Domaines/Cameras/_Index]] — caméras Dahua
- [[Batteries_Piles]] — capteurs ext. (souvent piles AA / CR2032 / lithium 3.7V)
- [[Reseau_Maison]] — IP fixes caméras

## Sources de remplissage à venir

- Photos extérieures (façade + jardin + emplacement caméras)
- Cartographie caméras (MAC ↔ position physique)
- Diagnostic Frigate `setup_retry`
