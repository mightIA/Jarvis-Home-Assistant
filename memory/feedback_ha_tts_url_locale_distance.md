---
name: HA TTS URL locale renvoyée même en distance
description: HA renvoie l'URL TTS en `http://192.168.1.11:2096/api/tts_proxy/<hash>.mp3` même quand l'utilisateur consomme depuis l'extérieur. Browser Mod et clients distants ne peuvent pas joindre. À corriger via `external_url`.
type: feedback
session: S84 (2026-05-02)
related_tasks: [T#53, T#89]
---

# HA TTS — URL locale renvoyée même en distance

## Constat

Lors de tests Piper TTS S84 (T#53) avec Mickael en distant (`https://ha.might.ovh`) :

- `tts.speak` exécuté avec succès, fichier audio généré sur HA RPi5.
- HA renvoie l'URL : `http://192.168.1.11:2096/api/tts_proxy/<hash>.mp3` (IP **locale**).
- Browser Mod côté navigateur Brave de Mickael ne peut pas joindre cette IP locale (autre réseau).
- Conséquence : aucun son ne joue dans Brave, alors que côté HA tout est `state: playing`.

Workaround S84 : transformer manuellement l'URL en `https://ha.might.ovh/api/tts_proxy/<hash>.mp3` et l'ouvrir dans un nouvel onglet Brave. Test live OK.

## Correction à apporter

**Why** : pour que les annonces TTS via Browser Mod ou consommateurs distants fonctionnent, HA doit renvoyer l'URL externe quand le client est externe.

**How to apply** :

1. **Configurer `external_url` côté HA** (`configuration.yaml` ou Settings → Système → Réseau) :
   ```yaml
   homeassistant:
     external_url: "https://ha.might.ovh"
     internal_url: "http://192.168.1.11:2096"
   ```
2. HA détecte le client (interne ou externe) via le `Host` header et choisit l'URL appropriée pour les media_content_id.
3. Tester avec `ha_call_service` en distance pour valider.

**Side-effect attendu** : les media_player Apple TV / HomePod / Chromecast en LAN continuent à utiliser `internal_url` (plus rapide, pas de hop CF). Browser Mod et apps mobile en LAN aussi.

## Pour T#89

L'intégration `script.jarvis_voice` aux workflows (rapport 23h30, alertes, tri Gmail) doit valider ce point en pré-requis. Si Mickael est en distance quand un workflow se déclenche, et qu'on veut Browser Mod / fallback ouverture URL audio, l'`external_url` doit être configurée.

## Sessions précédentes pertinentes

- S84 : constat lors test Piper TTS T#53.
