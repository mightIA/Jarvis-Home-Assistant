---
title: Prompt Vie perso v2 (validé)
created: 2026-04-25
tags: [vieperso/prompt, prompt]
parent: "[[_Index]]"
status: actif-en-attente
---

# Prompt Vie perso — v2 (validé S20)

Pointeur vers `Ressources/Competences/Vie_Perso.md` (et PDF
`Vie_Perso.pdf` à côté). Ce prompt est **prêt à coller dans une nouvelle
session Cowork** pour lancer la fonction Vie perso (todo personnel +
calendrier + alarmes + future app web).

## Statut

- ✅ Prompt v2 validé S20 (20/04/2026, 4 itérations en fallback iPhone)
- ⏳ V1 à construire (pas encore lancée)
- 🔒 V2/V3/V4 ne se lancent QUE sur feu vert explicite

## Plan en 4 phases

| Phase | Périmètre | Statut |
|---|---|---|
| **V1** | Structure fichiers + skill `vie-perso` + email/HA + scans planifiés (matin/soir + récap dimanche 19h) | ⏳ à lancer |
| **V2** | SMS Free Mobile + détection Gmail auto + lecture Google Calendar | 🔒 feu vert requis |
| **V3** | Écriture Google Calendar + gestion alarmes depuis Jarvis | 🔒 feu vert requis |
| **V4** | App web / PWA responsive iPhone+tablette+PC | 🔒 feu vert requis |

## Modèle de tâche Vie perso

- Titre, priorité (Haute / Moyenne / Faible), catégorie, échéance, statut
- Récurrence (quotidien/hebdo/mensuel/annuel) → courses, anniversaires
- Tags contextuels (`@maison`, `@courses`, `@téléphone`, `@bureau`)
- Personne liée (Stéphanie, enfants, parents, amis…)
- Notes / sous-tâches
- Visibilité (publique / privée — non lue à voix haute)
- Lien calendrier (si tâche = événement daté)

## Sources d'entrée

- Commande directe (`"ajoute…"`, `"rappelle-moi…"`)
- Dictée vocale iPhone (Dispatch) avec parsing naturel
- Détection auto depuis Gmail (factures → rappel paiement, RDV → tâche)
- Import / sync Google Calendar (événements, anniversaires)

## Rappels intelligents

- Snooze (10 min, 1 h, demain, semaine prochaine)
- Mode "Ne pas déranger" (22h-7h, sauf priorité Haute)
- Récap hebdo dimanche 19h (faites / à venir / en retard)

## Contraintes mobilité

- iPhone verrouillé → **pas d'app tierce libre installable**
- → Interface mobile uniquement par **navigateur (PWA / page web)**
- Tablette + PC : pas de restriction (app native ou web OK)

## Livrables attendus V1

1. Proposition d'arborescence + fichiers à créer (ex.
   `Ressources/Perso/PERSO.md` ou racine ?)
2. Brouillon `SKILL.md` `vie-perso`
3. Brouillon `PERSO.md` avec exemples
4. Liste des scheduled-tasks (matin 7h, soir 19h, récap dimanche 19h)
5. **Demande de validation avant toute création de fichier**

## Triggers prévus pour la skill `vie-perso`

`"ajoute à ma todo perso"`, `"rappelle-moi de…"`, `"qu'est-ce que j'ai
à faire"`, `"mes courses"`, `"mets une alarme"`, `"ajoute au
calendrier"`, etc.

## Sous-commandes prévues

- Ajouter, lister, marquer fait, reporter
- Supprimer (avec **confirmation explicite** si priorité Haute)
- Créer/modifier alarme
- Créer/modifier événement calendrier

## Intégration Home Assistant prévue

- `todo.*` natif HA (supporté par iOS app)
- Dashboard Lovelace dédié "Vie perso" (cartes par priorité)
- Entité `calendar.*` HA synchronisée Google Calendar
- Helper `input_datetime` pour alarmes programmables

## Liens

- Source complète (prompt à copier) : `Ressources/Competences/Vie_Perso.md`
- PDF (généré S21) : `Ressources/Competences/Vie_Perso.pdf`
- Skill (à créer V1) : `.claude/skills/vie-perso/SKILL.md`
- Macros liées : `[[Macros clavier]]` (section 5 "Vie perso")
- Tâche TASKS.md : #35 "Lancer fonction Vie perso V1"
