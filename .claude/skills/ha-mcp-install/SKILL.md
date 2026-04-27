---
name: ha-mcp-install
description: Procedure complete d'installation et configuration de l'add-on `homeassistant-ai/ha-mcp` (FastMCP) qui ajoute Dynamic Client Registration (DCR) au MCP Server HA. Solution de contournement quand le MCP Server natif HA (`mcp_server` core integration) ne permet pas le pairage avec Claude.ai/Cowork. Inclut l'install repo custom + flags safety + recuperation du secret path + plan d'expo HTTPS publique. Cree session 15 (19/04/2026) apres diagnostic du bug DCR manquant cote core HA.
---

# Skill : Installation add-on ha-mcp (homeassistant-ai/ha-mcp)

Procedure complete pour installer l'add-on `homeassistant-ai/ha-mcp`
(FastMCP avec DCR) en remplacement du MCP Server core HA, qui ne supporte
pas le Dynamic Client Registration requis par Claude.ai/Cowork.

## Quand cette skill est declenchee

- Mickael veut connecter Cowork/Claude.ai a HA via MCP et le pairage du
  `mcp_server` core HA echoue avec erreurs `ofid_*` malgre un bypass CF
  Access correctement configure.
- Diagnostic confirme : c'est le bug DCR (Dynamic Client Registration
  RFC 7591) cote `mcp_server` core. Cf. issue
  [homeassistant-ai/ha-mcp#245](https://github.com/homeassistant-ai/ha-mcp/issues/245).
- Mickael veut une integration MCP HA stable et pleinement compatible
  Claude.ai sans toucher a configuration.yaml.

## Pre-requis

- Home Assistant OS avec Supervisor actif (acces aux Add-ons / Apps).
- Sauvegarde HA recente (creer une **sauvegarde complete** avant install
  pour rollback possible).
- Add-on `Cloudflared` ou `NGINX HA SSL proxy` installe pour exposer
  l'add-on en HTTPS publique vers Cowork (sinon a installer en Phase 3).

## Phase 1 — Pre-bascule et nettoyage etat existant

Avant d'installer, faire le menage de toute la configuration anterieure
liee aux tentatives mcp_server core :

1. **Sauvegarde HA complete** (Parametres > Systeme > Sauvegardes > Creer).
2. Verifier `ip_bans.yaml` vide (sinon File editor > supprimer entrees IP
   Anthropic banies suite aux echecs de pairage precedents).
3. Desactiver le journal de debogage du `mcp_server` core integration
   (bouton orange dans Parametres > Appareils et services > Model Context
   Protocol Server).
4. Supprimer les anciens connecteurs Cowork/Claude.ai cote claude.ai
   (Settings > Connecteurs > supprimer toute trace de "Home Assistant
   Jarvis", "Jarvis HA" ou autre — pour eviter les tokens stale).
5. **Garder l'app CF Access `HA MCP Server Bypass`** existante avec ses 3
   destinations consolidees (`mcp_server`, `auth`, `.well-known`) — on la
   reutilisera en Phase 3 pour bypasser le nouveau path secret.

## Phase 2 — Installation de l'add-on

### Etape 2.1 — Ajouter le repo custom

Dans HA :

1. **Parametres > Apps** (icone puzzle jaune — note : "Apps" dans HA 2025+
   est l'ancien nom "Modules complementaires" ou "Add-ons").
2. Bouton bleu en bas a droite : **Installer l'application**.
3. Boutique des Apps > **3 points (`⋮`)** en haut a droite > **Depots**.
4. Champ "Ajouter un depot" : coller :

```
https://github.com/homeassistant-ai/ha-mcp
```

5. **+ Ajouter** > attendre 5-10 s > **Fermer**.

### Etape 2.2 — Installer la version stable (PAS la dev)

1. Retour a la boutique des Apps.
2. Scroll vers la section **`Home Assistant MCP Server`** apparue en bas.
3. **2 variantes visibles** :
   - **`Home Assistant MCP Server`** (sans badge) — **STABLE — installer celle-ci** ✅
   - `Home Assistant MCP ... Expérimentale` — DEV CHANNEL avec
     `ha_config_set_yaml` beta capable de modifier configuration.yaml — **NE PAS installer** ❌
4. Cliquer sur la version stable > **Installer** > attendre la fin.

### Etape 2.3 — Verifier la configuration safe AVANT demarrage

Onglet **Configuration** de l'add-on. Etat par defaut (a conserver) :

- **Backup hint** : `normal` ✅
- **Enable skills** : ON ✅ (expose les skills HA best-practices comme MCP
  resources, non dangereux)
- **Enable skills as tools** : ON ✅ (3 outils supplementaires pour
  clients sans support MCP resources natif)
- **Enable tool search** : OFF ✅ (garde le catalogue complet — ON
  reduirait le contexte mais ajoute une couche d'indirection)
- **Toggle "Afficher les options de configuration facultatives
  inutilisees"** : **OFF** ✅ — cache les 3 flags dangereux qui restent
  desactives par defaut :
  - `HAMCP_ENABLE_FILESYSTEM_TOOLS` (acces filesystem HA) — **JAMAIS
    activer sans accord explicite Mickael**
  - `ENABLE_YAML_CONFIG_EDITING` (modification configuration.yaml) —
    **JAMAIS activer**
  - `HAMCP_ENABLE_CUSTOM_COMPONENT_INTEGRATION` (install composants) —
    **JAMAIS activer**

Section **Reseau** : port `9583/tcp` (par defaut). Ne pas modifier sauf
conflit de port avec un autre add-on.

### Etape 2.4 — Demarrer + verifier les logs

1. Onglet **Informations** > activer les toggles :
   - **Lancer au demarrage** : ON
   - **Chien de garde** : ON (redemarrage auto en cas de crash)
   - **Mise a jour automatique** : selon preference Mickael
2. Cliquer **Demarrer** (ou **Redemarrer** si deja en cours).
3. Onglet **Journaux** > attendre la ligne :

```
🔒 MCP Server URL: http://<home-assistant-ip>:9583/private_XXXXXXXXXXXXXXXXXX
   Secret Path: /private_XXXXXXXXXXXXXXXXXX
```

4. **Sauvegarder le secret path** quelque part (memoire auto ou fichier
   local) — il est aussi persiste dans `/data/secret_path.txt` cote
   add-on. Le path est genere automatiquement avec 128-bit d'entropie et
   sert d'authentification (zero config OAuth).

Logs typiques OK :

```
Authentication configured via Supervisor token
Importing ha_mcp module...
Auto-discovery registered tools from 34 modules
Registered bundled skills as MCP resources
Starting MCP server 'ha-mcp' with transport 'http' (stateless)
Uvicorn running on http://0.0.0.0:9583
```

## Phase 3 — Exposer l'add-on en HTTPS publique pour Cowork

L'add-on ecoute sur `http://192.168.1.11:9583/<secret_path>` — accessible
en LAN uniquement. Cowork est dans le cloud Anthropic, il faut donc une
expo HTTPS publique. **3 options** par ordre de preference :

### Option A (recommandee, VALIDEE session 16) — Cloudflare Tunnel via add-on `Cloudflared`

**⚠ IMPORTANT** : la procedure officielle CF ("Networks > Tunnels > tunnel >
Public Hostnames") **NE MARCHE PAS** si le tunnel est configure **localement**
(cas de l'add-on `Cloudflared` HA). Clique sur le tunnel local → CF propose
"Demarrer la migration" = **IRREVERSIBLE, ne jamais faire**. Toute config
passe par l'UI de l'add-on HA, et le DNS par le dashboard Cloudflare classique.

Procedure reelle en 3 sous-etapes :

#### 3.1 — Ajouter l'hostname supplementaire dans l'add-on Cloudflared HA

1. HA > **Parametres > Apps** > **Cloudflared** (icone nuage orange).
2. Onglet **Configuration**.
3. Section **Hotes supplementaires** > bouton **Ajouter**.
4. Popup :
   - **hostname** :

```
mcp.might.ovh
```

   - **service** :

```
http://192.168.1.11:9583
```

   - Toggle `disableChunkedEncoding` : **OFF** (important pour le streaming MCP).
5. Clic **Ajouter** dans le popup.
6. **Clic Enregistrer** sur la page Configuration (bouton devient bleu).
   **⚠ Critique** : sans ce clic, la saisie est perdue (verifier la ligne
   apparait sous "Hotes supplementaires").

#### 3.2 — Creer le CNAME DNS manuellement dans Cloudflare

**Point crucial decouvert session 16** : l'add-on Cloudflared HA cree le
DNS automatiquement **uniquement pour le hostname principal** (champ
`Nom d'hote externe de Home Assistant`), **PAS pour les `additional_hosts`**.

Il faut donc creer le CNAME manuellement :

1. Recuperer le **tunnel ID** dans les logs de l'add-on Cloudflared
   (onglet **Journaux**). Chercher la ligne :

```
Starting tunnel tunnelID=e37fbcdc-7943-4bdc-9990-36cce788fe20
```

2. [dash.cloudflare.com](https://dash.cloudflare.com/) > clic sur le
   domaine (ex. `might.ovh`) > **Enregistrements DNS** (panneau droit).
3. Bouton **+ Ajouter un enregistrement** :
   - **Type** : `CNAME`
   - **Nom** : `mcp` (sous-domaine seulement, CF ajoute `.might.ovh`)
   - **Cible** : `<tunnel-id>.cfargotunnel.com` — exemple :

```
e37fbcdc-7943-4bdc-9990-36cce788fe20.cfargotunnel.com
```

   - **Etat du proxy** : **Proxied** (nuage orange ON)
   - **TTL** : Automatique
4. **Enregistrer**.

#### 3.3 — Recharger l'add-on Cloudflared (STOP + START, pas restart)

**Piege session 16** : un simple clic "Redemarrer" **ne recharge pas**
toujours proprement la config. Toujours faire **Arreter** puis **Demarrer**.

1. Onglet **Informations** de l'add-on Cloudflared > **Arreter**.
2. Attendre 5 secondes.
3. **Demarrer**.
4. Verifier dans l'onglet **Journaux** l'absence d'erreur + le tunnel
   connecte (lignes `Registered tunnel connection`).

#### 3.4 — Test de validation

**⚠ Piege trailing slash** decouvert session 16 : l'add-on ha-mcp
retourne 404 si l'URL se termine par `/`. Tester **sans slash final** :

[https://mcp.might.ovh/private_PfjEvJTqhCdo9ELRqCPADlzo](https://mcp.might.ovh/private_PfjEvJTqhCdo9ELRqCPADlzo)

**Reponse attendue** : page texte `HA-MCP server is up and running!` + 6
etapes instructions Cloudflare Users.

**Troubleshooting** :
- `DNS_PROBE_POSSIBLE` → CNAME DNS non cree ou mauvais cible, retour etape 3.2
- `HTTP 404 Not Found` → config `additional_hosts` pas enregistree OU pas rechargee, verifier etape 3.1 + refaire 3.3 (stop+start)
- Local OK mais tunnel 404 → tunnel pas reloade, refaire 3.3
- `Cloudflare 502 Bad Gateway` → add-on ha-mcp arrete, verifier son etat
- Local renvoie `HA-MCP server is up and running!` mais tunnel ne repond pas → decouvrir Host header possibles, voir logs Cloudflared

**AUCUN bypass CF Access a ajouter** sur `mcp.might.ovh` (l'add-on
utilise son propre secret path comme auth). L'URL finale est :

```
https://mcp.might.ovh/private_PfjEvJTqhCdo9ELRqCPADlzo
```

(a coller dans Cowork en Phase 4).

### Option B — NGINX HA SSL Proxy add-on

Mickael a aussi `NGINX HA SSL proxy` installe. Editer la config NGINX
pour router un path sur `ha.might.ovh` vers l'add-on :

```nginx
location /mcp-addon/ {
    proxy_pass http://192.168.1.11:9583/;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_buffering off;       # SSE long-lived
    proxy_read_timeout 86400s; # SSE
}
```

Puis ajouter une 4eme destination `mcp-addon` dans l'app CF Access
`HA MCP Server Bypass` (limite 5/5, on a 2 slots libres).

### Option C — Quick test sans expo HTTPS

Si Mickael veut juste valider l'install en local : tester l'URL sur le
PC LAN avec un MCP client compatible HTTP (mcp-inspector, Cursor, etc.).
Cowork necessitera Option A ou B pour le pairage final.

## Phase 4 — Connexion Cowork

1. claude.ai > Settings > Connecteurs > **+ Ajouter un connecteur
   personnalise**.
2. Nom : `Jarvis HA Add-on` (ou libre).
3. URL : URL HTTPS choisie en Phase 3 (ex. `https://mcp.might.ovh/<secret_path>`).
4. Connecter > si l'add-on supporte DCR/OAuth correctement, le pairage
   se fait sans erreur. Sinon (token stale, bug Cowork) : verifier les
   logs add-on et eventuellement basculer sur le dev channel (avec
   prudence — voir warning ci-dessous).

## Warning : ne pas activer les feature flags dangereux

Trois flags peuvent compromettre les fichiers HA s'ils sont actives sans
accord explicite Mickael :

| Flag | Risque | Status par defaut |
|------|--------|-------------------|
| `HAMCP_ENABLE_FILESYSTEM_TOOLS` | Lecture/ecriture filesystem HA via MCP tools | **OFF** ✅ |
| `ENABLE_YAML_CONFIG_EDITING` | Modification de configuration.yaml et packages/*.yaml par Claude (LAST RESORT selon doc) | **OFF** ✅ |
| `HAMCP_ENABLE_CUSTOM_COMPONENT_INTEGRATION` | Installation de composants custom HA par Claude | **OFF** ✅ |

Si une session future demande l'activation de l'un de ces flags : appliquer
la **Regle 0** (donnees sensibles / actions destructives) — informer
Mickael, expliquer le risque, obtenir accord explicite.

## Coexistence avec le mcp_server core

Le `mcp_server` core HA (integration `Model Context Protocol Server`
visible dans Parametres > Appareils et services) **continue d'exister**
apres install de l'add-on ha-mcp. Les deux peuvent cohabiter :

- Core : endpoint `/mcp_server/sse` sur le dashboard HA (port standard)
- Add-on : endpoint `/<secret_path>` sur port 9583

Cowork utilise uniquement l'add-on (URL fournie). Le core reste en place
mais inutilise pour Cowork — peut etre desinstalle pour proprete si
Mickael le souhaite (Parametres > Appareils et services > Model Context
Protocol Server > 3 points > Supprimer).

## Versions de reference (session 15 — 19/04/2026)

- Add-on ha-mcp : **7.3.0** (cote HA Supervisor)
- ha-mcp Python module : **7.2.0**
- FastMCP : **3.2.3** (update 3.2.4 dispo, non critique)
- Hostname container : `81f33d0f-ha-mcp`
- Port : `9583/tcp`
- Auth : Supervisor token (zero token cote utilisateur)

## Liens utiles

- Repo : https://github.com/homeassistant-ai/ha-mcp
- Doc complete : https://homeassistant-ai.github.io/ha-mcp/
- FAQ & Troubleshooting : https://homeassistant-ai.github.io/ha-mcp/faq/
- Issue DCR/OAuth : https://github.com/homeassistant-ai/ha-mcp/issues/245
- DOCS.md add-on : https://github.com/homeassistant-ai/ha-mcp/blob/master/homeassistant-addon/DOCS.md

---

*Skill creee le 2026-04-19 (session 15) — version 1.0*
*Basee sur le diagnostic du bug DCR mcp_server core et l'install reussie
de l'add-on ha-mcp v7.3.0 sur l'instance HA de Mickael.*
