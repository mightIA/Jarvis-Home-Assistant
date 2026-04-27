---
title: Bascule de conversation — urgence limite contexte
created: 2026-04-25
tags: [outils/bascule, productivite]
parent: "[[_Index]]"
status: actif
---

# Bascule conversation — skill `bascule-conversation`

Transition propre d'une conversation Claude.ai saturée vers une
nouvelle conversation, sans perdre l'état du travail en cours. Distincte
de `session-closure` (fin normale).

## Quand cette skill est déclenchée

- `[[Guidage photo etape]]` a détecté `LIMITE - 1` captures atteintes.
- Mickael demande explicitement *"bascule"*, *"archive et relance"*,
  *"on approche la limite"*.
- Erreur Claude.ai indiquant contexte saturé.

## Workflow en 5 étapes

### 1. Test de compatibilité pré-bascule

Vérifier qu'il n'y a pas de **travail en attente** qui serait perdu :

| Check | Action si bloqué |
|---|---|
| Fichier HA critique en cours d'écriture | Finir l'écriture AVANT |
| Script HA lancé pendant la session | Attendre fin ou décrire statut |
| Ban IP actif non résolu | Finir débannissement AVANT |
| Modif Cloudflare en attente de Save | Demander à Mickael de sauver |
| Connecteur MCP en cours d'appairage | Finir étape OAuth |
| `.claude/skills/*/SKILL.md` non sauvegardé | Sauver AVANT |

Si bloqué : **ne PAS basculer** tant que pas résolu.

### 2. Générer le résumé de reprise

Template à fournir à Mickael (copier-coller dans nouvelle conv) :

```markdown
## Resume de reprise — [AAAA-MM-JJ HH:MM]

**Contexte** : [1 phrase]
**Session précédente** : [n° + lien historique]

**Étapes terminées** :
- [x] ...

**Étape en cours** : [1 ligne claire]
**Prochaine action immédiate** : [1 ligne]

**Variables contextuelles** :
- URL cible : ...
- Nom stratégie : ...
- Email : ...

**Fichiers modifiés** :
- chemin/fichier1.md — [nature modif]

**Captures envoyées** : X sur LIMITE_OBSERVEE
**Tâches TASKS.md touchées** : #X, #Y
**Point de vigilance** : [optionnel]
```

### 3. MAJ fichiers projet AVANT bascule

1. **`TASKS.md`** : nouvelles tâches + statut.
2. **`METRIQUES.md`** : compteur sessions + ligne MAJ HA.
3. **`memory/historique/AAAA-MM-JJ_session_NN_titre.md`** : archive
   détaillée (même structure que sessions précédentes).
4. **`CLAUDE.md`** : si skills ajoutées/supprimées/renommées.
5. **`.auto-memory/MEMORY.md`** + fichiers feedback : nouvelles règles.

> Ces MAJ garantissent que la prochaine conv retrouve l'état complet
> via les fichiers projet, **même si Mickael oublie de coller le résumé**.

### 4. Fournir le bloc à coller

Présenter le résumé dans bloc triple backtick + indiquer à Mickael :
fermer la conv saturée, ouvrir une nouvelle conv projet Jarvis, coller
le bloc comme premier message, Jarvis reprendra à l'étape exacte.

### 5. Confirmer la bascule

Si Mickael revient dans la conv saturée : NE PAS continuer, rappeler
*"Bascule effectuée. Continue dans la nouvelle conversation."*

## Différences avec `session-closure`

| Aspect | `session-closure` | `bascule-conversation` |
|---|---|---|
| Déclencheur | Fin normale "on s'arrête" | Urgence limite contexte |
| Objectif | Archiver proprement | Transférer état sans perte |
| Priorité | Documentation | Continuité opérationnelle |
| Résumé reprise | Optionnel | **Obligatoire** |
| Nouvelle conv | Plus tard (jours) | Immédiatement (même jour) |
| MAJ METRIQUES + TASKS + .md historique | Oui | Oui |

Les 2 skills peuvent s'enchaîner si la bascule acte aussi la fin du
travail du jour.

## Chaînage typique

```
[procédure longue avec captures]
        |
        v
[[Guidage photo etape]]   (mode terse + comptage)
        |
        v  (à LIMITE - 1)
bascule-conversation (cette skill)
        |
        v  (si fin de travail)
session-closure
```

## Liens

- Skill source : `.claude/skills/bascule-conversation/SKILL.md`
- Skill complémentaire : `[[Guidage photo etape]]`
- Auto-memories : `feedback_anticipation_limite_images`, `feedback_fin_session_menu_archivage`
