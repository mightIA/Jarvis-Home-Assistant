---
name: traduction
description: Traduction entre francais, anglais et allemand (toutes directions FR<->EN, FR<->DE, EN<->DE) avec 4 modes adaptatifs - Professionnel (registre soutenu), Accessible (vocabulaire simple pour non-bilingues), Technique (termes specialises via glossaire), Personnel (style de Mickael appris au fil du temps). Declencher cette skill des que Mickael demande de traduire, reformuler dans une autre langue, ou ecrit "traduis/translate/ubersetze", meme sans preciser explicitement le mode. Egalement declencher si Mickael colle un texte etranger et demande ce qu'il signifie, ou demande d'envoyer un message a un correspondant anglophone ou germanophone.
---

# Skill : Traduction FR / EN / DE

## Quand cette skill est declenchee

- Mickael demande explicitement une traduction ("traduis", "translate", "ubersetze", "en anglais", "in German", etc.).
- Mickael colle un texte en EN ou DE et demande ce qu'il signifie, un resume ou un equivalent francais.
- Mickael demande de rediger un email ou un message a destination d'un correspondant non francophone.
- Mickael reformule une phrase francaise pour un public etranger.

## Langues supportees

Uniquement **francais (FR)**, **anglais (EN)** et **allemand (DE)**. Toutes les directions :
FR<->EN, FR<->DE, EN<->DE. Si une autre langue est demandee, prevenir Mickael et proposer
de basculer sur une des trois langues ou de sortir du perimetre de la skill.

## Les 4 modes de traduction

Le mode est choisi **explicitement** par Mickael ou demande s'il n'est pas precise. Chaque mode
a un but distinct et ne se confond pas avec les autres. En cas de doute, demander.

### 1. Mode Professionnel

**But** : traduction soignee pour un contexte pro (email a fournisseur, courrier administratif,
CV, lettre de motivation, contrat, documentation officielle).

- Registre **soutenu**, vocabulaire riche, tournures elegantes.
- Formules de politesse adaptees a chaque langue : "Cordialement" / "Best regards" / "Mit
  freundlichen Gruessen".
- Conserver la precision et la nuance de la version source, meme si la phrase s'allonge
  legerement.
- Respecter les conventions du pays cible (formats de date, adresses, titres).

### 2. Mode Accessible

**But** : se faire comprendre d'une personne qui **lit** la langue cible mais n'est pas
bilingue (famille, ami, collegue debutant).

- Phrases **courtes** (15-20 mots max), structure simple sujet-verbe-complement.
- Vocabulaire **courant** (niveau B1 CEFR maximum). Eviter les idiomes et les expressions
  locales.
- Quitte a **paraphraser** ou a ajouter 1-2 mots pour eviter un terme complexe.
  Exemple : "la mise en oeuvre" -> "the way we do it" plutot que "the implementation".
- Conserver le sens, meme au prix de la forme.

### 3. Mode Technique

**But** : traduction de documents techniques ou specialises (domotique Home Assistant,
CND, materiel, documentation produit).

- Charger le **glossaire personnel** `Ressources/Competences/Traduction_Glossaire.md` avant
  de traduire. Utiliser en priorite les termes qui y figurent.
- Conserver les termes techniques **intraduisibles** dans leur langue d'origine (ex : "API",
  "firmware", "Zigbee", "ultrason") avec une glose francaise entre parentheses si utile.
- Preserver les unites (Celsius/Fahrenheit, mm/inch) en les convertissant seulement si
  Mickael le demande.
- Si un terme technique nouveau apparait : proposer de **l'ajouter au glossaire** apres
  validation.

### 4. Mode Personnel

**But** : reproduire le style de traduction de Mickael, appris au fil des sessions.

- Charger `Ressources/Competences/Traduction_Style_Personnel.md` avant de traduire.
- Respecter les regles consignees (tournures preferees, mots a eviter, niveau de
  formalite habituel selon le type de destinataire, etc.).
- Apres chaque traduction en mode Personnel, si Mickael corrige, **formaliser la regle
  apprise** et proposer de l'ajouter au fichier (avec un exemple avant/apres).
- Si le fichier est vide ou minimaliste, prevenir Mickael et proposer de partir d'un autre
  mode comme base, puis enrichir progressivement.

## Procedure standard de traduction

1. **Identifier** langue source et langue cible (demander si ambigu).
2. **Identifier le mode** (demander si non precise). Par defaut : Professionnel pour les
   emails, Accessible pour un message a un proche, Technique si texte lie a la domotique,
   Personnel si Mickael le demande.
3. **Charger les references** utiles selon le mode :
   - Technique -> glossaire
   - Personnel -> style personnel
4. **Traduire** en respectant les regles du mode.
5. **Presenter** la traduction avec un court rappel du mode utilise.
6. **Proposer** les alternatives si une phrase a plusieurs traductions possibles importantes.
7. **Enrichir** le glossaire ou le fichier style si un nouveau terme ou une correction
   apparait (apres validation).

## Format de sortie

**Traduction simple** (une phrase, un paragraphe) :

> **Mode utilise** : Professionnel
>
> **[DE -> FR]**
>
> [texte traduit]

**Traduction avec alternatives** :

> **Mode utilise** : Accessible
>
> **[FR -> EN]**
>
> [texte traduit principal]
>
> *Alternative pour "[terme ambigu]"* : [autre traduction] si [contexte].

**Traduction avec note glossaire** :

> **Mode utilise** : Technique
>
> **[EN -> FR]**
>
> [texte traduit]
>
> *Note* : "[terme source]" traduit par "[terme cible]" selon le glossaire. Veux-tu
> ajouter "[nouveau terme]" au glossaire ?

## Regles transverses

- **Toujours** indiquer la direction et le mode au-dessus de la traduction.
- **Ne jamais** inventer un terme technique : si un mot est incertain, le signaler
  explicitement.
- **Ne jamais** melanger les modes dans une meme traduction. Si besoin, proposer
  deux versions.
- Conserver la **mise en forme** de la source (listes, paragraphes, ponctuation).
- Pour les **noms propres et lieux** : ne pas traduire sauf si equivalent etabli
  (ex : "Germany" -> "Allemagne", "Nuremberg" reste "Nuremberg").

## Limites

- **Pas d'autres langues** que FR/EN/DE dans cette skill. Refuser poliment et proposer de
  sortir du skill.
- **Pas de traduction automatique** de documents entiers tres longs (> 10 pages) sans
  validation de Mickael : proposer un decoupage par sections.
- **Contenu sensible** (donnees perso, credentials, informations bancaires) : appliquer la
  regle prioritaire du CLAUDE.md section 0 avant de traduire.

## References

- `Ressources/Competences/Traduction_Glossaire.md` — termes techniques FR/EN/DE
- `Ressources/Competences/Traduction_Style_Personnel.md` — style personnel de Mickael
