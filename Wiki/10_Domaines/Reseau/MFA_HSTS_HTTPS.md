---
title: MFA, HSTS, HTTPS — couches de durcissement
created: 2026-04-27
updated: 2026-04-27
tags: [atome, reseau, securite, mfa, hsts, tls]
status: actif
domaine: Reseau
sources: [S08, S19]
---

# MFA, HSTS, HTTPS — couches de durcissement

## Contexte

Audit sécurité du 18/04/2026 sur `https://ha.might.ovh/` : 2 vulnérabilités
HAUTES identifiées (HSTS absent, MFA non sauvegardé). Les deux ont été
**fermées en S19 (19/04/2026)**. Cette note fait le récap des paramètres
en place.

## Configuration

### MFA / TOTP (compte Mickael)

- **Module** : `Authenticator app` (TOTP standard) — HA 2026.4.3+
- **Activation** : Profil utilisateur → Modules d'authentification multifacteur
- **Backup secret** : la **chaîne base32** sous le QR code de configuration
  (HA n'expose **pas** de "codes de secours" séparés)
- **Stockage Mickael** : gestionnaire de mots de passe (carte HA, champ
  Notes, libellé `Secret TOTP HA - 19/04/2026`) + photo du QR — double
  sauvegarde ceinture+bretelles
- **Authenticator** : Google Authenticator iPhone

> Auto-memory `feedback_ha_totp_no_backup_codes` : ne plus jamais affirmer
> que HA propose des codes de secours natifs.

### HSTS — Strict-Transport-Security

Configuration via Cloudflare → SSL/TLS → Edge Certificates.

| Réglage              | Valeur                       |
|----------------------|------------------------------|
| Always Use HTTPS     | ON                           |
| HSTS                 | Activé                       |
| max-age              | **6 mois** (15 768 000 s)    |
| includeSubDomains    | OFF (prudent — pas tous les sous-domaines en HTTPS forcé) |
| Preload              | OFF                          |

### TLS

- **Minimum TLS Version** : TLS 1.2 (évite les anciennes versions 1.0/1.1
  vulnérables)
- Cipher suites gérés par Cloudflare edge (modernes, configurés côté CF)

### Headers HTTP de sécurité

| Header                    | Valeur                              | Source         |
|---------------------------|-------------------------------------|----------------|
| `Strict-Transport-Security` | `max-age=15768000`               | CF Edge        |
| `X-Content-Type-Options`  | `nosniff`                           | CF Edge        |
| `X-Frame-Options`         | `SAMEORIGIN` (HA) / `DENY` (CF)     | HA + CF        |
| `Content-Security-Policy-Report-Only` | défini S20 — voir [[CSP_Audit_Securite]] | CF Transform Rule |
| `Referrer-Policy`         | présent (valeur par défaut CF)      | CF             |
| `Permissions-Policy`      | **manquant** — tâche #16 BASSE      | —              |

### Validation externe

Test via [securityheaders.com](https://securityheaders.com) :

- **Grade global : A** (post-S19)
- Warning à traiter : `content-security-policy` contient `'unsafe-inline'`
  → suivi via [[CSP_Audit_Securite]] (tâche #10)
- Missing : `permissions-policy` → tâche #16 (priorité BASSE, pas
  d'API navigateur exposée à des tiers externes)

## Pièges connus

- **HSTS includeSubDomains OFF** par choix prudent : si activé, tous les
  sous-domaines `*.might.ovh` doivent être en HTTPS, ce qui peut casser
  des sous-domaines internes en HTTP.
- **HSTS Preload OFF** : preload list est irréversible (browser-level),
  inutile sans validation rigoureuse de tous les sous-domaines.
- **TOTP — pas de backup natif** : sauvegarder la chaîne base32 sous le
  QR pendant la configuration initiale, sinon impossible à retrouver
  après. Cf auto-memory `feedback_ha_totp_no_backup_codes`.
- **CSP `unsafe-inline`** : valeur par défaut CF qui n'est pas idéale,
  remplacée par la règle Transform `CSP-Report-Only-HA` côté HA (S20).

## Liens internes

- [[Cloudflare_Setup]] — config CF complète (tunnel, DNS, Access)
- [[CSP_Audit_Securite]] — Content-Security-Policy déployée S20
- [[MCP_HA_OAuth]] — auth machine via secret path
- [[../HomeAssistant/Connexion et accès]]

## Sources

- `memory/historique/2026-04-19_session_08_securite_HSTS_MCP.md` (Phase 1+2)
- `Ressources/Mode_Chat/Jarvis_Audits_Todo.md` Partie 1 — audit sécu
- `.claude/skills/cloudflare-access-ha/SKILL.md`
- Auto-memory `feedback_ha_totp_no_backup_codes`
