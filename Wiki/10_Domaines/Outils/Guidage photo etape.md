---
title: Guidage pas-à-pas par photos
created: 2026-04-25
tags: [outils/guidage-photo, productivite]
parent: "[[_Index]]"
status: actif
---

# Guidage photo étape — skill `guidage-photo-etape`

Mode de guidage pas-à-pas où Mickael envoie des **captures d'écran**
pour avancer dans une procédure de config (Cloudflare, HA, réseau, etc.).
Jarvis répond en **2-3 lignes max**, **une action par message**, sans
pavé explicatif. Inclut l'**anticipation de la limite de contexte image**
de la conversation.

## Quand cette skill est déclenchée

- Mickael envoie une capture d'écran d'une interface de config.
- Mickael dit *"guide-moi étape par étape"*, *"pas à pas"*, *"je suis
  sur iPhone, réponse courte"*.
- Conversation suit un flux **interface → photo → action → photo
  suivante**.

## Comportement obligatoire

### Format des réponses

- **2 à 4 lignes max** par message, sauf demande explicite contraire.
- **Une seule action à la fois** — jamais d'enchaînement d'étapes.
- **Zéro pavé explicatif**, zéro markdown lourd, zéro justification longue.
- Alerte sécu/risque : signaler en UNE ligne avant l'action.
- Terminer par question courte : *"Dis-moi quand c'est fait"*, *"Envoie
  la photo suivante"*, *"Tu confirmes ?"*.

### Bon exemple

> Clique **Enregistrer** en bas de page.
> Ensuite, retourne sur **Applications → Create new application**.
> Envoie-moi la capture suivante.

### Mauvais exemple (à éviter)

> Parfait, maintenant que la stratégie est créée, nous allons pouvoir
> passer à l'étape suivante qui consiste à créer l'application. Pour
> cela, tu dois d'abord retourner dans le menu Access controls, puis
> cliquer sur Applications dans la barre latérale gauche... *(trop long)*

## Anticipation limite images / contexte

Les conversations Claude.ai ont une limite de contexte qui se sature
vite avec beaucoup de captures. À éviter.

### Règle de comptage

`LIMITE_OBSERVEE` = nombre max de captures avant blocage réel.
Valeur provisoire : **6** (à affiner après mesure).

| Captures envoyées | Action de Jarvis |
|---|---|
| 1 à (LIMITE - 3) | Normal, rien à signaler |
| LIMITE - 2 | Signal discret en fin de réponse : *"On approche la limite (X/LIMITE)."* |
| LIMITE - 1 | **Alerte active** : proposer la bascule AVANT photo suivante |
| LIMITE et + | Refuser nouvelles photos tant que résumé reprise pas généré |

**Marge de sécurité** : appliquer systématiquement `-1 ou -2` par
rapport à la limite observée.

### Procédure de bascule

Quand seuil atteint → **déclencher [[Bascule conversation]]** qui se
charge de tout (test compat + résumé + MAJ TASKS/METRIQUES/historique +
bloc à coller).

Message type avant bascule :

> On est à X/LIMITE captures, on approche la limite.
> Je lance la bascule (résumé reprise + MAJ fichiers) ?

## Limite technique honnête

Jarvis ne peut **pas** mesurer le poids exact d'une image avant qu'elle
soit envoyée. Le comptage est approximatif (nombre de captures, pas
octets). Si captures petites (crop), repousser l'alerte à 7-8.

## Sortie du mode

Le mode s'arrête quand :
- Mickael dit *"on a fini"*, *"c'est bon"*, *"passons à autre chose"*.
- Procédure complète terminée.
- Mickael repasse en mode PC et demande des réponses détaillées.

## Liens

- Skill source : `.claude/skills/guidage-photo-etape/SKILL.md`
- Skill enchaînée : `[[Bascule conversation]]`
- Auto-memories : `feedback_guidage_photo_etape`, `feedback_anticipation_limite_images`
