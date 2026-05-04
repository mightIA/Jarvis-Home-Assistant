---
name: session-closure
description: A declencher en fin de session importante. DECLENCHEURS : 'fin de session', 'on s'arrete la', 'cloture session', 'sauvegarde la session', 'session-closure', 'on cloture', 'fait le bilan'. Propose a Mickael : (1) regenerer un .md date dans memory/historique/, (2) MAJ skills/protocoles modifies, (3) regenerer Jarvis_Audits_Todo.MD (format .md depuis S33, plus de PDF) si nouvelles taches, (4) MAJ CLAUDE.md si arborescence a evolue, (5) MAJ METRIQUES.md (compteurs sessions/tris/bans). Si session courte = ne RIEN proposer.
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


## Exemples d'invocation utilisateur

- « On s'arrete la pour ce soir » → declenchement complet 6 etapes.
- « Cloture la session, on a juste fait un debogage » → eval rapide : peu de modifs → ne proposer QUE l'historique court (etape 1) + METRIQUES (etape 5).
- « Sauvegarde la session » → equivalent cloture, generer le .md historique meme si session courte.
- « Fait le bilan rapide » → produire un resume court (3-5 lignes) sans creer de .md.

## Quand NE PAS utiliser

- Si Mickael n'a pas signale de fin → ne pas proposer spontanement (anti-pattern : couper une session encore active).
- Pour un changement de TOPIC en cours de session (passer du tri email au debogage HA) — ce n'est pas une fin de session.
- Si la session est < 5 min sans modification de fichier — ne rien proposer.
- Pour une session de pure lecture / questions-reponses sans nouvelle info => ne rien proposer.

## Pieges connus

- **Format `.md` ONLY** depuis S33 pour les 3 fichiers Knowledge fallback (`Jarvis_Profil.md`, `Jarvis_Instructions.md`, `Jarvis_Audits_Todo.md`). NE PLUS proposer la regen PDF/ReportLab (auto-memory `feedback_knowledge_md_not_pdf.md`).
- **METRIQUES.md** : ne PAS oublier d'incrementer le compteur sessions du mois meme pour une session courte (sinon decalage).
- **Numerotation sessions** : lire `memory/historique/INDEX_sessions.md` AVANT de proposer un numero (anti-pattern : repiquer un numero deja utilise).
- **Doublons S/jour** : si plusieurs sessions le meme jour, suffixer `a`/`b`/`c` (S69a/S69b — convention S74).
- **Frontmatter YAML** : tout `.md` historique DOIT avoir frontmatter `title/date/session/duration/mode`, sinon il sera mal indexe par `INDEX_sessions.md`.
- **Append-only IDs** : si une tache T#XX a ete creee puis supprimee dans la session, son ID reste reserve a vie (D4 S71). Ne pas reutiliser.

## Rotation archives (annuelle)

Au 1er janvier de chaque annee, zipper les sessions de l'historique de l'annee ecoulee dans `Archives/historique_AAAA.zip`, puis vider `memory/historique/` (sauf le ou les .md de la nouvelle annee).
