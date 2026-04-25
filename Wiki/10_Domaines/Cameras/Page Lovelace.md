---
title: Caméras — Page Lovelace
created: 2026-04-25
tags: [domotique/cameras, ha/lovelace]
status: actif
session: 18/04/2026
---

# Caméras — Page Lovelace

Vue créée le 18/04/2026 (S10-11). Layout `sections` à **3 colonnes**
(Chambre / Cuisine fixe / Cuisine PTZ).

## Structure d'une section

Chaque caméra a la même structure :

- **Ligne 1 — Boutons (4)** : Dossier (ouvre le media browser caméra
  spécifique) | Photo | Vidéo | Supprimer (avec confirmation, caméra
  spécifique)
- **Titre** : nom de la caméra
- **Flux vidéo** : carte Frigate
- **Cuisine PTZ uniquement** : contrôles PTZ supplémentaires
  (Fav 1-5, flèches directionnelles)

## Boutons dossier — comportement

Chaque bouton « Dossier » ouvre le media browser sur le sous-dossier
spécifique de la caméra (Chambre / Cuisine fixe / Cuisine PTZ), pas la
racine `/media/cameras/`. Permet d'accéder aux photos/vidéos de la
caméra cliquée sans naviguer.

## Boutons supprimer — comportement

Chaque bouton « Supprimer » lance la `shell_command` correspondante
(`vider_chambre`, `vider_cuisine_fixe`, `vider_cuisine_ptz`) avec une
confirmation Lovelace native. Les dossiers sont conservés, seuls les
fichiers sont effacés.

## Notes liées

- [[_Index]] — vue d'ensemble
- [[Configuration et scripts]] — scripts et shell_commands derrière les boutons
- [[../HomeAssistant/Modifications config]] — Lovelace via `hass.callWS`
- Skill : `.claude/skills/cameras-dahua/`
- Skill : `.claude/skills/lovelace-edit/`

---

*Source : `Ressources/Competences/Home_Assistant.md` §5.5.*
