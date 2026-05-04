---
id: 63
title: "Le connecteur 'Jarvis HA' côté Cowork Desktop renvoie `Session terminated` au..."
status: done
priority: P2
session_opened: S53
session_closed: S54
tags: [ha-mcp, mcp, cowork]
source: "Session 53 / Découverte divergence secret_path"
---

# T#63 — Le connecteur 'Jarvis HA' côté Cowork Desktop renvoie `Session terminated` au...

## Description

**[NOUVELLE session 53 — fix connecteur Cowork ha-mcp]** Le connecteur "Jarvis HA" côté Cowork Desktop renvoie `Session terminated` au premier appel `ha_get_state` (test S53). Cause : pointe sur le faux secret `private_Q49aOxbSlqkilVOMVrlE4g` documenté S48 mais jamais appliqué côté add-on (HTTP 404). Voir auto-memory `feedback_secret_path_s48_jamais_applique`. **Étapes** : (a) Cowork Desktop → Paramètres → Personnaliser → Connecteurs → trouver "Jarvis HA" → modifier l'URL → coller `https://mcp.might.ovh/private_[REDACTED-OLD-SECRET-S70]` (l'ancien secret = celui qui répond HTTP 405) ; OU supprimer + recréer si l'édition n'est pas dispo. (b) Refaire le flow OAuth DCR (le serveur ha-mcp ne change pas, juste l'URL côté connecteur). (c) Test bout-en-bout depuis Cowork : `ha_get_state("light.ampoule_chambre")` doit renvoyer un payload réel (state, brightness, RGB). **Durée estimée** : 5 min. **Pré-requis** : aucun (l'add-on tourne déjà avec l'ancien secret). **FAIT S54 (26/04/2026, ~10 min)** — désinstall + recréation connecteur "Jarvis HA" via Paramètres → Connecteurs → fiche n'expose pas de champ URL éditable, donc Désinstaller + Ajouter connecteur personnalisé avec URL `https://mcp.might.ovh/private_[REDACTED-OLD-SECRET-S70]`. OAuth DCR négocié silencieusement par Cowork. **Nouveau MCP server ID** Cowork : `ee1532b8-1184-43df-9749-13428394f74c` (ancien `948f33fb-77f1-4168-b094-325703b9a55f` jeté). Catalogue passé de 80+ outils (mode plein) à 14 outils pinned (mode `enable_tool_search` confirmé côté client, hint `tool_discovery` présent dans la sortie `ha_get_overview`). **Tests bout-en-bout OK** : `ha_get_overview(domains=["light"])` → 1130 entités / 36 domaines / version HA 2026.4.4 ; `ha_search_entities("ampoule chambre")` → `light.ampoule_chambre` state `on` score 100 exact_match. **Observations bonus** transformées en tâches BASSE : 3 alertes Repairs HA (2 HACS removed + 1 SamsungTV deprecated_implicit_wake_on_lan), `light.ampoule_chambre` non assignée à l'area "chambre".

## Source / Échéance

Session 53 / Découverte divergence secret_path

## Statut

**FAIT S54 (26/04/2026)**
