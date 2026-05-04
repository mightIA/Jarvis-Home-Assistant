---
title: Gmail MCP Custom — Référence technique
source: GongRzhe/Gmail-MCP-Server (package @gongrzhe/server-gmail-autoauth-mcp)
version_auditee: 1.1.11
audit_sha: a890d19189bbc1325b8728fab830fc278cfd8804
install_date: 22/04/2026
install_session: 25
validation_dry_run: S26 — Phase 4 FAIT bout-en-bout (list_labels + search + 2× modify_email TRASH + vérif visuelle + search post-trash 0 résultat)
contexte_decision: S24b (archive 2026-04-21_session_24b_mcp_gmail_custom_decision.md)
contrainte_structurelle: ⚠️ Cowork Desktop NE CHARGE PAS les MCP stdio. Ce serveur tourne uniquement depuis Claude Code CLI. Pour toute opération Gmail write (modify_email, batch_*, send_email), lancer `claude` CLI depuis le dossier projet. Pattern brain(Cowork)+hands(CLI) S19 obligatoire.
---

# Gmail MCP Custom — Référence technique

Serveur MCP Gmail local installé en session 25 pour contourner le bug
Anthropic #46206 du connecteur Gmail officiel (pas de scope gmail.modify,
label_thread impossible).

## Architecture en 1 image

```
Claude Code CLI (claude) dans D:\...\Jarvis - Home Assistant\
    ↓ stdin/stdout (stdio pur, aucun port réseau)
node dist/index.js                     ← lancé par Claude Code CLI à chaque démarrage de conv
    ↓
Server MCP @modelcontextprotocol/sdk
    ↓ googleapis SDK officiel
    ↓ HTTPS vers gmail.googleapis.com
Google Gmail API
```

⚠️ **Cowork Desktop N'EST PAS le lanceur** — découvert S26 pendant le
dry-run Phase 4. Cowork ne charge que les connecteurs HTTP/OAuth pairés
via `claude.ai/customize/connectors`. Les MCPs stdio de `.mcp.json` sont
consommés **exclusivement par Claude Code CLI** (`claude` dans PowerShell).

Aucune écoute réseau permanente. Le seul moment où un port s'ouvre est le
tout premier lancement de `npm run auth` (serveur HTTP éphémère sur
localhost:3000 pour capter le redirect OAuth, fermé dès que le token est
obtenu).

## Comment utiliser ce MCP

Depuis PowerShell :
```powershell
cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
claude
```
Au premier lancement, Claude Code demande à autoriser `gmail-mcp-local` :
choix option **2 (Use this MCP server)** — n'autorise que celui-ci, refus
des futurs MCPs par défaut (sécurité).

Dans la conv CLI, `/mcp` doit afficher `gmail-mcp-local · connected`.
Les 19 outils deviennent disponibles sous le préfixe
`mcp__gmail-mcp-local__*`.

Pour chaque outil d'écriture/suppression (`modify_email`,
`batch_modify_emails`, `batch_delete_emails`, `send_email`, `delete_email`,
`create_filter`, etc.) : choix **1 (Yes)** à chaque appel pour conserver
l'approbation explicite (Règle 0 CLAUDE.md).

## Validation dry-run Phase 4 (S26, 22/04/2026)

| Étape | Outil | Résultat |
|---|---|---|
| 1 | `list_email_labels` | 5 labels IA priorité + Jarvis-Alert présents ✅ |
| 2 | `search_emails from:news@topazlabs.com` + `from:hello@hellowatt.fr` | 2 messageIds (thread single-message) |
| 3 | `read_email` × 2 + inspection schéma `modify_email` | messageId obligatoire, addLabelIds + removeLabelIds optionnels. Opère au niveau message. |
| 4 | `modify_email` messageId topaz + `addLabelIds: ["TRASH"]` + `removeLabelIds: ["INBOX"]` | API `labels updated successfully` + vérif visuelle Gmail web ✅ |
| 5 | `modify_email` messageId hellowatt (mêmes params) | API OK + vérif visuelle ✅ |
| 6 | `search_emails` post-trash sur les 2 expéditeurs | 0 résultat (exclut TRASH par défaut) ✅ |

Conclusion : les 19 outils sont opérationnels côté Claude Code CLI.
La bascule Phase 5 de la skill `tri-email-gmail` (remplacement Brave →
outils natifs `mcp__gmail-mcp-local__*`) peut commencer.

## Emplacements fichiers

### Secrets (C:\Users\Might\.gmail-mcp\)

| Fichier | Contenu | Sensibilité | Source |
|---|---|---|---|
| `gcp-oauth.keys.json` | `client_id` + `client_secret` GCP | 🔴 Très sensible | Download manuel GCP console |
| `credentials.json` | **Token OAuth** (access_token + refresh_token) | 🔴 **Critique** | Généré auto par `npm run auth` |

⚠️ **Piège de nommage** : dans ce repo, `credentials.json` = TOKEN, pas le
fichier GCP (contrairement à la convention Google habituelle).

**Permissions NTFS** : héritage retiré + ACL limitée à Mickael uniquement
(via `icacls /inheritance:r /grant:r "${USERNAME}:(R,W)"` appliqué lors de
l'install).

### Code source (Runtime/Gmail-MCP-Server/)

- Clone local figé sur SHA `a890d19`
- `dist/index.js` = entrypoint compilé (lancé par Cowork)
- `src/index.ts` = source TypeScript (55 KB, 19 outils)
- `.gitignore` protège les 2 fichiers secrets

## Authentification OAuth Google

### Client OAuth GCP

- **Projet GCP** : `jarvis-ha-494017` (nommage affichage : "Jarvis HA")
- **Client** : `Gmail MCP` (type Application Web)
- **Redirect URI** : `http://localhost:3000/oauth2callback`
- **Créé le** : 21/04/2026 (session 25)

### Scopes accordés

- `https://www.googleapis.com/auth/gmail.modify` — lire/écrire/modifier/supprimer
  emails + gérer labels
- `https://www.googleapis.com/auth/gmail.settings.basic` — créer/lister/supprimer
  filtres Gmail natifs, paramètres pop/imap/forwarding (sans sharing)

### Pas de scope demandé

- ❌ `gmail.send` / `gmail.compose` → tools `send_email` et `draft_email`
  retournent 403 Google (envoi passe par `notify.might57290_gmail_com` dans HA)
- ❌ `gmail.readonly` (déjà couvert par `gmail.modify`)
- ❌ `gmail.settings.sharing` → pas de délégation/forwarding dangereux

### Renouvellement du token

Le `refresh_token` stocké dans `credentials.json` est valide indéfiniment
tant que :
- L'utilisateur ne le révoque pas (myaccount.google.com → Sécurité →
  Applications tierces → Gmail MCP)
- Les scopes ne changent pas (tout changement invalide le token)
- L'app OAuth Consent reste en état Testing actif

Si le token expire / est révoqué, relancer :
```powershell
cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\Runtime\Gmail-MCP-Server"
npm run auth
```

⚠️ L'OAuth Consent en Testing a une **durée de validité de 7 jours** pour
les refresh_tokens des apps non-vérifiées. Si le tri email tombe en erreur
`invalid_grant` après ~1 semaine, c'est très probablement le token expiré,
relancer `npm run auth`.

## Outils exposés (19 au total)

Les noms d'outils côté Cowork sont préfixés `mcp__gmail-mcp-local__<tool>`.

### Email CRUD (9)

| Tool | Usage |
|---|---|
| `send_email` | ⚠️ **403** (pas de scope send) |
| `draft_email` | ⚠️ **403** (pas de scope compose) |
| `read_email` | Lire le contenu d'un thread/message |
| `search_emails` | Recherche Gmail (syntaxe `from:`, `to:`, `subject:`, `label:`, `-label:`, etc.) |
| `modify_email` | ⭐ Appliquer/retirer labels sur un thread (cœur du tri email) |
| `delete_email` | Déplacer en corbeille |
| `batch_modify_emails` | ⭐⭐ Batch modify labels — critique pour tri par vagues |
| `batch_delete_emails` | ⭐⭐ Batch corbeille — critique pour spam massif |
| `download_attachment` | Télécharger une pièce jointe |

### Labels (5)

| Tool | Usage |
|---|---|
| `list_email_labels` | Lister tous les labels (INBOX, TRASH, SPAM, Jarvis-Alert, custom) |
| `create_label` | Créer un nouveau label |
| `update_label` | Renommer/modifier un label |
| `delete_label` | Supprimer un label |
| `get_or_create_label` | Idempotent — utile dans scripts |

### Filtres Gmail natifs (5)

| Tool | Usage |
|---|---|
| `create_filter` | Créer un filtre Gmail (critères + actions) |
| `list_filters` | Lister tous les filtres |
| `get_filter` | Détails d'un filtre |
| `delete_filter` | Supprimer un filtre |
| `create_filter_from_template` | Créer depuis un template prédéfini |

## Vulnérabilités résiduelles acceptées

2 CVE résiduelles après nettoyage (12 → 2 via `npm audit fix` + uninstall
`mcp-evals`). Toutes les deux sans exposition réelle dans la config Jarvis.

### `@modelcontextprotocol/sdk@0.4.0` — 2 CVE (high)

- **ReDoS** : inputs trusted en stdio (viennent de Cowork, pas d'attaquant
  externe) → pas d'exposition
- **DNS rebinding disabled** : inapplicable, pas d'écoute HTTP → pas
  d'exposition

Fix = upgrade v1.29.0 = **breaking** (API changée entre v0.4 et v1.x).
Décision : rester sur v0.4.x tant que l'upstream n'a pas migré.

### `nodemailer@7.x` — 2 CVE (moderate)

- SMTP injection via `envelope.size` et `EHLO/HELO` transport name.
- **Jamais appelé** car scope `gmail.send` absent.

Fix = upgrade v8.0.5 = **breaking**. Décision : ignorer.

## Procédure de réinstallation complète

En cas de corruption / format / migration PC :

```powershell
# 1. Cloner le repo au SHA auditable
cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\Projets"
git clone https://github.com/GongRzhe/Gmail-MCP-Server.git
cd .\Gmail-MCP-Server
git checkout a890d19189bbc1325b8728fab830fc278cfd8804

# 2. Récupérer les secrets depuis backup OneDrive (ou régénérer)
# Les fichiers gcp-oauth.keys.json + credentials.json doivent être dans
# C:\Users\Might\.gmail-mcp\ avec permissions restreintes.

# 3. Install + audit + cleanup vulns
npm install
npm uninstall mcp-evals
npm audit fix
npm run build

# 4. Si credentials.json perdu : relancer npm run auth
# 5. Vérifier que .mcp.json du projet Jarvis contient gmail-mcp-local
```

## Monitoring / diagnostic

### Le serveur ne se lance pas (Cowork)

Logs : Cowork affiche les stderr du sous-process dans les logs de la
conversation. Chercher :
- `OAuth keys file not found` → `gcp-oauth.keys.json` absent de `~/.gmail-mcp/`
- `invalid_grant` → token expiré, relancer `npm run auth`
- `ECONNREFUSED` pendant auth → port 3000 déjà utilisé par autre chose

### Un outil retourne 403

- `send_email` / `draft_email` → **attendu** (scope absent, n'utiliser ni
  l'un ni l'autre)
- Autre outil → vérifier OAuth Consent en Testing actif + Mickael toujours
  test user sur le projet GCP

### Token révoqué

Côté utilisateur : myaccount.google.com → Sécurité → Applications tierces →
`Gmail MCP` → Supprimer accès. Cela invalide le refresh_token.

Côté Jarvis : le prochain appel retournera `invalid_grant`. Relancer
`npm run auth` pour refaire le flow OAuth.

## Historique de maintenance

| Date | Évènement | Session |
|---|---|---|
| 22/04/2026 | Install initial (Phases 0-3), version 1.1.11 @ SHA a890d19 | S25 |
| 22/04/2026 | Phase 4 dry-run FAIT bout-en-bout (list_labels + search + 2× modify_email TRASH + vérif visuelle + 0 résultat post-trash). Découverte structurelle Cowork ≠ stdio | S26 |
| 22/04/2026 | **Phase 5 étape 2 FAIT** : refonte docs skill tri-email-gmail + Gmail.md v3.0 + settings.local.json reconstruit + scripts/tri-gmail-launcher.ps1 créé. Reste étapes Mickael CLI (label+filtre, webhook HA, Task Scheduler, tests V1/V2/V3) | S27 matin |
| 22/04/2026 | **Phase 5 étapes 3+4+5 FAIT en CLI** (suite S27) : label `Jarvis-RapportTri` (ID Label_3) + filtre Gmail natif `from:me subject:"[Jarvis] Rapport tri emails"` (bug cosmétique `list_filters` noté), Task Scheduler `Jarvis-TriGmail-Quotidien` via XML ré-encodé UTF-16 LE BOM, scripts bonus (`jarvis-cli.ps1/.bat`, `install-jarvis-shortcut.ps1`, icône pixel art Pillow), dry-run V0 + **V1 réel RÉUSSI** bout-en-bout. Bug `notify.might57290_gmail_com` découvert (`data.target` obligatoire) et corrigé transverse (SKILL.md + Gmail.md + auto-memory locale `memory/feedback_notify_gmail_target.md`). V3 auto demain 23/04 05:00. | S27 fin |

## Annexe Phase 5 — outillage ajouté session 27

### `.claude/settings.local.json` allowlist

Fichier reconstruit (l'ancien était tronqué à `"m`). Contenu :

- **allow** : Read projet + plugins Claude, Write/Edit sur `memory/historique_tri_gmail/` + `Ressources/Data/gmail_patterns/`, Bash python3/curl, outils MCP Gmail read+write (search/read/modify/batch_modify/list_email_labels/create_label/get_or_create_label/update_label/create_filter/list_filters/get_filter/download_attachment), HA ha_call_service
- **deny** : `delete_email`, `batch_delete_emails`, `delete_label`, `delete_filter`, `send_email` (403 attendu), `draft_email` (403 attendu)

La restriction `ha_call_service` au seul service `notify.might57290_gmail_com` n'est pas possible en syntaxe native Claude Code (pas de filtre par argument MCP standardisé) ; on compte sur le prompt CLI de la skill pour ne jamais appeler un autre service. À revalider si Claude Code ajoute un support natif.

### `scripts/tri-gmail-launcher.ps1` pré-filtre PowerShell

Séquence d'exécution :

1. Vérifie `$env:USERPROFILE\.gmail-mcp\credentials.json` existe
2. Vérifie âge `LastWriteTime` < 6 jours (marge OAuth Consent Testing 7j)
3. Crée `memory\historique_tri_gmail\` si absent
4. Se place dans le dossier projet
5. Vérifie `claude` est dans le PATH
6. Lance `claude -p "<prompt skill>" --output-format json | Tee-Object log`
7. Exit 0/1/2 selon succès/pré-filtre/claude

En cas d'échec du pré-filtre : tentative d'envoi alerte via webhook HA `jarvis_gmail_token_alert` (optionnel — à créer côté HA). Fallback silencieux si webhook indisponible.

### Scheduled Task Windows à créer (reste à faire côté Mickael)

- Nom : `Jarvis-TriGmail-Quotidien`
- Triggers : 05:00 et 14:00 tous les jours (heure locale)
- Action : `PowerShell.exe -ExecutionPolicy Bypass -File "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\scripts\tri-gmail-launcher.ps1"`
- Compte : utilisateur Mickael (pour accéder à `$env:USERPROFILE\.gmail-mcp\`)
- Conditions : démarrer même si le PC est sur batterie (PC allumé 24h/24)

---
*Dernière mise à jour : 22 avril 2026 (session 27 — Phase 5 étape 2 FAIT)*
