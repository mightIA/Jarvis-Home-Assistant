---
title: HA — Intégrations configurées
created: 2026-04-25
tags: [ha/integrations, ha/inventaire]
status: actif
---

# HA — Intégrations configurées

État au 21/04/2026 (session 24, MCP `ha_get_integration`) :
**62 entrées** — `loaded: 58 / not_loaded: 2 / setup_retry: 1 / setup_in_progress: 1`

## Système & onboarding (core HA)

`sun`, `hassio` (Supervisor), `raspberry_pi`, `rpi_power`, `local_ip`,
`time_date`, `uptime`, `systemmonitor`, `backup`, `shopping_list`,
`color_extractor`, `met` (météo défaut), `google_translate`, `radio_browser`.

## Réseaux & protocoles

| Domaine | Titre | État |
|---|---|---|
| `bluetooth` | RPi BT (`2C:CF:67:6F:5D:03`) | loaded |
| `mqtt` | `127.0.0.1` Mosquitto | loaded |
| `matter`, `thread`, `otbr` | Matter / Thread / Border Router | loaded |
| `zha` | Sonoff Zigbee 3.0 USB Dongle | **not_loaded** (volontaire — Mickael utilise Zigbee2MQTT) |
| `ibeacon` | iBeacon Tracker | loaded |

## Box / TV / Media

`upnp` Orange Livebox, `livebox`, `dlna_dmr` (Décodeur TV UHD + Samsung Q80
Series 65), `samsungtv`, `apple_tv` Salle de bain, `music_assistant`, `go2rtc`.

## Caméras & vidéo

| Domaine | Titre | État |
|---|---|---|
| `onvif` | Chambre `c4:aa:c4:4b:68:40` | loaded |
| `onvif` | Cuisine `f8:ce:07:b5:5b:f6` | loaded |
| `webrtc` | WebRTC Camera | loaded |
| `frigate` | `ccab4aaf-frigate-fa:5000` | **setup_retry** ⚠️ à diagnostiquer |

→ Voir [[../Cameras/_Index]]

## Appareils connectés

| Domaine | Titre | État |
|---|---|---|
| `frisquet_connect` | Maison (chaudière) | loaded → [[../Frisquet/_Index]] |
| `dyson_local` | MyDyson + Dyson Purifier | loaded → [[../Domotique/Dyson Purifier]] |
| `ecoflow_cloud` | River 2 Pro | loaded |
| `moonraker` | Creality Ender 3 S1 Pro | **setup_in_progress** (imprimante éteinte, `192.168.1.81:7125`) |

## Localisation & calendrier

`meteo_france` (Serémange-Erzange Lorraine 57), `proximity` Maison,
`local_calendar` Might + Might-ha, `google_tasks` Mickaël RUBINO, `downloader`.

## HomeKit Bridges (HA → iOS)

5 bridges + 5 accessories isolés (prises Child lock + Samsung Q80).

## Mobile apps

`mobile_app` Might iPhone + MightTab.

## Automatisation & IA

`nodered`, `browser_mod` (cf. [[../Domotique/Browser Mod]]), `hacs`,
`openai_conversation` (loaded) + ChatGPT (not_loaded volontaire),
`wyoming` Piper + Whisper.

## MCP

- Add-on **`ha-mcp`** (homeassistant-ai) sert de serveur MCP pour Cowork
  via `https://mcp.might.ovh/<secret>` (CF Tunnel).
- Intégration core `mcp_server` HA **abandonnée** (ne supporte pas DCR,
  bug noté S15 — auto-memory `feedback_mcp_server_core_no_dcr`).

## À surveiller

- `frigate` setup_retry → diagnostiquer (redémarrage add-on ou perte réseau)
- `moonraker` setup_in_progress → imprimante 3D injoignable
- `zha` not_loaded → normal, Zigbee2MQTT préféré

## Notes liées

- [[Apps installées]] — les add-ons sous-jacents
- [[Procédures diagnostiques]] — quand une intégration ne charge pas

---

*Source : `Ressources/Competences/Home_Assistant_Inventaire.md` §5.*
