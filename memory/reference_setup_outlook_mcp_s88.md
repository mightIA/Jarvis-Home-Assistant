---
name: Infrastructure outlook-mcp S88 — OBSOLÈTE depuis cleanup S92
description: Snapshot infra T#48 S88 (cloudflared, tunnel, DNS, softeria, .mcp.json). OBSOLÈTE depuis abandon T#48 + cleanup S92. Conservé pour contexte historique uniquement. Voir project_t48_outlook_mcp_abandon_s92.md pour décision actuelle.
type: project
---

> ⚠️ **OBSOLÈTE depuis S92 (03/05/2026)** — T#48 abandonnée, infra démantelée
> en cleanup S92. Ne PAS suivre les commandes de reprise ci-dessous. Voir
> `project_t48_outlook_mcp_abandon_s92.md` pour la décision et les critères
> de réactivation futurs.

S88 (03/05/2026) : itérations Plans A/B/C/I sur T#48 ont posé toute l'infra
sauf l'auth Microsoft (bloquée par bug app reg softeria + --public-url, voir
`feedback_softeria_redirect_uri_app_reg.md`). Reprise Plan D = créer app
reg Entra perso.

**Why** : éviter de refaire 2h de setup à la prochaine session, capitaliser
sur ce qui marche déjà.

**How to apply** : avant de lancer Plan D, vérifier que l'infra ci-dessous
est encore en place (services arrêtés mais config persistante). Si oui, sauter
direct à la création app reg Entra + env vars softeria.

## État de l'infra S88

| Élément | État | Note |
|---------|------|------|
| `npm` v0.95.0 softeria globale | ✅ installée | `npm install -g @softeria/ms-365-mcp-server@latest` (3 mai 2026) |
| `cloudflared` 2025.8.1 | ✅ installé | via winget sur Might-1000D, dans PATH système |
| Cert CF | ✅ `%USERPROFILE%\.cloudflared\cert.pem` | login fait, zone might.ovh autorisée |
| Tunnel `jarvis-outlook` | ✅ créé | UUID dans `%USERPROFILE%\.cloudflared\<UUID>.json` |
| DNS CNAME `outlook.might.ovh` | ✅ actif | propagé, testé curl 200 |
| Config `%USERPROFILE%\.cloudflared\config.yml` | 🟡 partiellement cassé | ligne `credentials-file: \.json` (path tronqué interpolation PowerShell). Fonctionne car cloudflared utilise default `cred-file` auto. À corriger. |
| `.mcp.json` projet entrée `outlook-mcp` | ✅ ajoutée | URL `http://127.0.0.1:3210/mcp` (CLI only) |
| Cowork connecteur "Jarvis Outlook" | 🔴 ajouté avec erreur | À supprimer ou refaire après Plan D |
| Service Windows softeria | ❌ pas créé | À faire post-Plan D (Scheduled Task au logon Mrubi) |
| Service Windows cloudflared | ❌ pas créé | À faire post-Plan D (`cloudflared service install`) |

## Commandes de reprise rapide (à coller PowerShell)

Démarrage manuel softeria + tunnel pour reprendre Plan D :

```powershell
# Fenêtre 1 — softeria
$env:MS365_MCP_CLIENT_ID = "<notre-client-id-Entra>"   # à compléter Plan D
$env:MS365_MCP_TENANT_ID = "consumers"                 # ou "common"
ms-365-mcp-server -v --http 127.0.0.1:3210 --public-url https://outlook.might.ovh

# Fenêtre 2 — cloudflared
cloudflared tunnel run jarvis-outlook
```

## Test post-démarrage (curl HTTPS)

```powershell
$r = Invoke-WebRequest -Uri "https://outlook.might.ovh/.well-known/oauth-authorization-server" -UseBasicParsing
($r.Content | ConvertFrom-Json).issuer
# Attendu : https://outlook.might.ovh
```

## Cleanup si abandon T#48 ultérieurement

```powershell
# Stopper services / processus
Stop-Process -Name "ms-365-mcp-server" -Force -ErrorAction SilentlyContinue
Stop-Process -Name "cloudflared" -Force -ErrorAction SilentlyContinue
# Supprimer le tunnel CF
cloudflared tunnel delete jarvis-outlook
# Désinstaller softeria
npm uninstall -g @softeria/ms-365-mcp-server
# Désinstaller cloudflared
winget uninstall --id Cloudflare.cloudflared
# Retirer outlook-mcp du .mcp.json (manuel)
# Supprimer connecteur "Jarvis Outlook" dans Cowork → Connecteurs
```

## Sources / refs

- Runbook complet : `tasks/task_048.md`
- Bug app reg : `memory/feedback_softeria_redirect_uri_app_reg.md`
- App reg softeria CLIENT_ID observé : `084a3e9f...` (logs softeria S88)
- Cowork redirect_uri : `https://claude.ai/api/mcp/auth_callback`
- Issues GitHub : softeria #288, claude-code #33028, claude-code #10439, claude-code #53408
