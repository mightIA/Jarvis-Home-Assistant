---
title: Inventaire — Réseau maison
created: 2026-04-27
updated: 2026-04-27
tags: [atome, inventaire, reseau, transverse]
status: stub
domaine: Inventaire
remplissage_attendu: Mickael
---

# Inventaire — Réseau maison

> **Template à remplir.** Mickael complétera lors d'une session dédiée.
>
> Connexion fibre Mickael ~ 1 Gbps réelle (mesurée S48). Voir auto-memory `reference_mickael_connexion_fibre`.

## Équipements réseau actifs

| Nom | Type | Marque/Modèle | IP fixe | Localisation | Notes |
|---|---|---|---|---|---|
| Box Internet | Box fibre | Orange Livebox (à préciser modèle) | (à préciser) | (à préciser) | Intégrations `upnp` + `livebox` |
| Switch principal | Switch L2/L3 | (à préciser) | (à préciser) | (à préciser) | |
| Point d'accès Wifi 1 | AP | (à préciser) | (à préciser) | (à préciser) | |
| Point d'accès Wifi 2 | AP | (à préciser) | (à préciser) | (à préciser) | (si applicable) |
| ... | ... | ... | ... | ... | ... |

## Adressage IP fixe (LAN)

| IP | Hostname / Device | Type | Notes |
|---|---|---|---|
| `192.168.1.1` | Livebox | Box | Gateway par défaut |
| `192.168.1.11` | Pi5 (Home Assistant OS) | SBC | Voir [[Garage_Cave]] |
| `192.168.1.81` | Ender 3 S1 Pro (Moonraker) | Imprimante 3D | Port 7125 — voir [[Bureau]] |
| ... | ... | ... | ... |

> À compléter avec capture de la table DHCP Livebox + scan réseau (nmap / Fing).

## Wifi (SSIDs)

| SSID | Bande | Sécurité | Notes |
|---|---|---|---|
| (à préciser) | 2.4 / 5 GHz | WPA2/WPA3 | SSID principal |
| (à préciser) | 2.4 / 5 GHz | WPA2/WPA3 | SSID invités si applicable |
| (à préciser) | 2.4 GHz | WPA2 | SSID IoT si applicable |

> **Ne JAMAIS noter les mots de passe ici.** Garder hors-vault, voir Règle 0 sécurité.

## Accès distant

| Service | Méthode | URL | Notes |
|---|---|---|---|
| HA distant | Cloudflare Tunnel + CF Access | `https://ha.might.ovh` | MFA TOTP via app `Might-HA` |
| HA MCP server | CF Tunnel + bypass CF Access | `https://mcp.might.ovh/<secret>` | Voir auto-memory `reference_ha_mcp_addon` |
| ZeroTier | VPN P2P | (à préciser) | Add-on `ZeroTier One` actif sur HA |

## Liens internes

- [[10_Domaines/HomeAssistant/Connexion et accès]]
- [[10_Domaines/HomeAssistant/_Index]]
- [[Garage_Cave]] (Pi5 host HA)
- [[Bureau]] (PC + imprimante)
- [[Exterieur]] (caméras IP)

## Sources de remplissage à venir

- Capture table DHCP Livebox
- Scan réseau (nmap ou Fing iOS)
- Plan/schéma physique de la maison avec emplacements AP et switch
