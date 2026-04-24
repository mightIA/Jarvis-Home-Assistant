---
title: Index Wiki Jarvis
created: 2026-04-25
tags: [moc, index]
status: actif
---

# Index Wiki Jarvis

Point d'entrée principal du vault. À mettre à jour quand de nouveaux
domaines/projets/références sont ajoutés.

## Domaines actifs

*(à remplir au fur et à mesure)*

- [ ] Home Assistant — `[[10_Domaines/HomeAssistant/_Index]]`
- [ ] Domotique appareils — `[[10_Domaines/Domotique/_Index]]`
- [ ] Réseau & sécurité — `[[10_Domaines/Reseau/_Index]]`
- [ ] Cloudflare — `[[10_Domaines/Cloudflare/_Index]]`
- [ ] Frisquet (chaudière) — `[[10_Domaines/Frisquet/_Index]]`
- [ ] Cameras Dahua — `[[10_Domaines/Cameras/_Index]]`

## Projets en cours

*(à remplir au fur et à mesure)*

- [ ] Hermes Agent (Phase 1bis) — `[[20_Projets/Hermes_Agent/_Plan]]`
- [ ] Tri email multi-boîtes — `[[20_Projets/Tri_Email_Multi/_Plan]]`

## Références récentes

*(à remplir au fur et à mesure)*

## Tags principaux

- `#ha/*` — Home Assistant (config, automation, dashboard)
- `#domotique/*` — Appareils connectés (Dyson, Frisquet, Dahua, Tuya)
- `#reseau/*` — Réseau, DNS, Cloudflare, sécurité
- `#projet/*` — Projets actifs avec deadline

## Recherche rapide

- **Dataview — 10 dernières notes du vault** :

```dataview
TABLE WITHOUT ID file.link AS "Note", title AS "Titre", file.folder AS "Dossier"
FROM ""
SORT file.cday DESC
LIMIT 10
```

- **Dataview — toutes les notes du dossier 20_Projets/** :

```dataview
TABLE WITHOUT ID file.link AS "Note", title AS "Titre"
FROM "20_Projets"
```

---

*MOC racine du vault. Mise à jour manuelle ou auto via Templater.*
