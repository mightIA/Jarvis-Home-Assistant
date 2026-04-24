---
name: bascule-conversation
description: Basculer d'une conversation Claude.ai saturee (limite de contexte images atteinte) vers une nouvelle conversation sans perdre l'etat. Genere un resume de reprise complet, verifie l'absence de conflits, met a jour TASKS/METRIQUES/historique, et fournit a Mickael le bloc a coller dans sa nouvelle conversation. Complementaire a session-closure (fin normale) mais dedie au cas "urgence limite images".
---

# Skill : Bascule de conversation (urgence limite images)

Transition propre d'une conversation Claude.ai saturee vers une nouvelle
conversation, sans perdre l'etat du travail en cours. Distincte de
`session-closure` qui cible la fin normale de session.

## Quand cette skill est declenchee

- `guidage-photo-etape` a detecte `LIMITE - 1` captures atteintes.
- Mickael demande explicitement *"bascule"*, *"archive et relance"*,
  *"on approche la limite"*.
- Erreur Claude.ai indiquant que le contexte est sature.
- Une autre skill (ex : `cloudflare-access-ha`) detecte une procedure
  longue impliquant beaucoup de captures et anticipe la bascule.

## Chainage avec d'autres skills

```
cloudflare-access-ha (procedure longue + captures)
        |
        v
guidage-photo-etape (mode reponses courtes + comptage images)
        |
        v  (declenche a LIMITE - 1)
bascule-conversation (ce skill)
        |
        v
session-closure (si la bascule vaut une clôture complete)
```

Autres skills pouvant declencher cette skill :
- Toute procedure HA longue avec captures (dashboard Lovelace, config NPM, etc.)
- `debannissement-ip` si plusieurs captures du terminal SSH
- `install-claude-code-windows` si captures d'installation

## Workflow de bascule (5 etapes)

### Etape 1 — Test de compatibilite pre-bascule

Avant toute bascule, verifier qu'il n'y a pas de **travail en attente**
qui serait perdu :

| Check | Action si bloque |
|-------|------------------|
| Fichier HA critique (config.yaml, automations.yaml) en cours d'ecriture | Finir l'ecriture AVANT la bascule |
| Script HA lance pendant la session (`ha-scripts`) | Attendre la fin ou decrire le statut dans le resume |
| Ban IP actif non resolu (`debannissement-ip`) | Finir le debannissement AVANT |
| Modification Cloudflare en attente de Save | Demander a Mickael de sauvegarder avant bascule |
| Connecteur MCP en cours d'appairage | Finir l'etape OAuth en cours |
| Modification `.claude/skills/*/SKILL.md` non sauvegardee | Sauvegarder AVANT |

Si un point bloque : **ne PAS basculer tant que ce n'est pas resolu**.
Annoncer clairement a Mickael : *"Bloque sur X. On resout d'abord, puis
on bascule."*

### Etape 2 — Generer le resume de reprise

Template standard du bloc resume (a fournir a Mickael pour copier-coller
dans la nouvelle conversation) :

```markdown
## Resume de reprise — [AAAA-MM-JJ HH:MM]

**Contexte** : [1 phrase — ex : "config Cloudflare Access bypass pour endpoint MCP HA"]

**Session precedente** : [numero + lien fichier historique si cree]

**Etapes terminees** :
- [x] [etape 1]
- [x] [etape 2]
- [x] [etape 3]

**Etape en cours** : [1 ligne claire — ex : "ecran Create new self-hosted application, onglet Access policies a remplir"]

**Prochaine action immediate** : [1 ligne — ex : "creer politique `Bypass MCP` avec Action=Bypass + Include=Everyone"]

**Variables contextuelles** :
- URL cible : ...
- Nom strategie : ...
- Email : ...
- Tokens/cookies actifs : ...
- Autres : ...

**Fichiers modifies dans la session precedente** :
- `chemin/fichier1.md` — [nature modif]
- `chemin/fichier2.md` — [nature modif]

**Captures envoyees** : X sur LIMITE_OBSERVEE

**Taches TASKS.md touchees** : #X, #Y

**Point de vigilance pour la suite** : [optionnel — pieges a eviter,
references croisees aux memoires auto, etc.]
```

### Etape 3 — Mettre a jour les fichiers projet

Avant la bascule, Jarvis **doit** mettre a jour :

1. **`TASKS.md`** : ajouter les nouvelles taches nees de la session, mettre
   a jour le statut de celles qui ont avance.
2. **`METRIQUES.md`** : incrementer le compteur sessions, ajouter ligne
   "Modifications HA significatives" si applicable.
3. **`memory/historique/AAAA-MM-JJ_session_NN_titre.md`** : generer un fichier
   historique detaille (meme structure que les sessions precedentes).
4. **`CLAUDE.md`** : si skills ajoutees/supprimees/renommees, mettre a jour
   la section 5.
5. **`.auto-memory/MEMORY.md`** + fichiers feedback : ajouter les nouvelles
   regles ou corrections de comportement apprises pendant la session.

Ces mises a jour garantissent que la prochaine conversation retrouve
l'etat complet via les fichiers projet (meme si Mickael oublie de coller
le resume).

### Etape 4 — Fournir a Mickael le bloc a coller

Presenter le bloc resume dans un bloc de code markdown (pour faciliter
la copie), et lui indiquer :

1. Fermer la conversation saturee (bouton X / onglet fermer).
2. Ouvrir une nouvelle conversation dans le projet Jarvis
   (`claude.ai/project/jarvis-home-assistant` ou equivalent).
3. Coller le bloc resume comme premier message.
4. Jarvis reprendra a l'etape exacte ou on s'etait arrete.

### Etape 5 — Confirmer la bascule

Apres la bascule, si Mickael revient dans la conversation saturee :
- NE PAS tenter de continuer (les fichiers ont deja ete mis a jour).
- Rappeler : *"Bascule effectuee. Continue dans la nouvelle conversation."*

## Exemple minimal de bloc resume (cas Cloudflare session 12)

```markdown
## Resume de reprise — 2026-04-19 HH:MM

**Contexte** : config Cloudflare Access bypass pour endpoint MCP HA (tache #3).

**Session precedente** : session 12 — creation skills guidage-photo-etape, cloudflare-access-ha, bascule-conversation.

**Etapes terminees** :
- [x] Creation skill `guidage-photo-etape`
- [x] Creation skill `cloudflare-access-ha`
- [x] Creation skill `bascule-conversation`
- [x] Creation politique CF `MCP-Might-Access` (**FAUSSE — a supprimer**)

**Etape en cours** : correction CF Access — stratégie Allow+MFA a remplacer par Bypass+Everyone.

**Prochaine action immediate** : supprimer `MCP-Might-Access` et creer `Bypass MCP` (Action=Bypass / Include=Everyone) + app `HA MCP Server Bypass` sur path `mcp_server`.

**Variables contextuelles** :
- Domaine : `ha.might.ovh`
- Path MCP : `mcp_server`
- Email CF : `might@live.fr`
- Compte CF : Might@live.fr's Access

**Fichiers modifies dans la session 12** :
- `.claude/skills/guidage-photo-etape/SKILL.md` (creation)
- `.claude/skills/cloudflare-access-ha/SKILL.md` (creation)
- `.claude/skills/bascule-conversation/SKILL.md` (creation)
- `CLAUDE.md` (section 5)
- `TASKS.md` (tache #3 mise a jour + nouvelles taches)
- `METRIQUES.md` (+1 session)
- `memory/historique/2026-04-19_session_12_*.md` (creation)
- `.auto-memory/MEMORY.md` + 3 nouveaux feedbacks

**Captures envoyees** : 5 sur LIMITE_OBSERVEE (provisoire 6).

**Taches TASKS.md touchees** : #3 (bypass — erreur a corriger), #24 nouvelle (trio skills), #25 nouvelle (calibrage LIMITE_OBSERVEE).

**Point de vigilance** : ne PAS appliquer Allow+MFA sur `/mcp_server/*` — toujours Bypass+Everyone (voir memoire `feedback_cf_mcp_bypass_not_allow.md`).
```

## Evolutions prevues de la skill

- [ ] Calibrage precis de `LIMITE_OBSERVEE` apres premiere mesure reelle (Mickael fournira la valeur).
- [ ] Integration d'un "mode silencieux" ou Jarvis bascule automatiquement sans demander confirmation (si Mickael l'active un jour).
- [ ] Hook vers `session-closure` quand la bascule est aussi une fin de session (pas juste une pause).
- [ ] Export du resume en fichier .md dans `memory/resumes_reprise/` pour archive.
- [ ] Integration optionnelle avec un MCP "Claude.ai API" pour creer la nouvelle conversation automatiquement (feature future).

## Differences avec session-closure

| Aspect | `session-closure` | `bascule-conversation` |
|--------|-------------------|------------------------|
| Declencheur | Fin normale, utilisateur dit "on s'arrete" | Urgence limite images / contexte |
| Objectif | Archiver proprement | Transferer etat sans perte |
| Priorite | Documentation | Continuite operationnelle |
| Resume de reprise | Optionnel | **Obligatoire** |
| Nouvelle conversation | Prochaine fois (jours plus tard) | Immediatement (meme jour) |
| MAJ METRIQUES | Oui | Oui |
| MAJ TASKS | Oui | Oui |
| Historique .md | Oui | Oui |

Les deux skills peuvent etre enchainees : `bascule-conversation` puis
`session-closure` si la bascule acte aussi la fin du travail du jour.

---

*Skill creee le 2026-04-19 (session 12) — version 1.0*
