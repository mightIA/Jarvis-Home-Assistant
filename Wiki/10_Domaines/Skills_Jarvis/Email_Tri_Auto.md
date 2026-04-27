---
title: Skills Email — Tri auto & rédaction
created: 2026-04-27
tags: [skill, email]
status: actif
domaine: Skills_Jarvis
---

# Skills Email — Tri auto & rédaction

Catégorie regroupant les 4 skills qui touchent aux 4 boîtes mail de Mickael (voir [[Wiki/10_Domaines/Email/Boites_Email]]).

## Skills incluses

### `tri-email-gmail`

- **Déclencheur** : tâche planifiée Windows `tri-email-gmail-quotidien` (5h + 14h) + demande explicite ("trie ma boîte Gmail") + toute mention de tri Gmail / boîte `might57290@gmail.com`.
- **Boîte** : `might57290@gmail.com`.
- **Dépendances** :
  - MCP `gmail-mcp-local` (stdio, **CLI uniquement** — Cowork ne charge pas stdio)
  - Service HA `notify.might57290_gmail_com` pour l'envoi du rapport (scope `gmail.send` volontairement absent)
  - Filtre Gmail auto-label `Jarvis-RapportTri`
  - Fichiers patterns : `Ressources/Data/gmail_patterns/whitelist.json` + `blacklist.json` + `learning_log.json`
  - Pattern brain(Cowork) + hands(CLI) si demande arrive en Cowork
- **Détail exécutable** : `.claude/skills/tri-email-gmail/SKILL.md`
- **Liens vault** : [[Wiki/10_Domaines/Email/Tri_Gmail_Automatise]], [[Wiki/10_Domaines/Email/Gmail_MCP_Custom]], [[Wiki/10_Domaines/Email/Envoi_via_Home_Assistant]]

### `tri-email-outlook`

- **Déclencheur** : tâche planifiée `tri-email-outlook-quotidien` (5h + 14h) + demande explicite ("trie ma boîte Outlook") + mention de la boîte `might@live.fr`.
- **Boîte** : `might@live.fr` via `https://outlook.live.com/mail/0/inbox`.
- **Dépendances** :
  - MCP **Claude in Chrome** (Brave) — pas de connecteur MCP Outlook
  - Session Outlook active dans Brave
  - Fichiers patterns : `Ressources/Data/outlook_patterns/whitelist.json` + `blacklist.json` + `learning_log.json`
  - Rapport auto-envoyé par email
- **Détail exécutable** : `.claude/skills/tri-email-outlook/SKILL.md`
- **Liens vault** : [[Wiki/10_Domaines/Email/Tri_Outlook]], [[Wiki/10_Domaines/Email/Boites_Email]]

### `tri-email-outlook-priorites`

- **Déclencheur** : demande explicite Mickael ("trie ma boîte Outlook par priorité", "classe mes mails Outlook", "fait le tri Outlook avec moi"). Premier nettoyage d'une boîte encombrée ou validation visuelle souhaitée.
- **Boîte** : `might@live.fr`.
- **Dépendances** :
  - MCP **Claude in Chrome** (Brave)
  - 4 dossiers Outlook créés au préalable : `Urgent`, `Perso`, `Info`, `À supprimer`
  - Pas d'auto-apprentissage (workflow purement manuel/interactif)
  - Mickael valide chaque lot ("Urgent : 1 sup, 2-3 non lu, 4 perso")
- **Détail exécutable** : `.claude/skills/tri-email-outlook-priorites/SKILL.md`
- **Liens vault** : [[Wiki/10_Domaines/Email/Tri_Outlook]]

### `redaction-email`

- **Déclencheur** : demande de rédaction ("écris à X", "réponds à ce mail"), réponse à un email reçu (après approbation explicite).
- **Boîtes** : toutes (Gmail / Outlook / autres).
- **Dépendances** :
  - MCP `gmail-mcp-local` `create_draft` (méthode préférée pour Gmail)
  - MCP **Claude in Chrome** pour Outlook ou vérification finale
  - Adaptation du ton selon le destinataire (6 profils : Pro, SAV, Admin, Proche, Asso, Auto-envoi)
  - Validation explicite avec screenshot avant envoi
- **Détail exécutable** : `.claude/skills/redaction-email/SKILL.md`
- **Liens vault** : [[Wiki/10_Domaines/Email/Redaction_email]], [[Wiki/10_Domaines/Email/Boites_Email]]

## Patterns d'usage transversaux

### Pattern brain + hands (S19)

Toute action **write** Gmail (`modify_email`, `batch_*`, `delete_*`, `create_draft`) passe par Claude Code CLI car le MCP `gmail-mcp-local` est en transport stdio. Cowork = lecture seule via connecteur Gmail natif.

- **Brain (Cowork)** : prépare la query, le plan d'action, le filtre.
- **Hands (CLI)** : Mickael lance `claude` dans `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant` pour exécuter.

### Envoi mail sans scope `gmail.send`

Le scope OAuth `gmail.send` est volontairement absent (`send_email` / `draft_email` en deny). Tout envoi de mail (rapports, notifications) passe par `ha_call_service` `notify.might57290_gmail_com` (champ `data.target` obligatoire, pas de pièces jointes).

### Cron Windows Task Scheduler

Les skills planifiées (`tri-email-gmail`, `tri-email-outlook`) tournent via Windows Task Scheduler qui lance `claude -p` headless avec `settings.local.json` allowlist. Les tokens CLI headless comptent dans le quota **Plan Max** (pas en facturation API).

## Voir aussi

- [[_Index]] — MOC Skills Jarvis
- [[Wiki/10_Domaines/Email/_Index]] — domaine Email
- `Ressources/Protocoles/Gmail.md` + `Ressources/Protocoles/Outlook.md` — protocoles complets
