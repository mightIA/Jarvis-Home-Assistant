---
id: 9
title: "Créer compte `MightTab` dédié (non-admin, 2FA, groupe `tablette_mobile` avec ..."
status: pending
priority: P2
session_opened: S20
tags: [security]
source: "Audit secu / S20"
---

# T#9 — Créer compte `MightTab` dédié (non-admin, 2FA, groupe `tablette_mobile` avec ...

## Description

Créer compte `MightTab` dédié (non-admin, 2FA, groupe `tablette_mobile` avec exposition climate/light/switch/media_player) — quand config HA stabilisée et tablette prête à sortir du réseau local

## Source / Échéance

Audit secu / S20

## Statut

⏸️ `pending` (S83 — 01/05/2026) — **étape 1/3 réalisée, blocage matériel**.

**Avancement S83** :
- ✅ Étape 1 — Compte `MightTab` (username `mighttab`) créé, groupe `Utilisateurs` (non-admin), Local seulement **décoché** (décision Mickael S83 : tablette doit pouvoir se connecter via `ha.might.ovh` aussi). Mot de passe ≥12 caractères confirmé.
- ⏸ Étape 2 — Activation 2FA TOTP sur compte MightTab (via login + Profil → Authenticator).
- ⏸ Étape 3 — Bascule de l'app HA tablette sur compte MightTab + test (allumer une lampe).

**Approche retenue S83** : MVP (compte non-admin + dashboard tablette tel quel). Filtrage strict aux 4 domaines (climate/light/switch/media_player) **abandonné** : aucun dashboard tablette dédié n'existe à ce jour, et l'utilisateur non-admin protège déjà des accès Paramètres/Outils dev/Logs/etc.

**Surveillance logs login MightTab** : explicitement non retenue par Mickael (« si je la perds je peux toujours la supprimer des comptes »).

**Risque résiduel actuel** : compte MightTab actif mais sans 2FA → mot de passe = unique barrière. Tant que la tablette n'a pas basculé sur ce compte, le compte n'est pas utilisé en pratique, donc risque limité.

**Bloquant pour reprendre** : Mickael doit avoir la tablette physiquement disponible pour étape 3 (bascule + test). Étape 2 (2FA) peut se faire dès maintenant sur PC mais Mickael préfère grouper tablette + 2FA.

**À reprendre en session future** quand tablette accessible.
