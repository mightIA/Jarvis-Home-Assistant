---
title: Rotation Secret Path HA MCP
created: 2026-04-27
tags: [procedure, securite, ha, mcp]
status: actif
domaine: Procedures
sources: [S48, S53]
---

# Rotation du secret_path de l'add-on ha-mcp

## Quand utiliser

- Suspicion de **fuite** du secret_path (capture publique, commit pousse,
  log partage, screen share, partage email accidentel).
- Audit periodique de securite (1x / trimestre conseille).
- Apres incident d'acces non autorise sur l'endpoint MCP `https://mcp.might.ovh/...`.

## Pourquoi

L'add-on `ha-mcp` (port 9583) est expose en public via Cloudflare Tunnel
sur `https://mcp.might.ovh/<secret_path>`. Le `<secret_path>` (24 chars)
est le **seul** garde-fou (CF Access est en Bypass, voir auto-memory
`feedback_cf_mcp_bypass_not_allow.md`). Sa fuite = exposition complete des
80+ outils `ha_*` (lecture + ecriture HA, dont restart, services, scripts).
Rotation = **regenerer** + **resynchroniser** toutes les surfaces qui
referencent l'ancien secret.

## Vue d'ensemble (6 etapes)

1. **Generer** un nouveau secret 24 chars URL-safe :
   `python -c "import secrets; print(secrets.token_urlsafe(18))"` (ou equivalent PS).
2. **HA UI** : Apps -> ha-mcp -> Configuration -> remplacer `secret_path` -> SAVE.
3. **Stop + Start** l'add-on (pas reload : full restart obligatoire).
4. **curl test** : `curl -i https://mcp.might.ovh/<NEW_SECRET>` doit
   renvoyer **405** ou **404** (pas 502/503). 405 = endpoint actif (POST attendu).
5. **sed parallele projet** : remplacer toutes les occurrences de l'ancien
   secret dans le dossier projet (`.mcp.json`, scripts, docs internes).
   Lister AVANT (Grep -i) pour estimer le nombre de surfaces.
6. **Edit auto-memories** + **update Hermes config** :
   - `memory/auto/reference_ha_mcp_addon.md`, `reference_ha_mcp_secret_regeneration.md`, `reference_ha_mcp_endpoint_validated.md`
   - `~/.hermes/config.yaml` cote WSL2 (section `mcp_servers:` URL).
   - Connecteur Cowork Desktop : Parametres -> Personnaliser -> Connecteurs -> Jarvis HA -> Edit URL.

## Pieges connus

- **PIEGE MAJEUR S53** : la rotation S48 (`[REDACTED-SECRET-NEW]`) a ete
  documentee mais **jamais appliquee** cote add-on. Le vrai secret actif reste
  l'ancien `[REDACTED-SECRET-OLD]` (HTTP 405 testable). 21 surfaces
  desynchronisees a corriger ou refaire la rotation. Voir auto-memory
  `feedback_secret_path_s48_jamais_applique`. **Toujours valider avec curl APRES Stop+Start**.
- **Reload != Restart** : `Reload` config ne suffit pas, il faut Stop puis Start
  l'add-on pour que le nouveau secret_path soit pris en compte.
- **Cowork Desktop ne charge pas les MCP stdio** mais charge bien l'URL HTTP
  ha-mcp — penser a editer le connecteur Cowork apres rotation, sinon le
  catalogue d'outils `ha_*` plante.
- **Backup HA pre-rotation** : reflexe S53, snapshot nomme `Pre_RotationSecret_YYYY-MM-DD`.
- **Hermes Agent** : si `provider: openrouter` + ha-mcp dans `mcp_servers:`,
  redemarrer Hermes pour qu'il recharge l'URL.
- **Grep avant sed** : estimer le perimetre. Eviter les faux positifs sur
  `private_*` generique (regex precise sur le secret entier).

## Detail executable

Pas de protocole standalone dedie pour le moment. Procedure consolidee
S48 (jamais executee) + correctifs S53 dans :

- Auto-memory `reference_ha_mcp_secret_regeneration.md` (6 etapes detaillees).
- Auto-memory `feedback_secret_path_s48_jamais_applique.md` (etat reel).

A formaliser en `Ressources/Protocoles/Rotation_Secret_HA_MCP.md` lors de
la prochaine vraie rotation (TODO).

## Sources

- `memory/historique/2026-04-25_session_48_phase1bisc_cloture.md`
- `memory/historique/2026-04-26_session_53_phase1bisd_b1_enable_tool_search.md`
- Auto-memories : `reference_ha_mcp_secret_regeneration`, `feedback_secret_path_s48_jamais_applique`, `reference_ha_mcp_addon`, `feedback_cf_mcp_bypass_not_allow`
