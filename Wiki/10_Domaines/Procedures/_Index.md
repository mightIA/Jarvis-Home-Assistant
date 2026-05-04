---
title: Procedures rares — Hub
created: 2026-04-27
updated: 2026-05-02
tags: [moc, procedure, domaine/procedures]
status: actif
source_skills:
  - .claude/skills/debannissement-ip/SKILL.md
  - .claude/skills/install-claude-code-windows/SKILL.md
source_ressources:
  - Ressources/Protocoles/IP_Bans.md
  - Ressources/Protocoles/Backup_Jarvis.md
---

# Procedures rares — Hub central

Catalogue rapide des procedures rares (urgence, recovery, rotation). Indique
**quand / pourquoi** declencher chaque procedure ; le **detail executable**
reste dans `Ressources/Protocoles/` (source de verite, non duplique ici).

## Atomes du domaine

- [[Debannissement IP]] — 401/403 repetes / IP bloquee par fail2ban HA. 3 methodes (SSH local, File Editor distant, MCP fallback).
- [[Backup Restauration HA]] — avant update HA / manipulation risquee. 3 cibles (OneDrive + disque externe + Git prive).
- [[Rotation Secret Path HA MCP]] — suspicion fuite secret_path add-on `ha-mcp`. Procedure 6 etapes + Edit auto-memories + Hermes config.yaml.
- [[Recovery TOTP HA]] — perte telephone TOTP. HA n'a PAS de codes de secours, plan de prevention + reset MFA via SSH local.
- [[Perte Acces Distant]] — `ha.might.ovh` down. Diagnostic 4 niveaux (local LAN, CF Tunnel, DNS CF, Pi5 ping).
- [[Reactivation Cowork Apres Reboot]] — PC redemarre. Verifier autostart Cowork + raccourci `shell:startup`.

> **Note S84 (2026-05-02)** : atome `[[Bascule Conversation Limite Contexte]]`
> retiré suite suppression skill `bascule-conversation` (T#24 cancelled —
> obsolète depuis mode PC permanent S24). À l'approche limite contexte,
> proposer `/compact` ou nouvelle conv (auto-memory `feedback_compact_vs_bascule_proposition`).

## Reflexes de declenchement

| Symptome | Atome a ouvrir |
|----------|----------------|
| 2-3 erreurs 401/403 sur HA | [[Debannissement IP]] |
| Avant update Core/OS HA, avant edit massif config.yaml | [[Backup Restauration HA]] |
| Secret expose dans capture / commit / log public | [[Rotation Secret Path HA MCP]] |
| Telephone TOTP perdu/casse | [[Recovery TOTP HA]] |
| Plus d'acces a `ha.might.ovh` (timeout / 5xx) | [[Perte Acces Distant]] |
| PC reboot, Cowork ne demarre pas | [[Reactivation Cowork Apres Reboot]] |
| Conv qui rame / approche limite tokens | `/compact` ou nouvelle conv (cf. auto-memory `feedback_compact_vs_bascule_proposition`) |

## Regles transverses

- **Avant** toute procedure rare touchant HA : preferer un snapshot / backup.
- **Apres** : tester en local (`http://192.168.1.11:2096`) AVANT de retester en distant.
- **Regle 0** : si la procedure expose un secret (token, mdp, secret_path), arret + accord explicite Mickael.
- **Pas-a-pas** : livrer UNE etape a la fois et attendre le retour Mickael (CLAUDE.md section 4).

## Source de verite executable

- `Ressources/Protocoles/IP_Bans.md` — debannissement (3 methodes detaillees).
- `Ressources/Protocoles/Backup_Jarvis.md` — 3 strategies + scripts robocopy/git.
- Auto-memories : `feedback_secret_path_s48_jamais_applique`, `reference_ha_mcp_secret_regeneration`, `feedback_ha_totp_no_backup_codes`, `feedback_compact_vs_bascule_proposition`.

---

*Hub cree S65+ (27/04/2026). Convention atomique stricte D4-S42. Pattern "pointer, don't embed".*
