---
title: HA — Connexion et accès
created: 2026-04-25
tags: [ha/connexion, ha/securite]
status: actif
---

# HA — Connexion et accès

## URLs

| Priorité | URL | Usage |
|---|---|---|
| 1 | `http://192.168.1.11:2096/` | Connexion locale (à privilégier) |
| 2 | `https://ha.might.ovh/` | Fallback distant via Cloudflare Access |
| 3 | `https://mcp.might.ovh/<secret>` | Endpoint MCP add-on `ha-mcp` (Cowork CLI) |

URL locale → toujours en premier. Distante uniquement si réseau local
indisponible (Mickael en mobilité, etc.).

## SSH

| Paramètre | Valeur |
|---|---|
| IP locale | `192.168.1.11` |
| Port | `22` |
| Auth | Mot de passe (à améliorer en clés SSH — TASKS) |
| Exposition internet | Non, local uniquement |

## Règles de comportement (CLAUDE.md §2)

- Si **2-3 erreurs 401/403 consécutives** → STOP, vérifier ban IP.
- Si premier ban de la session → proposer désactivation temporaire (cf. [[Débannissement IP]]).
- Après débannissement → toujours retester en local en premier (`http://192.168.1.11:2096`).
- Ne pas répéter les appels API qui échouent.

## Notes liées

- [[Débannissement IP]] — procédures de levée
- [[../Cloudflare/_Index|Cloudflare]] — sécurité du tunnel `ha.might.ovh`
- [[Apps installées]] — voir add-on `Cloudflared` qui sert le tunnel

---

*Source : `Ressources/Competences/Home_Assistant.md` §1 + §3 + `Home_Assistant_Inventaire.md` §1.*
