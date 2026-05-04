---
id: 79
title: "Décisions vault post-audit S72 (lien externe Inventaire, normalisation tags)"
status: done
priority: P3
session_opened: S72
session_closed: S86
tags: [vault, obsidian]
source: "Session 72 — Audit Vault Obsidian (28/04/2026)"
---

# T#79 — Décisions vault post-audit S72

## Description

À l'issue de l'audit complet du vault Obsidian S72, deux décisions de fond restent à arbitrer avec Mickaël :

### 1. Lien hors vault dans `Inventaire/_Index.md` (P2.6)

Le hub `Wiki/10_Domaines/Inventaire/_Index.md` contient un wikilink `[[Ressources/Competences/Home_Assistant_Inventaire]]` qui pointe **hors du vault**. Obsidian le considère comme cassé.

**Options** :
- (A) Laisser tel quel + tag `[externe]` ou note de bas
- (B) Rapatrier le contenu dans un nouvel atome `Wiki/10_Domaines/Inventaire/Inventaire_HA_complet.md`
- (C) Remplacer par un lien markdown classique `[Voir l'inventaire](../../Ressources/Competences/Home_Assistant_Inventaire.md)` (reco Jarvis)

### 2. Normalisation des tags (P3.2)

220 tags distincts dans le vault, mix flat (`hardware`, `email`, `outils`) + hiérarchique (`ha/lovelace`, `email/envoi`, `vie-perso/abonnements`). Obsidian considère `email` et `email/envoi` comme deux tags **différents** → fragmente la recherche.

**Options** :
- (A) Tout passer en hiérarchique
- (B) Tout passer en flat (`-` au lieu de `/`)
- (C) Garder le mix mais imposer une règle (un tag racine valide en flat, sous-tags `racine/sub` à côté quand on précise — reco Jarvis)

## Source / Échéance

Session 72 / Audit Vault Obsidian (`Projets/Audit_Vault_S72_2026-04-28/99_Rapport_Final_Synthese.md`)

## Résolution (S86 — 02/05/2026)

### D1 — Lien externe Inventaire → option C appliquée

`Wiki/10_Domaines/Inventaire/_Index.md` ligne 15 :

- **Avant** : `Complément de [[Ressources/Competences/Home_Assistant_Inventaire]]` (wikilink cassé hors vault)
- **Après** : `Complément de [Home Assistant — Inventaire (hors vault)](../../../Ressources/Competences/Home_Assistant_Inventaire.md)` (lien markdown relatif fonctionnel)

### D2 — Normalisation tags vault → option C appliquée

Convention tags tripartite **complétée** dans `Wiki/README.md` (la section avait été tronquée S81 au milieu de la famille 1) :

- Famille 1 — Type de note (flat) : 8 tags listés (`moc`, `adr`, `accepted/rejected`, `procedure`, `reference`, `journal`, `coquille/stub`, `index`)
- Famille 2 — Domaine fonctionnel (hiérarchique) : 7 racines + sous-tags + **règle option C** : "tag racine + sous-tag ajoutés ensemble" (jamais juste le sous-tag)
- Famille 3 — Technologie transversale (flat) : `rtx3090`, `ryzen`, `proxmox`, `ollama`, `hermes`, `mcp`, `cloudflare`, `pdf`, etc.
- Exemple concret + section maintenance ("pas de migration des 220 tags existants — refonte vault prévue plus tard")

### Notes de bouclage

- Auto-memory Cowork créée : `feedback_vault_refonte_future.md` (Mickael envisage repart from scratch sur le vault → tactique > stratégique en attendant).
- Pas de migration brutale appliquée (220 tags existants laissés tels quels).
- Règle option C s'applique aux **nouveaux atomes** et à ceux modifiés au fil de l'eau.

## Statut

✅ **done** — closed S86 (02/05/2026)
