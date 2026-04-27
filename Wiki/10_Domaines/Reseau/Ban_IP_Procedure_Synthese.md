---
title: Ban IP — synthèse rapide
created: 2026-04-27
tags: [reseau, securite, ban-ip]
status: actif
domaine: Reseau
sources: [Ressources/Protocoles/IP_Bans.md]
---

# Ban IP — synthèse rapide

> ⚠️ **Source de vérité** : `Ressources/Protocoles/IP_Bans.md` (procédure
> complète + 3 méthodes + règles de détection). Cette note est juste un
> résumé pour un rappel express.

## En 5 lignes

1. **Détection** : 2-3 erreurs 401/403 consécutives → STOP, vérifier ban IP.
2. **Méthode 1** (priorité) : SSH local via Brave → cmd `cat ip_bans.yaml && rm -f && ha core restart`.
3. **Méthode 2** (fallback distant) : File Editor sur `https://ha.might.ovh/hassio/addon/core_configurator/info`.
4. **Méthode 3** (MCP fallback iPhone) : `ha_call_service("shell_command", "ha_clear_all_ip_bans")` puis `ha_restart`.
5. **Toujours** tester en local après débannissement (`http://192.168.1.11:2096`).

## Liens internes

- Source complète : `Ressources/Protocoles/IP_Bans.md`
- Skill source : `.claude/skills/debannissement-ip/SKILL.md`
- Auto-memory `feedback_ha_ipbans_not_sensitive` — exception Règle 0 (pas besoin d'accord)
- Auto-memory `reference_ha_debannissement_mcp` — Méthode 3 MCP
- [[../HomeAssistant/Débannissement IP]] — note HA dédiée
- [[Cloudflare_Setup]] — bypass MCP qui interagit avec ban (range Anthropic 160.79.104.0/21)

## Sources

- `Ressources/Protocoles/IP_Bans.md` (~90 lignes)
