---
name: CLI claude n'interpole PAS ${env:VAR} dans headers HTTP MCP du .mcp.json scope project
description: Limitation/bug Anthropic Claude Code CLI v2.1.126 (S109 04/05/2026) — la chaîne littérale ${env:CF_ACCESS_CLIENT_ID} est envoyée en valeur de header HTTP au lieu de la vraie valeur, ce qui casse l'auth CF Access Service Token côté CLI. Workaround : scope local avec valeurs en dur (mais secrets en clair dans ~/.claude.json).
type: feedback
session: S109
---

**Limitation découverte S109** : CLI claude (v2.1.126) **n'interpole PAS** les variables d'environnement au format `${env:VAR}` dans la section `headers:` des MCP servers HTTP du `.mcp.json` scope project.

**Symptôme** : `claude mcp get home-assistant` affiche les headers avec la chaîne littérale `${env:CF_ACCESS_CLIENT_ID}` au lieu de la vraie valeur. CF Access reçoit donc un header invalide et refuse → MCP `Failed to connect`.

**Pourquoi ça marche en stdio mais pas en HTTP headers** : l'interpolation `${env:VAR}` est supportée dans `command:` et `args:` (stdio) mais pas dans `headers:` (HTTP). Probablement un oubli ou bug Anthropic.

**Tableau des cas d'usage** :

| Scope | Format `${env:VAR}` | Stdio | HTTP sans headers | HTTP avec headers `${env:VAR}` |
|-------|--------------------|-------|--------------------|-------------------------------|
| Project (`.mcp.json` versionné) | Supporté | ✅ marche | ✅ marche | ❌ **bug** — chaîne littérale envoyée |
| Local (`~/.claude.json` non versionné) | Valeurs en dur (`claude mcp add`) | ✅ marche | ✅ marche | ✅ marche (mais secrets en clair) |

**Conséquence pour Jarvis (T#60 résolution S102)** : le pairing CLI claude home-assistant via Service Token CF Access **n'a JAMAIS fonctionné** depuis S102. T#60 résolution S102 documentait "Niveau 1 acquis Cowork + Hermès" — pas CLI. Nous n'avions pas remarqué la régression CLI car les sub-agents/skills CLI utilisent la REST API HA directement (pas le MCP).

**Workaround scope local (testé OK S109)** :

```powershell
# PowerShell interpole $env:VAR au moment de l'ajout, valeurs en dur dans ~/.claude.json
claude mcp add --transport http home-assistant "https://mcp.might.ovh/<path>" `
  --header "CF-Access-Client-Id: $env:CF_ACCESS_CLIENT_ID" `
  --header "CF-Access-Client-Secret: $env:CF_ACCESS_CLIENT_SECRET" `
  -s local
```

⚠ Les secrets se retrouvent **en clair** dans `~/.claude.json` (perms NTFS user, OK mais moins safe que vars d'env).

⚠ **PIÈGE LEAK** : `claude mcp get <name>` sur scope local affiche les headers en clair → JAMAIS coller cette sortie dans un chat persisté. Cf. auto-memory Cowork [`feedback_alerter_avant_commandes_revelant_secrets.md`](../../spaces/.../memory/feedback_alerter_avant_commandes_revelant_secrets.md).

**Solutions long terme** :
1. **Attendre fix Anthropic** Claude Code CLI (issue à ouvrir éventuellement) pour supporter `${env:VAR}` dans `headers:` scope project
2. **Ne pas dépendre du MCP CLI** — REST API HA suffit pour les sub-agents CLI actuels (Mode Réactif Phase 1 = check-jarvis-alert + rapport-journalier-reactif passent par notify HA)
3. **Proxy local T#95** post-Proxmox qui injecte les headers Service Token côté serveur — débloque aussi Cowork desktop UI (limite documentée S102)

**Comportement à adopter** :

- Ne PAS tenter de fix le pairing CLI via patches `.mcp.json` (ça ne peut pas marcher sans interpolation)
- Si un workflow CLI claude a vraiment besoin du MCP HA : utiliser scope local (`claude mcp add ... -s local`), accepter secrets en clair dans `~/.claude.json`, surveiller le piège leak `claude mcp get`
- Documenter dans `manuel-claude-cli` (skill T#99 phase 2)
