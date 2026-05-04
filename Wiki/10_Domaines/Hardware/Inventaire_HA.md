---
title: Inventaire HA — pointeur synthèse
created: 2026-04-27
updated: 2026-04-27
migrated_from: Ressources/Competences/Home_Assistant_Inventaire.md (pointeur, pas copie)
type: atome
domaine: Hardware
maintenance: vivant (mise à jour récurrente côté Ressources)
tags: [atome, hardware, ha, inventaire, pointeur]
---

# Inventaire HA — synthèse pointeur

Cet atome est un **pointeur** vers la fiche d'inventaire Home Assistant complète, qui vit côté `Ressources/` et est mise à jour à chaque évolution add-ons / dépôts custom / intégrations / sécurité CF / raccourcis clavier.

## Vue d'ensemble (synthèse 10 lignes)

| Catégorie | Volume actuel (S66 audit sécurité) |
|---|---|
| Add-ons HA installés | 25 |
| Intégrations actives | 63 |
| Devices Zigbee (ZHA) | ~30 |
| Devices Matter / Thread | quelques |
| Devices MQTT | 43 (capture S55) |
| Devices Frigate | 6 (capture S55) |
| Caméras IP | 3 actuelles → 5-6 cibles Phase F |
| HACS services chargés | 50 |
| Backup auto Google Drive | OK quotidien (dernier 26/04 05:47) |
| CVE 2026-34205 (CVSS 9.6) | ✅ PATCHÉ via Supervisor 2026.04.0 |

## Source vivante

📍 **Fichier de référence à maintenir à jour** :

```
D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\Ressources\Competences\Home_Assistant_Inventaire.md
```

Couvre :
- Add-ons installés (avec versions + statut)
- Dépôts custom (HACS, repos community)
- Intégrations actives (avec détail config)
- Sécurité CF (Tunnel + Access policies + HSTS)
- Raccourcis clavier HA UI
- Mapping UI (notamment renommage Add-ons → Apps en 2026)

## Pourquoi c'est pas dupliqué dans le vault

- **Document vivant** : changements quasi-hebdomadaires (add-ons, intégrations, captures UI). Maintenir 2 copies = risque de divergence.
- **Pattern S67** : pour les fichiers vivants critiques (CLAUDE, METRIQUES, TASKS, MEMORY), on applique « pointer, don't embed » (cf. décongestion S49-S52).
- **Audit sécu S66** s'appuie sur ce fichier comme source de vérité périmètre.

## Si tu veux un snapshot vault stable

Pour un audit ponctuel ou un état à un moment T, faire une **copie ponctuelle datée** type `Inventaire_HA_2026-04-27.md` dans `Wiki/30_Sessions/audit_S66/`, plutôt que de figer ici.

## Liens

- [`_Index.md`](_Index.md) — MOC Hardware
- Source vivante : `Ressources/Competences/Home_Assistant_Inventaire.md` (pas de lien vault — fichier hors `Wiki/`)
- Audit sécurité S66 : `Projets/Audit_Securite_S65_2026-04-27/Rapport_Audit_S65.md`
