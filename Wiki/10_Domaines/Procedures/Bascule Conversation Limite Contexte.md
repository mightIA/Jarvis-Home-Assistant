---
title: Bascule Conversation Limite Contexte
created: 2026-04-27
tags: [procedure, cowork, contexte]
status: actif
domaine: Procedures
sources: [S12, S53]
---

# Bascule de conversation a l'approche de la limite de contexte

## Quand utiliser

- Conversation Cowork qui **rame** notablement (latence augmentee, reponses
  qui mettent du temps a streamer).
- Approche visible de la **limite de tokens** (warnings dans la sidebar, ou
  message "context window approaching").
- `guidage-photo-etape` a detecte `LIMITE - 1` captures atteintes.
- Mickael demande explicitement *"bascule"*, *"on approche la limite"*, ou
  signale *"ca coute cher en tokens"*.

## Pourquoi

Une conversation Cowork sature son contexte au fil des messages, du chargement
de fichiers et des outputs MCP. Au-dela de ~80 % de la fenetre, la latence
augmente et la qualite des reponses peut chuter. Deux strategies coexistent :

- **`/compact`** : Cowork resume la conversation en place et libere du
  contexte. Pratique si le travail courant a peu de valeur a conserver
  texto et qu'on veut continuer dans la **meme** conv.
- **Bascule nouvelle conv** : on cree un fichier historique + un bloc resume
  de reprise, puis on ouvre une nouvelle conv en collant le resume. Pratique
  quand le contexte courant est riche/critique et qu'on veut un re-debut propre.

## Vue d'ensemble (regle S53)

**Toujours proposer LES 2 solutions** au moment du declenchement, avec
recommandation motivee selon valeur du contexte courant pour la suite.
Voir auto-memory `feedback_compact_vs_bascule_proposition.md`.

### Strategie 1 — `/compact`

1. Mickael (ou Jarvis qui propose) tape `/compact` dans la conv.
2. Cowork resume automatiquement et libere ~70-80 % du contexte.
3. Verifier que les references critiques (chemins fichiers, commandes en
   cours, IDs) ont survecu au resume.
4. Continuer dans la meme conv.

### Strategie 2 — Bascule nouvelle conv (skill `bascule-conversation`)

1. **Test compatibilite** : verifier qu'aucun travail en attente ne sera
   perdu (config HA en cours d'ecriture, OAuth en cours, etc.). Si bloque,
   resoudre AVANT bascule.
2. **Generer le resume de reprise** (template detaille dans la skill).
3. **Mettre a jour fichiers projet** : TASKS.md, METRIQUES.md, archive
   `memory/historique/AAAA-MM-JJ_session_NN_titre.md`, eventuellement
   `CLAUDE.md` et auto-memories.
4. **Fournir le bloc a coller** dans un bloc de code markdown.
5. Mickael ferme l'ancienne conv et colle le bloc dans la nouvelle.

## Pieges connus

- **Anti-pattern S53** : ne pas livrer R1+R2+R3+R4 d'un coup. Une etape a la
  fois, attendre le retour Mickael (`feedback_pas_a_pas_attente_retour`).
- **Ne pas oublier le titre FR** au demarrage de la nouvelle conv (regle
  S53, auto-memory `feedback_titre_conversation_fr`).
- **Re-charger les fichiers vivants** : la nouvelle conv ne les a pas en
  contexte. Mickael doit autoriser/charger CLAUDE.md, TASKS.md, MEMORY.md
  selon besoin.
- **Ne pas continuer dans la conv saturee apres bascule** — toutes les MAJ
  fichiers ont deja ete faites, continuer la-bas cree des incoherences.
- **`/compact` perd les nuances** : si le travail en cours impliquait des
  decisions architecturales, mieux vaut bascule + archive.
- **Limite images Claude.ai (mode chat fallback)** : si en fallback (pas
  Cowork), c'est la limite **images** qui declenche, pas les tokens. Voir
  `feedback_anticipation_limite_images`.

## Detail executable

- Skill : `.claude/skills/bascule-conversation/SKILL.md` (workflow complet
  5 etapes + template resume).
- Skill complementaire : `.claude/skills/session-closure/SKILL.md` (fin
  normale, pas urgence).
- Skill amont : `.claude/skills/guidage-photo-etape/SKILL.md` (detection
  `LIMITE - 1` captures).

## Sources

- `memory/historique/2026-04-19_session_12_skills_guidage_cloudflare_bascule.md`
- `memory/historique/2026-04-26_session_53_phase1bisd_b1_enable_tool_search.md`
- Auto-memories : `feedback_compact_vs_bascule_proposition`, `feedback_titre_conversation_fr`, `feedback_pas_a_pas_attente_retour`, `feedback_anticipation_limite_images`
