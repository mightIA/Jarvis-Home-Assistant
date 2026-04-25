---
title: Mode Réactif — Vue d'ensemble
created: 2026-04-25
tags: [ha/mode-reactif, jarvis/architecture]
status: actif
version: v1.1
---

# Mode Réactif — Vue d'ensemble

Version **1.1** validée 21/04/2026 (S22) — Phase 1 déployée S29 — Bascule
CLI Option A actée S31.

## Principe directeur

Jarvis reste **l'agent unique**. Il fonctionne en deux modes complémentaires :

- **Mode conversationnel** (déjà en place) — Mickael discute avec Jarvis,
  Jarvis agit sur demande.
- **Mode réactif** (nouveau v1.1) — Home Assistant émet des alertes,
  Jarvis les traite de façon semi-autonome selon un curseur d'autonomie
  configurable (voir [[Mode Réactif - Niveaux d'autonomie]]).

## Ce que le Mode Réactif n'est PAS

- Pas un sous-agent séparé (« Jérôme » abandonné 21/04/2026).
- Pas un daemon 24/7 qui tourne en tâche de fond.
- Pas un remplacement des notifications push iPhone pour les urgences
  critiques (chauffage HS, intrusion, coupure réseau) — celles-là restent
  HA → push iPhone direct, hors Jarvis.

## Schéma global

```
HA (automations.yaml) → notify.email → Gmail (filtre → label Jarvis-Alert)
    ↓ [tampon — latence acceptable 15-30 min]
Windows Task Scheduler (CLI) → claude -p headless → skill check-jarvis-alert
    ↓
Jarvis :
  - lit le niveau d'autonomie actif (input_select.jarvis_niveau_autonomie)
  - applique la règle (action / propose / signaler / ignore)
  - logge dans memory/historique_reactif/AAAA-MM-JJ.md
  - archive label Jarvis-Alert/Traité (jamais TRASH)

23h30 chaque jour : skill rapport-journalier-reactif
  → PDF envoyé à might57290@gmail.com
  → archive rapports/journalier/AAAA-MM-JJ.pdf
```

## Notes liées

- [[Mode Réactif - Niveaux d'autonomie]] — les 5 niveaux + comportement
- [[Mode Réactif - Pipeline alertes]] — label Gmail + convention sujet
- [[Mode Réactif - Décisions S31 CLI]] — bascule Option A + mitigation moindre privilège
- Skill : `.claude/skills/check-jarvis-alert/`
- Skill : `.claude/skills/rapport-journalier-reactif/`
- Source maître : `Ressources/Competences/Mode_Reactif.md`

---

*Source : `Ressources/Competences/Mode_Reactif.md` §1, §2, §8.*
