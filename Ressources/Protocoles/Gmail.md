# Protocole Gmail

> Spécifique à `might57290@gmail.com`
> Complément au protocole général `02_Competences/Gestion_Emails.md`
>
> Source initiale : Protocole_Gmail_might57290.pdf — Version 2.0 — 18 avril 2026
> **Version 3.0 — 22 avril 2026 (session 27)** : refonte complète Phase 5 Gmail MCP custom. Suppression du canal navigateur Brave, bascule vers les outils natifs `mcp__gmail-mcp-local__*`. Envoi rapport via service Home Assistant `notify.might57290_gmail_com`. Mode d'exécution : Claude Code CLI uniquement (Cowork ne charge pas les MCP stdio — voir auto-memory `feedback_cowork_no_stdio`).

---

## Fiche récapitulative

| Champ | Valeur |
|---|---|
| Boîte email | `might57290@gmail.com` (Gmail / Google) |
| Propriétaire | Mickael Rubino |
| Outils disponibles | Serveur MCP Gmail custom local (GongRzhe/Gmail-MCP-Server) — CRUD complet + labels + filtres | Service HA `notify.might57290_gmail_com` pour l'envoi du rapport |
| Mode d'exécution | **Claude Code CLI uniquement** (stdio non chargé par Cowork Desktop) |
| Labels IA existants | IA priorité haute \| IA priorité moyenne \| IA priorité faible \| IA suppression \| Jarvis-RapportTri |
| Tâche planifiée | `Jarvis-TriGmail-Quotidien` (Windows Task Scheduler) — 5h + 14h tous les jours |
| Fichiers patterns | `Ressources/Data/gmail_patterns/{whitelist,blacklist,learning_log}.json` |
| Version | 3.0 — 22 avril 2026 |

---

## OUTILS ET CAPACITÉS

Cette boîte Gmail est gérée via un **unique canal** depuis Phase 5 (session 27) :
le serveur MCP Gmail custom local. Le navigateur Chrome/Brave n'est plus utilisé.

### Serveur MCP custom — `mcp__gmail-mcp-local__*`

| Famille | Outils | Capacités |
|---|---|---|
| Lecture | `search_emails`, `read_email`, `list_email_labels` | Recherche avancée (syntaxe Gmail : `from:`, `to:`, `subject:`, `label:`, `-label:`, `in:inbox`, `category:`), lecture threads/messages, listing labels |
| Écriture labels | `modify_email`, `batch_modify_emails`, `create_label`, `get_or_create_label`, `update_label` | Appliquer/retirer labels (TRASH, INBOX, custom, CATEGORY_*) unitairement ou en lot (max 50 messageIds/appel) |
| Suppression | `delete_email`, `batch_delete_emails` | Suppression définitive — ⚠️ **interdits dans la skill tri-email-gmail** (passer uniquement par TRASH label) |
| Pièces jointes | `download_attachment` | Télécharger une PJ (≤ 25 Mo) |
| Filtres Gmail natifs | `create_filter`, `list_filters`, `get_filter`, `delete_filter`, `create_filter_from_template` | Gérer les règles de tri automatique côté Gmail (persistantes, appliquées à chaque nouveau mail) |
| Envoi | `send_email`, `draft_email` | ⚠️ **403 Google** (scope `gmail.send` / `gmail.compose` absents côté OAuth) — ne pas utiliser |

### Envoi — service Home Assistant

| Service | Usage |
|---|---|
| `notify.might57290_gmail_com` | Envoi de tout email depuis Jarvis (rapport tri, alertes hors Mode Réactif, etc.). Paramètres : `title`, `message` (HTML supporté via `data.html: true` selon config HA) |

**Stratégie** : toute action Gmail (lecture, tri, labels) passe par le MCP
custom. Tout envoi passe par HA notify. Aucune dépendance au navigateur.

---

## SYSTÈME D'AUTO-APPRENTISSAGE

Jarvis apprend de chaque session de tri pour améliorer ses décisions futures.
Le système repose sur 3 fichiers JSON :

| Fichier | Rôle | Mise à jour |
|---|---|---|
| `whitelist.json` | Expéditeurs protégés — ne JAMAIS supprimer (impôts, banques, famille, dons déductibles) | Manuelle par Mickael ou quand il conteste une suppression (2 erreurs = ajout auto) |
| `blacklist.json` | Expéditeurs à supprimer avec score de confiance (0-100). Plus le score est haut, plus la suppression est automatique | Automatique à chaque tri : nouveau pattern = confiance 50, confirmé par Mickael = +10/session |
| `learning_log.json` | Journal de toutes les sessions de tri : stats, patterns découverts, erreurs, feedback | Automatique après chaque session |

### Score de confiance et actions

| Score | Niveau | Action | Dans le rapport ? |
|---|---|---|---|
| 100 | Spam évident | Suppression auto (TRASH) | NON (trop évident) |
| 90-99 | Très sûr | Suppression auto (TRASH) | OUI (vérification) |
| 70-89 | Probable | Ne pas supprimer | OUI (validation Mickael) |
| 50-69 | Nouveau pattern | Ne pas supprimer | OUI (à confirmer) |
| < 50 | Incertain | Ne pas supprimer | OUI (décision Mickael) |

**Évolution du score :** chaque fois que Mickael confirme une suppression
(répond S), le score monte de **+10** (max 100). S'il conteste (répond G),
le score descend de **-30** et l'expéditeur peut être déplacé en whitelist
après 2 contestations.

### Pondération par catégorie Gmail

Chaque message renvoyé par `search_emails` contient un champ `labels` qui
inclut automatiquement les catégories Gmail (onglets natifs). Le score de
base est pondéré selon :

| Label présent | Pondération score |
|---|---|
| `CATEGORY_SOCIAL` | +30 (plus agressif — réseaux sociaux) |
| `CATEGORY_PROMOTIONS` | +30 (plus agressif — promos) |
| `CATEGORY_UPDATES` | +0 (neutre — notifications) |
| `CATEGORY_FORUMS` | +0 (neutre — mailing lists) |
| `CATEGORY_PERSONAL` | -20 (prudent — onglet Principale) |

Un email promo d'un expéditeur blacklist à 60 passe ainsi à 90 et bascule
en suppression auto, sans toucher aux emails de l'onglet Principale.

---

## PHASE 1 : NETTOYAGE AUTOMATIQUE

À exécuter en premier, sans demander confirmation à Mickael.

### Étape 1 : Vider le dossier Spam

```
search_emails  query="label:spam"  maxResults=500
  ↓ collecter tous les messageIds
batch_modify_emails  ids=[...50 max...]  addLabelIds=["TRASH"]  removeLabelIds=["SPAM"]
  ↓ répéter par lots de 50 jusqu'à épuisement
```

Confirmer à Mickael le nombre d'emails déplacés en corbeille.

### Étape 2 : Suppression automatique dans la boîte de réception

Supprimer directement (sans demander) les emails correspondant à ces
catégories, après scan `search_emails query="in:inbox -label:Jarvis-Alert -label:Jarvis-RapportTri"` :

| Catégorie | Expéditeurs / Patterns connus | Raison |
|---|---|---|
| Codes expirés | Cloudflare Access, codes 2FA anciens, codes de vérification > 1 jour | Expirés, inutilisables |
| Notifications livraison | Amazon (Expédié, Livré, En cours) | Livraison déjà effectuée |
| Promos crypto | Binance (Gagnez des cryptos, Soft staking) | Spam publicitaire répétitif |
| Newsletters non sollicitées | Topaz Labs, EcoFlow, CORSAIR, FANATEC, CHARLOTT' | Promos commerciales sans intérêt |
| Notifications réseaux sociaux | Facebook, Instagram suggestions | Bruit sans valeur |
| Pubs déguisées Microsoft | Microsoft (Mettez à niveau, pub Outlook) | Publicités déguisées |
| Notifications apps génériques | Tinder, Deezer recap, TwoNav, Saily | Routine sans action |
| Newsletters tech non lues | STMicroelectronics, STM32Cube updates | Newsletters non lues |
| Promos musique IA | Suno (promos quotidiennes répétitives) | Spam répétitif quotidien |
| Onboarding non sollicité | Claude Team (séries d'emails 1/5 à 5/5), OpenAI (newsletters ChatGPT) | Newsletters onboarding |

**Règle générale :** si un email est clairement publicitaire, répétitif (même
expéditeur/même sujet dans les 7 derniers jours), ou périmé (code expiré,
livraison déjà reçue), le supprimer sans demander.

**Procédure technique :**

```
batch_modify_emails  ids=[...messageIds...]  addLabelIds=["TRASH"]  removeLabelIds=["INBOX"]
```

Par lots de **50 messageIds max** pour respecter le quota Gmail API
(250 units/user/seconde, 5 units/message sur `messages.modify`).

---

## PHASE 2 : CLASSIFICATION PAR LABELS IA

Gmail dispose de 4 labels IA personnalisés pour le classement automatique :

| Label | Usage | Exemples |
|---|---|---|
| IA priorité haute | Emails urgents ou importants nécessitant une action rapide | Alertes sécurité, factures à payer, correspondance pro urgente |
| IA priorité moyenne | Emails utiles mais non urgents | Confirmations commande, newsletters info, reçus |
| IA priorité faible | Emails informatifs à consulter quand Mickael a le temps | Actualités, presse, promos potentiellement intéressantes |
| IA suppression | Emails identifiés pour suppression en attente de validation (scores 70-89) | Promos répétitives, newsletters non sollicitées |

**Procédure technique** : `batch_modify_emails` avec `addLabelIds` = labelId
du label IA correspondant (récupéré via `list_email_labels` au démarrage).

---

## RAPPORT DE SYNTHÈSE POUR VALIDATION

Après le nettoyage automatique, générer un rapport HTML/markdown des emails
restants et l'envoyer via le service HA `notify.might57290_gmail_com`.

### Format du rapport

| N. | Expéditeur | Sujet | Date | Type | Action? |
|---|---|---|---|---|---|
| 1 | Apple | Votre reçu Apple - Facture… | 11/04 | Facture | G / S / A |
| 2 | Frisquet Connect | Émission d'une alarme… | 12/04 | Alerte | G / S / A |
| … | … | … | … | … | … |

### Regroupement par catégories

- **Factures / Reçus** : Apple, Amazon confirmations, factures pro
- **Alertes / Sécurité** : Frisquet Connect, Find My, Google alertes connexion
- **Correspondance perso** : emails de Mickael, proches, famille
- **Professionnel** : devis, factures fournisseurs, relances
- **Associations / Dons** : Restos du Cœur (déductible impôts), MSF
- **Actualités / Presse** : Courrier International, newsletters info
- **Divers** : tout ce qui ne rentre pas dans les catégories ci-dessus

**Réponse de Mickael :** pour chaque ligne, Mickael répond par le numéro
suivi de **G** (garder), **S** (supprimer) ou **A** (archiver). Exemple :
`1G 2S 3A`. Jarvis exécute les actions en lot via `batch_modify_emails`.

---

## PHASE 3 : ACTIONS SUR LES EMAILS

### 3.1 Supprimer des emails (soft delete — label TRASH)

```
batch_modify_emails  ids=[...]  addLabelIds=["TRASH"]  removeLabelIds=["INBOX"]
```

Les emails vont dans la corbeille Gmail (récupérables 30 jours).

⚠️ **Jamais** utiliser `batch_delete_emails` ni `delete_email` (hard delete
définitif). Ces outils sont en **deny** dans `settings.local.json` pour la
skill tri-email-gmail.

Confirmer à Mickael le nombre d'emails traités.

### 3.2 Archiver des emails (sortie de l'INBOX, conservation)

Dans Gmail API, "archiver" = retirer le label INBOX sans toucher aux autres
labels. Le message reste dans `All Mail` et dans tous ses autres labels.

```
batch_modify_emails  ids=[...]  removeLabelIds=["INBOX"]
```

**Cas particuliers à archiver systématiquement :**

- Reçus de dons (Restos du Cœur, MSF, etc.) — déductibles des impôts
- Factures professionnelles avec pièces jointes
- Confirmations d'abonnement actifs
- Alertes de sécurité Google (historique connexions)

### 3.3 Sauvegarder avant suppression

Pour certains emails importants à supprimer, créer un PDF de sauvegarde avant :

- Alertes (Frisquet, Find My) : noter les infos clés dans un PDF daté
- Factures : télécharger les pièces jointes via `download_attachment` avant
  suppression
- Le PDF de sauvegarde est placé dans `memory/historique_tri_gmail/sauvegardes/`

### 3.4 Ciblage par onglet Gmail (CATEGORY_*)

Gmail organise la boîte de réception en 5 catégories automatiques. Elles
apparaissent comme labels spéciaux sur chaque message :

| Onglet UI | Label Gmail API | Syntaxe query | Action par défaut |
|---|---|---|---|
| Principale | `CATEGORY_PERSONAL` | `category:primary` | Tri individuel (rapport) |
| Promotions | `CATEGORY_PROMOTIONS` | `category:promotions` | Suppression auto sauf exceptions |
| Réseaux sociaux | `CATEGORY_SOCIAL` | `category:social` | Suppression auto |
| Notifications | `CATEGORY_UPDATES` | `category:updates` | Tri individuel (rapport) |
| Forums | `CATEGORY_FORUMS` | `category:forums` | Tri individuel (rapport) |

**Recommandation** : scan global unique `in:inbox -label:Jarvis-Alert`, puis
post-traitement par catégorie via le champ `labels` de chaque message
(cf. section Pondération par catégorie Gmail plus haut).

---

## PHASE 4 : RÉDACTION ET ENVOI LIBRE — **hors scope tri-email**

> ⚠️ La rédaction d'emails libres (réponse à un fournisseur, mail perso,
> courrier à un service client) **n'est plus dans le scope du protocole
> tri-email-gmail** depuis la refonte Phase 5 (session 27).
>
> **Pourquoi** :
> - Scope OAuth `gmail.send` / `gmail.compose` absents → `send_email` et
>   `draft_email` retournent 403.
> - La rédaction libre est transverse (relève de la skill `redaction-email`
>   dédiée aux règles de ton par type de destinataire).
>
> **Où traiter** :
> - Règles de ton et rédaction : skill `redaction-email` (voir CLAUDE.md
>   section 5).
> - Envoi technique : service HA `notify.might57290_gmail_com` (ou service
>   dédié à créer si besoin d'un destinataire dynamique — tâche #46
>   future).
>
> L'ancienne PHASE 4 (brouillon MCP → envoi navigateur) est supprimée.

---

## RAPPORT JOURNALIER PAR EMAIL

Deux fois par jour (5h et 14h), Windows Task Scheduler lance le tri
automatique qui envoie un rapport à Mickael dans sa boîte Gmail via le
service HA `notify.might57290_gmail_com`.

### Contenu du rapport

- **Résumé** : nombre total d'emails traités, supprimés, gardés, archivés
- **Emails supprimés auto (confiance 90-99)** : tableau avec expéditeur,
  sujet, date — pour vérification
- **Emails à valider** : expéditeurs inconnus ou confiance < 90, en attente
  de décision G/S/A
- **Nouveaux expéditeurs détectés** : patterns pas encore dans la blacklist
- **Exclus du rapport** : spam évident (confiance 100) — pas besoin de
  vérifier

### Format du rapport email

- **Objet** : `[Jarvis] Rapport tri emails — {YYYY-MM-DD HH:MM}`
- **Expéditeur** : `might57290@gmail.com` (auto-envoi via HA notify)
- **Destinataire** : `might57290@gmail.com`
- **Corps** : texte brut (HTML pas encore validé sur l'intégration `google_mail`, à tester séparément avant de re-basculer en rich format)

### ⚠️ Paramètres obligatoires de `ha_call_service` → `notify.might57290_gmail_com`

Appel complet minimal validé session 27 (V1 réel) :

```yaml
service: notify.might57290_gmail_com
data:
  target: ["might57290@gmail.com"]   # OBLIGATOIRE sinon HTTP 500 ValueError
  title: "[Jarvis] Rapport tri emails — 2026-04-22"
  message: "Corps du rapport en texte brut"
```

**Piège découvert S27 V1** : sans `data.target`, l'intégration `google_mail`
lève `ValueError: recipient address required` dans
`components/google_mail/notify.py:84` → HTTP 500. Voir auto-memory
`memory/feedback_notify_gmail_target.md`.

Cette contrainte s'applique à **toute skill qui envoie un mail auto-envoi via
`notify.might57290_gmail_com`** (tri-email-gmail, tri-email-outlook,
rapport-journalier-reactif, etc.).

### Filtre Gmail auto-archivage

Un filtre Gmail natif créé via `create_filter` applique automatiquement le
label `Jarvis-RapportTri` à tous les rapports reçus et les sort de l'INBOX.

**Critère** : `from:me subject:"[Jarvis] Rapport tri emails"`
**Actions** : `addLabelIds: ["Label_JarvisRapportTri"]`, `removeLabelIds: ["INBOX"]`

Ainsi les rapports ne polluent pas la boîte principale et sont consultables
d'un clic via le label dédié.

### Si Mickael détecte une erreur dans une suppression

1. Répondre au rapport avec le numéro de l'email à récupérer (ou par
   message direct à Jarvis).
2. Jarvis récupère l'email depuis la corbeille via
   `modify_email` `addLabelIds=["INBOX"]` `removeLabelIds=["TRASH"]`
   (Gmail conserve 30 jours).
3. Le score de confiance de l'expéditeur est réduit de **-30**.
4. Si 2 erreurs sur le même expéditeur → déplacement en whitelist.

### Planification

| Paramètre | Valeur |
|---|---|
| Nom de la tâche | `Jarvis-TriGmail-Quotidien` (Windows Task Scheduler) |
| Fréquence | Tous les jours à 5h00 et 14h00 (heure locale) |
| Action | `PowerShell.exe -File scripts\tri-gmail-launcher.ps1` |
| Exécutable Claude | `claude -p "..."` --output-format json (headless) |
| Allowlist outils | `.claude/settings.local.json` (allow search/read/modify/batch_modify + HA notify; deny delete_*) |
| Pré-filtre | `scripts\tri-gmail-launcher.ps1` vérifie `credentials.json` (existence + âge < 6 jours) |
| Alerte token expiré | Via HA notify `notify.might57290_gmail_com` si le pré-filtre échoue |
| Logs | `memory/historique_tri_gmail/run_YYYY-MM-DD_HHMMSS.json` |
| Rapport | Envoyé via HA notify, auto-archivé par filtre `Jarvis-RapportTri` |
| Mise à jour patterns | Automatique après chaque exécution |

---

## WORKFLOW COMPLET EN 9 ÉTAPES

| Étape | Action | Outil | Qui décide ? |
|---|---|---|---|
| 1 | Scanner l'inbox via `search_emails` (query `in:inbox -label:Jarvis-Alert -label:Jarvis-RapportTri`) | MCP Gmail | Jarvis (auto) |
| 2 | Comparer avec whitelist/blacklist, calculer les scores, pondérer selon `CATEGORY_*` | JSON local | Jarvis (auto) |
| 3 | Vider le dossier Spam via `batch_modify_emails` TRASH par lots de 50 | MCP Gmail | Jarvis (auto) |
| 4 | Supprimer les emails périmés et promos répétitives (score ≥ 90) via `batch_modify_emails` | MCP Gmail | Jarvis (auto) |
| 5 | Envoyer le rapport journalier via HA `notify.might57290_gmail_com` | MCP HA | Jarvis (auto) |
| 6 | Mickael valide : G / S / A par numéro (mode interactif) — sinon skip en mode scheduled | — | Mickael |
| 7 | Exécuter les actions validées via `batch_modify_emails` | MCP Gmail | Jarvis (sur validation) |
| 8 | Mettre à jour les patterns et le `learning_log.json` | Fichiers JSON | Jarvis (auto) |
| 9 | Confirmer le résultat final à Mickael + log JSON dans `memory/historique_tri_gmail/` | — | Jarvis (auto) |

---

## RÈGLES DE SÉCURITÉ

### Interdictions absolues

- Jamais de suppression définitive (`delete_email`, `batch_delete_emails`) —
  interdits via `settings.local.json` deny. Toujours passer par TRASH label.
- Jamais envoyer un email libre sans validation Mickael (le rapport auto
  est la seule exception).
- Jamais ouvrir de pièces jointes suspectes ou de liens douteux.
- Jamais répondre à un email sans instruction de Mickael.

### Obligations

- Toujours vérifier que `/mcp` affiche `gmail-mcp-local · connected` au
  démarrage d'une session CLI interactive.
- Toujours respecter **50 messageIds max par `batch_modify_emails`**
  (quota Gmail API).
- Toujours sauvegarder en PDF (via `download_attachment` si PJ) les infos
  importantes avant suppression.
- Toujours archiver (removeLabelIds=["INBOX"]) les reçus de dons et
  factures pro (impôts).
- Toujours confirmer le nombre d'emails traités à Mickael en fin de tri.
- **Ne jamais toucher aux threads avec le label `Jarvis-Alert`** — ce sont
  les alertes du Mode Réactif, traitées exclusivement par
  `check-jarvis-alert`. Jamais supprimer, archiver, relabeler ou répondre.

---

## GESTION DES ERREURS

| Situation | Action à suivre |
|---|---|
| `/mcp` → `gmail-mcp-local · disconnected` | Vérifier `.mcp.json` puis `/mcp reconnect gmail-mcp-local`. Si échec → `npm run build` dans `Runtime/Gmail-MCP-Server/` |
| Erreur `invalid_grant` | Token OAuth expiré (OAuth Consent Testing 7j). Relancer `npm run auth` dans `Runtime/Gmail-MCP-Server/` |
| Erreur 403 sur `send_email` / `draft_email` | ✅ Attendu (scope absent). Basculer sur `notify.might57290_gmail_com` |
| Erreur 403 sur autre outil | Vérifier OAuth Consent Testing actif + Mickael test user dans projet GCP `jarvis-ha-494017` |
| Erreur 429 `quotaExceeded` | Dépassement 250 units/s. Réduire taille batch < 50 ou ajouter pause 1,1s entre lots |
| Erreur `messageId not found` | Thread déjà modifié/supprimé entre scan et action. Retirer de la liste et continuer |
| Pré-filtre PowerShell échoue (token âge ≥ 6 jours) | Email alerte HA reçu. Relancer `npm run auth`, puis retester manuellement |
| Ban IP Gmail (très rare) | Arrêter, attendre 1h, vérifier logs `credentials.json`. Voir `Ressources/Protocoles/IP_Bans.md` |

---

*Document complémentaire au protocole général `02_Competences/Gestion_Emails.md`*
*Version 3.0 — 22 avril 2026 (session 27) — Refonte Phase 5 Gmail MCP custom*
*Ancienne version 2.0 : Protocole_Gmail_might57290.pdf — 18 avril 2026 (archive)*
