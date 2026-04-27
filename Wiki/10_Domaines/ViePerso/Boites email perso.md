---
title: Boîtes email de Mickael — vue Vie perso
created: 2026-04-25
tags: [vieperso/email, email]
parent: "[[_Index]]"
status: actif
---

# Boîtes email perso

Source de vérité pour toute action email côté Vie perso. Vue
**simplifiée** (4 boîtes + canal de tri actuel). Vue technique détaillée
côté `[[10_Domaines/Email/Boites email]]`.

> **Règle email** : toujours **nommer explicitement la boîte traitée**
> (`might57290@gmail.com` vs `might@live.fr` vs autre) — ne jamais
> supposer (auto-memory `feedback_email_boite_explicite`).

## Les 4 boîtes (S31)

| Boîte | Type | Compte Gmail | Canal tri actuel | Usage |
|---|---|---|---|---|
| `might57290@gmail.com` | Gmail | `u/0` | ✅ gmail-mcp-local stdio CLI (5h+14h) + Mode Réactif | **Principal** |
| `mighthomeassistant@gmail.com` | Gmail | `u/1` | ⚠️ Brave only | Dédié Home Assistant |
| `mickael.rubino@gmail.com` | Gmail | `u/2` | ⚠️ Brave only | Perso (à préciser) |
| `might@live.fr` | Outlook | — | ⚠️ Brave only (tri manuel S28) | Perso Outlook |

## Limitations actuelles

- **`gmail-mcp-local` est authentifié pour 1 SEULE boîte** (`might57290`)
  via `credentials.json` dans `C:\Users\Might\.gmail-mcp\`.
- Les **scheduled Cowork ne marchent pas** pour les MCP stdio (auto-memory
  `feedback_cowork_no_stdio`) → toute tâche de tri auto passe par
  Windows Task Scheduler + Claude Code CLI (pattern brain+hands).
- **Outlook `might@live.fr`** dépend de la tâche #48 (MCP Microsoft
  Graph API).

## Plan multi-boîtes (TASKS #52, à planifier S?)

Pour trier en CLI les 2 autres Gmail (`mighthomeassistant` +
`mickael.rubino`), il faut **2 instances supplémentaires** du GongRzhe
Gmail MCP avec **2 Clients OAuth GCP distincts** (1 par boîte).
Setup ~30 min/boîte.

Procédure prévue par boîte :
1. Créer Client OAuth GCP dédié (Console GCP → APIs & Services →
   Credentials).
2. Télécharger `credentials.json` dans dossier dédié
   `C:\Users\Might\.gmail-mcp-<alias>\`.
3. Cloner `Runtime/Gmail-MCP-Server/` dans
   `Runtime/Gmail-MCP-Server-<alias>/`.
4. Adapter `.mcp.json` avec 2 entrées MCP supplémentaires (chaque MCP
   pointe sur son `credentials.json` dédié).
5. Tester `npm run auth` sur chaque instance, refresh token tous les
   7 jours.

## Boîte de réception unifiée (option future)

Idée à creuser : interface vie perso (V4 prévue dans
`[[Prompt Vie perso]]`) pourrait **agréger** les 4 boîtes côté UI tout
en gardant les 4 MCP backend séparés.

## Liens

- Hub Email technique : `[[10_Domaines/Email/_Index]]`
- Atome détaillé multi-boîtes : `[[10_Domaines/Email/Boites email]]`
- Auto-memory : `reference_boites_email`
- Tâches TASKS.md : #48 (MCP Outlook), #52 (multi-Gmail MCP)
