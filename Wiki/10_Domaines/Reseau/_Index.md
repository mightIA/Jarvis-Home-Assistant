---
title: Réseau & Sécurité — MOC
created: 2026-04-27
updated: 2026-04-27
tags: [moc, reseau, securite]
status: actif
domaine: Reseau
---

# Réseau & Sécurité — MOC

Hub central pour tout ce qui touche à l'**exposition réseau** de l'instance
Home Assistant de Mickael (`ha.might.ovh` + `mcp.might.ovh`), à la
**sécurité périmétrique** (Cloudflare, MFA, HSTS, CSP) et aux **accès
authentifiés** (MCP HA, OpenRouter, Allowlist Claude in Chrome).

## Atomes du domaine

### Périmètre Cloudflare et HTTP

- [[Cloudflare_Setup]] — Tunnel Cloudflared, DNS, app Access, bypass MCP, pièges connus
- [[MFA_HSTS_HTTPS]] — TOTP HA, HSTS 6 mois, TLS 1.2 minimum, headers MIME/anti-clickjacking
- [[CSP_Audit_Securite]] — Content-Security-Policy report-only S20, audit sécu 18/04, statut tâches #9/#10/#16

### Accès Home Assistant

- [[Ban_IP_Procedure_Synthese]] — synthèse rapide ban IP (5 lignes — la source de vérité reste `Ressources/Protocoles/IP_Bans.md`)
- [[MCP_HA_OAuth]] — add-on `ha-mcp` v7.3.0, secret_path, OAuth DCR, transport streamable HTTP

### Outils tiers et garde-fous

- [[Allowlist_Claude_Chrome]] — Paramètres Claude in Chrome → Sites autorisés (débloque les actions MCP sur dashboards)
- [[OpenRouter_Setup_Garde_fous]] — compte OpenRouter, clé `Hermes-Jarvis`, cap $5/mois, dépôt one-time, CB non sauvegardée
- [[Backup_Jarvis_Synthese]] — synthèse rapide stratégie backup (la source de vérité reste `Ressources/Protocoles/Backup_Jarvis.md`)

## Voir aussi

### Hubs liés

- [[../Cloudflare/_Index|Hub Cloudflare]] — détails apps/policies, miroir partiel ; ce hub Réseau rassemble tous les sous-sujets (CSP, MFA, MCP, OpenRouter, backup) au-delà de CF seul
- [[../HomeAssistant/_Index|Hub Home Assistant]] — pour la partie usage HA (intégrations, dashboards)
- [[../Outils/HA MCP add-on|HA MCP add-on]] — fiche détaillée skill `ha-mcp-install`

### ADR pertinents (à créer dans T#8)

- ADR : choix add-on `ha-mcp` vs `mcp_server` core HA (bug DCR — voir [[MCP_HA_OAuth]])
- ADR : bypass CF Access pour MCP plutôt que Allow + MFA (Cowork n'enchaîne pas le SSO — voir [[Cloudflare_Setup]])
- ADR : OpenRouter prépayé one-time vs abonnement flat (voir [[OpenRouter_Setup_Garde_fous]])

### Sources externes

- `Ressources/Protocoles/IP_Bans.md` — procédure complète débannissement
- `Ressources/Protocoles/Backup_Jarvis.md` — protocole backup complet
- `Ressources/Mode_Chat/Jarvis_Audits_Todo.md` — audit sécurité 18/04 + suivi
- `Ressources/Competences/Home_Assistant_Inventaire.md` §6 — inventaire CF
