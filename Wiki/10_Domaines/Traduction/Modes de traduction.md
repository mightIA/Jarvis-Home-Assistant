---
title: Modes de traduction
created: 2026-04-25
updated: 2026-04-25
tags: [atome, traduction, traduction/mode, domaine/traduction]
status: actif
parent: "[[_Index]]"
---

# Modes de traduction

4 modes de la skill `traduction`. Chaque mode a un **but distinct** et ne se
confond pas avec les autres. Mode choisi explicitement par Mickael ou demandé
si ambigu. Jamais de mélange dans une même traduction.

## 1. Mode Professionnel

**But** : contexte pro (email fournisseur, courrier administratif, CV, lettre
de motivation, contrat, documentation officielle).

- Registre **soutenu**, vocabulaire riche, tournures élégantes.
- Formules de politesse adaptées : `Cordialement` / `Best regards` /
  `Mit freundlichen Grüßen`.
- Conserver précision et nuance de la source, même si la phrase s'allonge.
- Respecter les conventions du pays cible (dates, adresses, titres).

## 2. Mode Accessible

**But** : se faire comprendre par une personne qui **lit** la langue cible
mais n'est pas bilingue (famille, ami, collègue débutant).

- Phrases **courtes** (15-20 mots max), structure simple sujet-verbe-complément.
- Vocabulaire **courant** (niveau B1 CEFR maximum). Éviter les idiomes et
  les expressions locales.
- **Paraphraser** ou ajouter 1-2 mots pour éviter un terme complexe. Exemple :
  « la mise en œuvre » → `the way we do it` plutôt que `the implementation`.
- Conserver le sens, même au prix de la forme.

## 3. Mode Technique

**But** : documents techniques ou spécialisés (domotique Home Assistant, CND,
matériel, documentation produit).

- **Charger [[Glossaire technique]]** avant de traduire. Utiliser en priorité
  les termes qui y figurent.
- Conserver les termes **intraduisibles** dans leur langue d'origine
  (`API`, `firmware`, `Zigbee`, `ultrason`) avec glose FR entre parenthèses si
  utile.
- Préserver les unités (°C / °F, mm / inch) en convertissant seulement si
  Mickael le demande.
- Nouveau terme technique rencontré → **proposer l'ajout au glossaire** après
  validation.

## 4. Mode Personnel

**But** : reproduire le style de Mickael, appris au fil des sessions.

- **Charger [[Style personnel]]** avant de traduire.
- Respecter les règles consignées (tournures préférées, mots à éviter, niveau
  de formalité habituel selon destinataire).
- Après chaque traduction Personnel, si Mickael corrige → **formaliser la
  règle apprise** et proposer de l'ajouter au fichier (avec exemple avant /
  après).
- Fichier vide ou minimaliste → prévenir Mickael et proposer de partir d'un
  autre mode, puis enrichir.

## Format de sortie imposé

Toujours préfixer avec direction et mode :

```
> **Mode utilisé** : Technique
>
> **[EN → FR]**
>
> [texte traduit]
```

Variantes : avec *Alternative pour « terme ambigu »* ou avec *Note glossaire*
proposant un ajout.

---

*Atome créé S43. Voir [[_Index]] pour le workflow 7 étapes complet.*
