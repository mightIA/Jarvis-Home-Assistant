---
title: ADR rejected — convention
created: 2026-04-27
tags: [adr, rejected, convention]
---

# ADR rejected — convention

Un ADR **rejected** documente une piste **explorée et écartée**, AVEC raison + impact, pour ne pas y revenir 6 mois après en ayant oublié pourquoi.

## Règles

- 1 ADR = 1 fichier, format `ADR-NNN-titre-court.md` (numérotation simple sans préfixe).
- Frontmatter obligatoire : `status: rejected`, `session_origine`, `created`.
- Sections : Contexte / Décision (REJETÉE) / Raison du rejet / Impact / Alternative retenue / Source.
- L'ADR rejected reste **immuable** une fois écrit — si on rouvre la piste plus tard, on crée un NOUVEL ADR (accepted ou rejected) qui le référence.

## Quand créer un ADR rejected ?

- Une techno candidate sérieusement évaluée puis écartée (ex. mistral-nemo testé en principal Hermès).
- Une voie d'architecture envisagée puis abandonnée pour cause de bug upstream connu (ex. provider custom OpenRouter).
- Un service externe écarté pour raison structurelle (ex. Mammouth AI sans API).

Pas pour les fausses pistes immédiatement éliminées en 5 minutes (préférer une note dans l'archive de session).
