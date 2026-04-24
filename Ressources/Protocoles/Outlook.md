# Protocole Outlook

> Spécifique à `might@live.fr`
> Complément au protocole général `02_Competences/Gestion_Emails.md`
>
> Source : Protocole_Outlook_might_live_fr.pdf — Version 1.0 — 18 avril 2026 (avec auto-apprentissage + rapport journalier)

---

## Fiche récapitulative

| Champ | Valeur |
|---|---|
| Boîte email | `might@live.fr` (Outlook / Microsoft Live) |
| Propriétaire | Mickael Rubino |
| Outils | Navigateur Chrome/Brave uniquement (pas de connecteur MCP Outlook) |
| URL | `https://outlook.live.com/mail/0/inbox` |
| Dossiers spéciaux | Courrier indésirable (27) \| Éléments supprimés (69) \| À supprimer (12) \| Archive |
| Tâche planifiée | `tri-email-outlook-quotidien` — tous les jours à 5h00 et 14h00 |
| Fichiers patterns | `05_Data/outlook_patterns/{whitelist,blacklist,learning_log}.json` |
| Version | 1.0 — 18 avril 2026 |

---

## DIFFÉRENCES AVEC GMAIL

Outlook n'a pas de connecteur MCP. Tout le tri se fait via le navigateur. Les différences principales :

|  | Gmail (`might57290@gmail.com`) | Outlook (`might@live.fr`) |
|---|---|---|
| Scan | MCP Gmail (rapide) | Navigateur (lire la page) |
| Brouillons | MCP `create_draft` | Navigateur (Nouveau message) |
| Suppression | Navigateur | Navigateur |
| Onglets | Principale / Promotions / Réseaux | Boîte unique + dossiers latéraux |
| Spam | Dossier Spam | Courrier indésirable |
| Corbeille | Corbeille (30 jours) | Éléments supprimés (30 jours) |
| Labels IA | 4 labels personnalisés | Dossier "À supprimer" existant |

---

## PHASE 1 : NETTOYAGE AUTOMATIQUE

À exécuter en premier, sans demander confirmation à Mickael.

### Étape 1 : Vider le Courrier indésirable
Dans la barre latérale, cliquer sur **« Courrier indésirable »**, puis **« Vider le dossier »**. Confirmer dans la popup.

### Étape 2 : Suppression automatique dans la boîte de réception

| Catégorie | Expéditeurs identifiés | Confiance |
|---|---|---|
| Codes expirés | Dyson (codes MyDyson), Cloudflare Access (login codes) | 100 |
| Promos crypto | Binance (rendements, staking, promos) | 95 |
| Notifications réseaux sociaux | Instagram / CHOWH1 on Instagram, Facebook / Marion sur Facebook | 90 |
| Newsletters promos | EcoFlow France, CORSAIR, FANATEC, Saily, Austrian Airlines, Lufthansa | 95 |
| Notifications apps | Deezer (recap semaine, concerts) | 90 |
| Newsletters non sollicitées | ChatGPT / OpenAI | 80 |
| Promos boutique | La Boutique Courrier International (différent des alertes éditoriales) | 85 |

### Cas particuliers à traiter avec attention

| Expéditeur | Garder | Supprimer |
|---|---|---|
| AliExpress | Confirmations de commande récentes (< 30 jours), suivi colis actif | Demandes d'avis anciennes, notifications commandes terminées |
| Orange | Factures Internet (« Votre facture est arrivée ») | Promos VOD, offres mini prix |
| Courrier International | Alertes éditoriales (actualité, reportages) | Promos boutique (« Découvrez notre sélection ») |

**Astuce Outlook :** utiliser le bouton **« Sélectionner »** en haut à droite de la barre d'outils pour tout sélectionner, puis cliquer sur **« Supprimer »**.

---

## SYSTÈME D'AUTO-APPRENTISSAGE

Même système que Gmail — 3 fichiers JSON dans `05_Data/outlook_patterns/` :

| Fichier | Rôle | Mise à jour |
|---|---|---|
| `whitelist.json` | 13 expéditeurs protégés (Apple, Orange factures, impôts, dons, santé, Rubix) | Manuelle ou quand Mickael conteste une suppression |
| `blacklist.json` | 14 expéditeurs à supprimer avec score 0-100 + cas particuliers documentés | Auto à chaque tri : confirmé = +10, contesté = -30 |
| `learning_log.json` | Journal de toutes les sessions | Auto après chaque session |

### Score de confiance et actions

| Score | Action | Dans le rapport ? |
|---|---|---|
| 100 | Suppression auto (spam évident) | NON |
| 90-99 | Suppression auto | OUI (vérification) |
| 70-89 | Ne pas supprimer | OUI (validation Mickael) |
| < 70 | Ne pas supprimer | OUI (décision Mickael) |

---

## RAPPORT JOURNALIER PAR EMAIL

Envoyé à `might@live.fr` via le navigateur Outlook (Nouveau message > auto-envoi).

### Contenu
- **Résumé** : nombre total traités, supprimés, gardés
- **Emails supprimés auto (confiance 90-99)** : pour vérification
- **Emails à valider** : expéditeurs inconnus ou confiance < 90
- **Nouveaux expéditeurs** : patterns pas encore dans la blacklist
- **Exclus** : spam évident (confiance 100)

- **Objet** : `[Jarvis] Rapport tri Outlook — {date}`
- **Fréquence** : 2× par jour (5h00 et 14h00)

---

## WORKFLOW COMPLET EN 8 ÉTAPES

| Étape | Action | Qui décide ? |
|---|---|---|
| 1 | Ouvrir Outlook dans le navigateur, vérifier session active | Jarvis (auto) |
| 2 | Lire les patterns (whitelist + blacklist) | Jarvis (auto) |
| 3 | Scanner la boîte de réception (lire la page) | Jarvis (auto) |
| 4 | Vider le Courrier indésirable | Jarvis (auto) |
| 5 | Supprimer les emails confiance ≥ 90 (bouton Sélectionner + Supprimer) | Jarvis (auto) |
| 6 | Envoyer le rapport journalier par email (Nouveau message > `might@live.fr`) | Jarvis (auto) |
| 7 | Mickael valide G / S / A si emails à valider | Mickael |
| 8 | Mettre à jour patterns + `learning_log` | Jarvis (auto) |

---

## RÈGLES DE SÉCURITÉ

### Interdictions absolues
- Jamais vider les Éléments supprimés sans validation explicite
- Jamais envoyer un email (sauf rapport à Mickael) sans confirmation
- Jamais ouvrir de pièces jointes suspectes ou de liens douteux
- Jamais répondre à un email sans instruction de Mickael
- Jamais supprimer un expéditeur de la whitelist

### Obligations
- Toujours sauvegarder en PDF les factures et alertes avant suppression
- Toujours archiver les reçus de dons et factures pro (impôts)
- Toujours utiliser le bouton « Sélectionner » pour les sélections en lot
- Toujours vérifier que la session Outlook est active avant d'agir
- Toujours confirmer le nombre d'emails traités en fin de tri

---

## GESTION DES ERREURS

| Situation | Action |
|---|---|
| Session Outlook expirée | Arrêter, notifier Mickael |
| Page de login affichée | Arrêter, Mickael doit se reconnecter |
| Erreur répétée | Vérifier ban IP (`03_Protocoles/IP_Bans.md`) |
| Email suspect / phishing | Ne pas ouvrir, signaler à Mickael |

---

*Document complémentaire au protocole général `02_Competences/Gestion_Emails.md`*
*Converti depuis Protocole_Outlook_might_live_fr.pdf v1.0 — 18 avril 2026*
