---
id: 100
title: "Rotation Service Tokens CF Access suite leak chat S109"
status: done
priority: P0
session_opened: S109
session_closed: S111
tags: [security, cloudflare, service-token, rotation, leak, urgent]
source: "Session 109 / Leak Service Tokens CF Access (Client ID + Client Secret 64 chars) collés dans chat Cowork persisté via sortie claude mcp get scope local"
---

# T#100 — Rotation Service Tokens CF Access suite leak S109

## Contexte

Pendant le diagnostic du pairing CLI claude home-assistant (S109, T#94 sous-objectif 1bis), Mickael a collé dans le chat Cowork la sortie de `claude mcp get test-ha-cli` qui affichait les vraies valeurs des Service Tokens CF Access en clair (Client ID + Client Secret 64 chars). Ces valeurs sont maintenant dans l'historique persisté de la conv Cowork "Tâches Jarvis — Priorisation reprise" S109.

**Cause racine** : j'ai oublié de prévenir Mickael que la commande `claude mcp get` sur scope local affiche les valeurs interpolées en clair. Anti-récidive capturée dans auto-memory Cowork [`feedback_alerter_avant_commandes_revelant_secrets.md`](../../spaces/.../memory/feedback_alerter_avant_commandes_revelant_secrets.md).

## Périmètre rotation

| Composant | Action | Note |
|-----------|--------|------|
| CF Zero Trust → Identifiants du service | Créer "HA MCP Service v2" + Supprimer "HA MCP Service v1" | Garder v1 pendant transition |
| App CF Access "mcp" → Stratégie | Inclure le nouveau Service Token v2 (ajouter en plus de v1 temporairement) | Smooth transition |
| Variables d'env Windows User | `CF_ACCESS_CLIENT_ID` + `CF_ACCESS_CLIENT_SECRET` ← nouvelles valeurs | Via System Properties → Environment Variables OU `[System.Environment]::SetEnvironmentVariable(...)` |
| Hermès Agent `~/.hermes/config.yaml` | Remplacer ancien par nouveau Client ID + Secret en clair (perms 600) | Backup `.bak.s109d-pre-rotation` avant |
| CLI claude `~/.claude.json` (entrée local `test-ha-cli` + `home-assistant` si scope local appliqué) | Supprimer entrées avec ancien token + recréer avec nouveau via `claude mcp add` (PowerShell interpolation `$env:VAR`) | Vérifier via `claude mcp get` ⚠ MASQUÉ |
| Tests bout-en-bout | curl serveur HTTP 405 + Hermès Test B + CLI claude mcp list ✓ Connected | Preuve curl OBLIGATOIRE (pattern S70) |
| CF Zero Trust → Service Tokens v1 | Supprimer après validation v2 | Anti-rollback |

## Procédure détaillée

### Phase 1 — Génération nouveau token (CF dashboard)

1. Sidebar CF Zero Trust → **Identifiants du service** (PAS Settings → Service Auth, c'est l'ancien chemin)
2. Cliquer **Créer un identifiant de service**
3. Nom : `HA MCP Service v2`
4. Durée : `Non-expirant`
5. **⚠ ÉCRAN UNIQUE** : copier Client ID + Client Secret dans Notepad temporaire local. JAMAIS dans le chat Cowork/Claude. Préférer commande masquée pour vérif (`if ($env:VAR) { "OK : " + $env:VAR.Length + " chars" }`)

### Phase 2 — Inclusion dans stratégie CF Access "mcp"

1. CF Zero Trust → **Applications** → "mcp"
2. Onglet **Policies**
3. Édition policy "Service Auth" existante
4. Section Include : ajouter le nouveau Service Token v2 (en plus de v1 temporairement)
5. Save

### Phase 3 — MAJ variables d'env Windows User

```powershell
# Méthode programmatique (depuis nouveau Notepad, ne pas coller en chat) :
[System.Environment]::SetEnvironmentVariable("CF_ACCESS_CLIENT_ID", "<NOUVEAU_ID>", "User")
[System.Environment]::SetEnvironmentVariable("CF_ACCESS_CLIENT_SECRET", "<NOUVEAU_SECRET>", "User")
# Vérification masquée :
if ($env:CF_ACCESS_CLIENT_ID) { "ID OK : " + $env:CF_ACCESS_CLIENT_ID.Length + " chars" }
```

⚠ Les vars d'env User nécessitent ouverture d'une nouvelle fenêtre PowerShell pour être propagées.

### Phase 4 — MAJ Hermès `~/.hermes/config.yaml`

```bash
# WSL2 bash
cp ~/.hermes/config.yaml ~/.hermes/config.yaml.bak.s109d-pre-rotation
# Édition manuelle dans nano/vim, remplacer ancien Client ID/Secret par nouveau
nano ~/.hermes/config.yaml
chmod 600 ~/.hermes/config.yaml
```

### Phase 5 — Nettoyage CLI claude

```powershell
claude mcp remove "test-ha-cli" -s local
# Si scope local home-assistant a été appliqué : remove + recréer
```

### Phase 6 — Tests bout-en-bout

```powershell
# Test serveur (preuve curl)
curl.exe -s -o NUL -w "HTTP %{http_code}`n" -H "CF-Access-Client-Id: $env:CF_ACCESS_CLIENT_ID" -H "CF-Access-Client-Secret: $env:CF_ACCESS_CLIENT_SECRET" "https://mcp.might.ovh/private_6G36IXICr8K4HJv02SXU9OlE"
# → HTTP 405 attendu (endpoint répond avec nouveau Service Token)

# Test Hermès
wsl bash -c "echo 'Recherche entité température cuisine' | hermes chat 2>&1 | head -20"

# Test CLI claude (sortie MASQUÉE)
claude mcp list | Select-String "home-assistant"
```

### Phase 7 — Suppression ancien Service Token v1

1. CF Zero Trust → **Identifiants du service**
2. Cliquer "HA MCP Service v1" → **Supprimer**
3. Confirmer

## Pré-requis

- Mickael devant dashboard CF Zero Trust (URL : [https://one.dash.cloudflare.com/](https://one.dash.cloudflare.com/))
- Notepad temporaire local pour stocker valeurs nouveau token (à supprimer après rotation)
- Session ~30-45 min dédiée
- Fenêtre PowerShell + WSL2 bash disponibles

## Livrables attendus

- (a) Service Token v2 créé + inclus dans stratégie CF Access "mcp"
- (b) Vars env Windows User à jour + propagées (nouvelle fenêtre PS)
- (c) `~/.hermes/config.yaml` à jour avec backup `.bak.s109d`
- (d) CLI claude `test-ha-cli` supprimé OU rebranché avec nouveau token
- (e) Tests curl + Hermès + CLI tous OK
- (f) Service Token v1 supprimé côté CF
- (g) Notepad temporaire vidé/supprimé
- (h) MAJ doc : auto-memory `feedback_alerter_avant_commandes_revelant_secrets.md` enrichie + ajout au `manuel-cloudflare` (T#99 phase 1)
- (i) Clôture T#100 + reprise T#94 sous-objectif 1bis dans la foulée si temps

## Liens

- Anti-récidive Cowork : [`feedback_alerter_avant_commandes_revelant_secrets.md`](../../spaces/9a5f0c32-e9e5-438a-af52-bf209946a359/memory/feedback_alerter_avant_commandes_revelant_secrets.md)
- Pattern rotation général : [`memory/feedback_rotation_secret_curl_obligatoire.md`](../memory/feedback_rotation_secret_curl_obligatoire.md)
- Pattern Service Token CF Access : [`memory/reference_cloudflare_service_token_pattern.md`](../memory/reference_cloudflare_service_token_pattern.md)
- Tâche source : [T#94](task_094.md) — sous-objectif 1bis bloqué côté CLI
- Tâche apparentée : [T#99](task_099.md) — système meta-skills `manuel-*`
- **Tâche découlante** : [T#101](task_101.md) — purge historique `~/.claude.json` patterns sensibles (créée S110 post Phase 5)

---

## Avancement S110 (4 mai 2026, 19:53 → ~21:30)

Conv Cowork **« Sécurité Cloudflare — Rotation Service Tokens (T#100) »** (suite de la S109 « Tâches Jarvis — Priorisation reprise » où le leak avait eu lieu).

### Phases réalisées ✅

| Phase | Réalisé | Détail |
|-------|---------|--------|
| **1** | ✅ | Service Token `HA MCP Service Token — Jarvis (rotation)` créé côté CF (durée 1 an, expire 4 mai 2027 19:54). Valeurs dans Notepad temporaire local (à supprimer livrable g). |
| **2** | ✅ | Stratégie CF Access "HA MCP Service Token" éditée — section Inclure contient maintenant **2 Service Tokens** (ancien + nouveau via multi-valeurs OR implicite). |
| **3** | ✅ | Variables d'env Windows User mises à jour. Comparaison `-eq` masquée : `ID match : OK`, `SECRET match : OK`. Nouvelle session PS hérite correctement (39 + 64 chars). |
| **4** | ✅ | `~/.hermes/config.yaml` édité via `sed -i`. Backup `.bak.t100-pre-rotation` (9578 bytes, perms 600). Comparaison silencieuse : ID + SECRET match OK. Perms 600. 2 lignes CF-Access (pas de doublon). |

### Phase 5 — partiellement bloquée ⚠

Audit `~/.claude.json` a remonté un **résidu de leak ancien token en clair** (Client ID 32-hex.access ×1 + Secret 64-hex ×2 + mentions `test-ha-cli`/`home-assistant`/`mcp.might.ovh`). Mais `claude mcp list` ne montre PAS ces entrées MCP (juste Gmail+GDrive claude.ai), et `claude mcp remove test-ha-cli` retourne "No MCP servers are configured" → les patterns sont dans **l'historique de conversation Claude Code** (pas une config MCP active à supprimer via la commande native).

→ Création **T#101** (P1 post-rotation) pour purge dédiée. Bloque T#101 ← Phase 7 T#100.

### Phases restantes (à faire en S111+)

- **Phase 6** — Tests bout-en-bout :
  - `curl HEAD` HTTP 405 attendu avec nouveau token
  - Test Hermès (`hermes chat` avec recherche entité HA)
  - `claude mcp list` (status Connected pour entrées éventuelles)
- **Phase 7** — **PRIORITÉ ABSOLUE début S111** : suppression Service Token v1 (ancien) côté CF Zero Trust → invalide définitivement les valeurs leakées dans `~/.claude.json` (T#101 devient un cleanup forensique inerte).

### Brief reprise S111

1. Vérifier nouvelle fenêtre PS (39+64 chars User scope)
2. Phase 6a — `curl` HEAD endpoint avec nouveau token (preuve HTTP 405)
3. Phase 6b — Test Hermès Test B (recherche entité)
4. **Phase 7** — Suppression ancien Service Token v1 côté CF (priorité absolue)
5. Cleanup Notepad temporaire (livrable g)
6. Clôture T#100 + lancer T#101 dans la foulée si temps

### Statut courant T#100 — `open` (avancement ~70%, Phases 6+7 restantes)

---

## Avancement S111 (4 mai 2026, ~22h00) — Phases 6+7 réalisées ✅

Conv Cowork **« Sécurité Cloudflare — Rotation Service Tokens T#100 (Phases 6+7) »** (suite directe S110).

### Phase 6 — Tests bout-en-bout ✅

| Test | Commande | Résultat |
|------|----------|----------|
| **Vars env nouvelle PS** | `$env:CF_ACCESS_CLIENT_ID.Length` / `.Length` | 39 / 64 ✅ |
| **curl HTTP** | `curl.exe -s -o NUL -w "HTTP %{http_code}" -H ... $mcpUrl` | HTTP 405 ✅ (auth CF Access OK + ha-mcp répond) |
| **Hermès `mcp test`** | `hermes mcp test ha-mcp` | `Connected (988ms)` + 83 outils découverts ✅ |

Note nomenclature : côté Cowork le serveur MCP s'appelle `home-assistant` dans `.mcp.json` ; côté Hermès c'est `ha-mcp` dans `~/.hermes/config.yaml`. Conventions séparées, pas de blocage.

### Phase 7 — Suppression ancien Service Token v1 ✅

- 1ère tentative bloquée : "références existantes" → ancien token cité dans la stratégie CF Access "HA MCP Service Token" sous l'app `mcp`.
- Correctif : édité la stratégie → section Inclure → retiré l'ancien token, gardé uniquement `HA MCP Service Token — Jarvis (rotation)`.
- 2ème tentative suppression : ✅ ancien token éliminé définitivement.
- Renommé le nouveau token de `HA MCP Service Token — Jarvis (rotation)` → `HA MCP Service Token — Jarvis` (suffixe propre pour prochaine rotation).

### Régression notée — leak path-token Étape 4-octies

`hermes mcp test ha-mcp` affiche en clair l'URL complète avec le path-token (`https://mcp.might.ovh/private_xxx`). Aucun warning préalable de Jarvis avant la commande → enrichir [`feedback_alerter_avant_commandes_revelant_secrets.md`](../../spaces/9a5f0c32-e9e5-438a-af52-bf209946a359/memory/feedback_alerter_avant_commandes_revelant_secrets.md) avec ce nouveau pattern. Conséquence : path-token désormais exposé dans la conv Cowork S111 + probablement `~/.claude.json` → accélère la priorité de **T#94** (cleanup path-token côté ha-mcp + `.mcp.json`).

### Drapeau jaune non investigué

L'ancien token montrait `dernière connexion 4 mai 18:39` (avant le début de S111). Source non identifiée. Token désormais supprimé donc la fuite ne mord plus, mais à creuser si une scheduled task / Mode Réactif tombe en 403 dans les prochaines 24h.

### Cleanup final

- ✅ Notepad temporaire (valeurs nouveau token) fermé sans sauvegarder (livrable g).
- ✅ Token CF v1 supprimé (livrable f).
- ✅ Token CF v2 renommé propre.
- ⏳ Livrable h (enrichir auto-memory + `manuel-cloudflare`) → fin de session.
- ⏳ Livrable i (T#101) → reste à lancer (dépend de la disponibilité de temps).

### Statut final T#100 — `done` (avancement 100%, archivé `tasks/archive_2026-Q2/`)
