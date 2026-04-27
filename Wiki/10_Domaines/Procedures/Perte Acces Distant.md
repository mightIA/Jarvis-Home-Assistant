---
title: Perte Acces Distant
created: 2026-04-27
tags: [procedure, reseau, ha, cloudflare]
status: actif
domaine: Procedures
sources: [S10, S11, S12, S15, S16, S17]
---

# Perte d'acces distant a Home Assistant

## Quand utiliser

- `https://ha.might.ovh/` renvoie **timeout / 502 / 503 / 521** alors que la
  veille tout marchait.
- Mickael en deplacement signale qu'il ne peut plus piloter HA depuis iPhone
  via 5G ou Wi-Fi exterieur.
- Endpoint MCP `https://mcp.might.ovh/<secret>` injoignable cote Cowork
  Desktop ou Hermes alors que tout marchait.

## Pourquoi

Le distant repose sur une chaine : **Pi5 (HA local)** -> **cloudflared**
(tunnel CF en tant que service) -> **DNS Cloudflare** (`*.might.ovh`) ->
**resolveur public**. Une rupture sur n'importe quel maillon coupe l'acces
distant **sans** affecter le LAN. Le diagnostic doit donc isoler le maillon
defaillant **du plus proche au plus loin**.

## Vue d'ensemble (4 niveaux, du local vers l'externe)

1. **Test local LAN** : Mickael ouvre `http://192.168.1.11:2096` depuis le
   PC ou Brave PC. Si **OK** -> HA tourne, le probleme est **en aval** (CF/DNS).
   Si **KO** -> Pi5 / HA Core down (passer au niveau 4).
2. **Test CF Tunnel** : cote Pi5 (SSH), `sudo systemctl status cloudflared`
   doit renvoyer `active (running)`. Si KO -> `sudo systemctl restart cloudflared`.
   Verifier les logs `journalctl -u cloudflared -n 50`.
3. **Test DNS Cloudflare** : depuis n'importe quel poste,
   `nslookup ha.might.ovh 1.1.1.1` doit renvoyer une IP CF (`104.x.x.x` ou
   equivalent CDN). Si NXDOMAIN -> connexion CF dashboard, verifier
   l'enregistrement CNAME `ha` -> tunnel UUID + flag oranger (proxy ON).
4. **Test Pi5 alive** : `ping 192.168.1.11` depuis un poste LAN. Si KO ->
   reboot Pi5 (bouton physique ou `sudo reboot` si SSH possible). Si Pi5
   alive mais HA Core down : `ha core start` via Terminal add-on / SSH.

## Pieges connus

- **PIEGE Allow vs Bypass CF Access** : si une politique CF Access "Allow + MFA"
  a ete creee sur `mcp_server` (au lieu de Bypass + Everyone), Cowork ne peut
  pas enchainer le SSO CF -> 403. Voir auto-memory `feedback_cf_mcp_bypass_not_allow.md`.
- **PIEGE additional_hosts sans DNS auto** : un nouveau hostname ajoute dans
  CF Tunnel `additional_hosts` ne cree PAS le DNS automatiquement, il faut
  creer le CNAME a la main dans CF DNS dashboard.
- **PIEGE trailing slash MCP** : `https://mcp.might.ovh/<secret>` renvoie
  405/404 (normal, POST attendu). `https://mcp.might.ovh/<secret>/` avec slash
  final renvoie 307. Toujours utiliser sans slash final.
- **PIEGE HSTS browser cache** : si SSL/TLS CF a ete bascule full -> strict
  recemment, Brave peut cacher l'ancien certif. Vider cache HSTS Brave si
  doute (Settings -> Privacy -> Clear browsing data).
- **Apres restauration** : tester en LOCAL (192.168.1.11:2096) AVANT distant.
- **Carte navigation UI CF + HA** : auto-memory `reference_ui_nav_map.md`
  catalogue les chemins avec pieges.

## Detail executable

Pas de protocole standalone dedie. Procedures fragmentees dans :

- `Ressources/Competences/Home_Assistant.md` (section connectivite).
- Auto-memories : `reference_ui_nav_map`, `reference_ha_mcp_endpoint_validated`,
  `feedback_cf_mcp_bypass_not_allow`.
- `.claude/skills/cloudflare-access-ha/SKILL.md` (config CF complete).

## Sources

- `memory/historique/2026-04-19_session_10_diagnostic_mcp_ban_ip_raccourcis.md`
- `memory/historique/2026-04-19_session_11_diagnostic_cf_access_bypass.md`
- `memory/historique/2026-04-19_session_15_pivot_ha_mcp_dcr.md`
- `memory/historique/2026-04-19_session_16_phase3_expo_mcp.md`
- `memory/historique/2026-04-20_session_17_install_cli_validation_mcp.md`
- Auto-memories : `reference_ha_mcp_endpoint_validated`, `feedback_cf_mcp_bypass_not_allow`, `reference_ui_nav_map`
