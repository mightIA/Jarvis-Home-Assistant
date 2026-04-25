---
title: HA — Procédures diagnostiques
created: 2026-04-25
tags: [ha/diagnostic, ha/troubleshooting]
status: actif
---

# HA — Procédures diagnostiques

3 cas typiques + checklist pas-à-pas.

## Appareil ne répond plus

1. Ping de l'appareil sur le réseau
2. Vérifier Zigbee2MQTT si l'appareil est Zigbee
3. Redémarrer l'add-on Zigbee2MQTT si nécessaire
4. Vérifier les piles (transmetteurs IR, capteurs)

## Interface HA ne charge pas

1. Vérifier la connexion locale `http://192.168.1.11:2096`
2. Si **403** → vérifier ban IP, suivre [[Débannissement IP]]
3. Basculer en distant `https://ha.might.ovh/` si nécessaire
4. Vérifier les logs HA pour erreurs (Outil sidebar **Log Viewer**)

## Caméra ne s'affiche pas

1. Vérifier le flux dans Lovelace
2. Tenter un rafraîchissement de la page (badge `mdi:refresh` ou F5)
3. Vérifier la connectivité réseau de la caméra
4. Vérifier ONVIF dans **Paramètres → Appareils et services**

## Notes liées

- [[Connexion et accès]] — règles 401/403
- [[Débannissement IP]]
- [[../Cameras/_Index]] — config des 3 caméras
- [[Outils sidebar]] — Log Viewer, Frigate

---

*Source : `Ressources/Competences/Home_Assistant.md` §10.*
