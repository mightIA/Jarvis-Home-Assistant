---
id: 18
title: "Valider la methode de tri emails par vagues (selection par lots avec 'Vider l..."
status: done
priority: P2
session_opened: S9
session_closed: S82
tags: [email, tri-email]
source: "Verification 19/04/2026"
---

# T#18 — Valider la methode de tri emails par vagues (selection par lots avec 'Vider l...

## Description

**[A TESTER ENSEMBLE]** Valider la methode de tri emails par vagues (selection par lots avec "Vider le dossier" spam)

## Contexte (mis à jour S82)

Méthode documentée `Ressources/Competences/Gestion_Emails.md` Phase 1 Étape 2 : sélection 20-50 emails par vague avec cases à cocher, suppression vague par vague.

**Scope réduit à Outlook depuis S82** : le MCP Gmail custom (installé S25) avec `batch_modify_emails` / `batch_delete_emails` (lots de 50 messageIds) rend la méthode UI navigateur obsolète pour Gmail. Côté Outlook il n'y a pas de MCP (cf. T#48), donc la méthode vagues UI reste utile en attendant.

## Protocole de test (option A retenue S82)

À exécuter lors du **prochain tri Outlook live** sur Brave + extension Claude in Chrome :

1. Ouvrir `https://outlook.live.com` dans onglet Brave connecté à Claude in Chrome
2. Dossier **Courrier indésirable** : bouton « Vider le dossier » → noter nombre supprimé
3. Boîte de réception : sélectionner par **vagues de 20-50** via cases à cocher
4. Supprimer **chaque vague** avant de passer à la suivante (limite risque si UI Outlook bug)
5. Compter le total + comparer perçu vs méthode unitaire (temps gagné, fiabilité)
6. **Conclure** : valider la méthode, ajuster taille vagues, ou rejeter si UI Outlook bug

## Source / Échéance

Verification 19/04/2026 (S9) — option A retenue 01/05/2026 (S82)

## Statut

✅ done — méthode validée S82 (01/05/2026) lors d'un tri Outlook live (45 spam + 1 MSF mal classé → 0).

### Résultats du test S82

- **Vague 1** : 14 emails supprimés en 2 clics (case 1er email + Shift+clic case dernier visible). Mécanique OK, pas de bug UI.
- **Vague 2** : 14 emails supprimés (même méthode, même résultat).
- **Reste 17** : finis avec « Vider le dossier » (1 clic + confirmation pop-up Outlook) — plus rapide que vagues quand tout est jetable.
- **Bug UI Outlook web découvert** : mode Sélection **sticky** (re-clic « Sélectionner » et `Esc` ne désactivent pas). Workaround : `F5` pour reset. À documenter dans `Gestion_Emails.md`.

### Recommandations finales

- **Méthode « Vider le dossier »** quand tout est jetable (ex: spam pur, dossier "À supprimer") → 1 clic.
- **Méthode vagues** quand tri sélectif partiel (garder certains, supprimer les autres) → 2 clics par vague.
- **Méthode unitaire** quand très peu de mails à traiter (< 5).
