---
title: CSP & audit sécurité — statut S33
created: 2026-04-27
tags: [reseau, securite, csp, audit]
status: actif
domaine: Reseau
sources: [S20, audit-2026-04-18]
---

# CSP & audit sécurité

## Contexte

Audit sécurité de `https://ha.might.ovh/` réalisé le **18/04/2026**.
Mis à jour S33 (23/04/2026) dans `Ressources/Mode_Chat/Jarvis_Audits_Todo.md`.
2 vulnérabilités HAUTES fermées (HSTS + MFA — voir [[MFA_HSTS_HTTPS]]),
**CSP en mode report-only** (S20), 1 MOYENNE ajournée (compte MightTab),
2 BASSES restantes (Permissions-Policy, SSH clés).

## Configuration CSP — Phase 1 FAIT (S20)

### Règle Cloudflare Transform Response Header

**Navigation** : Cloudflare > `might.ovh` > Règles > Vue d'ensemble > +
Créer une règle > Règles de transformation de l'en-tête réponse

| Paramètre       | Valeur                                              |
|-----------------|-----------------------------------------------------|
| Nom             | `CSP-Report-Only-HA`                                |
| Filtre          | `(http.host eq "ha.might.ovh")`                     |
| Action          | Ajouter un en-tête (statique)                       |
| Nom d'en-tête   | `Content-Security-Policy-Report-Only`               |
| Valeur          | voir politique ci-dessous                           |

### Politique de démarrage (permissive volontairement)

```
default-src 'self';
script-src 'self' 'unsafe-inline' 'unsafe-eval';
style-src 'self' 'unsafe-inline';
img-src 'self' data: blob: https:;
connect-src 'self' wss://ha.might.ovh https://ha.might.ovh;
font-src 'self' data:;
frame-ancestors 'self'
```

Active depuis 20/04/2026, badge vert "Actif", ordre 1, 1/10 règles
utilisées sur le forfait CF gratuit.

### Validation live

Via `javascript_tool` dans Brave (tab HA) :

```js
fetch('/manifest.json', {cache: 'no-store'}).then(r =>
  r.headers.get('content-security-policy-report-only'))
```

→ Retour : politique servie par CF edge confirmée.

### Capture des violations (test)

| Test                                       | Directive       | Attendu      | Réel          |
|--------------------------------------------|-----------------|--------------|---------------|
| `<script src="cdn.jsdelivr.net/...">`     | script-src-elem | violation    | violation OK  |
| `<img src="via.placeholder.com/1x1">`     | img-src         | non bloqué   | OK            |
| `fetch("api.github.com/zen")`             | connect-src     | violation    | violation OK  |

Toutes en `disposition: "report"` → mode report-only confirmé, rien ne casse.

## Phase 2 — Collecte 1-2 semaines (en cours)

À faire par Mickael en navigation normale, surveiller F12 → Console.

**Points chauds à tester** :

- Cartes HACS custom (risque CDN externe jsdelivr/unpkg)
- Panneaux Frigate (streams, iframes)
- AdGuard, ESPHome Builder (polices, iframes)
- File editor / Studio Code Server (monaco/ace depuis CDN)

**Critère de bascule Phase 3** : zéro violation pendant 1-2 semaines →
basculer le header sur `Content-Security-Policy` (actif, plus report-only).
Sinon, ajouter les domaines détectés à la politique.

## Statut audit (snapshot S33, source : `Jarvis_Audits_Todo.md`)

### Fermées (HAUTES)

- **HSTS** — FAIT S19 (max-age 6 mois, TLS min 1.2) — voir [[MFA_HSTS_HTTPS]]
- **MFA TOTP** — FAIT S19 (compte Mickael + secret base32 coffre)

### En cours

- **CSP** — Phase 1 FAIT S20, Phase 2 en cours (collecte violations)

### Ajournée (MOYENNE)

- **Compte MightTab accessible à distance** — Tâche #9. Aujourd'hui la
  tablette utilise le compte admin principal (owner HA). Risque assumé
  tant que la tablette reste au domicile. Fix cible : compte `MightTab`
  non-admin + TOTP + groupe `tablette_mobile` (climate / light / switch /
  media_player uniquement). À rediscuter quand config HA stabilisée.

### À faire (BASSES)

- **Permissions-Policy** — Tâche #16. Ajouter via CF Transform Response
  Header (géolocation, caméra, microphone). Priorité BASSE car APIs non
  exposées à des tiers externes.
- **SSH aux clés (port 22 local)** — Tâche #14. Passer aux clés ed25519
  pour éliminer brute force local. Priorité BASSE : attaque locale
  uniquement.

## Données sensibles accessibles via session authentifiée

⚠️ Une session valide donne accès à : adresse postale, GPS maison + temps
réel iPhone/tablette, SSID Wi-Fi Livebox, caméras intérieures, présence
domicile, switch Wi-Fi, scripts, automatisations, dashboards.

La MFA TOTP (S19) réduit fortement ce risque à l'authentification.

## Pièges connus

- **CSP `unsafe-inline` + `unsafe-eval`** dans la politique de démarrage :
  volontaire pour ne rien casser en Phase 1, à durcir en Phase 3 si
  possible (probablement pas faisable sur HA frontend).
- **Limite CF free** : 10 règles Transform Response Header max. CSP en
  utilise 1, reste 9 slots.
- **`Ajouter un en-tête statique`** (Set) ≠ `Dynamique` (qui attend une
  expression). Toujours statique pour la CSP.
- **CSP report-only refresh** : si listener JS perdu après refresh
  complet, ré-injecter l'écouteur `securitypolicyviolation`.

## Liens internes

- [[MFA_HSTS_HTTPS]] — autres couches de sécu HTTP
- [[Cloudflare_Setup]] — règles CF Transform globales
- [[Allowlist_Claude_Chrome]] — outil de pilotage CF dashboard depuis Claude

## Sources

- `memory/historique/2026-04-20_session_20_allowlist_csp_ha.md` (Phase 1 CSP)
- `Ressources/Mode_Chat/Jarvis_Audits_Todo.md` Partie 1
- `TASKS.md` #9 #10 #14 #16
