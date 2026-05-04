---
id: 16
title: "Ajouter Permissions-Policy via Cloudflare"
status: done
priority: P3
session_closed: S89
tags: [cloudflare, security]
source: "Audit secu — 10 min"
---

# T#16 — Ajouter Permissions-Policy via Cloudflare

## Description

Ajouter Permissions-Policy via Cloudflare pour compléter les en-têtes de
sécurité HTTP de `ha.might.ovh` (après HSTS T#2 et CSP Report-Only T#10).

## Réalisation S89 (03/05/2026)

Règle Cloudflare **Modify Response Header** créée et déployée depuis
Might-KT (laptop, déplacement) :

- **Nom** : `Permissions-Policy-HA`
- **Filtre** : `(http.host eq "ha.might.ovh")`
- **Action** : `Set static`
- **Header** : `Permissions-Policy`
- **Valeur** (une seule ligne) :

```
camera=(self), microphone=(self), geolocation=(self), fullscreen=(self), clipboard-read=(self), clipboard-write=(self), picture-in-picture=(self), display-capture=(), usb=(), payment=(), midi=(), magnetometer=(), gyroscope=(), accelerometer=(), serial=(), bluetooth=(), hid=()
```

7 features autorisées en `(self)` (camera, microphone, geolocation,
fullscreen, clipboard-read, clipboard-write, picture-in-picture).
9 features désactivées en `()` (display-capture, usb, payment, midi,
magnetometer, gyroscope, accelerometer, serial, bluetooth, hid).

### Validation

- ✅ `curl.exe -sI https://ha.might.ovh/` (PowerShell) : header présent, valeur exacte.
- ✅ `curl.exe -sIL` (suit redirects) : header sur **première réponse uniquement**, suivi du redirect 302 vers `might-ha.cloudflareaccess.com` (login Cloudflare Access).
- ⚠️ Scanners externes (securityheaders.com, Mozilla Observatory) **ne détectent pas** le header en `followRedirects=on` car ils suivent jusqu'à la page de login Cloudflare Access (host hors scope règle). **Faux négatif documenté** — pour un utilisateur authentifié, le header est bien servi.
- ✅ HA toujours accessible et fonctionnel post-déploiement (test manuel Brave).

### Audit headers HA — passe de B à A

Présents post-déploiement : Strict-Transport-Security, Content-Security-Policy
(Report-Only, T#10), Referrer-Policy, X-Content-Type-Options, X-Frame-Options,
**Permissions-Policy** (T#16).

Restent (non-bloquants A → A+) : Cross-Origin-Opener-Policy,
Cross-Origin-Resource-Policy.

## Source / Échéance

Audit secu — estimé 10 min, réalisé S89 en ~25 min (pas-à-pas guidage Brave + 3 tests de validation).

## Statut

✅ `done` — déployé et validé S89 (03/05/2026).
