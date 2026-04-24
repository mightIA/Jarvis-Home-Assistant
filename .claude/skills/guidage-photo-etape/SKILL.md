---
name: guidage-photo-etape
description: Mode de guidage pas-a-pas ou Mickael envoie des captures d'ecran pour avancer dans une procedure de config (Cloudflare, HA, reseau, etc.). Jarvis repond en 2-3 lignes max, une action par message, sans pave explicatif. Inclut l'anticipation de la limite de contexte image de la conversation et propose la bascule de session avec resume de reprise avant d'atteindre le blocage.
---

# Skill : Guidage pas-a-pas par photos

## Quand cette skill est declenchee

- Mickael envoie une **capture d'ecran** d'une interface de configuration
  (Cloudflare, HA, routeur, dashboard, etc.) pour demander quoi faire.
- Mickael dit explicitement *"guide-moi etape par etape"*, *"pas a pas"*,
  *"je suis sur iPhone, reponse courte"*.
- La conversation suit un flux interface -> photo -> action -> photo
  suivante.

## Comportement obligatoire

### Format des reponses

- **2 a 4 lignes maximum** par message, sauf demande explicite contraire.
- **Une seule action a la fois** — jamais d'enchainement d'etapes.
- **Zero pave explicatif**, zero markdown lourd, zero justification longue.
- Si une alerte de securite ou un risque existe : le signaler en UNE ligne
  avant l'action.
- Terminer par une **question courte** : *"Dis-moi quand c'est fait"*,
  *"Envoie la photo suivante"*, *"Tu confirmes ?"*.

### Exemple de bon format

> Clique **Enregistrer** en bas de page.
> Ensuite, retourne sur **Applications** -> **Create new application**.
> Envoie-moi la capture de l'ecran suivant.

### Exemple de mauvais format (a EVITER)

> Parfait, maintenant que la strategie est creee, nous allons pouvoir
> passer a l'etape suivante qui consiste a creer l'application. Pour cela,
> tu dois d'abord retourner dans le menu Access controls, puis cliquer sur
> Applications dans la barre laterale gauche, puis appuyer sur le bouton
> bleu Create new application en haut a droite... *(trop long)*

## Anticipation de la limite d'images / contexte

Les conversations Claude.ai ont une limite de contexte qui se sature vite
quand Mickael envoie beaucoup de captures. Quand c'est atteint, Mickael se
retrouve bloque et doit remonter dans la conversation pour relancer depuis
un message anterieur. A eviter.

### Regle de comptage (seuil configurable)

Jarvis **compte mentalement** les captures recues dans la session en cours.

**Seuil de reference** : `LIMITE_OBSERVEE` = nombre maximum de captures avant
blocage reel observe par Mickael (valeur a renseigner ici par Mickael des
la premiere mesure). Valeur provisoire : `6` (a affiner).

**Seuils d'action** (en fonction de `LIMITE_OBSERVEE`) :

| Nb captures envoyees | Action de Jarvis |
|----------------------|------------------|
| 1 a (LIMITE - 3)     | Normal, rien a signaler |
| LIMITE - 2           | Signal discret en fin de reponse : *"On approche la limite (X/LIMITE)."* |
| LIMITE - 1           | **Alerte active** : proposer la bascule AVANT que Mickael envoie la photo suivante |
| LIMITE et +          | Priorite absolue : refuser les nouvelles photos tant que le resume de reprise n'est pas genere |

**Marge de securite** : Jarvis applique systematiquement `-1 ou -2` par
rapport a la limite observee de Mickael, pour eviter un blocage a la
captures N qui couperait la conversation.

**Mise a jour de la valeur** : quand Mickael fournit une limite mesuree,
Jarvis edite ce fichier pour remplacer la valeur provisoire.

### Procedure de bascule

Quand le seuil d'alerte est atteint, **declencher la skill
`bascule-conversation`** qui se charge de tout :

- Test de compatibilite pre-bascule (pas de fichier HA en attente, pas
  de script en cours, pas de ban IP non resolu).
- Generation du bloc resume de reprise (template standard).
- Mise a jour des fichiers projet (TASKS, METRIQUES, historique, CLAUDE.md,
  auto-memory).
- Presentation du bloc a Mickael pour copier-coller dans nouvelle conversation.

Message type minimal a envoyer a Mickael avant d'activer `bascule-conversation` :

> On est a X/LIMITE captures, on approche la limite.
> Je lance la bascule (resume de reprise + MAJ fichiers) ?

### Contenu du resume de reprise

Quand Mickael valide la bascule, Jarvis genere un bloc markdown unique
contenant :

```markdown
## Resume de reprise - [date YYYY-MM-JJ HH:MM]

**Contexte** : [1 ligne - ex: config Cloudflare Access pour endpoint MCP HA]

**Etapes terminees** :
- [x] ...
- [x] ...

**Etape en cours** : [1 ligne - ex: creation de la self-hosted app, ecran Additional settings]

**Prochaine action** : [1 ligne claire]

**Variables contextuelles** :
- URL cible : ...
- Nom strategie : ...
- Email : ...
- Autres : ...

**Fichiers modifies ce jour** : [liste ou aucun]

**Limite atteinte** : X captures envoyees dans la session precedente.
```

Mickael doit pouvoir copier-coller ce bloc dans la nouvelle conversation
et reprendre sans perte d'information.

## Test de compatibilite avant bascule

Avant de proposer la bascule, Jarvis doit verifier rapidement :

1. **Aucune action en attente d'ecriture** sur un fichier HA critique
   (config.yaml, automations.yaml) — sinon finir l'ecriture d'abord.
2. **Aucun script HA en cours** declenche pendant la session (ha-scripts).
3. **Pas de ban IP actif non resolu** — sinon finir le debannissement
   avant la bascule.

Si un de ces points n'est pas OK : Jarvis annonce le blocage et demande a
Mickael quoi faire (continuer et risquer le blocage, ou resoudre d'abord).

## Limite technique honnete

Jarvis ne peut **pas** mesurer le poids exact d'une image avant qu'elle
soit envoyee. Le comptage est approximatif (nombre de captures dans la
session, pas octets). L'alerte a 5 captures est une estimation
conservatrice basee sur des captures plein ecran type 2600x1300 px.

Si Mickael envoie des petites captures (crop), la limite reelle peut etre
atteinte plus tard — dans ce cas, Jarvis peut ajuster et repousser
l'alerte a 7-8 captures.

## Sortie du mode

Le mode guidage-photo-etape s'arrete quand :

- Mickael dit *"on a fini"*, *"c'est bon"*, ou *"passons a autre chose"*.
- La procedure complete est terminee (bascule reussie ou tache close).
- Mickael repasse en mode PC et demande des reponses detaillees.

---

*Skill creee le 2026-04-19 — version 1.0*
