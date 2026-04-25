---
title: HA — Débannissement IP
created: 2026-04-25
tags: [ha/securite, ha/debannissement]
status: actif
---

# HA — Débannissement IP

> ⚠️ **Exception Règle 0** — `ip_bans.yaml` est explicitement non sensible
> (cf. auto-memory `feedback_ha_ipbans_not_sensitive`). Pas besoin
> d'accord explicite avant de manipuler ce fichier.

## Règles avant de supprimer un ban

| Règle | Action |
|---|---|
| 1 | Si ban > 30 min, prévenir Mickael avant action |
| 2 | Si plusieurs IPs bannies, prévenir Mickael |
| 3 | Toujours retester la connexion locale après débannissement |

## Méthode 1 — Terminal SSH local via Brave (PRIORITÉ)

Validée depuis PC, à retester depuis Dispatch/iPhone.

1. Ouvrir dans Brave : `http://192.168.1.11:2096/hassio/addon/core_ssh/info`
2. Cliquer sur **Ouvrir l'interface utilisateur Web** (bouton bleu)
3. Dans le terminal, exécuter :

```bash
cat /homeassistant/ip_bans.yaml 2>/dev/null && rm -f /homeassistant/ip_bans.yaml && ha core restart || echo 'Pas de ban IP actif'
```

4. Attendre 30 s puis tester `http://192.168.1.11:2096`

## Méthode 2 — File Editor via URL distante

Fallback si réseau local impossible.

1. Ouvrir `https://ha.might.ovh/hassio/addon/core_configurator/info`
2. Naviguer dans `homeassistant/`, chercher `ip_bans.yaml`
3. Si absent = aucun ban actif. Sinon, supprimer le fichier.

## Méthode 3 (fallback) — MCP `ha-mcp`

Via la skill `debannissement-ip` :
`shell_command.ha_clear_all_ip_bans` exécutée via le MCP add-on `ha-mcp`.
Utilisée quand Brave bloqué/iPhone seul.
Cf. auto-memory `reference_ha_debannissement_mcp`.

## Notes liées

- [[Connexion et accès]] — règle 2-3 erreurs 401/403 → arrêt automatique
- [[../Cloudflare/_Index|Cloudflare]] — bypass MCP qui contourne CF Access
- Skill : `.claude/skills/debannissement-ip/`

---

*Source : `Ressources/Competences/Home_Assistant.md` §2 + `Ressources/Protocoles/IP_Bans.md`.*
