---
name: tri-email-outlook-priorites
description: Tri interactif de la boite Outlook might@live.fr via Brave (Claude in Chrome) avec 4 dossiers de priorite : Urgent, Perso, Info, A supprimer. Workflow manuel : Jarvis classe, Mickael valide par lot (ex "Urgent 1 sup, 2-3 non lu, 4 perso"). Pas d'auto-apprentissage. Complement au skill `tri-email-outlook` (automatise).
---

# Skill : Tri email Outlook par priorites

## Quand cette skill est declenchee

- Mickael demande un tri manuel/interactif d'Outlook ("trie ma boite
  Outlook par priorite", "classe mes mails Outlook", "fait le tri Outlook
  avec moi").
- Premiere mise en ordre d'une boite tres encombree (avant de passer au
  tri automatique quotidien).
- Quand Mickael veut valider visuellement chaque email avant decision.

## Difference vs `tri-email-outlook` (automatise)

| Aspect            | `tri-email-outlook`             | `tri-email-outlook-priorites` |
|-------------------|----------------------------------|-------------------------------|
| Declenchement     | Tache planifiee 5h/14h          | Demande explicite Mickael     |
| Decision          | Score whitelist/blacklist       | Mickael valide chaque lot     |
| Rapport           | Email auto-envoye               | Recap chat numerote           |
| Usage             | Quotidien routine               | Grand nettoyage + validation  |

## Boite ciblee

`might@live.fr` via `https://outlook.live.com/mail/0/`
Session Brave active prealablement (Claude in Chrome).

## Structure des 4 dossiers

Verifier/creer dans la sidebar Outlook (clic droit sur `Might@live.fr` >
"Creer un dossier") :

| Dossier         | Contenu                                              |
|-----------------|------------------------------------------------------|
| **Urgent**      | Actions rapides (factures, relances, alertes secu)   |
| **Perso**       | Perso non urgent (abonnements, docs impots)          |
| **Info**        | Newsletters, alertes secu info, notifications        |
| **A supprimer** | Candidats suppression — Mickael vide d'un clic       |

Note : Mickael peut fusionner Urgent/Important. La regle par defaut :
"important et urgent → Urgent. Perso urgent → Urgent aussi."

## Workflow en 7 etapes

1. **Verifier** session Outlook active (`tabs_context_mcp` + screenshot).
2. **Creer** les dossiers manquants (Urgent / Perso / Info / A supprimer).
3. **Classer** les emails par lots selon le contenu visible (expediteur +
   objet). Deplacer en batch via `Selectionner` + clic droit + Deplacer.
4. **Traiter** aussi le Courrier indesirable (decocher "Ne jamais envoyer
   de futurs messages..." dans le popup pour garder les scammers filtres).
5. **Presenter** a Mickael un recap numerote : "Urgent 1:..., 2:..., Perso
   1:..., Info 1:...". Format concis sans details inutiles.
6. **Appliquer** les decisions de Mickael (ex : "Urgent 1 sup, 2 non lu,
   3 perso, Info tous sup"). Supporter les actions : supprimer, non lu,
   archiver, deplacer vers autre dossier.
7. **Resume final** compteurs par dossier + etat A supprimer.

## Pieges connus (Brave + Outlook)

### Menu Deplacer : dossier Urgent absent de la liste
Les dossiers recents sont prioritaires dans le submenu `Deplacer`. Si
Urgent n'apparait pas :
- Cliquer sur la zone de recherche "Rechercher un dossier"
- Taper "Urg"
- Cliquer sur **le texte "Urgent"** dans le resultat (pas sur l'icone)
- Si clic sur icone echoue : retenter avec `hover` + clic droit

Astuce : apres 1 deplacement vers Urgent, le dossier apparait direct dans
le submenu pour les suivants.

### Drag-drop alternative
Si clic droit > Deplacer echoue 2 fois, **drag-drop** l'email vers le
dossier dans la sidebar. Fonctionne toujours.

### Popup "Ne jamais envoyer..."
Apparait uniquement quand on deplace DEPUIS Courrier indesirable vers
un autre dossier. **Toujours DECOCHER** la case avant OK, sinon Outlook
debloque les expediteurs et les scams reviennent en inbox. Utiliser
`find` pour localiser la checkbox `ref_XXX` puis `left_click` dessus.

### Selection multiple
- Bouton "Selectionner" en haut a droite pour activer le mode.
- Shift+clic sur checkbox pour selection en plage.
- Apres 1re selection, bandeau "N conversations selectionnees" apparait.

### Marquer comme non lu
Clic droit sur la selection > **"Marquer comme non lu"** (pas "Marquer
comme lu" qui est au-dessus). Appliquer sur des emails deja non lus ne
change rien (idempotent).

### Archiver
Clic droit sur un email > **"Archiver"** — l'envoie dans le dossier
`Archive` d'Outlook (different de "A supprimer"). A utiliser pour les
docs a garder mais sortir de la vue (ex: recus fiscaux).

## Classification type (reperes rapides)

### Urgent
- Factures non payees, relances (niveau 2/3)
- Bulletins de paie recents
- Alertes securite perso (Find My, banque)
- Devis attendus, contrats a signer

### Perso
- Abonnements (Amazon Prime, Netflix) — renouvellements
- Documents impots (recus fiscaux, attestations)
- Demandes complementaire sante, assurances
- Amazon Prime

### Info
- Alertes securite Gmail (copies automatiques)
- Newsletters editoriales (Courrier International alertes)
- Mises a jour compte (Microsoft Rewards, etc.)

### A supprimer
- Pubs commerciales (Lidl, Costco, Decathlon, FANATEC)
- Notifications reseaux sociaux (Instagram, Facebook)
- Faux cadeaux / scams (YETI wagon, makita gratuit)
- Codes de login expires (> 10 min)
- Rappels crypto (Binance)
- Promos de compagnies aeriennes

## Regles de securite (heritage CLAUDE.md)

- **Jamais supprimer definitivement** sans validation Mickael. "A
  supprimer" = dossier tampon, Mickael vide d'un clic quand il veut.
- Jamais vider "Elements supprimes" automatiquement.
- Si doute entre 2 categories : Perso plutot que A supprimer.
- Ne pas toucher les dossiers Archive existants (archives historiques).

## Commande Mickael type

Reponses acceptees pour la phase validation (etape 6) :
- `Urgent 1 sup, 2 non lu, 3 perso` — actions mixtes
- `Info tous sup` — batch
- `Perso 3 archive` — archiver (pas supprimer)
- `Urgent 4 marquer lu` — lecture sans action

## Exemple de session (session 28, 22/04/2026)

- Inbox de depart : 19 emails non lus (en fait 25 total avec les lus)
- Spam : 8 emails

**Repartition initiale proposee** :
- Urgent 6 : Find My, Revolut IBAN, Neida paie, facture MEDICO, devis
  SCHIEBEL, relance BIOGROUP
- Perso 3 : Amazon Prime, complementaire sante, recu fiscal MSF
- Info 5 : Microsoft Rewards + 3 Google alertes + Courrier intl Russie
- A supprimer 11 : pubs, scams, notifs Insta, cloudflare expire

**Apres validation Mickael** :
- Urgent → Find My sup, Neida paie → Perso, 4 autres non lu
- Perso → MSF archive, 2 autres deja non lus
- Info → tous vers A supprimer
- Spam → tous vers A supprimer (popup decoche)

**Resultat** : inbox vide, spam vide, A supprimer = 22 emails prets a
etre vides par Mickael.

## Dependances

- Outil `Claude in Chrome` actif (navigate, computer, find,
  form_input, browser_batch).
- Session Outlook active dans Brave (sinon Mickael se reconnecte
  lui-meme — jamais de credentials).

## Reference

- Skill jumelle `tri-email-outlook` (automatise)
- Protocole long : `Ressources/Protocoles/Outlook.md`
- Regle "donnees sensibles" : `CLAUDE.md` section 0

---
*Skill creee session 28 — 22 avril 2026*
