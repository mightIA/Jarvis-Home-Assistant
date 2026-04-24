---
name: tri-email-gmail
description: Tri quotidien et à la demande des emails de la boîte Gmail might57290@gmail.com. Utilise le serveur MCP Gmail custom local (GongRzhe/Gmail-MCP-Server, outils mcp__gmail-mcp-local__*) pour toutes les actions CRUD + labels + filtres. Envoi du rapport journalier via service Home Assistant notify.might57290_gmail_com (scope gmail.send absent). Implémente l'auto-apprentissage via whitelist / blacklist / learning_log JSON et les scores de confiance 0-100.
---

# Skill : Tri email Gmail

## Quand cette skill est déclenchée

- Toute question parlant du tri email Gmail, de la boîte might57290, de
  suppression / archivage / rapport email.
- La tâche planifiée `tri-email-gmail-quotidien` (5h + 14h via Windows
  Task Scheduler, pas Cowork — voir section "Mode d'exécution").
- À la demande explicite de Mickael ("trie ma boîte Gmail").

## Boîte ciblée

`might57290@gmail.com` — voir `Ressources/Protocoles/Gmail.md` pour le
détail complet du protocole et `Ressources/Competences/Gmail_MCP_Custom.md`
pour la référence technique du serveur MCP.

## Mode d'exécution — ⚠️ CLI UNIQUEMENT

Le serveur MCP `gmail-mcp-local` est en transport **stdio** : il est
**chargé uniquement par Claude Code CLI**, pas par Cowork Desktop
(découvert session 26, voir auto-memory `feedback_cowork_no_stdio`).

Conséquences pratiques :

- Toute action Gmail write (modify_email, batch_*, delete_*) se lance
  depuis `claude` CLI, dans le dossier projet
  `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant`.
- Si je suis en Cowork quand Mickael demande un tri : pattern
  **brain(Cowork) + hands(CLI)** obligatoire (S19). Je prépare le plan
  + la query dans Cowork, Mickael lance `claude` CLI pour exécuter.
- La tâche planifiée quotidienne passe par **Windows Task Scheduler**
  qui lance `claude -p` headless avec `settings.local.json` allowlist.

## Fichiers de configuration

| Fichier | Rôle |
|---|---|
| `Ressources/Data/gmail_patterns/whitelist.json` | Expéditeurs protégés (9 entrées actuelles) |
| `Ressources/Data/gmail_patterns/blacklist.json` | Expéditeurs à supprimer avec score 0-100 (13 entrées) |
| `Ressources/Data/gmail_patterns/learning_log.json` | Journal des sessions de tri |
| `.claude/settings.local.json` | Allowlist des outils MCP auto-approuvés pour le mode headless |
| `scripts/tri-gmail-launcher.ps1` | Pré-filtre PowerShell (check credentials.json) + lancement `claude -p` |

## Labels IA Gmail

| Label | Usage |
|---|---|
| IA priorité haute | Emails urgents nécessitant une action rapide |
| IA priorité moyenne | Emails utiles mais non urgents |
| IA priorité faible | Emails informatifs à consulter au calme |
| IA suppression | Emails identifiés pour suppression en attente |
| Jarvis-RapportTri | Rapports quotidiens du tri email (auto-archivés via filtre Gmail natif) |

## Outils MCP utilisés

Tous préfixés `mcp__gmail-mcp-local__` :

| Outil | Usage dans la skill |
|---|---|
| `search_emails` | Étape 1 scan inbox + étape 3 collecte messageIds spam |
| `read_email` | Inspection ponctuelle d'un message pour arbitrage |
| `list_email_labels` | Vérifier existence des labels IA + Jarvis-RapportTri |
| `modify_email` | Action unitaire (rare, préférer batch) |
| `batch_modify_emails` | ⭐ Cœur du tri : applique/retire labels par lots de **50 messageIds max** |
| `batch_delete_emails` | Non utilisé en prod (réservé aux cas exceptionnels, préférer TRASH) |
| `create_label` | Créer Jarvis-RapportTri si absent |
| `create_filter` | Créer le filtre auto-archivage des rapports |
| `download_attachment` | Sauvegarde PDF avant suppression si besoin |

**Outils interdits dans cette skill** (via `settings.local.json` deny) :
`delete_email` (hard delete), `delete_label`, `delete_filter`.

**Envoi emails** : `send_email` et `draft_email` retournent **403** (scope
`gmail.send` absent côté OAuth GCP). Tout envoi passe par le service HA
`notify.might57290_gmail_com` via `mcp__home-assistant__ha_call_service`.

## Workflow en 9 étapes

1. **Scanner** l'inbox via `search_emails` avec query
   `in:inbox -label:Jarvis-Alert -label:Jarvis-RapportTri`. L'exclusion
   de `Jarvis-Alert` est obligatoire (alertes gérées par la skill
   `check-jarvis-alert`). L'exclusion de `Jarvis-RapportTri` évite de
   retrier les rapports quotidiens.
2. **Comparer** les expéditeurs avec whitelist + blacklist, calculer les
   scores de confiance, pondérer selon la catégorie Gmail (labels
   `CATEGORY_*` présents dans chaque message) :
   - `CATEGORY_SOCIAL` ou `CATEGORY_PROMOTIONS` → score base +30
   - `CATEGORY_PERSONAL` (Principale) → score base -20
   - `CATEGORY_UPDATES` / `CATEGORY_FORUMS` → neutre
3. **Vider Spam** : `search_emails label:spam` → collecter messageIds →
   `batch_modify_emails` par lots de 50 avec
   `addLabelIds: ["TRASH"]` + `removeLabelIds: ["SPAM"]`.
4. **Supprimer auto** les messages de score ≥ 90 :
   `batch_modify_emails` par lots de 50 avec
   `addLabelIds: ["TRASH"]` + `removeLabelIds: ["INBOX"]`.
5. **Envoyer le rapport journalier** via
   `mcp__home-assistant__ha_call_service` →
   `notify.might57290_gmail_com` avec :
   - `data.target` = `["might57290@gmail.com"]` — **obligatoire**,
     l'intégration google_mail lève `ValueError: recipient address
     required` → HTTP 500 sans ce champ (découvert S27 V1 réel).
   - `data.title` = `[Jarvis] Rapport tri emails — {YYYY-MM-DD}`
   - `data.message` = corps texte listant supprimés + à valider +
     nouveaux patterns + stats. HTML pas encore validé sur cette
     intégration — rester en texte brut tant que non testé.
   - Le filtre Gmail natif `Jarvis-RapportTri` appliquera
     automatiquement le label + archivera hors INBOX.
6. **Attendre la validation Mickael** (G / S / A par numéro) si emails
   à valider dans le rapport. En mode scheduled/headless : pas
   d'attente, les actions 70-89 restent en boîte avec label
   `IA suppression` pour revue manuelle ultérieure.
7. **Exécuter les actions validées** :
   - S → `batch_modify_emails` TRASH
   - A → `batch_modify_emails` removeLabelIds=[INBOX] (archive Gmail)
   - G → rien (laisser en INBOX)
8. **Mettre à jour** les patterns + `learning_log.json` :
   - confirmation S → score +10 (max 100)
   - contestation G → score -30, et si 2 erreurs sur le même
     expéditeur → déplacement en whitelist
9. **Confirmer** le résultat final à Mickael (nombre restant, archivés,
   supprimés) + écriture du log dans
   `memory/historique_tri_gmail/run_{timestamp}.json`.

## Scores de confiance

| Score | Action | Dans le rapport ? |
|---|---|---|
| 100 | Suppression auto | NON (spam évident) |
| 90-99 | Suppression auto | OUI (vérification) |
| 70-89 | Ne pas supprimer | OUI (validation) |
| < 70 | Ne pas supprimer | OUI (décision) |

## Règles de sécurité

- Jamais vider la corbeille Gmail (hard delete) sans validation
  explicite — la skill utilise TRASH label, pas `batch_delete_emails`.
- Jamais envoyer un email libre hors rapport sans validation Mickael.
- En début de session CLI : vérifier que `/mcp` affiche
  `gmail-mcp-local · connected`. Si `invalid_grant` → token expiré,
  relancer `npm run auth` dans `Runtime/Gmail-MCP-Server`.
- **Ne jamais toucher aux threads avec le label `Jarvis-Alert`** — ce
  sont les alertes du Mode Réactif, traitées exclusivement par
  `check-jarvis-alert`. Jamais supprimer, archiver, relabeler ou
  répondre.
- Respecter la limite **50 messageIds par appel `batch_modify_emails`**
  (quota Gmail API 250 units/user/seconde, 5 units/message).

## Limitations connues

- Scope `gmail.send` absent → pas d'envoi direct, rapport via HA notify.
- Scope `gmail.compose` absent → pas de brouillons. La rédaction libre
  passe par la skill `redaction-email` + envoi HA notify.
- OAuth Consent en Testing → refresh_token valide ~7 jours. Pré-filtre
  PowerShell vérifie l'âge de `credentials.json` avant chaque run.
- `download_attachment` limité aux PJ ≤ 25 Mo (limite Gmail).

## Cas particuliers à mémoriser

- AliExpress : garder les confirmations de commande récentes (< 30 jours).
- Orange : garder les factures, supprimer les promos VOD.
- Courrier International : garder les alertes éditoriales, supprimer les
  promos boutique.
- Apple, Frisquet Connect, impôts, banques, dons : whitelist permanente.

## Référence longue

- `Ressources/Protocoles/Gmail.md` — protocole complet (v3.0 — 22 avril 2026)
- `Ressources/Competences/Gmail_MCP_Custom.md` — référence technique
  du serveur MCP (19 outils, OAuth, réinstall, diagnostic)
