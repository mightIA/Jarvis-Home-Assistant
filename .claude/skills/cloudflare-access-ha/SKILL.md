---
name: cloudflare-access-ha
description: Procedure complete de configuration Cloudflare (DNS + SSL/TLS + HSTS + Access Zero Trust) pour proteger une instance Home Assistant exposee sur internet. Inclut le bypass CF Access sur l'endpoint MCP Server pour permettre l'appairage Cowork/Claude via OAuth 2.0 natif HA. Testee sur might.ovh / ha.might.ovh le 19/04/2026.
---

# Skill : Cloudflare Access pour Home Assistant

Procedure complete pour proteger une instance HA exposee sur internet
derriere Cloudflare, tout en permettant l'appairage MCP Cowork/Claude.

## Quand cette skill est declenchee

- Mickael veut exposer une nouvelle instance HA via un domaine Cloudflare.
- Duplication de la config pour une **autre maison** ou **ami**.
- Reconfiguration apres migration ou reset Cloudflare.
- Debug d'un probleme d'appairage MCP Cowork bloque par CF Access.
- Durcissement de la securite (HSTS, CSP, etc.).

## Chainage avec d'autres skills

Cette procedure implique generalement **beaucoup de captures d'ecran**
(interface Cloudflare Zero Trust). Des que Mickael commence a envoyer
des captures, Jarvis doit basculer en **mode guidage-photo-etape** :

```
cloudflare-access-ha (ce skill)
        |
        v  (Mickael envoie sa 1ere capture)
guidage-photo-etape (reponses 2-3 lignes, comptage images, une action par message)
        |
        v  (seuil LIMITE - 1 atteint)
bascule-conversation (test compat + resume reprise + MAJ fichiers)
```

Jarvis **ne doit pas** repondre en format long/pedagogique sur ce type
de procedure si Mickael envoie des captures. Passer direct en mode
guidage-photo-etape.

## Prerequis

- Compte Cloudflare avec domaine actif (ex : `might.ovh`).
- Compte **Cloudflare Zero Trust** active (gratuit jusqu'a 50 users).
- Home Assistant accessible en interne (ex : `192.168.1.11:2096`).
- Reverse proxy NPM / Caddy / Traefik deja configure pour faire pointer
  le sous-domaine vers l'IP HA locale.
- Enregistrement DNS CNAME ou A pointant le sous-domaine vers le tunnel
  Cloudflare ou l'IP publique + port forward.

---

## Phase 1 — SSL/TLS et HSTS (securite transport)

### Objectif

Forcer HTTPS, TLS minimal 1.2, activer HSTS avec preload.

### Procedure (dashboard Cloudflare > domaine > SSL/TLS > Edge Certificates)

| Reglage                        | Valeur cible         |
|--------------------------------|----------------------|
| Always Use HTTPS               | ON                   |
| Minimum TLS Version            | **TLS 1.2**          |
| Automatic HTTPS Rewrites       | ON                   |
| Opportunistic Encryption       | ON                   |
| HSTS (Strict-Transport-Security)| **Activer**         |
| HSTS max-age                   | **6 mois** (15552000 s) |
| Include subdomains             | ON (si pas de sous-domaine HTTP-only) |
| Preload                        | ON                   |
| X-Content-Type-Options: nosniff| ON                   |

### Procedure detaillee HSTS

1. Clic **Activer HSTS**.
2. Modal Confirmation : `Je comprends l'impact de HSTS` + **Suivant**.
3. Modal Configurer :
   - Toggle HSTS : ON.
   - max-age : `6 mois` (15552000 s).
   - Include subdomains : ON (si pas de sous-domaine HTTP-only).
   - Preload : ON.
   - No-Sniff : ON.
4. **Enregistrer**.

### Piege a eviter

- **Ne pas activer HSTS** tant qu'un eventuel sous-domaine HTTP-only est
  present (il deviendrait inaccessible).
- Si l'activation casse le dashboard HA, penser a vider le cache Brave /
  cookies CF_AppSession avant de conclure.

---

## Phase 2 — Cloudflare Access : protection du dashboard HA

### Objectif

Proteger le dashboard web HA (`https://ha.might.ovh/`) par un SSO email
+ MFA, pour que seul Mickael puisse y acceder depuis internet.

### Procedure

1. **one.dash.cloudflare.com** > Zero Trust > Controles Access >
   **Applications**.
2. **Create new application** > **Self-hosted and private** > Continue.
3. Onglet **Application details** :
   - Application name : `Might-HA` (ou `HA-Dashboard`).
   - Session duration : 24 h (ou 7 jours selon preference).
   - Destinations > Public hostnames :
     - Subdomain : `ha`
     - Domaine : `might.ovh`
     - Path : (vide — couvre tout le dashboard)
4. Onglet **Additional settings** : laisser par defaut.
5. Onglet **Access policies** : creer une politique
   (voir [Phase 2 bis](#phase-2-bis--creer-la-politique-access-dashboard)).
6. **Save application**.

### Phase 2 bis — Creer la politique Access Dashboard

1. Zero Trust > Controles Access > **Strategies** > **Ajouter une strategie**.
2. Informations de base :
   - **Nom** : `HA-Dashboard-Access`
   - **Action** : **Allow**
   - **Duree de session** : identique a l'application
3. **Ajouter des regles > Inclure** :
   - Selecteur : `Emails` > Valeur : `might@live.fr`
4. **Ajouter exiger** (ET) :
   - Selecteur : `Authentication Method` > Valeur : `MFA` (Multi-factor)
5. **Enregistrer**.

Cette strategie Allow+Email+MFA **convient UNIQUEMENT** au dashboard web
normal, OU un humain se connecte via navigateur.

---

## Phase 3 — Cloudflare Access : BYPASS sur l'endpoint MCP Server

### ⚠️ CRITIQUE — Erreur classique a ne PAS reproduire

Pour l'endpoint `/mcp_server/*` appele par **Cowork/Claude** (et non un
navigateur humain), il **NE FAUT PAS** creer une politique Allow+MFA.
Pourquoi :

- Cowork est un client MCP / API, **pas un navigateur**.
- Il **ne sait pas** enchainer le flow SSO Cloudflare
  (`cloudflareaccess.com` > login > redirect).
- Si CF Access est active avec Allow+MFA sur `/mcp_server/sse`, la
  requete Cowork est redirigee vers `cloudflareaccess.com` > **echec**
  > message *"Couldn't reach the MCP server"*.

**La bonne solution** : creer une app CF Access dediee avec une politique
**Bypass** qui laisse passer la requete **sans** authentification CF.
HA gere ensuite sa propre authentification via OAuth 2.0 natif du MCP
Server (RFC 9728).

### Procedure (app Bypass MCP)

1. Zero Trust > Controles Access > **Applications** > **Create new
   application**.
2. **Self-hosted and private** > Continue.
3. Onglet **Application details** :
   - Application name : `HA MCP Server Bypass`
   - Session duration : 24 h (indifferent, bypass)
   - Destinations > Public hostnames :
     - Subdomain : `ha`
     - Domaine : `might.ovh`
     - Path : `mcp_server`  *(matching "starts-with", couvre `/mcp_server/sse`)*
4. Onglet **Additional settings** : laisser par defaut.
5. Onglet **Access policies** :
   - Creer une NOUVELLE politique **dediee** (ne pas reutiliser une
     politique Allow existante) :
     - **Nom** : `Bypass MCP`
     - **Action** : **Bypass** *(CRUCIAL — pas Allow, pas Block)*
     - **Include > Everyone**
   - Ne JAMAIS ajouter de regle Exiger MFA ici.
6. **Save application**.

### Verification immediate (test curl)

Depuis PowerShell PC (hors session Brave authentifiee) :

```powershell
curl.exe -v -H "Accept: text/event-stream" --max-time 10 https://ha.might.ovh/mcp_server/sse
```

**Attendu apres bypass OK** :
- **Plus de** header `Www-Authenticate: Cloudflare-Access`.
- **Plus de** redirect 302 vers `cloudflareaccess.com`.
- Soit flux SSE 200 (flux d'evenements), soit 401 natif de HA (OAuth MCP
  qui demande un token).

**Si encore bloque par CF Access** : verifier l'ordre des applications CF
Access (l'app Bypass doit etre prioritaire). Cloudflare evalue dans
l'ordre de la liste, la premiere app matchant le path gagne.

### Verification appairage Cowork

1. `https://claude.ai/customize/connectors`.
2. Cliquer **Home Assistant Jarvis** > **Connecter**.
3. Flow OAuth HA s'ouvre : *"Authorize Claude to access…"* > **Autoriser**.
4. Retour sur claude.ai : **Connecte**.

**Si encore "Couldn't reach the MCP server"** : verifier si l'OAuth HA
redirige vers `/auth/authorize` (endpoint encore protege par CF Access).
Si oui, **etendre le bypass** avec 2 destinations supplementaires dans
la meme app Bypass : `auth/authorize` et `auth/token` + eventuellement
`.well-known/*`.

---

## Phase 4 — Durcissement securite additionnel (optionnel)

### 4.1 — CSP (Content Security Policy) en mode Report-Only

Pour detecter les ressources externes sans casser le dashboard.

- Cloudflare > Domaine > **Regles** > **Transform Rules** > **Modifier les
  en-tetes de reponse HTTP**.
- Ajouter header `Content-Security-Policy-Report-Only` avec une policy
  permissive au debut, puis durcir progressivement.
- Surveiller les reports avant de passer en mode enforce.

### 4.2 — Permissions-Policy

Limiter l'acces navigateur aux capteurs sensibles (micro, camera,
geolocation) que HA n'utilise pas.

- Meme chemin que CSP (Transform Rules > Response headers).
- Header : `Permissions-Policy: geolocation=(), microphone=(), camera=()`.

### 4.3 — Rate limiting

- Cloudflare > Domaine > **Security** > **WAF** > **Rate limiting rules**.
- Regle recommandee : 100 req/min par IP sur le path racine.
- Path a exclure : `/mcp_server/*` (peut etre intensif en SSE longue duree).

---

## Phase 5 — Option avancee : sous-domaine dedie MCP via add-on Cloudflared

**[MIS A JOUR session 16 — procedure validee en production le 19/04/2026
pour exposer l'add-on ha-mcp via `mcp.might.ovh`]**

Si on veut une isolation propre du trafic MCP (separer du dashboard HA),
ou si l'add-on MCP utilise un port propre (ex. ha-mcp sur 9583), creer un
sous-domaine dedie.

**⚠ Attention navigation CF** : le tunnel Cloudflared HA est configure
**localement** (cote add-on). Donc :
- Cliquer sur le tunnel dans Zero Trust > Networks > Tunnels propose
  "Demarrer la migration" → **IRREVERSIBLE, ne jamais faire**.
- Toute config hostname se fait via l'UI de l'add-on HA Cloudflared.
- L'add-on ne cree le DNS qu'AUTOMATIQUEMENT pour le hostname principal.
  Pour tout `additional_host`, creer le CNAME manuellement.

### Procedure validee (3 sous-etapes)

#### 5.1 — Hostname supplementaire dans add-on Cloudflared HA

1. HA > Parametres > Apps > **Cloudflared** > onglet **Configuration**.
2. Section **Hotes supplementaires** > **Ajouter**.
3. Popup :
   - **hostname** : `mcp.might.ovh`
   - **service** : `http://192.168.1.11:<port>` (ex. `:9583` pour ha-mcp,
     `:2096` pour dashboard HA, etc.)
   - `disableChunkedEncoding` : **OFF** (pour streaming SSE/MCP)
4. **Ajouter** dans le popup, puis **ENREGISTRER** sur la page (bouton
   bleu) — sinon saisie perdue.

#### 5.2 — CNAME DNS manuel dans Cloudflare

1. Recuperer le tunnel ID dans add-on Cloudflared > **Journaux** (ligne
   `Starting tunnel tunnelID=...`).
2. [dash.cloudflare.com](https://dash.cloudflare.com/) > clic sur le
   domaine > **Enregistrements DNS**.
3. **+ Ajouter un enregistrement** :
   - Type : **CNAME**
   - Nom : `mcp` (sous-domaine uniquement)
   - Cible : `<tunnel-id>.cfargotunnel.com`
   - Etat du proxy : **Proxied** (nuage orange ON)
   - TTL : Automatique

**Note type DNS** : le type special `Tunnel` (visible pour `ha` dans la
liste) **n'est PAS creable en manuel** via le dropdown (types standard
seulement : A, AAAA, CNAME, MX, etc.). Le CNAME `<tunnel-id>.cfargotunnel.com`
fait fonctionnellement la meme chose.

#### 5.3 — Reload add-on Cloudflared : STOP + START (pas restart)

Onglet Informations > **Arreter**, attendre 5 s, **Demarrer**. Le simple
"Redemarrer" ne recharge pas toujours la config `additional_hosts`.

#### 5.4 — Reverse proxy / trusted_proxies (cas dashboard HA uniquement)

Si le service cible est le dashboard HA (port 2096/8123), pas un add-on
dedie qui gere son propre auth :

1. HA > `configuration.yaml` > section `http:` :

```yaml
http:
  use_x_forwarded_for: true
  trusted_proxies:
    - 172.30.33.0/24   # range cloudflared container
    - 127.0.0.1
  cors_allowed_origins:
    - https://mcp.might.ovh
```

2. Pour un add-on MCP dedie (ex. ha-mcp, port 9583) : **pas necessaire**,
   l'add-on gere son propre auth via secret path ou OAuth.

#### 5.5 — CF Access sur le sous-domaine

**Recommandation** :
- Si l'add-on gere son propre auth (ex. ha-mcp avec secret path) :
  **aucune app CF Access** sur `mcp.might.ovh` → expose sans CF Access.
- Si le service cible est le dashboard HA nu : creer une **app Bypass**
  full-domain (meme modele que Phase 3 mais sur `mcp.might.ovh` sans
  path) + proteger avec un Service Token CF.

#### 5.6 — Piege trailing slash

Quel que soit le service, tester l'URL **sans slash final** :

```
https://mcp.might.ovh/<path>
```

Les apps Python (FastMCP, Uvicorn) retournent souvent 404 sur trailing
slash.

### Avantages sous-domaine dedie

- Isolation propre : le dashboard web garde son SSO+MFA complet.
- Pas de gestion de bypass par path, plus lisible.
- Permet de cibler un port interne different du dashboard (ex. add-on ha-mcp
  sur :9583).

### Inconvenients

- Maintenance DNS supplementaire (1 CNAME de plus).
- Creation manuelle du CNAME requise (pas auto comme le hostname principal).
- Si Cloudflared restart ne recharge pas la config, pas d'alerte visible
  (c'est silencieux).

### Exemple concret : expo add-on ha-mcp (session 16)

- `external_hostname` : `ha.might.ovh` (inchange, dashboard HA)
- `additional_host` : `mcp.might.ovh` → `http://192.168.1.11:9583`
- CNAME : `mcp.might.ovh` → `e37fbcdc-7943-4bdc-9990-36cce788fe20.cfargotunnel.com`
- CF Access : aucune app sur `mcp.might.ovh` (secret path fait auth)
- URL finale Cowork : `https://mcp.might.ovh/private_PfjEvJTqhCdo9ELRqCPADlzo`
- Duree totale : ~25 min (hors diagnostic initial tunnel local / piege stop+start)

---

## Phase 6 — Ban IP Cloudflare (en cas d'attaque)

- Cloudflare > Domaine > **Security** > **WAF** > **Tools** > **IP Access
  Rules**.
- Action : **Block** ou **Challenge (Managed Challenge)**.
- Scope : ce domaine seulement ou tous les sites.
- Duree : permanente ou temporaire.

Pour les bans IP cote Home Assistant lui-meme, voir la skill
`debannissement-ip`.

---

## Checklist finale

Apres configuration complete, verifier :

- [ ] HTTPS force et redirection automatique depuis HTTP.
- [ ] TLS 1.2 minimum.
- [ ] HSTS 6 mois actif avec preload + includeSubDomains.
- [ ] Dashboard HA protege par Allow+Email+MFA via CF Access.
- [ ] MCP Server accessible via Bypass CF Access.
- [ ] Test curl sur `/mcp_server/sse` sans redirect cloudflareaccess.com.
- [ ] Appairage Cowork reussit en une tentative.
- [ ] 7 tests de validation MCP OK (voir checklist migration HA).
- [ ] (Optionnel) CSP en mode report-only actif.
- [ ] (Optionnel) Permissions-Policy defini.
- [ ] (Optionnel) Rate limiting configure.

---

## Debugging : messages d'erreur courants

| Symptome Cowork | Cause probable | Solution |
|-----------------|----------------|----------|
| "Couldn't reach the MCP server" + ref `ofid_*` ET bypass curl OK | **Bug DCR du mcp_server core HA** — Cowork exige Dynamic Client Registration (RFC 7591) que `mcp_server` core ne supporte pas | **Basculer sur l'add-on `ha-mcp` (homeassistant-ai)** — voir skill `ha-mcp-install`. Le bypass CF Access n'est PAS la cause. |
| "Couldn't reach the MCP server" + ref `ofid_*` ET bypass curl KO | CF Access intercepte `/mcp_server/*` avec politique Allow au lieu de Bypass | Creer politique **Bypass** + Everyone |
| Boucle de redirect `cloudflareaccess.com` | Bypass non applique au bon path | Verifier path = `mcp_server` avec matching "starts-with" |
| 401 persistant apres bypass + logs HA `http.ban` "invalid auth" sur `/mcp_server/sse` depuis IP `160.79.104.0/21` | Cowork (range IP Anthropic) hit direct `/mcp_server/sse` sans flow OAuth | Bug DCR confirme — voir bascule add-on ha-mcp |
| 502 Bad Gateway | Reverse proxy en panne, pas CF | Verifier NPM/Caddy + HA up |
| 1020 Access Denied | Regle WAF CF bloque l'IP | Verifier IP Access Rules |
| Ban IP HA recurrent sur `160.79.106.x` | Range Anthropic outbound `160.79.104.0/21` (Cowork) banni apres 5 echecs OAuth consecutifs | Debannir + augmenter `login_attempts_threshold` ou desactiver `ip_ban_enabled` temporairement |

## Limite critique du mcp_server core HA (decouverte session 15 — 19/04/2026)

**Le `mcp_server` core HA (integration `Model Context Protocol Server`)
ne supporte PAS le Dynamic Client Registration (DCR, RFC 7591).** Or
Claude.ai/Cowork **exige DCR** pour pairer un connecteur MCP custom.

Consequence : meme avec un bypass CF Access PARFAITEMENT configure
(curl externe valide chaque endpoint OAuth en 405/401 natif HA), le
pairage Cowork echoue toujours avec `ofid_*` et HA enregistre des
"invalid authentication" en log `http.ban` car Cowork hit direct
`/mcp_server/sse` sans token OAuth (Cowork ne suit pas le header
`WWW-Authenticate: Bearer resource_metadata="..."` de HA en l'absence de
DCR).

**Solution** : installer l'add-on **`homeassistant-ai/ha-mcp`** (FastMCP
avec DCR + secret path) — voir skill `ha-mcp-install`. Le core HA peut
rester en place ou etre desinstalle, l'add-on coexiste.

**Issues GitHub de reference :**
- `anthropics/claude-ai-mcp#111` — symptome `ofid_*` Cannot reach valid MCP server
- `anthropics/claude-code#26675` — Support pre-configured OAuth client without DCR
- `homeassistant-ai/ha-mcp#245` — Feature request DCR pour HA core
- Blog modelcontextprotocol.io/posts/client_registration — MCP a adopte OAuth 2.1 + DCR

## Astuce : consolidation paths bypass (session 15)

Au lieu de creer 5 destinations precises (`mcp_server`, `auth/authorize`,
`auth/token`, `.well-known/oauth-protected-resource`,
`.well-known/oauth-authorization-server`), consolider en **3 destinations
plus larges** :

| # | Path bypass | Couvre |
|---|-------------|--------|
| 1 | `mcp_server` | `/mcp_server/sse` + futurs sous-paths MCP |
| 2 | `auth` | `/auth/authorize` + `/auth/token` + `/auth/revoke` + tout `/auth/*` |
| 3 | `.well-known` | les 2 OAuth discovery + futurs `.well-known/*` |

Avantages :
- Libere 2 slots sur la limite 5/5 destinations CF Access
- Couvre `/auth/revoke` qui est dans le discovery OAuth HA mais souvent oublie
- Plus resilient aux ajouts d'endpoints futurs cote HA

---

## Duree moyenne de la procedure complete

- Phase 1 (SSL/HSTS) : 2-3 min
- Phase 2 (Access dashboard) : 5-7 min
- Phase 3 (Bypass MCP) : 3-5 min
- Phase 4 (durcissement) : 15-30 min optionnel
- Phase 5 (sous-domaine MCP) : 15-20 min optionnel
- Total minimal (sans optionnel) : **10-15 min**

---

*Skill creee le 2026-04-19 — version 1.0*
*Basee sur les sessions 8, 10 et 11 de Jarvis.*
