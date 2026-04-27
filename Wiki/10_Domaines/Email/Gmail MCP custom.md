---
title: Gmail MCP custom
created: 2026-04-25
tags: [email, email/gmail, email/mcp, domaine/email]
status: actif
parent: "[[_Index]]"
source: Ressources/Competences/Gmail_MCP_Custom.md
source_protocol: Ressources/Protocoles/Gmail.md
---

# Gmail MCP custom

Serveur MCP Gmail local installé pour la boîte `might57290@gmail.com`. Donne
à Jarvis un accès **CRUD complet** Gmail en CLI (lecture, labels, filtres,
PJ, suppression soft).

> **Pointeur** : la fiche d'install + audit + ACL est dans
> `Ressources/Competences/Gmail_MCP_Custom.md`. Le protocole d'usage côté
> tri est dans `Ressources/Protocoles/Gmail.md` (v3.0). Cet atome ne
> duplique pas — il résume la stack et liste les pièges transverses.

## Stack technique

| Champ          | Valeur                                                          |
|----------------|-----------------------------------------------------------------|
| Repo upstream  | `GongRzhe/Gmail-MCP-Server`                                     |
| SHA figé       | `a890d19` (S25 — install bout-en-bout)                          |
| Emplacement    | `Runtime/Gmail-MCP-Server/` (déplacé de Projets/ en S33)        |
| Type           | `stdio` (Node.js local pur, 127.0.0.1)                          |
| Client OAuth   | GCP projet `jarvis-ha-494017`, app *Gmail MCP*                  |
| Credentials    | `C:\Users\Might\.gmail-mcp\credentials.json` (ACL NTFS Mickael uniquement) |
| Scopes OAuth   | `gmail.readonly`, `gmail.modify`, `gmail.labels` (PAS `gmail.send`) |

## Outils exposés — `mcp__gmail-mcp-local__*`

| Famille            | Outils                                                                           | Capacités                                              |
|--------------------|----------------------------------------------------------------------------------|--------------------------------------------------------|
| Lecture            | `search_emails`, `read_email`, `list_email_labels`                               | Recherche syntaxe Gmail, lecture threads, listing labels. |
| Labels (écriture)  | `modify_email`, `batch_modify_emails`, `create_label`, `get_or_create_label`, `update_label` | Apply/retire labels, max 50 messageIds par batch.   |
| Suppression hard   | `delete_email`, `batch_delete_emails`                                            | ⚠️ **Deny** — interdits dans `settings.local.json`.    |
| Pièces jointes     | `download_attachment`                                                            | DL ≤ 25 Mo.                                            |
| Filtres natifs     | `create_filter`, `list_filters`, `get_filter`, `delete_filter`, `create_filter_from_template` | Règles Gmail persistantes (auto-archive, label).      |
| Envoi              | `send_email`, `draft_email`                                                      | ⚠️ Retournent **403** — scope `gmail.send` absent.    |

## Décision scope `gmail.send` absent (S27)

Choix **volontaire** : ne pas accorder le scope `gmail.send` ni `gmail.compose`
au Client OAuth. Conséquence : Jarvis **ne peut pas** envoyer un mail via
Gmail API. Tout envoi passe par le service HA `notify.might57290_gmail_com`
(voir [[Envoi via Home Assistant]]).

**Pourquoi** : limite drastique le blast radius en cas de bug ou prompt
injection. Jarvis peut lire et trier mais ne peut pas envoyer un mail
arbitraire à n'importe qui.

Auto-memory : `feedback_gmail_send_scope_absent`.

## Cowork ne charge pas les MCP stdio

**Découverte structurelle S26** : Cowork Desktop lit `.mcp.json` mais
n'instancie **que** les serveurs `type: http`. Les serveurs `type: stdio`
sont ignorés.

Conséquence directe : `gmail-mcp-local` n'est utilisable **que** via
Claude Code CLI (`claude -p` headless ou interactif). Toute skill de tri
Gmail tourne donc côté CLI, pas Cowork.

Auto-memory : `feedback_cowork_no_stdio`.

## Pattern brain + hands

Pour tout besoin Gmail en écriture depuis Cowork (ex. nettoyer 4 mails
test S31) :

1. **Brain (Cowork)** : prépare le prompt complet auto-porté avec tous les
   IDs et la logique de décision.
2. **Hands (Claude Code CLI)** : Mickael colle le prompt dans `claude -p`
   ou en interactif, le serveur stdio s'instancie, l'action s'exécute.

Pattern documenté `scripts/brain-hands-bascule-cli-s31.md`.

## Bug connu — `list_filters` (S27)

`create_filter` fonctionne mais `list_filters` retourne vide alors que le
filtre existe côté Gmail web. **Toujours vérifier l'UI Gmail** avant de
recréer un filtre (risque de doublon).

Auto-memory : `feedback_gmail_mcp_list_filters_bug`.

## Refresh token

Token OAuth Consent Testing dure **7 jours**. Pré-filtre PowerShell vérifie
l'âge `< 6 jours` (marge de sécurité). Refresh manuel par Mickael :

```powershell
cd "D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Runtime\Gmail-MCP-Server"
npm run auth
```

## Liens

- Fiche install + audit : `Ressources/Competences/Gmail_MCP_Custom.md`
- Protocole tri : `Ressources/Protocoles/Gmail.md`
- Pipeline tri : [[Tri Gmail automatise]]
- Envoi mail : [[Envoi via Home Assistant]]

---

*Atome créé S44. Stack stable depuis S25, décisions S27 figées.*
