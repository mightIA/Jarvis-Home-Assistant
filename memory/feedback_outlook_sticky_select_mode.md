---
name: Outlook web — mode Sélection sticky, F5 obligatoire
description: Dans Outlook web, le mode "Sélectionner" reste actif après suppression — re-clic et Esc ne le désactivent pas. Reset via F5 obligatoire.
type: feedback
---

# Outlook web — mode Sélection sticky

Découvert lors du test T#18 (S82, 01/05/2026) : dans Outlook web (https://outlook.live.com), une fois le bouton **« Sélectionner »** activé en haut de la liste de mails, le mode multi-sélection reste **collé** même après :

- Suppression d'une vague d'emails
- Re-clic sur le bouton « Sélectionner »
- Touche `Esc`
- Click ailleurs dans la page

**Why** : le bouton « Sélectionner » dans Outlook web n'est pas un toggle propre. Tant que le mode est actif, la barre du haut affiche **« Supprimer ⌄ »** au lieu de **« Vider le dossier »**, ce qui empêche d'utiliser ce dernier sans repasser par une sélection.

**How to apply** : pour sortir du mode Sélection (et faire réapparaître **« Vider le dossier »**), faire **F5** (rafraîchir la page). C'est le seul moyen fiable observé. À documenter dans `Ressources/Competences/Gestion_Emails.md` Phase 1 Étape 2 (fait S82).

Conséquence pour le tri Outlook : toujours décider **avant de cliquer « Sélectionner »** si on veut faire des vagues OU « Vider le dossier ». Si on veut « Vider le dossier » après avoir activé Sélection → F5 obligatoire.
