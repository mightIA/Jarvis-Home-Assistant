---
title: Tri Gmail automatisé
created: 2026-04-25
updated: 2026-04-25
tags: [atome, email, email/gmail, email/tri, domaine/email]
status: actif
parent: "[[_Index]]"
source_skill: .claude/skills/tri-email-gmail/SKILL.md
source_protocol: Ressources/Protocoles/Gmail.md
---

# Tri Gmail automatisé

Pipeline de tri quotidien de la boîte `might57290@gmail.com`. **Mode
d'exécution** : Claude Code CLI **uniquement** (Cowork ne charge pas les MCP
stdio — auto-memory `feedback_cowork_no_stdio`).

## Cadence

| Run         | Heure  | Déclencheur                          |
|-------------|--------|--------------------------------------|
| Matin       | 05h00  | Windows Task Scheduler `Jarvis-TriGmail-Quotidien` |
| Après-midi  | 14h00  | Même tâche, double trigger          |

XML source : `scripts/jarvis-trigmail-quotidien.xml`. Configuration via
`schtasks /Create /XML`. Première mise en service S27 (V1 réel validé).

## Pré-filtre PowerShell

Avant de lancer `claude -p`, le launcher
`scripts/tri-gmail-launcher.ps1` vérifie :

1. **Existence** de `credentials.json` dans `C:\Users\Might\.gmail-mcp\`.
2. **Âge** du fichier `< 6 jours` (token OAuth Consent Testing dure 7 j).
3. Si KO → email d'alerte HA via `notify.might57290_gmail_com` puis `exit 1`.
4. Si OK → lance `claude -p` en mode headless avec le prompt skill.

Si l'âge est dépassé, Mickael relance `npm run auth` dans
`Runtime/Gmail-MCP-Server/` pour rafraîchir le token.

## Workflow 9 étapes

| # | Action                                                           | Outil           | Décide       |
|---|------------------------------------------------------------------|-----------------|--------------|
| 1 | Scan inbox `in:inbox -label:Jarvis-Alert -label:Jarvis-RapportTri` | MCP Gmail     | Auto         |
| 2 | Comparer whitelist / blacklist + scores + pondération `CATEGORY_*` | JSON local    | Auto         |
| 3 | Vider Spam via `batch_modify_emails` TRASH (lots de 50)          | MCP Gmail       | Auto         |
| 4 | Supprimer périmés et promos répétitives (score ≥ 90)             | MCP Gmail       | Auto         |
| 5 | Envoyer rapport via `notify.might57290_gmail_com`                | MCP HA          | Auto         |
| 6 | Mickael valide G/S/A par numéro (mode interactif uniquement)     | —               | Mickael      |
| 7 | Exécuter actions validées via `batch_modify_emails`              | MCP Gmail       | Sur validation |
| 8 | Mettre à jour patterns + `learning_log.json`                     | Fichiers JSON   | Auto         |
| 9 | Confirmer + log JSON dans `memory/historique_tri_gmail/`         | —               | Auto         |

## Auto-apprentissage — 3 fichiers JSON

Stockés dans `Ressources/Data/gmail_patterns/` :

| Fichier               | Rôle                                                                                          |
|-----------------------|-----------------------------------------------------------------------------------------------|
| `whitelist.json`      | Expéditeurs protégés — JAMAIS supprimer (impôts, banques, famille, dons déductibles).        |
| `blacklist.json`      | Expéditeurs à supprimer + score 0-100. Plus haut = plus auto.                                |
| `learning_log.json`   | Journal des sessions : stats, patterns découverts, erreurs, feedback.                        |

### Évolution du score

- Mickael répond `S` (supprimer) → expéditeur **+10** (max 100).
- Mickael répond `G` (garder) → expéditeur **−30**, déplacé en whitelist
  après **2 contestations** sur le même expéditeur.

## Pondération CATEGORY_* (Gmail tabs)

Chaque message Gmail porte une catégorie native qui modifie le score :

| Label                  | Pondération |
|------------------------|-------------|
| `CATEGORY_PROMOTIONS`  | +30 (agressif)              |
| `CATEGORY_SOCIAL`      | +30 (agressif)              |
| `CATEGORY_UPDATES`     |  +0 (neutre)                |
| `CATEGORY_FORUMS`      |  +0 (neutre)                |
| `CATEGORY_PERSONAL`    | −20 (prudent — Principale) |

Exemple : un expéditeur blacklist à 60 + label `CATEGORY_PROMOTIONS` → score
effectif 90 → suppression auto, sans toucher aux mails de l'onglet Principale.

## Quota Gmail API

- **250 units/user/seconde** (limite globale).
- `messages.modify` = 5 units → **50 messageIds max par batch**.
- Si dépassement (HTTP 429) : réduire taille batch ou ajouter pause 1,1 s.

## Sécurité — interdictions

- `delete_email` et `batch_delete_emails` en **deny** dans
  `.claude/settings.local.json`. Toujours passer par TRASH label
  (récupérable 30 j).
- `send_email` et `draft_email` retournent **403** (scope `gmail.send` /
  `gmail.compose` absents côté OAuth — choix volontaire S27, voir
  [[Gmail MCP custom]]).
- Threads avec label `Jarvis-Alert` : **interdiction absolue** d'y toucher
  (réservés à `check-jarvis-alert` Mode Réactif).

## Rapport — filtre auto

Un filtre Gmail natif créé via `create_filter` :

- **Critère** : `from:me subject:"[Jarvis] Rapport tri emails"`
- **Actions** : addLabel `Jarvis-RapportTri` + removeLabel `INBOX`

Les rapports ne polluent pas l'INBOX et sont consultables d'un clic via le
label dédié.

## Liens

- Skill : `.claude/skills/tri-email-gmail/SKILL.md`
- Protocole détaillé : `Ressources/Protocoles/Gmail.md` (v3.0)
- Stack MCP : [[Gmail MCP custom]]
- Service envoi : [[Envoi via Home Assistant]]
- Logs runs : `memory/historique_tri_gmail/run_YYYY-MM-DD_HHMMSS.json`

---

*Atome créé S44. Pipeline opérationnel depuis S27 (V1 réel 22/04/2026).*
