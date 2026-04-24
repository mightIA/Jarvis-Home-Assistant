---
name: tri-email-outlook
description: Tri quotidien des emails de la boite Outlook might@live.fr. Pas de connecteur MCP Outlook — tout passe par le navigateur Brave (Claude in Chrome). Utilise l'auto-apprentissage via whitelist / blacklist / learning_log JSON et les scores de confiance 0-100. Genere un rapport journalier envoye par email auto-envoi.
---

# Skill : Tri email Outlook

## Quand cette skill est declenchee

- Toute question parlant du tri Outlook, de la boite might@live.fr,
  de courrier indesirable Outlook.
- La tache planifiee `tri-email-outlook-quotidien` (5h, 14h).
- A la demande explicite de Mickael ("trie ma boite Outlook").

## Boite ciblee

`might@live.fr` (Outlook / Microsoft Live) — voir
`Ressources/Protocoles/Outlook.md` pour le detail complet du protocole.

URL : `https://outlook.live.com/mail/0/inbox`

## Difference cle vs Gmail

Pas de connecteur MCP. Tout le scan + actions se fait via le navigateur.
Plus lent, mais workflow identique (whitelist / blacklist / scores /
rapport).

## Fichiers de configuration

| Fichier                                                 | Role           |
|---------------------------------------------------------|----------------|
| `Ressources/Data/outlook_patterns/whitelist.json`       | 13 expediteurs proteges |
| `Ressources/Data/outlook_patterns/blacklist.json`       | 14 expediteurs a supprimer (avec score) |
| `Ressources/Data/outlook_patterns/learning_log.json`    | Journal des sessions |

## Workflow en 8 etapes

1. **Ouvrir** Outlook dans le navigateur, verifier session active.
2. **Lire** les patterns (whitelist + blacklist).
3. **Scanner** la boite de reception (lire la page).
4. **Vider** le Courrier indesirable (Selectionner tout + Supprimer).
5. **Supprimer** les emails de score >= 90 (bouton Selectionner +
   icone corbeille).
6. **Envoyer** le rapport journalier par email a `might@live.fr`
   (Nouveau message > auto-envoi).
7. **Attendre** la validation Mickael (G / S / A) si emails a valider.
8. **Mettre a jour** patterns + `learning_log.json`.

## Cas particuliers documentes

| Expediteur            | Garder                                     | Supprimer                          |
|-----------------------|--------------------------------------------|------------------------------------|
| AliExpress            | Confirmations < 30 jours, suivi colis      | Demandes d'avis anciennes          |
| Orange                | Factures Internet                          | Promos VOD, offres mini prix       |
| Courrier International| Alertes editoriales (actualite)            | Promos boutique                    |

## Regles de securite

- Jamais vider les Elements supprimes sans validation explicite.
- Jamais envoyer un email (autre que le rapport auto) sans confirmation.
- Toujours verifier que la session Outlook est active avant d'agir.
- Toujours utiliser le bouton "Selectionner" pour les selections en lot.

## Reference longue

Voir `Ressources/Protocoles/Outlook.md` (v1.0 — 18 avril 2026).
