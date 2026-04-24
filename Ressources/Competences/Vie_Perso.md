---
title: Prompt "Vie perso" — version 2 (validée)
statut: À lancer (V1 uniquement au démarrage)
created: 2026-04-20 (session 20)
source: discussion Cowork fallback iPhone
moved: 2026-04-23 (session 33) — depuis Projets/Vie_Perso/PROMPT_v2.md vers Ressources/Competences/Vie_Perso.md (PDF en Vie_Perso.pdf à côté)
---

# Prompt « Vie perso » — v2

Ce document archive le prompt validé par Mickael, à coller dans une **nouvelle session Cowork** pour lancer la fonction « Vie perso » (todo personnel + calendrier + alarmes + future app web).

> **Important** : seule la **V1** doit être construite après collage. Les phases V2, V3, V4 ne se lancent qu'avec feu vert explicite.

---

## Prompt à copier

```
Jarvis, je veux ajouter une fonction "Vie perso" (todo personnel) en
parallèle de TASKS.md (qui reste réservé au projet Jarvis/HA).

OBJECTIFS
- Liste de choses à faire pour ma vie quotidienne :
  rappels email, appels téléphoniques, courses, gens à voir, divers.
- 3 niveaux de priorité : Haute / Moyenne / Faible.
- Rappels proactifs : début de session + scans planifiés (matin/soir).
- Gestion des alarmes (sonneries) distinctes des rappels (notifications).
- Accès et modification du calendrier (Google Calendar).
- Notifications multi-canaux par phases :
  - V1 : email (might57290@gmail.com) + notify.mobile_app HA.
  - V2 : SMS via Free Mobile API (gratuit, mon opérateur).
  - V3+ : à définir plus tard.

MODÈLE DE TÂCHE
- Titre, priorité, catégorie, échéance, statut.
- Récurrence (quotidien/hebdo/mensuel/annuel) → courses, anniversaires.
- Tags contextuels (@maison, @courses, @téléphone, @bureau).
- Personne liée (Stéphanie, enfants, parents, amis…).
- Notes / sous-tâches.
- Visibilité (publique / privée — non lue à voix haute).
- Lien calendrier (si tâche = événement daté).

SOURCES D'ENTRÉE
- Commande directe ("ajoute…", "rappelle-moi…").
- Dictée vocale iPhone (Dispatch) avec parsing naturel
  "rappelle-moi mardi d'appeler le médecin" → tâche structurée.
- Détection auto depuis Gmail (factures → rappel paiement, RDV → tâche).
- Import / sync Google Calendar (événements, anniversaires).

RAPPELS INTELLIGENTS
- Snooze (10 min, 1 h, demain, semaine pro).
- Mode "Ne pas déranger" (22h-7h, sauf priorité Haute).
- Récap hebdo dimanche 19h (faites / à venir / en retard).

CONTRAINTES D'USAGE MOBILE
- iPhone verrouillé : je ne peux PAS installer d'app tierce libre.
- → L'interface mobile doit passer par navigateur (PWA / page web).
- Tablette et PC : pas de restriction, app native ou web OK.
- Toute app future doit être accessible depuis ces 3 supports.

À ME PROPOSER (pour mise en place progressive)
1. Structure de fichiers
   - Emplacement (ex. Ressources/Perso/PERSO.md ou racine ?).
   - Format markdown : sections par priorité ou par catégorie ?
   - Historique / archivage des tâches faites.

2. Skill dédiée (.claude/skills/vie-perso/SKILL.md)
   - Triggers : "ajoute à ma todo perso", "rappelle-moi de…",
     "qu'est-ce que j'ai à faire", "mes courses",
     "mets une alarme", "ajoute au calendrier", etc.
   - Sous-commandes : ajouter, lister, marquer fait, reporter,
     supprimer (avec confirmation explicite si priorité Haute),
     créer/modifier alarme, créer/modifier événement calendrier.

3. Tâches planifiées (scheduled-tasks)
   - Scan matin (ex. 7h) : rappels du jour + en retard.
   - Scan soir (ex. 19h) : récap + lendemain.
   - Récap hebdo dimanche 19h.
   - Notif via email + HA mobile_app.

4. Intégration Home Assistant
   - Utiliser todo.* natif HA (supporté par iOS app).
   - Dashboard Lovelace dédié "Vie perso" (cartes par priorité).
   - Entité calendar.* HA synchronisée Google Calendar.
   - Helper input_datetime pour alarmes programmables.

5. Sécurité / sauvegarde
   - Backup chiffré OneDrive + Git privé (cohérent Backup_Jarvis.md).
   - Pas de partage hors session.
   - Confirmation avant suppression d'une tâche Haute ou événement.
   - Anti-spam : max 3 notifs/jour par tâche.

6. Plan en phases
   - V1 (immédiat) :
     structure fichiers + skill + email/HA + scans planifiés.
   - V2 (ensuite) :
     SMS Free Mobile + détection Gmail auto + lecture Google Calendar.
   - V3 (plus tard) :
     écriture Google Calendar + gestion alarmes depuis Jarvis.
   - V4 (futur, PAS MAINTENANT — on en reparlera) :
     application web / PWA responsive accessible iPhone (navigateur),
     tablette et PC, pour gérer listes, rappels, alarmes, calendrier
     en visuel — ajout/suppression/modif rapides hors session Cowork.

LIVRABLES ATTENDUS (V1 uniquement pour démarrer)
- Proposition d'arborescence + fichiers à créer.
- Brouillon de SKILL.md vie-perso.
- Brouillon de PERSO.md avec exemples.
- Liste des scheduled-tasks à créer.
- Demande de validation avant toute création de fichier.
- NE PAS démarrer V2/V3/V4 sans feu vert explicite de ma part.
```

---

## Historique

- **2026-04-20 (session 20)** : prompt élaboré en fallback iPhone (4 itérations). Enrichissements retenus : calendrier Google, contraintes mobile (pas d'install app iPhone), phase V4 app web future.
- Version 1 (initiale) et version intermédiaire archivées dans la conversation Claude.ai d'origine.
