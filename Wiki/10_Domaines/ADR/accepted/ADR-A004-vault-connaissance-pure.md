---
title: ADR-A004 — Vault = connaissance pure (pas de projets ni d'archives)
created: 2026-04-30
updated: 2026-04-30
tags: [adr, accepted, obsidian, vault, structure, gouvernance]
status: accepted
session_origine: S81
supersedes_partial: ADR-A001
---

# ADR-A004 — Vault Obsidian = connaissance pure (pas de projets ni d'archives)

## Contexte

S81 (30/04/2026) — audit de fond du vault `Wiki/` à la demande de Mickael : « Le vault ne doit rien contenir de projets. Les projets sont des créations en cours ou des tests qui ne doivent pas influencer le comportement de Jarvis ni modifier de fichiers hors de leur propre dossier. Les archives n'ont pas non plus à être stockées dans le vault. »

État S80 du vault (avant audit) : **149 fichiers .md, ~960 KB, 6 dossiers top-level** (`00_Index`, `10_Domaines`, `15_Hermes_Agent`, `20_Projets`, `30_References`, `90_Archives`).

Constat de l'audit fichier par fichier : la plupart des fichiers `15_Hermes_Agent/` et `20_Projets/` étaient des **copies cosmétiques** des fichiers correspondants dans `Projets/` racine (frontmatter Obsidian + wikilinks + emojis virés), sans connaissance technique unique. Le dossier `90_Archives/` ne contenait qu'un README. Deux verbatims volumineux étaient présents (`ChatGPT_Conv_Originale.md` 28 KB, `REPRISE_CONVERSATION.md` 16 KB).

L'ADR-A001 (S41) avait acté la structure PARA + Karpathy LLM Wiki avec 5 dossiers. Cet ADR-A004 **supersède partiellement** ADR-A001 sur la structure, sans annuler la décision principale (vault co-localisé dans le projet).

## Décision

**ACCEPTÉE** le 30/04/2026 (S81). Le vault `Wiki/` ne contient que **3 dossiers top-level** :

| Dossier | Rôle |
|---|---|
| `00_Index/` | Maps Of Content (MOC), points d'entrée navigation |
| `10_Domaines/` | Domaines de connaissance persistants (fiches techniques, ADR, procédures) |
| `30_References/` | Références externes (manuels, datasheets, captures) |

Les dossiers `15_Hermes_Agent/`, `20_Projets/` et `90_Archives/` sont **supprimés** (Phase A+B+C de l'audit S81).

## Règles structurelles

1. **Aucun projet dans le vault.** Les projets vivent exclusivement dans `Projets/` racine du repo, en isolation totale. Un projet ne doit pas modifier de fichiers hors de son propre dossier ni du vault.
2. **Aucune archive dans le vault.** Les archives vivent exclusivement dans `Archives/` racine.
3. **Aucune conversation verbatim.** Pas de dump ChatGPT/Claude/transcript. Soit synthèse en fiche courte, soit déplacement hors vault.
4. **Pas de MOC pointeur** vers un projet (anti-pattern : invitait à dupliquer / créait du drift).
5. **Une fiche du vault doit être autonome** : la connaissance contenue ne dépend pas d'un état projet en cours. Si une connaissance technique mérite d'être pérennisée, on l'extrait du projet et on crée une fiche propre dans `10_Domaines/<topic>/` (extraction, pas duplication).

## Conséquence

- **Vault épuré** : 149 → 124 fichiers (−25), 960 → 608 KB (−37 %), 6 → 3 dossiers top-level.
- **Pas de perte de connaissance technique** : les contenus supprimés étaient soit des doublons cosmétiques, soit des verbatims, soit des MOC pointeurs.
- **Annotations post-S68 préservées** : `Wiki/15_Hermes_Agent/02_Plan_Phase1bis.md` et `03_Decision_Q1-Q8.md` contenaient des annotations sur l'avancement réel des phases, transférées en pied de `Projets/Jarvis_Hermes_Projet/Projet_Complet.md` (section "Avancement post-S36") avant suppression.
- **Règle de gouvernance** capitalisée dans l'auto-memory `feedback_vault_pas_de_projets_archives.md`.
- **Liens morts à nettoyer** dans 8 fiches `10_Domaines/` qui pointaient vers les dossiers supprimés (Phase D de l'audit S81).
- **ADR-A001 conservé** comme historique S41, frontmatter enrichi `superseded_by: ADR-A004` sur la partie structure (5 dossiers → 3).

## Alternative écartée

- **Garder un MOC pointeur par projet dans le vault** (`type: moc-pointeur`, comme `AI_Prompt_Design/INDEX.md`) — écarté par Mickael S81 : « pas de projets, pas même de pointeurs ».
- **Garder une fiche post-mortem par projet clos dans le vault** — écarté par Mickael S81 : les archives sortent du vault.
- **Synthétiser les rapports projet en fiches `10_Domaines/`** avant suppression (option B initiale Phase B+C) — écarté à l'usage : les `Projets/` racine et `memory/historique/` couvrent déjà l'information.

## Source

- Auto-memory `feedback_vault_pas_de_projets_archives.md` (Cowork web + CLI local)
- Session S81 (30/04/2026) — épuration vault, audit fichier par fichier
- ADR-A001 (S41) — vault co-localisé dans le projet (décision principale conservée)
