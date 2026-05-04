# Compétence Gestion des Emails

> Protocole général pour Jarvis (Claude) — Applicable à toutes les boîtes email
>
> Ce document définit les règles et procédures que Jarvis doit suivre pour gérer les emails de Mickael. Il couvre : le tri automatique, la génération de rapports de synthèse, l'envoi, l'archivage et la rédaction d'emails.
>
> Source : Competence_Gestion_Emails.pdf — 12 avril 2026

---

## PHASE 1 : NETTOYAGE AUTOMATIQUE DES INDÉSIRABLES

À exécuter en premier, **sans demander confirmation à Mickael**.

### Étape 1 : Vider le dossier Courrier indésirable / Spam
- Ouvrir le dossier Courrier indésirable (ou Spam selon la boîte)
- Utiliser le bouton « Vider le dossier » pour tout supprimer d'un coup
- Confirmer à Mickael le nombre d'emails supprimés

### Étape 2 : Sélection par vagues pour suppression en lot (✅ Validée S82)

Méthode validée 01/05/2026 (cf. T#18 archivée) :

- Cliquer sur **« Sélectionner »** (bouton en haut de la liste) pour activer le mode multi-sélection (cases à cocher visibles).
- Cocher la case du **1er email** + **Shift+clic** sur la case du dernier visible → toute la plage est cochée en 2 clics.
- Cliquer **« Supprimer »** pour valider la vague.
- Répéter par vagues de 20-50 (selon hauteur d'écran) avant de passer à la suivante.
- Confirmer à Mickael le total en fin de traitement.

**⚠ Piège Outlook web (S82)** : le mode Sélection est **sticky** — re-clic sur « Sélectionner » et `Esc` ne le désactivent pas. Pour repasser en mode normal (et faire apparaître le bouton « Vider le dossier ») : **F5 pour rafraîchir la page**.

**Quand utiliser cette méthode vs « Vider le dossier »** : la sélection par vagues est utile **uniquement pour un tri sélectif** (garder certains mails, supprimer les autres). Si tout est jetable (spam pur, dossier "À supprimer"), utiliser directement « Vider le dossier » (Étape 1) — 1 clic plus rapide.

### Étape 3 : Suppression automatique dans la boîte de réception
Supprimer directement (sans demander) les emails qui correspondent à ces catégories :

| Catégorie | Exemples | Raison |
|---|---|---|
| Codes expirés | Cloudflare Access codes, codes 2FA anciens | Expirés après 10 min, inutilisables |
| Notifications de livraison | Amazon 'Expédié', 'En cours de livraison', 'Livré' | Livraison déjà effectuée |
| Promos crypto répétitives | Binance 'Gagnez des cryptos', 'Soft staking' | Spam publicitaire répétitif |
| Newsletters non sollicitées | EcoFlow, CORSAIR, FANATEC, CHARLOTT' | Promos commerciales sans intérêt |
| Notifications réseaux sociaux | Facebook statuts, Instagram suggestions | Bruit sans valeur informationnelle |
| Mises à jour de compte | Microsoft 'Mettez à niveau', pub Outlook | Publicités déguisées |
| Notifications apps génériques | Tinder, Deezer recap, TwoNav, Saily | Notifications de routine sans action |
| STMicroelectronics newsletters | Breaking the mold, STM32Cube updates | Newsletters techniques non lues |

**Règle générale :** si un email est clairement publicitaire, répétitif (même expéditeur/même sujet dans les 7 derniers jours), ou périmé (code expiré, livraison déjà reçue), le supprimer sans demander.

---

## PHASE 2 : RAPPORT DE SYNTHÈSE POUR VALIDATION

Après le nettoyage automatique, générer un PDF de synthèse des emails restants pour que Mickael décide quoi garder ou supprimer.

### Format du rapport de synthèse

| N. | Expéditeur | Sujet | Date | Type | Action? |
|---|---|---|---|---|---|
| 1 | Apple | Votre reçu Apple - Facture Claude Max | 11/04 | Facture | G / S |
| 2 | Frisquet Connect | Émission d'une alarme - MANQUE D'EAU | 12/04 | Alerte | G / S |
| 3 | Angelique MEDICO | Facture YWQ879 - Rubix | 09/04 | Facture pro | G / S |
| … | … | … | … | … | … |

### Regroupement par catégories
- **Factures / Reçus** : Apple, Amazon confirmations de commande, factures pro
- **Alertes / Sécurité** : Frisquet Connect, Find My, alertes de connexion
- **Correspondance perso** : emails envoyés par Mickael lui-même, proches
- **Professionnel** : devis, factures fournisseurs, relances
- **Associations / Dons** : Restos du Cœur (déductible impôts), MSF, etc.
- **Actualités / Presse** : Courrier International, newsletters info
- **Divers** : tout ce qui ne rentre pas dans les catégories ci-dessus

**Réponse de Mickael :** pour chaque ligne, Mickael répond par le numéro suivi de **G** (garder), **S** (supprimer) ou **A** (archiver). Exemple : `1G 2S 3A`. Jarvis exécute les actions en lot.

---

## PHASE 3 : ACTIONS SUR LES EMAILS

### 3.1 Supprimer des emails
- Sélectionner les emails à supprimer (cases à cocher)
- Cliquer sur « Supprimer » — les emails vont dans les Éléments supprimés (récupérables)
- **NE JAMAIS vider la corbeille (suppression définitive) sans validation explicite**
- Confirmer à Mickael le nombre d'emails supprimés

### 3.2 Archiver des emails
- Sélectionner les emails à archiver
- Cliquer sur « Archiver » — déplacés dans le dossier Archive
- **Cas particuliers à archiver systématiquement :**
  - Reçus de dons (Restos du Cœur, MSF, etc.) — déductibles des impôts
  - Factures professionnelles avec pièces jointes
  - Confirmations d'abonnement

### 3.3 Sauvegarder avant suppression
Pour certains emails importants à supprimer, créer un PDF de sauvegarde avant :
- **Alertes** (Frisquet, Find My) : noter les infos clés dans un PDF daté
- **Factures** : télécharger les pièces jointes si présentes avant suppression
- Le PDF de sauvegarde est envoyé à Mickael via Dispatch (pièce jointe)

---

## PHASE 4 : ENVOYER UN EMAIL

> ⚠ **Contrainte OAuth Gmail** : `send_email` et `draft_email` (MCP Gmail) retournent **HTTP 403** car les scopes `gmail.send` / `gmail.compose` sont absents du Client OAuth GCP. Seul `create_draft` fonctionne pour la création de brouillon. L'envoi effectif passe par 2 canaux distincts selon le destinataire.

### 4.1 Auto-envoi (note à soi-même → might57290@gmail.com)

Pas de brouillon intermédiaire — envoi direct via le service Home Assistant `notify.might57290_gmail_com`.

Appel `mcp__home-assistant__ha_call_service` :

```yaml
service: notify.might57290_gmail_com
data:
  target: ["might57290@gmail.com"]   # OBLIGATOIRE — sinon HTTP 500 ValueError
  title: "[Sujet rapide]"
  message: |
    Contenu texte brut (HTML pas encore validé sur cette intégration).
```

- **`data.target` obligatoire** (auto-memory `feedback_notify_gmail_target.md`, S27).
- **HTML pas encore validé** sur l'intégration `google_mail` — rester en texte brut.
- Pas de validation préalable nécessaire (Mickael s'écrit à lui-même).

### 4.2 Envoi à un tiers (SAV, impôts, asso, proche…)

#### Prérequis
- L'onglet de la boîte email doit être dans le groupe Claude sur Brave
- La session doit être connectée (pas de page de login)
- Le domaine doit être autorisé dans l'extension Claude in Chrome (active dans Brave)

#### Procédure d'envoi

**Voie 1 — Brouillon via MCP Gmail (préféré pour Gmail)** :
- Appeler `create_draft` avec les paramètres `to`, `subject`, `body` directement remplis (pas besoin d'étapes "Remplir" séparées — l'outil prend tout en une seule passe).
- Le brouillon apparaît dans le dossier "Brouillons" Gmail.
- Ouvrir Brave sur Gmail → onglet Brouillons → ouvrir le brouillon créé.
- Vérifier visuellement, screenshot pour Mickael.
- **TOUJOURS demander confirmation avant de cliquer Envoyer**.

**Voie 2 — Composition directe via Brave (Outlook ou Gmail si MCP indisponible)** :
- Ouvrir Brave sur la boîte → "Nouveau message" / "Composer".
- Remplir le champ destinataire avec l'adresse fournie par Mickael.
- Remplir l'objet et le corps du message.
- Si pièce jointe : utiliser l'outil `file_upload` si le fichier est sur le PC.
- **TOUJOURS demander confirmation avant de cliquer Envoyer**.
- Envoyer un screenshot du mail prêt à Mickael pour validation.

---

## PHASE 5 : RÉDIGER UN EMAIL

### Règles générales de rédaction
- **Langue** : toujours en français sauf si le destinataire est anglophone
- **Ton** : adapter au contexte (voir tableau ci-dessous)
- **Longueur** : concis et direct — pas de blabla inutile
- **Signature** : utiliser 'Mickael Rubino' ou 'Mickael' selon le contexte

### Adaptation du ton selon le destinataire

| Type de destinataire | Ton | Formule d'ouverture | Formule de fermeture |
|---|---|---|---|
| Professionnel / Fournisseur | Formel, courtois | Bonjour [Prénom], | Cordialement, Mickael Rubino |
| Service client / SAV | Poli mais ferme | Bonjour, | Dans l'attente de votre retour, cordialement |
| Administration / Impôts | Très formel | Madame, Monsieur, | Je vous prie d'agréer mes salutations distinguées |
| Proche / Ami | Décontracté | Salut [Prénom], | À bientôt ! |
| Association / Don | Chaleureux | Bonjour, | Bien cordialement, Mickael |
| Auto-envoi (à soi-même) | Note rapide | Pas de formule | Pas de formule |

---

## RÉSUMÉ : WORKFLOW COMPLET EN 7 ÉTAPES

| Étape | Action | Qui décide ? |
|---|---|---|
| 1 | Vider le dossier Indésirables / Spam | Jarvis (automatique) |
| 2 | Supprimer les emails périmés et promos répétitives de la boîte de réception | Jarvis (automatique) |
| 3 | Générer un PDF de synthèse des emails restants groupés par catégorie | Jarvis (automatique) |
| 4 | Mickael valide : G (garder) / S (supprimer) / A (archiver) par numéro | Mickael |
| 5 | Jarvis exécute les actions validées par Mickael | Jarvis (sur validation) |
| 6 | Créer des PDFs de sauvegarde si nécessaire (alertes, factures) | Jarvis (automatique) |
| 7 | Confirmer le résultat final à Mickael (nombre restant, archives, supprimés) | Jarvis (automatique) |

---

## RÈGLES DE SÉCURITÉ

- **Jamais** de suppression définitive (vider la corbeille) sans validation explicite
- **Jamais** envoyer un email sans screenshot de confirmation à Mickael
- **Jamais** ouvrir de pièces jointes suspectes ou de liens douteux
- **Jamais** répondre à un email sans instruction de Mickael
- **Toujours** sauvegarder en PDF les infos importantes avant suppression
- **Toujours** archiver les reçus de dons et factures pro (impôts)

---

## LIMITATIONS ACTUELLES

- **Gmail** : MCP disponible (lecture + drafts + labels) mais **pas d'envoi direct** (scopes `gmail.send` / `gmail.compose` absents OAuth GCP) → envoi auto-envoi via `notify.might57290_gmail_com` HA, envoi à un tiers via Brave.
- **Outlook** : pas de MCP actif — gestion via Brave uniquement (T#48 = MCP Outlook à chercher).
- Les domaines email doivent être autorisés dans l'extension Claude in Chrome (active dans Brave)
- Le tri email par email dans le navigateur est lent (pas de bulk API)
- Claude ne peut pas se reconnecter seul si la session email expire
- Les pièces jointes ne peuvent être téléchargées que si autorisé par Mickael

---

*Fin du document Gestion_Emails.md — Converti depuis Competence_Gestion_Emails.pdf — 12 avril 2026*
