---
id: 82
title: "Décongestion METRIQUES.md lignes 47-52 (mode modéré)"
status: done
priority: P2
session_opened: S76
session_closed: S77
tags: [metriques, decongestion]
source: "Session S76 / Demande Mickael (2026-04-29)"
---

# T#82 — Décongestion METRIQUES.md lignes 47-52 (mode modéré)

## Description

Externaliser les sections « Tri email (cumul) » et « Bans IP » de `METRIQUES.md`
racine vers `memory/historique/METRIQUES_archive_2026-Q2.md` selon le pattern
« pointer, don't embed » (cohérence avec décongestion P1 S72).

## Source / Échéance

Session S76 / Demande Mickael (2026-04-29)

## Statut

Fait S77 (29/04/2026, option A validée par Mickael) :
- Tableaux Tri email + Bans IP déplacés dans `METRIQUES_archive_2026-Q2.md`
  (nouvelle section « archivés S76 (29/04/2026) »).
- `METRIQUES.md` racine : 2 tableaux remplacés par 1 bloc pointeur compact
  + cumul rapide en 1 ligne.
- Bump version `METRIQUES.md` 4.4 → 4.5.
- Gain : ~600 octets / ~150 tokens par tour réinjecté.
