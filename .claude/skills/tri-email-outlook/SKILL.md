---
name: tri-email-outlook
description: Tri quotidien automatise des emails Outlook might@live.fr. DECLENCHEURS : 'tri Outlook', 'trie ma boite Outlook', 'fais le tri Outlook quotidien', 'lance tri-email-outlook', 'rapport tri Outlook', 'vide spam Outlook', 'Outlook scan'. Pas de MCP Outlook — workflow navigateur (Brave + Claude in Chrome). Auto-apprentissage via whitelist/blacklist/learning_log JSON + scores 0-100. Genere un rapport journalier envoye par auto-mail. Tache planifiee 5h/14h. T#48 ouverte pour rechercher un MCP Outlook.
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


## Exemples d'invocation utilisateur

- « Lance le tri Outlook » → workflow 8 etapes complet, rapport auto-envoye.
- « Vide juste le spam Outlook » → etape 4 uniquement (Selectionner tout + Supprimer dans Courrier indesirable).
- « Ajoute X a la whitelist Outlook » → editer `whitelist.json`, persister, mentionner dans `learning_log.json`.
- « Pourquoi tu as supprime cet email Lidl ? » → consulter `blacklist.json` + score, expliquer la regle.

## Quand NE PAS utiliser

- Pour Gmail — utiliser `tri-email-gmail` (MCP natif, beaucoup plus rapide).
- Pour un tri INTERACTIF/manuel d'Outlook ou pour le grand nettoyage initial — utiliser la skill jumelle `tri-email-outlook-priorites` (4 dossiers Urgent/Perso/Info/A-supprimer + validation Mickael).
- Pour rediger une reponse a un email — passer a `redaction-email`.
- Si la tache planifiee plante 2 fois de suite : NE PAS retenter en boucle, suspendre et alerter Mickael (probable session Outlook expiree ou ban).

## Pieges connus

- **Session Outlook expiree** : 1re cause d'echec. Verifier `tabs_context_mcp` + screenshot AVANT toute action. Si deconnecte, demander a Mickael de se reconnecter manuellement (jamais de credentials).
- **Popup "Ne jamais envoyer..."** : apparait quand on deplace depuis Courrier indesirable. TOUJOURS DECOCHER avant OK, sinon les scammers reviennent.
- **Bouton "Selectionner"** : indispensable pour selection en lot. Sans clic dessus, Shift+clic ne fonctionne pas.
- **Workflow lent** : ~15-20 min via navigateur (vs 2 min Gmail MCP). Ne pas s'inquieter, c'est normal.
- **Score >= 90 = suppression auto** : verifier `blacklist.json` est a jour avant lancement, sinon faux-positifs.
- **Apprentissage** : chaque session DOIT mettre a jour `learning_log.json` meme si rien n'a change (entree timestamp + decisions vides) — pour traçabilite.

## Reference longue

Voir `Ressources/Protocoles/Outlook.md` (v1.0 — 18 avril 2026).
