---
title: Samsung Q80 65 + décodeur Orange UHD
created: 2026-04-29
updated: 2026-04-30
tags: [atome, domotique/tv, ha/integrations, samsungtv, livebox, orange]
status: actif
source: Ressources/Competences/Home_Assistant.md (intégration native samsungtv + dlna_dmr)
---

# Samsung Q80 Series 65 + décodeur Orange UHD

Téléviseur Samsung Q80 Series 65 piloté par Home Assistant via
l'intégration native **`samsungtv`** (WebSocket local — pas SmartThings
cloud). Le décodeur TV UHD Orange (fabricant SoftAtHome) est exposé via
**DLNA-DMR (UPnP)** uniquement. Les deux appareils apparaissent dans la
page Lovelace **Media** (`ordinateur-media`).

## Identification

### Téléviseur

- **Modèle** : Samsung **QE65Q82RATXXC** (Q80 Series 65", gamme Q82R)
- **MAC** : `f4:fe:fb:65:9d:58`
- **UPnP UUID** : `0ebfc793-f0e8-4bec-a2b4-15a985a41e3b`
- **Aire HA** : `chambre`
- **Mode d'intégration** : 4 plateformes simultanées
  - `samsungtv` — natif, WebSocket local (pilotage principal)
  - `dlna_dmr` — UPnP/DLNA (player secondaire pour stream)
  - `music_assistant` — player MA broadcasté vers la TV
  - `livebox` — la Livebox Orange voit la TV comme client réseau
    (device_tracker + switch WAN access)
- **État** : `off` (TV éteinte au moment du briefing — fonctionne donc
  en veille connectée)

### Décodeur Orange

- **Fabricant** : **SoftAt