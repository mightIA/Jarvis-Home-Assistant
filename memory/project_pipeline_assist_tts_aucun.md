---
name: Pipeline Assist HA "Home Assistant" a TTS=Aucun
description: S93 — Découvert que le pipeline Assist par défaut "Home Assistant" a Synthèse vocale=Aucun, donc Assist ne répond JAMAIS à voix haute. À corriger en sélectionnant Piper.
type: project
---

# Pipeline Assist HA « Home Assistant » a TTS=Aucun

## Fait

Découverte S93 (03/05/2026) lors de l'investigation T#92 P1 sur les
voix Piper :

Le pipeline Assist par défaut **« Home Assistant »** (Paramètres →
Voice Assistants → Pipelines → Home Assistant) a la configuration
suivante :

| Brique | Valeur |
|---|---|
| Nom | Home Assistant |
| Langue | français |
| Agent de conversation | Home Assistant (builtin matching d'intentions) |
| Reconnaissance vocale (STT) | `faster-whisper` français ✅ |
| **Synthèse vocale (TTS)** | **`Aucun`** ❌ |

**Conséquence** : quand Mickael utilise Assist via micro (HomePod,
companion app iOS, etc.), Assist comprend la commande (STT OK), exécute
(intentions OK), mais **ne répond jamais à voix haute** car aucun TTS
n'est branché. Seule réponse possible : notification visuelle / texte
dans l'UI.

## Why

Assist sans réponse vocale, c'est 50 % de l'expérience. À corriger
pour que la conversation Mickael ↔ Assist soit complète vocalement.

## How to apply

À faire en session dédiée (hors T#92, hors T#89) :

1. HA UI → **Paramètres → Voice Assistants → Pipelines** → cliquer sur
   **Home Assistant**
2. Section **Synthèse vocale (TTS)** → dropdown → sélectionner
   **Piper** (`tts.piper`, voix par défaut `fr_FR-gilles-low`)
3. **Mettre à jour**
4. Tester via micro HomePod : *« Hey, allume la lumière du salon »*
5. Assist devrait répondre vocalement *« OK, j'allume la lumière du
   salon »* ou équivalent

⚠️ **Ne pas faire** tant que T#92 P1 (switch voix Piper) est encore
ouvert ou en récup post-bug Wyoming. Cohabite mal avec les changements
de voix par défaut.

⚠️ **Pipeline « Jarvis »** (custom, à vérifier dans la liste) — peut
avoir une config différente, à auditer aussi en même temps. Si Mickael
a configuré un LLM custom comme Agent de conversation, c'est ce
pipeline qui devrait recevoir la voix premium future (Kokoro/XTTS) une
fois T#92 reprise post-PC Proxmox.

## Lien

- T#92 (TTS multi-modèles, en pause) : `tasks/task_092.md`
- T#89 (workflows TTS Jarvis) : `tasks/task_089.md`
- Archive session S93 : `memory/historique/2026-05-03_session_93_hermes_v012_p1_p2_tts_pause.md`

## Statut

⏸️ Reporté — à traiter dans une mini-tâche dédiée (P3) ou intégrer à
T#89 phase de finalisation. Pas de blocant fonctionnel actuel
(`script.jarvis_voice` continue de fonctionner indépendamment du
pipeline Assist).
