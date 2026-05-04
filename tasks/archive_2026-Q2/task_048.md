---
id: 48
title: "Rechercher et installer un MCP pour la boite Outlook (Microsoft Live / Outlook"
status: cancelled
priority: P3
session_opened: S28
session_closed: S92
tags: [gmail, outlook, email, security, mcp, brave, cowork, tri-email]
source: "Session 28 / Demande Mickael"
cancelled_reason: "Microsoft refuse app reg perso pour @live.fr (directory-less bloqué + sandbox M365 Dev Program refusé S92). Réactiver si softeria patche app reg shared OU si MCP Outlook 1-clic compatible compte perso sort. Veille auto via T#91."
---

# T#48 — Rechercher et installer un MCP pour la boite Outlook (Microsoft Live / Outlook

## Description

**[NOUVELLE session 28 — MCP Outlook might@live.fr]** Rechercher et installer un MCP pour la boite Outlook (Microsoft Live / Outlook.com) afin de remplacer le workflow actuel 100% navigateur Brave (skills `tri-email-outlook` + `tri-email-outlook-priorites`). **Gains attendus** : (a) ~10x plus rapide (pas de screenshot/clic/wait), (b) ~5-10x moins gourmand en tokens (pas de lecture de captures/DOM), (c) workflow Gmail-like unifié (list/move/mark_read/archive/trash), (d) Cowork-compatible si on trouve un MCP HTTP natif (pas stdio). **Pré-requis sécurité** : (1) auditer le repo (stars, last commit, maintainer, CVE `npm audit`/`pip-audit`), (2) vérifier scopes OAuth demandés (lecture seule prioritaire au démarrage, write en phase 2), (3) si le MCP demande du `mail.readwrite` + `mail.send`, créer un Client OAuth Azure AD / Microsoft Identity **dédié** (même pattern que Gmail MCP custom S25), (4) auth local 127.0.0.1 stdio si possible (cf. pattern GongRzhe Gmail MCP), (5) ACL NTFS sur credentials.json + tokens, (6) pas d'exposition publique. **Options à étudier** : (A) repo open-source existant (rechercher `outlook-mcp` / `microsoft-graph-mcp` sur GitHub), (B) fork du GongRzhe Gmail MCP adapté pour Microsoft Graph API, (C) intégration HA `microsoft-outlook` si elle existe (moins probable). **Plan en 5 phases** similaire à #45 : (0) audit repo + CVE, (1) Client OAuth Microsoft Azure + scopes minimaux, (2) install local stdio + ACL, (3) `.mcp.json` entry, (4) dry-run `list_folders` + `search_messages` + `move_email` sur 1 email test, (5) bascule skills `tri-email-outlook` + `tri-email-outlook-priorites` retrait Brave. **Impact attendu** : session 28 entière (40 min, ~40 captures, ~60 clics) refaisable en 2-3 min sans captures.

## Source / Échéance

Session 28 / Demande Mickael

## Recommandation S87 — Research mai 2026

### Verdict communauté

**Pour un compte perso `might@live.fr` (Outlook.com / Live.com)**, tous les
MCP Outlook open-source passent par **Microsoft Graph API** + **app
registration Microsoft Entra ID** (gratuite, ex-Azure AD). C'est imposé
par Microsoft, indépendant du choix de MCP. Compte perso = OK avec
l'option "Accounts in any organizational directory **and personal
Microsoft accounts**" lors de la création de l'app reg.

**3 patterns d'auth observés** :

- ❌ Auth Code + Client Secret — secret en clair, à éviter
- ✅ **Auth Code + PKCE** — recommandé, pas de client secret
- ✅ Device Code Flow — alternative headless

### MCP officiel Anthropic (registry Cowork) — insuffisant

`microsoft365.mcp.claude.com/mcp` (déjà dans le registry) expose
`outlook_email_search`, `outlook_calendar_search` et `read_resource`
uniquement. **Pas de `move`, `archive`, `trash`** → inadapté au tri-email
qui est l'objectif de cette tâche.

### Comparatif des 3 candidats communauté

| Candidat | Forces | Compat Cowork | Compat CLI | Note |
|----------|--------|---------------|------------|------|
| **softeria/ms-365-mcp-server** | ★ ~660 GitHub, OAuth 2.1, **HTTP transport**, multi-comptes, Outlook+Calendar+OneDrive+Excel+OneNote, npm `@softeria/ms-365-mcp-server` v0.36 (févr. 2026), pas de CVE connue | ✅ HTTP → **Cowork OK** | ✅ stdio dispo | 🥇 Choix recommandé |
| **merill/lokka** | Microsoft Entra-natif, interactive auth perso, Graph API complet, populaire dans la commu Entra | ⚠️ Plutôt stdio | ✅ stdio | 🥈 Fallback CLI |
| **sajadghawami/outlook-mcp** | TypeScript, **23 outils** dont folders/move/inbox-rules, callback `localhost:1337` | ❌ stdio uniquement | ✅ stdio | 🥉 Si Softeria déçoit |

### Choix : `softeria/ms-365-mcp-server`

Justification :

1. ✅ **Seul des 3 à supporter HTTP transport** → Cowork ET CLI compatibles
   (vs Gmail-MCP-Local stdio = CLI-only actuellement)
2. ✅ Device Code Flow dispo → **pas besoin de Client Secret**
3. ✅ Couvre Outlook (mail) + bonus Calendar/OneDrive/Excel pour usages
   futurs Jarvis (sans 2e MCP à installer)
4. ✅ Maintenance active (v0.36 févr. 2026, ~660 stars, 35 releases)
5. ✅ Aucune CVE connue sur le package
6. ⚠️ Audit `npm audit` à refaire **juste avant install** (toujours)

### Découverte clé — pas besoin d'app reg Entra

Softeria intègre une **app reg Entra par défaut** (publique, pré-enregistrée
par les développeurs) utilisable via :

```
npx -y @softeria/ms-365-mcp-server --login
```

→ Device Code Flow ouvre `microsoft.com/devicelogin`, Mickael colle le
code, login `might@live.fr`, autorise → tokens stockés localement.

**Conséquence** : la Phase 1 "App registration Microsoft Entra" du plan
initial est **supprimée**. Microsoft a serré la vis (création app reg
"directory-less" passée de "déconseillée" à "bloquée" sur les comptes
perso sans tenant Azure / M365 Dev Program). Avec l'app reg de softeria,
on contourne complètement le problème.

Trade-offs de l'app par défaut softeria :

- ✅ Setup ×10 plus simple, marche immédiatement
- ✅ Pas de M365 Dev Program à créer, pas d'Azure
- ⚠️ Côté Microsoft (`account.microsoft.com/privacy` → "Apps and services"),
  l'app affichée sera **"softeria/ms-365-mcp-server"**, pas "Jarvis"
- ⚠️ Scopes prédéfinis par softeria (couvre Outlook + Calendar + OneDrive
  + Excel + OneNote ; à confirmer au login)
- ⚠️ Si softeria perd/révoque son app reg → migration vers app reg propre
  nécessaire (cf. annexe future)

Pour usage perso Jarvis = largement OK. Si besoin de branding ou contrôle
total des scopes plus tard, on créera notre propre app via M365 Dev Program
(documenté en annexe).

### Architecture choisie — Option C : 1 install local pur (PAS de Tunnel)

Décidée S87 (mai 2026) avec Mickael après itération A → B → C :

| Aspect | Option A | Option B | **Option C (retenue)** |
|--------|----------|----------|------------------------|
| Installs | 2 (1000D + KT) | 1 (1000D) | **1 (1000D)** |
| Tokens OAuth | Sur chaque PC | Sur 1000D | **Sur 1000D uniquement** |
| Cloudflare Tunnel | Non | ✅ requis (`outlook.might.ovh`) | ❌ **Pas besoin** |
| Subdomain DNS | — | ✅ | ❌ |
| Exposition publique | Non | Oui (CF Access) | ❌ **Aucune (localhost)** |
| Surface d'attaque | 2× tokens KT | URL publique | **0** |
| Setup | 2 OAuth flows | Tunnel + Access | **5 min total** |
| Trigger tri | Dispatch + auto par PC | Idem | **Dispatch + auto + Cowork direct** |

**Justification Option C** :

- Mickael a renoncé au tri depuis Might-KT (laptop) — trop de complexité
  pour un usage rare en déplacement
- Le tri tournera **uniquement sur Might-1000D** (allumé 24/7) via 3
  triggers cumulatifs :
  - 🔁 **Auto** — scheduled task Windows (heure fixe, ex 04h15)
  - 🖥️ **Cowork direct** — Mickael devant Might-1000D, session Cowork
  - 📱 **iPhone Dispatch (à distance)** — déclenche Cowork sur Might-1000D
- → Pas besoin d'exposition publique, le MCP reste sur `127.0.0.1`
- Pattern proche du Gmail-MCP-Local actuel, mais en **HTTP** (pas stdio) →
  Cowork ET CLI peuvent tous les deux l'utiliser sur Might-1000D

## Plan d'install en 4 phases (simplifié post-Option C)

### Phase 0 — Audit sécurité

#### ✅ `npm audit` exécuté S87 (mai 2026)

```
0 critical | 0 high | 3 moderate | 0 low | 0 info
204 packages audités
```

Cause racine unique des 3 moderate :

```
uuid <14.0.0 → @azure/msal-node → @softeria/ms-365-mcp-server
```

Vuln upstream : [GHSA-w5hq-g745-h8pq](https://github.com/advisories/GHSA-w5hq-g745-h8pq)
— buffer bounds check manquant dans `uuid v3/v5/v6` quand un buffer est
passé. **Impact réel sur notre usage : nul** car MSAL Node utilise
UUID v4 (random) pour les correlation IDs OAuth, pas v3/v5/v6.

`fixAvailable: false` car le bump `uuid` doit venir de
`@azure/msal-node` (Microsoft), pas de softeria.

**Verdict : install acceptable**, avec surveillance des releases
`@azure/msal-node` pour le bump `uuid >= 14.0.0`. Refaire `npm audit`
à chaque update softeria.

#### À refaire au moment de l'install (Mickael, Might-1000D)

```powershell
# PowerShell sur Might-1000D
mkdir C:\temp\audit-softeria; cd C:\temp\audit-softeria
npm init -y
npm install --package-lock-only @softeria/ms-365-mcp-server
npm audit
```

→ Vérifier toujours 0 critical / 0 high. Les 3 moderate transitives sont
acceptées (cf. ci-dessus).

### Phase 1 — Install softeria + Login Device Code

```powershell
# PowerShell sur Might-1000D — installation globale
npm install -g @softeria/ms-365-mcp-server

# Premier login (Device Code Flow, app reg softeria par défaut)
ms-365-mcp-server --login
```

Le terminal va afficher un message du type :

```
To sign in, use a web browser to open the page
https://microsoft.com/devicelogin and enter the code XXXX-YYYY
to authenticate.
```

**Côté Brave/Chrome** :

1. Ouvrir https://microsoft.com/devicelogin
2. Coller le code `XXXX-YYYY`
3. Login `might@live.fr`
4. Page d'autorisation → **lire les scopes demandés par softeria**
5. ⚠️ **Vérifier que les scopes sont raisonnables** :
   - ✅ Attendus : `Mail.Read`, `Mail.ReadWrite`, `Calendars.Read`,
     `Files.Read.All`, `User.Read`, `offline_access`
   - ❌ Refuser si `Mail.Send` non explicité par toi (on n'envoie pas)
   - ❌ Refuser si scopes admin (`Directory.Read.All`, etc.)
6. Si OK → "Yes" pour autoriser

→ Le terminal `ms-365-mcp-server --login` doit afficher "Login successful"
ou équivalent. Tokens stockés localement (chemin par défaut softeria, à
documenter au moment de l'install — souvent `%APPDATA%\ms-365-mcp-server\`).

**ACL NTFS sur le dossier tokens** (à appliquer juste après login) :

```powershell
# Vérifier puis restreindre l'accès au dossier tokens
$tokensPath = "$env:APPDATA\ms-365-mcp-server"  # à confirmer au login
icacls $tokensPath /inheritance:r
icacls $tokensPath /grant:r "Mrubi:(OI)(CI)F"
icacls $tokensPath /remove "Users" "Authenticated Users" 2>$null
```

### Phase 2 — Lancer en mode HTTP localhost

```powershell
# PowerShell sur Might-1000D — démarrage serveur HTTP
ms-365-mcp-server --http --port 3210
```

(port 3210 arbitraire, choisir un port libre)

→ Test rapide :

```powershell
# Autre fenêtre PowerShell
Invoke-WebRequest -Uri "http://127.0.0.1:3210/health"
```

Si serveur OK, on automatise le démarrage avec un service Windows ou une
scheduled task "ms-365-mcp-server" (au choix). À ne PAS exposer hors localhost
(pas de `--host 0.0.0.0`).

### Phase 3 — `.mcp.json` Cowork + CLI

Entrée à ajouter dans `.mcp.json` (à la racine projet Jarvis) :

```json
{
  "outlook-mcp": {
    "type": "http",
    "url": "http://127.0.0.1:3210/mcp"
  }
}
```

Pas de `env` (token gérés par softeria en interne, app reg par défaut).

→ Restart Cowork pour charger le MCP.
→ Vérifier dans Cowork settings que le MCP `outlook-mcp` apparaît avec
liste des outils (move_email, search_messages, list_folders, etc.).

### Phase 4 — Dry-run + 3 triggers

1. **Dry-run lecture** :
   - `outlook-mcp.list_folders` → liste des dossiers
   - `outlook-mcp.search_messages` "objet:test" → 1-2 résultats
2. **Dry-run écriture** :
   - Créer dossier test `_Test_MCP_` dans Outlook web
   - `outlook-mcp.move_email` 1 mail vers `_Test_MCP_` → vérifier dans
     Outlook web
3. **Refonte skill** `tri-email-outlook` (et `tri-email-outlook-priorites`) :
   - Ajouter section "Méthode 2 — MCP softeria" à côté méthode Brave
   - Pattern identique à la refonte Gmail S78
4. **Configurer les 3 triggers** :
   - 🔁 **Auto** : scheduled task Windows quotidienne (matin tôt)
     déclenchant `claude-code` ou un script qui appelle la skill
   - 🖥️ **Cowork direct** : Mickael devant 1000D, session Cowork "tri
     outlook maintenant"
   - 📱 **iPhone Dispatch** : route déjà existante Dispatch → Cowork
     1000D, juste dire "tri outlook" (à valider que Dispatch envoie bien
     vers la session Cowork active sur 1000D)
5. **Bascule progressive** : MCP par défaut, fallback Brave si erreur

## Checklist sécurité — Règle 0 (CLAUDE.md) — Option C

Ce qui sera **vu ou manipulé** lors de l'install :

| Élément | Sensibilité | Qui ? |
|---------|-------------|-------|
| Login `might@live.fr` (Device Code) | 🔴 **Sensible** (mot de passe) | **Mickael uniquement**, dans son navigateur |
| App reg utilisée | 🟢 Pré-existante softeria, publique | — |
| Tenant ID / Client ID | ❌ NON GÉRÉS (softeria interne) | — |
| Client Secret | ❌ NON UTILISÉ (Device Code) | — |
| Token OAuth (access + refresh) | 🔴 **Sensible** | Stocké `%APPDATA%\ms-365-mcp-server\` Might-1000D, ACL Mrubi only |
| Emails Outlook (contenu) | 🔴 **Sensible** | Lecture par MCP, jamais persisté par Jarvis |
| Liste folders/labels | 🟡 Moyenne | Lecture par MCP |
| URL HTTP MCP | 🟢 `127.0.0.1:3210` (localhost) | Jamais exposé externe |

**Procédure stricte** :

1. Login Device Code = **Mickael uniquement** (mot de passe Microsoft,
   Règle 0 — Jarvis ne touche jamais)
2. Tokens OAuth = stockés **uniquement** sur Might-1000D, JAMAIS sur
   Might-KT, JAMAIS commit Git, ACL NTFS Mrubi only
3. Serveur HTTP softeria = **localhost only** (`127.0.0.1`), jamais
   `--host 0.0.0.0`
4. Pas de read d'emails sensibles (banque, santé, RH) tant que phase
   d'écriture non validée
5. **Procédure de récupération laptop volé** : N/A puisque pas de tokens
   sur Might-KT (Option C). Si besoin général de révoquer l'accès :
   `https://account.microsoft.com/privacy` → "Apps and services" →
   révoquer `softeria/ms-365-mcp-server`.

## Décisions à prendre au retour de Mickael

1. ✅/❌ Valider candidat **softeria/ms-365-mcp-server** ?
   *(reco : oui)*
2. ✅/❌ Valider archi **Option C (local pur)** ?
   *(reco : oui — décidée S87)*
3. Choix port HTTP local (proposition `3210`, à valider) ?
4. Démarrage serveur softeria : service Windows OU scheduled task au boot ?
5. Migration skills : **refonte** `tri-email-outlook` (méthode 2) **ou**
   nouvelle skill `tri-email-outlook-mcp` ?
6. Trigger iPhone Dispatch → vérifier que la route existante envoie bien
   vers la session Cowork active sur Might-1000D, sinon adapter

## Sources research

- [Microsoft 365 MCP officiel Anthropic (registry)](https://microsoft365.mcp.claude.com/mcp)
- [softeria/ms-365-mcp-server (GitHub)](https://github.com/softeria/ms-365-mcp-server)
- [npm @softeria/ms-365-mcp-server](https://www.npmjs.com/package/@softeria/ms-365-mcp-server)
- [merill/lokka](https://github.com/merill/lokka)
- [sajadghawami/outlook-mcp](https://github.com/sajadghawami/outlook-mcp)
- [elyxlz/microsoft-mcp](https://github.com/elyxlz/microsoft-mcp)
- [nsakki55/outlook-mcp (PKCE)](https://github.com/nsakki55/outlook-mcp)
- [Microsoft Learn — OAuth Outlook.com](https://learn.microsoft.com/en-us/exchange/client-developer/legacy-protocols/how-to-authenticate-an-imap-pop-smtp-application-by-using-oauth)

## Itération S88 — 03/05/2026

### Décisions prises au lancement

- Port HTTP : `3210`
- Démarrage : Scheduled Task au logon Mrubi (recommandé)
- Skills : refonte `tri-email-outlook` + `tri-email-outlook-priorites`
  (méthode 2 MCP + fallback Brave)
- Scopes : full (12) — Microsoft compte perso ne permet pas le toggle
  scope-par-scope

### Plans tentés et résultats

| Plan | Description | Résultat |
|------|-------------|----------|
| A | `--login` stdio v latest (0.95.0) | 🔴 Bug URL OAuth malformée (issues #288, #33028, claude-code #10439). Browser auto sur `localhost/callback?error=invalid_request` (response_type manquant). Terminal figé. |
| C | Downgrade v0.36 + `--login` stdio | 🟡 Browser auto absent (correct), Device Code affiché propre, login `might@live.fr` + Confirmer connexion → Microsoft renvoie sur `localhost/callback?error=...` quand même. Bug app reg softeria pour comptes perso. |
| B | HTTP server + Cowork DCR (skip --login) | 🔴 Cowork desktop refuse HTTP localhost (« L'URL doit commencer par "https" »). |
| I | Tunnel CF `outlook.might.ovh` → 127.0.0.1:3210 | 🟡 Tunnel UP, softeria UP avec `--public-url https://outlook.might.ovh`, issuer + endpoints HTTPS OK. Cowork DCR appel `/register` OK avec son `redirect_uris=["https://claude.ai/api/mcp/auth_callback"]`. Two-leg PKCE softeria amorce. **Microsoft refuse `redirect_uri` au /authorize** : softeria envoie `https://outlook.might.ovh/callback` qui n'est pas whitelisté dans l'app reg softeria default (CLIENT_ID `084a3e9f...`). |

### Diagnostic fin S88 (logs softeria verbose)

```
info: Client registration request {
  "body":{
    "client_name":"Claude",
    "grant_types":["authorization_code","refresh_token"],
    "redirect_uris":["https://claude.ai/api/mcp/auth_callback"],
    "scope":"Mail.ReadWrite Mail.Send MailboxSettings.Read ... User.Read",
    "token_endpoint_auth_method":"none"
  }
}
info: Two-leg PKCE: stored client challenge, generated server challenge
```

Microsoft erreur :
```
invalid_request: The provided value for the input parameter 'redirect_uri'
is not valid. The expected value is a URI which matches a redirect URI
registered for this client application.
```

→ L'app reg softeria default ("MS 365 MCP Server", CLIENT_ID `084a3e9f...`)
ne whiteliste pas `https://outlook.might.ovh/callback`. Quand on utilise
`--public-url`, softeria génère ce redirect_uri custom mais Microsoft le
refuse. **Bug architectural quand on combine `--public-url` + app reg
softeria partagée**.

### Infrastructure mise en place S88 (préservée pour reprise)

- ✅ npm v0.95.0 globalement installée (latest)
- ✅ `cloudflared` 2025.8.1 installé via winget sur Might-1000D
- ✅ Tunnel `jarvis-outlook` créé, credentials dans `%USERPROFILE%\.cloudflared\<UUID>.json`
- ✅ DNS CNAME `outlook.might.ovh` (CF auto via `cloudflared route dns`)
- ✅ Config `%USERPROFILE%\.cloudflared\config.yml` avec ingress `outlook.might.ovh → http://localhost:3210` (ligne credentials-file à corriger : path `\.json` cassé, mais cloudflared utilise le default `cred-file` → tunnel UP malgré tout)
- ✅ `.mcp.json` projet édité avec entrée `outlook-mcp` HTTP localhost (utilisable côté Claude Code CLI uniquement, pas Cowork)
- 🔴 Cowork connecteur "Jarvis Outlook" ajouté avec erreur (à supprimer ou refaire après Plan D)
- 🟡 softeria + cloudflared lancés en foreground PS (à basculer en services Windows en finalisation)

### Plan D — Reprise prochaine session

**Objectif** : créer une app reg Microsoft Entra perso, configurer redirect_uri custom, faire pointer softeria vers cette app reg via env vars.

Étapes prévues :

1. **App reg Microsoft Entra** (Microsoft Entra admin center ou via M365 Developer Program — Mickael might@live.fr) :
   - `signInAudience: AzureADandPersonalMicrosoftAccount` (autorise comptes perso `@live.fr`)
   - **Public client** (sans secret, pour PKCE)
   - Redirect URIs whitelistés :
     - `https://outlook.might.ovh/callback` (pour --public-url)
     - `http://localhost:3210/callback` (fallback dev)
   - Scopes API permissions : Mail.ReadWrite, Mail.Send (delegated), Calendars.ReadWrite, Files.ReadWrite, User.Read, etc. (12 scopes utilisés par softeria)
2. **Récupérer** `CLIENT_ID` (et `TENANT_ID` si tenant perso, sinon `consumers` ou `common`).
3. **Lancer softeria** avec env vars (à confirmer noms exacts via softeria docs/code source) :
   ```powershell
   $env:MS365_MCP_CLIENT_ID = "<notre-client-id>"
   $env:MS365_MCP_TENANT_ID = "consumers"  # ou "common"
   ms-365-mcp-server -v --http 127.0.0.1:3210 --public-url https://outlook.might.ovh
   ```
4. **Re-tester** Cowork ajout connecteur. Microsoft devrait accepter le redirect_uri car il sera whitelisté dans NOTRE app reg.
5. **Phase 4** : dry-run lecture/écriture, refonte skills, scheduled task au logon, services Windows softeria + cloudflared.

Setup Plan D estimé ~30-60 min. Risque résiduel : limites comptes perso Entra (M365 Dev Program peut être requis pour avoir un tenant Azure). Voir Issue #53408 anthropics/claude-code (comptes Hotmail/Outlook/Live rejetés sur certains MCP) pour info supplémentaire.

## Statut

🔴 `cancelled` S92 (03/05/2026) — Plan D abandonné après 2 murs Microsoft :

1. Création app reg directe refusée pour compte perso `@live.fr` ("La possibilité de créer des applications hors d'un répertoire a été déconseillée")
2. M365 Developer Program → inscription OK, mais **sandbox subscription refusée** ("You don't currently qualify for a Microsoft 365 Developer Program sandbox subscription"). Microsoft a serré les critères 2024-2025, comptes perso de plus en plus refusés.

Restantes : Azure free tier (CB requise) ou Composio (3rd-party). Mickael juge le ROI insuffisant vs workflow Brave actuel qui marche déjà.

**Critères de réactivation future** (à vérifier par T#91 veille auto) :
- softeria publie un fix de l'app reg shared (issue #288 ou autre) qui whiteliste les redirect_uris custom
- Un nouveau MCP Outlook **1-clic compatible compte perso** sort (sans Azure/Entra)
- Le connecteur officiel Anthropic Microsoft 365 ajoute les outils write (`move_email`, `archive`, `trash`)
- Mickael décide de créer un compte Azure free tier (CB) si gain MCP devient critique

## Itération S92 — 03/05/2026 — Abandon

### Plans tentés en S88 puis S92

Voir section "Itération S88 — 03/05/2026" ci-dessus pour Plans A/B/C/I.

### Plan D tenté S92

| Étape | Résultat |
|-------|----------|
| 1. Portail Entra `entra.microsoft.com` (login `might@live.fr`) | ✅ Tenant gratuit auto-créé (vide) |
| 2. Cliquer "Inscriptions d'applications" → "+ Nouvelle inscription" | 🔴 Microsoft : "La possibilité de créer des applications hors d'un répertoire a été déconseillée. Vous pouvez obtenir un nouveau répertoire en adhérant au programme pour les développeurs M365 ou en vous inscrivant à Azure." |
| 3. Inscription M365 Developer Program (Personal projects) | ✅ Profil créé (Mickael RUBINO + might@live.fr + MightLab) |
| 4. Wait sandbox tenant Azure dédié | 🔴 Microsoft : "You don't currently qualify for a Microsoft 365 Developer Program sandbox subscription." |

### Cleanup S92

Infra S88 démantelée :

- Tunnel CF `jarvis-outlook` supprimé
- DNS CNAME `outlook.might.ovh` supprimé (CF dashboard)
- Package npm `@softeria/ms-365-mcp-server` désinstallé global
- Binaire `cloudflared` désinstallé (winget)
- Dossier `%USERPROFILE%\.cloudflared\` supprimé
- Entrée `outlook-mcp` retirée de `.mcp.json`
- Connecteur Cowork "Jarvis Outlook" supprimé
- Profil M365 Developer Program supprimé

### Suivi via T#91 (créée S92)

Veille hebdomadaire automatisée sur écosystème MCP/addons/plugins. Si nouvelle solution Outlook viable détectée → rapport avec proposition de test. T#48 pourra alors être réouverte.

### Sources research mai 2026 (recap)

- Connecteur officiel Anthropic Microsoft 365 = read-only confirmé (UCToday, AdminDroid, Office365ITPros avril 2026)
- Composio = service tiers managé, tokens chez Composio (déconseillé Règle 0)
- softeria self-host = nécessite app reg perso, non créable pour @live.fr en mai 2026
- ryaker/outlook-mcp + syedazharmbnr1/claude-outlook-mcp = même problème (app reg requise)
- marlonluo2018/outlook-mcp-server = win32COM = nécessite Outlook desktop client (pas notre setup)
