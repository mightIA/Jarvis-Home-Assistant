---
id: 101
title: "Purge historique ~/.claude.json (résidus Service Tokens ancien en clair S109)"
status: done
priority: P1
session_opened: S110
session_closed: S111
tags: [security, cleanup, claude-cli, leak, post-rotation, anti-recidive]
source: "Session 110 / T#100 Phase 5 — résidus secrets en clair détectés dans ~/.claude.json après rotation : Client ID 32-hex.access ×1 + Secret 64-hex ×2 + mentions 'test-ha-cli' + 'home-assistant' + 'mcp.might.ovh' + 'CF-Access-Client-Id'. `claude mcp list` ne montre PAS ces entrées (= pas une config MCP active à supprimer via `claude mcp remove`). Patterns dans sections d'historique de conversation Claude Code S109 (sortie persistée du `claude mcp get test-ha-cli` qui avait affiché les valeurs interpolées)."
---

# T#101 — Purge historique `~/.claude.json` patterns sensibles S109

## Contexte

Pendant T#100 Phase 5 (audit `~/.claude.json`), audit ciblé a remonté :

| Pattern | Occurrences | Interprétation |
|---------|-------------|----------------|
| `${CF_ACCESS_CLIENT_ID}` (placeholder env var) | 0 | Aucune entrée propre via env var |
| `[a-f0-9]{32}\.access` (Client ID en clair) | 1 | LEAK ancien token |
| `[a-f0-9]{64}` (Secret 64-hex en clair) | 2 | LEAK ancien token (probablement cité 2× dans 2 entrées) |
| `mcp.might.ovh` | 1 | Endpoint HA |
| `test-ha-cli` | 1 | Nom MCP S109 |
| `home-assistant` | 1 | Nom MCP S109 |
| `CF-Access-Client-Id` (header) | 1 | Header HTTP |

**`claude mcp list`** : ne montre QUE Gmail+GDrive (claude.ai), pas `test-ha-cli`/`home-assistant`. Confirmation que les patterns sont dans des sections d'historique de conv Claude Code (pas une config MCP active). `claude mcp remove test-ha-cli` retourne "No MCP servers are configured".

**Risque résiduel** : après Phase 7 T#100 (suppression Service Token v1 côté CF Access), les valeurs en clair dans `~/.claude.json` deviennent **inutilisables** (juste des chaînes hex sans pouvoir d'auth). Mais elles restent **forensiquement présentes** dans le fichier.

## Périmètre

Purge des sections d'historique Claude Code contenant des patterns sensibles dans `~/.claude.json`, **sans casser les autres conversations historiques utiles**.

## Pré-requis

- T#100 Phase 7 effectuée (ancien Service Token v1 supprimé côté CF Access — sinon le leak reste actif)
- Backup `~/.claude.json` avant manipulation
- Outil de parsing JSON robuste (jq, PowerShell `ConvertFrom-Json`, Python)

## Procédure proposée (à valider)

### Phase 1 — Backup

```powershell
# PowerShell (Windows)
Copy-Item "$env:USERPROFILE\.claude.json" "$env:USERPROFILE\.claude.json.bak.t101-pre-purge"
```

### Phase 2 — Identification des sections compromises

Localiser les conversations/projets contenant les patterns sensibles sans les afficher en clair.

```powershell
$config = Get-Content "$env:USERPROFILE\.claude.json" -Raw | ConvertFrom-Json
# Parcourir la structure JSON pour identifier les clés (projets, conversations, history) qui contiennent les patterns
# (script à élaborer selon structure exacte du fichier)
```

### Phase 3 — Suppression ciblée

Options :
- (a) Supprimer entièrement les conversations historiques compromises (~projet S109)
- (b) Remplacer les patterns sensibles par `<REDACTED-T101-2026-05-04>` dans les content texts
- (c) Tronquer/réinitialiser l'historique entier de la conversation S109 problématique

Choix dépend de l'usage Claude Code de Mickael (résumés vs historique complet).

### Phase 4 — Vérification post-purge

Re-exécuter le bloc d'audit T#100 Phase 5c et confirmer **0 occurrence** de tous les patterns sensibles :

```powershell
$config = Get-Content "$env:USERPROFILE\.claude.json" -Raw
"Pattern .access (Client ID en clair) : " + ([regex]::Matches($config, '[a-f0-9]{32}\.access')).Count
"Pattern Secret 64-hex en clair : " + ([regex]::Matches($config, '[a-f0-9]{64}')).Count
$config = $null
```

Attendu : tous à 0.

### Phase 5 — Anti-récidive

- Ajouter au manuel `manuel-claude-code` (T#99) une section « Hygiène de l'historique `~/.claude.json` »
- Note pour les commandes `claude mcp add ... ${env:VAR}` : avertir Mickael que **même avec placeholder**, certaines versions du CLI résolvent en clair au moment du `add` et stockent la valeur résolue dans le JSON (à vérifier expérimentalement)

## Livrables attendus

- (a) Backup `.bak.t101-pre-purge`
- (b) Audit avant/après documenté (counts patterns)
- (c) `~/.claude.json` purgé (audit final 0 partout sur patterns sensibles)
- (d) Hygiène ajoutée au manuel `manuel-claude-code` (T#99) ou auto-memory dédiée
- (e) Auto-memory `feedback_claude_json_history_leak.md` (anti-récidive)

## Liens

- Tâche source : [T#100](task_100.md) — Rotation Service Tokens (rendue caduque mais résidus historique)
- Anti-récidive Cowork : [`feedback_alerter_avant_commandes_revelant_secrets.md`](../../spaces/9a5f0c32-e9e5-438a-af52-bf209946a359/memory/feedback_alerter_avant_commandes_revelant_secrets.md)
- Pattern Service Token CF : [`memory/reference_cloudflare_service_token_pattern.md`](../memory/reference_cloudflare_service_token_pattern.md)
- Système manuel-* : [T#99](task_099.md)

## Remarques

- **Priorité P1** (et non P0) car post-Phase 7 T#100 le leak devient inerte (token invalidé côté CF). Mais la purge reste nécessaire pour ne pas garder de chaînes "hex apparemment sensibles" qui pourraient inquiéter à un futur audit.
- **Bloqué par T#100 Phase 7** : ne pas commencer T#101 avant que le Service Token v1 soit supprimé côté CF Zero Trust. ✅ Levé S111.

---

## Avancement S111 (4 mai 2026, ~22h30) — Exécution complète ✅

Conv Cowork **« Sécurité Cloudflare — Rotation Service Tokens T#100 (Phases 6+7) »** (mêmê conv que clôture T#100, enchaînée).

### Phases réalisées

| Phase | Réalisé | Détail |
|-------|---------|--------|
| **1** | ✅ | Backup `~/.claude.json.bak.t101-pre-purge` créé. |
| **2** | ✅ | Audit avant : 1 Client ID `.access` + 2 Secret 64-hex + 1 path-token S111 + 2 `CF-Access-Client` + 1 `mcp.might.ovh` + 1 `test-ha-cli` + 1 `home-assistant`. Total 4 patterns sensibles à purger. |
| **3a** | ⚠ → ✅ | Inspection contextuelle **avec régression de masquage** : code initial masquait QUE le match courant, pas les patterns adjacents. Mickael a vu un Secret 64-hex en clair dans la sortie et l'a masqué manuellement avant collage (discipline anti-leak excellente). Le Secret leaké était l'ancien v1, déjà invalidé Phase 7 T#100 → impact réel = 0. **Anti-récidive capturée** dans [`feedback_alerter_avant_commandes_revelant_secrets.md`](../../spaces/9a5f0c32-e9e5-438a-af52-bf209946a359/memory/feedback_alerter_avant_commandes_revelant_secrets.md) section "Régression S111" (script corrigé fourni avec masquage TOUS-MASKED). Inspection contextuelle a confirmé : userID Anthropic position 20677 (à PRÉSERVER) + entrée MCP `test-ha-cli` position ~22000-22200 (à PURGER). |
| **3b** | ✅ | Purge ciblée par regex contextuelles JSON (`"CF-Access-Client-Id":\s*"[a-f0-9]{32}\.access"` → REDACTED, `"CF-Access-Client-Secret":\s*"[a-f0-9]{64}"` → REDACTED, `private_6G36IXICr8K4HJv02SXU9OlE` → REDACTED). Validation JSON OK. Écriture UTF-8 sans BOM via `[System.IO.File]::WriteAllText`. Diff length : −48 chars. |
| **4** | ✅ | Audit post-purge : Client ID `.access` = 0, Secret 64-hex = **1** (userID préservé, invariant respecté), path-token S111 = 0, sentinelles REDACTED-T101 = 3 (1 Client ID + 1 Secret + 1 path-token). |
| **4-bis** | ✅ | Test fonctionnel Claude CLI : `claude --version` = `2.1.126` OK. `claude mcp list` montre 5 MCPs dont `test-ha-cli` désormais broken (URL REDACTED). Suppression propre via `claude mcp remove test-ha-cli` → fait le ménage des sentinelles aussi (REDACTED-T101 count : 0). |
| **5** | ✅ | Anti-récidive : auto-memory dédiée [`feedback_claude_json_history_leak.md`](../../spaces/9a5f0c32-e9e5-438a-af52-bf209946a359/memory/feedback_claude_json_history_leak.md) créée avec procédure complète (audit / inspection contextuelle TOUS-MASKED / purge ciblée / cleanup MCP / 6 surfaces forensiques à auditer post-incident). |

### Découverte importante S111

**`~/.claude.json` contient AUSSI les configs MCP scope local du projet courant**, pas juste l'historique conv. L'entrée `test-ha-cli` ajoutée en S109 via `claude mcp add test-ha-cli ... -s local` y a été persistée avec ses headers CF-Access en clair (le `${env:VAR}` n'est pas interpolé pour les headers HTTP MCP côté CLI, mémoire `feedback_cli_claude_env_var_pas_interpolee_headers.md`). Donc T#101 a touché à la fois :
- résidus historique conv (sortie `claude mcp get` collée par Claude S109)
- config MCP scope local active (test-ha-cli créée S109)

### MCP `home-assistant` Failed (hors périmètre T#101)

`claude mcp list` montre `home-assistant: ✗ Failed to connect`. C'est dû au **même problème** que S109 : Claude CLI n'interpole pas les `${env:VAR}` dans les headers HTTP MCP. Sujet T#94 / T#95 (proxy local headers Service Token). Pas notre périmètre ici, mais à noter pour reprise T#94.

### Livrables — bilan

| # | Livrable | Status |
|---|----------|--------|
| (a) | Backup `.bak.t101-pre-purge` | ✅ |
| (b) | Audit avant/après documenté (counts patterns) | ✅ |
| (c) | `~/.claude.json` purgé (audit final 0 partout sur patterns sensibles) | ✅ (Secret 64-hex = 1 légitime userID préservé) |
| (d) | Hygiène ajoutée à manuel-claude-code (T#99) ou auto-memory dédiée | ✅ auto-memory `feedback_claude_json_history_leak.md` (manuel-claude-cli reste à créer en T#99 Phase 2, le contenu sera repris depuis cette auto-memory) |
| (e) | Auto-memory `feedback_claude_json_history_leak.md` | ✅ |

### Statut final T#101 — `done` (avancement 100%, archivé `tasks/archive_2026-Q2/`)
