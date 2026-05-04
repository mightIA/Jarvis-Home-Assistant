---
name: Bug architectural softeria + --public-url + app reg default
description: softeria/ms-365-mcp-server avec --public-url + app reg default refuse l'auth Microsoft (redirect_uri non whitelisté). Plan D obligatoire (app reg Entra perso).
type: feedback
---

S88 (03/05/2026) : softeria/ms-365-mcp-server v0.95.0 avec `--public-url <url>`
+ Cowork DCR génère un redirect_uri vers Microsoft = `<public-url>/callback`
qui n'est PAS whitelisté dans l'app reg default softeria
("MS 365 MCP Server", CLIENT_ID commençant par `084a3e9f...`).

**Symptôme** : Microsoft renvoie après login + Confirmer la connexion :
```
invalid_request: The provided value for the input parameter 'redirect_uri'
is not valid. The expected value is a URI which matches a redirect URI
registered for this client application.
```

**Logs softeria verbose** lors du flow :
```
info: Client registration request from "Claude" (=Cowork)
  redirect_uris=["https://claude.ai/api/mcp/auth_callback"]
info: Two-leg PKCE: stored client challenge, generated server challenge
[Microsoft refuse au /authorize car redirect_uri custom non whitelisté]
```

**Why** : softeria's app reg partagée par tous les utilisateurs n'autorise que
quelques redirect_uris fixes (probablement `http://localhost:3000/callback`,
`http://localhost:3210/callback`). Quand on utilise `--public-url
https://outlook.might.ovh`, softeria construit `https://outlook.might.ovh/callback`
mais l'app reg ne le connaît pas → refus Microsoft. Bug architectural :
incompatibilité `--public-url` + app reg shared softeria.

**How to apply** : pour exposer softeria via tunnel CF / reverse proxy avec
`--public-url`, créer NOTRE app reg Microsoft Entra perso avec :
- `signInAudience: AzureADandPersonalMicrosoftAccount` (compte perso @live.fr)
- Public client (PKCE, pas de secret)
- Redirect URIs whitelistés : `https://<public-url>/callback` + fallback localhost
- API permissions : 12 scopes utilisés par softeria

Puis lancer softeria avec env vars pour pointer vers notre app reg :
- `MS365_MCP_CLIENT_ID=<notre-client-id>`
- `MS365_MCP_TENANT_ID=consumers` (compte perso) ou `common`

Setup ~30-60 min. M365 Developer Program peut être requis pour avoir un
tenant Azure et créer l'app reg si Microsoft Entra direct ne le permet pas
pour un compte perso.

**Cas où la règle ne s'applique PAS** : si softeria reste sur `--http localhost`
sans `--public-url` (pattern Option C runbook S87), l'app reg default
fonctionne car le redirect_uri reste localhost (whitelisté). Mais Cowork
desktop refuse HTTP localhost → CLI only. Pour Cowork compatible, Plan D
obligatoire.
