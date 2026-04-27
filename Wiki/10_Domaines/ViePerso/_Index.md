---
title: Vie perso — Hub
created: 2026-04-25
updated: 2026-04-25
tags: [moc, hub, vieperso]
parent: "[[00_Index/_Index]]"
status: actif
---

# Vie perso

Hub central de la **fonction Vie perso** de Jarvis : todo personnel
(distinct de `TASKS.md` réservé au projet Jarvis/HA), boîtes email perso,
identités GitHub, macros clavier/pad. Ces atomes regroupent tout ce qui
touche à la vie de Mickael en dehors du projet domotique strict.

> **Statut V1** : la fonction Vie perso est **prête à lancer** (prompt V2
> validé S20, archivé dans `[[Prompt Vie perso]]`). V1 = structure
> fichiers + skill + email/HA + scans planifiés. V2/V3/V4 ne se lancent
> pas sans feu vert explicite.

> **Règle 0** rappelée : avant tout accès à des boîtes email, identifiants
> GitHub ou tokens OAuth, Jarvis s'arrête, décrit ce qui serait vu, et
> n'agit que sous accord explicite.

## Atomes du domaine

- `[[Prompt Vie perso]]` — prompt V2 validé S20 + plan en 4 phases V1→V4
- `[[Macros clavier]]` — catalogue v1 (G915 + G502 + Tartarus V2) + méthodologie
- `[[Boites email perso]]` — 4 boîtes Mickael + canal de tri actuel + multi-MCP
- `[[Identites GitHub]]` — compte `mightIA` + procédure ajout autres comptes

## Règles transverses Vie perso

- **TASKS.md séparé** : `TASKS.md` à la racine projet est **réservé au
  projet Jarvis/HA**. Le todo personnel ira dans un fichier dédié
  (probablement `Ressources/Perso/PERSO.md` ou via `todo.*` natif HA — à
  trancher V1).
- **Mobilité iPhone verrouillée** : Mickael ne peut PAS installer d'app
  tierce libre sur iPhone → toute interface mobile passe par navigateur
  (PWA / page web). Tablette + PC : pas de restriction.
- **Multi-canaux par phases** :
  - V1 : email (`might57290@gmail.com`) + `notify.mobile_app` HA
  - V2 : SMS via Free Mobile API (gratuit, opérateur Mickael)
  - V3+ : à définir
- **Sécurité** : backup chiffré OneDrive + Git privé (cohérent
  `Backup_Jarvis.md`), confirmation avant suppression d'une tâche Haute
  ou événement, anti-spam max 3 notifs/jour par tâche.

## Workflow démarrage Vie perso

1. Coller le prompt de `[[Prompt Vie perso]]` dans une nouvelle session
   Cowork.
2. Jarvis propose : structure fichiers + brouillon SKILL.md
   `vie-perso` + brouillon `PERSO.md` + liste scheduled-tasks (V1).
3. Mickael valide AVANT toute création de fichier.
4. **NE PAS démarrer V2/V3/V4 sans feu vert explicite**.

## Liens externes

- Source prompt : `Ressources/Competences/Vie_Perso.md` (+ PDF à côté)
- Source macros : `Ressources/Competences/Macros_Clavier.md`
- Auto-memories Vie perso :
  - `reference_boites_email` (4 boîtes + canal tri)
  - `reference_compte_github_might` (compte `mightIA`)
  - `feedback_email_boite_explicite` (toujours nommer la boîte)
- Hub Email : `[[10_Domaines/Email/_Index]]` (technique tri)

## Tags

`#vieperso/prompt` `#vieperso/macros` `#vieperso/email`
`#vieperso/github` `#vieperso/calendrier` `#vieperso/mobilite`
