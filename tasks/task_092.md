---
id: 92
title: "Bibliothèque TTS multi-modèles Jarvis (Pi5 légers + PC Windows premium)"
status: pending
priority: P2
session_opened: S93
session_paused: S93
tags: [tts, piper, kokoro, f5-tts, xtts, fish-audio, kimi-audio, voix, jarvis, ha, hardware, blocked-by-hardware]
source: "Session 93 / Demande Mickael — extension T#53/T#89 pour comparer plusieurs TTS locaux 2026"
blocked_by: "Arrivée PC domotique Proxmox + Docker (cf. T#41 / hardware_upgrade)"
---

# T#92 — Bibliothèque TTS multi-modèles Jarvis

## Description

Constituer une **bibliothèque de moteurs TTS locaux** déployés en parallèle
sur 2 environnements pour pouvoir A/B tester puis choisir à froid quel TTS
utilise quel canal Jarvis. **Contrainte forte (Règle 0)** : zéro fuite des
textes vocalisés vers le cloud — tous les modèles doivent tourner en LAN
local.

**Contexte d'origine** : T#53 (S84) a livré `script.jarvis_voice` branché
sur Piper `fr_FR-gilles-low` (Pi5). T#89 a intégré ce script aux 3
workflows Jarvis (S85/S91). Mickael souhaite désormais évaluer les
alternatives 2026 plus puissantes que Piper bas-débit, en gardant Piper
sur Pi5 comme fallback offline pour le pipeline Assist HA standard.

**Décision archi (S93)** :
- **Pi5 → modèles légers** (CPU ARM) pour le pipeline Assist « Home
  Assistant » par défaut
- **PC Windows MIGHT-1000D (RTX 3090 24GB) → gros modèles** pour le
  pipeline Assist « Jarvis » premium et `script.jarvis_voice`
- **Plus tard (post-upgrade i9)** : consolidation potentielle sur la nouvelle
  machine

## Catalogue cible

### A — GROS MODÈLES (PC Windows, RTX 3090) → Jarvis premium

| # | Modèle | Taille | FR | Voice cloning | Licence | Source |
|---|--------|--------|----|---------------|---------|--------|
| 1 | **Kokoro-82M** | 82M | ✅ (parmi 9 langues) | ❌ | Apache 2.0 | https://kokorottsai.com/ |
| 2 | **F5-TTS** | ~1.4B | À valider | ✅ (5-10s sample) | CC-BY-NC 4.0 (perso OK) | https://github.com/SWivid/F5-TTS |
| 3 | **XTTS-v2 (Coqui)** | 467M | ✅ (17 langues) | ✅ (6s sample) | Coqui Public License | https://github.com/coqui-ai/TTS |
| 4 | **Fish Audio S2 Pro** | ~1B | À valider | ✅ | Apache 2.0 | https://github.com/fishaudio/fish-speech |
| 5 | **Kimi-Audio 7B** | 7B | ⚠️ FR non confirmé | partiel | MIT | https://github.com/MoonshotAI/Kimi-Audio |

### B — LÉGERS (Pi5 CPU, Wyoming) → Home Assistant Assist offline

| # | Modèle | Notes |
|---|--------|-------|
| 1 | Piper `fr_FR-gilles-low` | **Actuel S84** (baseline) |
| 2 | Piper `fr_FR-gilles-medium` | Upgrade direct (qualité ↑↑, taille ~30 MB) |
| 3 | Piper `fr_FR-siwis-medium` | Voix féminine FR |
| 4 | Piper `fr_FR-tom-medium` | Alternative masculine |
| 5 | Piper `fr_FR-upmc-pierre-medium` | Voix universitaire FR |
| 6 | Piper `fr_FR-mls-medium` | Communautaire récente |
| 7 | Kokoro-82M sur Pi5 CPU (à benchmarker) | Faisabilité à valider — 82M peut peiner ARM |

## Architecture HA cible

```
HA Assist Pipeline « Home Assistant » (default)
   └─ TTS = tts.piper (sélection voix au runtime via options.voice)

HA Assist Pipeline « Jarvis » (custom)
   └─ TTS = tts.<modele_premium_pc>

script.jarvis_voice (paramétrable)
   └─ entity_id = tts.{kokoro|f5|xtts|fish|kimi|piper_*}_pc
                  selon contexte (rapport long, alerte courte, etc.)
```

Chaque moteur expose une entité HA distincte. Switch au runtime sans
modifier les workflows existants. Aucun trafic Internet sortant.

## Plan d'implémentation par phases

| Phase | Quoi | Effort | Statut |
|-------|------|--------|--------|
| **P1** | Voix Piper FR medium sur Pi5 (catalog B 2-6) | 15-30 min | 🔄 in_progress S93 |
| **P2** | Setup serveur Wyoming PC Windows + Kokoro-82M | 1h | ⏸️ pending (après P1) |
| **P3** | Ajout XTTS-v2 + F5-TTS au serveur PC | 1-2h | ⏸️ session dédiée |
| **P4** | Test Kokoro sur Pi5 CPU (faisabilité) | 30 min | ⏸️ session dédiée |
| **P5** | Fish Audio S2 Pro + Kimi-Audio 7B (exploration) | 2-3h | ⏸️ plus tard |
| **P6** | Création multiples `script.jarvis_voice_*` ou param dynamique | 30 min | ⏸️ après P3 |
| **Post-i9** | Consolidation + benchmarks de référence sur nouvelle machine | TBD | ⏸️ post-upgrade hardware |

## Pré-requis

- ✅ `tts.piper` opérationnel sur Pi5 (S84)
- ✅ `script.jarvis_voice` opérationnel (S84/S91, canal HomePod + TV Q80 DLNA)
- ✅ Pipeline Assist HA configuré (à confirmer ce qui distingue « Jarvis » vs « Home Assistant »)
- ❌ Wyoming wrapper pour Kokoro/F5/XTTS — à explorer (P2/P3)
- ❌ Espace disque PC Windows : ~15 GB pour catalog A complet — à vérifier sur D:\

## Pièges anticipés

1. **Wyoming protocol** standard HA mais pas tous les modèles ont un wrapper natif. Pour Kokoro/F5/XTTS, fallback : serveur HTTP custom + intégration HA REST TTS.
2. **PC down** = bascule auto fallback Piper Pi5 (à scripter dans `script.jarvis_voice`).
3. **Démarrage cold start** des gros modèles (loading VRAM) : à mesurer pour décider si keep-alive en RAM permanent.
4. **Concurrence VRAM** avec Hermès qwen35-agent (~17 GB) : faire attention à ne pas dépasser 24 GB total. Probable nécessité d'unloading dynamique ou bascule CPU pour TTS si Hermès chargé.

## Critères de succès

1. Catalog A et B installés et exposés en entités HA distinctes
2. `script.jarvis_voice` configurable au moins manuellement entre 3-4 moteurs
3. Comparatif écoute documenté (Mickael note ses préférences par moteur/cas d'usage)
4. Pipeline Assist « Home Assistant » conserve Piper local par défaut (zéro régression)
5. Aucun trafic réseau sortant détecté (tous LAN)

## Liens

- T#53 (S84) — création initiale `script.jarvis_voice` Piper : `tasks/archive_2026-Q2/task_053.md`
- T#89 (S91) — intégration aux 3 workflows : `tasks/task_089.md`
- Reference TV Q80 DLNA Music Assistant S91 : `memory/reference_canal_tts_tv_q80_dlna.md`
- Hardware upgrade T#73 (archivé S65) — contexte i9 futur

## Avancement S93 (03/05/2026)

### ❌ Phase P1 — Voix Piper FR medium Pi5 (ABANDONNÉE)

**Bug bloquant identifié** : changer la voix Piper par défaut + restart
add-on **CASSE l'intégration Wyoming HA** (entité `tts.piper`
désinscrite, "Échec de la configuration, nouvel essai: Unable to
connect"). Symptôme observé S93 lors de la tentative de switch
`fr_FR-gilles-low` → `fr_FR-siwis-medium`.

**Reproduction** :
1. Piper config UI → Voice → autre voix → Save → Restart add-on
2. Wyoming intégration HA voit l'ancien "service ID" disparu, désinscrit
   `tts.piper` sans en créer une nouvelle pour la nouvelle voix
3. `tts.piper` passe `unavailable`
4. Le dropdown TTS du pipeline Assist HA ne propose plus Piper

**Tentatives de récupération non concluantes** :
- Reload Wyoming via MCP `homeassistant.reload_config_entry` → succès
  apparent mais entité reste `unavailable`
- Re-mettre la voix originale `gilles-low` + restart add-on → l'add-on
  redémarre OK mais Wyoming reste cassé

**Solution fiable trouvée** : **restart Home Assistant Core complet** via
Paramètres → Système → Redémarrer. Wyoming se reconnecte automatiquement
au démarrage HA. ~45s de downtime mais 100 % fiable.

**Conclusion** : la méthode "1 add-on Piper, switch voix par défaut +
restart" est **non viable** pour comparaison rapide multi-voix.
Architectures alternatives à explorer plus tard (post-PC Proxmox) :
- Plusieurs instances de l'add-on Piper (port 10200, 10201, etc.)
- Container Docker `wyoming-piper` custom multi-voices
- Bascule complète sur Kokoro/XTTS qui exposent toutes leurs voix
  simultanément via `options.voice` au call (à valider)

**Tests Piper non réalisés** : `fr_FR-siwis-medium`, `fr_FR-tom-medium`,
`fr_FR-mls-medium`, `fr_FR-upmc-medium`. Reportés à P4 (post-hardware) ou
abandonnés au profit de Kokoro/XTTS qui surpasseront probablement.

**Découverte annexe à corriger** : le pipeline Assist « Home Assistant »
de Mickael a `Synthèse vocale = Aucun` (TTS non branché). Donc Assist ne
parle jamais. À sélectionner Piper dans ce dropdown quand on aura
clarifié la stratégie multi-TTS. Hors scope T#92 / à intégrer dans T#89.

### ⏸️ Phase P2 — Kokoro PC Windows (REPORTÉE)

Décision Mickael S93 : préférer attendre l'arrivée du PC domotique
(Proxmox + Docker) pour avoir une archi propre dès le départ, plutôt que
d'installer Python WSL2 ad-hoc qu'il faudrait re-migrer plus tard.

**Plan validé pour la reprise post-PC Proxmox** :
1. Image Docker `nordwestt/kokoro-wyoming` sur Proxmox (port 10210,
   intégration Wyoming HA native)
2. Test FR Kokoro sur la même phrase que P1 → décision keep/bascule
   XTTS-v2 ou F5-TTS si FR décevant
3. Élargissement aux autres modèles (XTTS-v2, F5-TTS, Fish Audio S2 Pro,
   Kimi-Audio 7B) en parallèle

**Drapeau rouge à confirmer** : doc Kokoro indique support FR thin (1
seule voix possible). À tester avant de juger.

## Statut

⏸️ `pending` — créée S93 (03/05/2026), P1 abandonnée S93 (bug Wyoming),
P2 reportée S93 (attente PC Proxmox + Docker). Reprise prévue post-arrivée
du nouveau matériel domotique (cf. T#41 / `Projets/Hardware_Upgrade/`).
