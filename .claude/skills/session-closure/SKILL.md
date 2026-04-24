---
name: session-closure
description: A declencher en fin de session importante. Propose a Mickael de regenerer un .md date dans memory/historique/, de mettre a jour les skills ou protocoles modifies, de regenerer Jarvis_Audits_Todo.pdf si nouvelles taches, de mettre a jour CLAUDE.md si l'arborescence a evolue, et d'actualiser METRIQUES.md.
---

# Skill : Cloture de session

## Quand cette skill est declenchee

- Fin d'une session de travail importante.
- Mickael indique qu'il termine ("on va s'arreter la", "fin de session", etc.).
- Apres une serie de modifications significatives (config HA, nouvelle skill,
  nouveau protocole).

## Workflow propose

### 1. Generer un .md date pour l'historique

Si la session a apporte des informations utiles, proposer la creation d'un
fichier `memory/historique/AAAA-MM-JJ_session_NN_titre.md` avec :
- Phases / etapes de la session
- Decisions importantes (tableau)
- Fichiers crees ou modifies
- Points reportes ou a continuer

Format inspire des sessions existantes (sessions 01 a 05).

### 2. Mettre a jour les skills / protocoles modifies

Si une skill ou un protocole a ete modifie pendant la session :
- Proposer la mise a jour du SKILL.md correspondant dans `.claude/skills/`
- OU la mise a jour du document source dans `Ressources/Competences/` ou
  `Ressources/Protocoles/`

### 3. Regenerer TASKS.md et le PDF

Si nouvelles taches ou audit :
- Mettre a jour `TASKS.md` directement
- Regenerer `Ressources/Mode_Chat/Jarvis_Audits_Todo.md` si l'audit a
  ete modifie de maniere significative (format `.md` uniquement depuis S33,
  plus de PDF — voir auto-memory `feedback_knowledge_md_not_pdf`)

### 4. Mettre a jour CLAUDE.md

Si l'arborescence a evolue (nouvelle skill creee, nouveau dossier,
suppression) : proposer la mise a jour de `CLAUDE.md` (notamment la
section 5 — liste des skills).

### 5. Mettre a jour METRIQUES.md

A chaque session :
- Incrementer le compteur de sessions du mois
- Logger les bans IP geres si applicable
- Logger les modifications HA significatives
- MAJ stats tri email si une session de tri a eu lieu

### 6. Fin de session courte

Si la session etait courte ou sans nouveaute : ne rien proposer.

## Rotation archives (annuelle)

Au 1er janvier de chaque annee, zipper les sessions de l'historique de
l'annee ecoulee dans `Archives/historique_AAAA.zip`, puis vider
`memory/historique/` (sauf le ou les .md de la nouvelle annee).
