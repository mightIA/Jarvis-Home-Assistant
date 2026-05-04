---
title: ADR accepted — convention
created: 2026-04-27
updated: 2026-04-27
tags: [adr, accepted, convention]
---

# ADR accepted — convention

Un ADR **accepted** documente une decision d'architecture **toujours valide aujourd'hui**.

## Règles

- 1 ADR = 1 fichier, format `ADR-ANNN-titre-court.md` (préfixe `A` pour accepted).
- Frontmatter obligatoire : `status: accepted`, `session_origine`, `created`.
- Sections : Contexte / Décision / Conséquence / Alternative écartée / Source.
- Si la décision est invalidée plus tard : ne PAS supprimer, créer un nouvel ADR rejected qui pointe vers celui-ci, et ajouter une note `## Mise à jour` en bas de l'ADR original.
- Numérotation indépendante des rejected (A001, A002, ... vs 001, 002, ...).

## Quand créer un ADR accepted ?

- Choix de techno ou fournisseur structurant (ex. add-on retenu vs core).
- Décision hardware engageant le budget (ex. validation GPU).
- Pattern d'architecture global (ex. vault Obsidian co-localisé avec le projet).

Pas pour les micro-décisions du quotidien (préférer auto-memory `feedback_*` ou `reference_*`).
