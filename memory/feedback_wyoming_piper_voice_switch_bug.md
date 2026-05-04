---
name: Bug Wyoming Piper switch voix par défaut
description: S93 — Changer la voix par défaut Piper add-on + restart CASSE l'intégration Wyoming HA. Symptôme tts.piper unavailable. Solution fiable = restart HA Core complet (pas reload Wyoming).
type: feedback
---

# Bug Wyoming Piper switch voix par défaut

## Règle

Ne **jamais** changer la voix par défaut de l'add-on Piper (`core_piper`) +
restart de l'add-on tant qu'on n'a pas une procédure de récupération
prête. La méthode "1 add-on Piper, switch voix par défaut + restart"
**casse systématiquement** l'intégration Wyoming HA.

## Symptôme observé S93 (03/05/2026)

Lors d'une tentative de comparer plusieurs voix FR Piper (T#92 P1) :

1. Add-on Piper config UI → Voice → `fr_FR-gilles-low` → `fr_FR-siwis-medium`
2. Save + Restart add-on
3. Add-on redémarre OK (logs `Ready` + voix téléchargée)
4. **MAIS** : intégration Wyoming HA passe en
   *« Échec de la configuration, nouvel essai: Unable to connect »*
5. Entité `tts.piper` → `state: unavailable`
6. Le dropdown TTS du pipeline Assist HA ne propose plus Piper
7. Bandeau orange sur la carte entité : *« Cette entité n'est plus
   fournie par l'intégration wyoming »*

## Cause racine

L'intégration Wyoming HA identifie l'entité TTS par un "service ID"
qui inclut probablement le nom de la voix. Quand la voix par défaut
change, Wyoming considère l'ancien service ID disparu et désinscrit
l'entité `tts.piper`, mais **n'en crée pas une nouvelle** pour la
nouvelle voix. Pas de mécanisme de re-discovery automatique.

## Tentatives de récupération NON concluantes

- ❌ Reload Wyoming via MCP `homeassistant.reload_config_entry` avec
  l'entry_id extrait du `unique_id` `tts.piper` (préfixe avant `-tts`)
  → succès apparent côté API (`message: "Successfully executed"`)
  mais entité reste `unavailable`
- ❌ Re-mettre la voix originale `gilles-low` + restart add-on →
  l'add-on redémarre OK avec la bonne voix mais Wyoming reste cassé
- ❌ Reload manuel via UI HA (Paramètres → Périphériques → Wyoming →
  ⋮ → Recharger) — non testé S93 mais Mickael a directement choisi
  l'option nucléaire

## Solution fiable à 100 %

**Restart Home Assistant Core complet** :
- HA UI → Paramètres → Système → Redémarrer → **Restart Home Assistant Core**
- ~45s de downtime
- Wyoming se reconnecte automatiquement au démarrage
- Entité `tts.piper` redevient disponible avec la voix configurée

## Why

Sans cette règle, on perd 30-45 min en diagnostic à chaque switch :
add-on a l'air OK, MCP retourne success, mais l'audio ne sort pas et
on cherche dans la mauvaise direction (téléchargement voix, conflit
réseau, etc.). Le restart HA Core est la seule action qui re-bootstrap
proprement l'intégration Wyoming.

## How to apply

- Avant tout changement de voix par défaut Piper : prévoir 5 min de
  downtime HA pour restart Core post-switch
- Pour comparaison rapide multi-voix : abandonner cette méthode,
  préférer plusieurs instances Piper (ports 10200/10201/...) ou
  bascule sur Kokoro/XTTS/F5-TTS qui exposent toutes leurs voix
  simultanément via `options.voice` au call
- Si le bug se reproduit sans changement de voix volontaire (autre
  cause) : restart HA Core reste la solution de premier recours

## Lien

- T#92 phase P1 (abandonnée S93) : `tasks/task_092.md`
- Archive session S93 : `memory/historique/2026-05-03_session_93_hermes_v012_p1_p2_tts_pause.md`
