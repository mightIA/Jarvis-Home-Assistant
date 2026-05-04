---
name: HomePod Mini ≠ Apple TV salle de bain
description: L'équipement de la salle de bain est un HomePod Mini, pas une Apple TV. Confusion historique due à l'intégration HA `apple_tv` qui couvre les deux familles. Ne pas réintroduire la confusion.
type: feedback
session_origin: S79 (2026-04-30)
---

# HomePod Mini ≠ Apple TV (salle de bain)

**Règle** : l'équipement Apple présent dans la salle de bain de Mickaël
est un **HomePod Mini** (audioOS), pas une Apple TV (tvOS). Ne JAMAIS
introduire le terme "Apple TV salle de bain" dans une fiche, automation,
ou réponse.

## Why

Vérification MCP HA S79 (29/04/2026 → 30/04/2026) :

- `device_id`: `dec47c9bac725e285900a13bb310f8fb`
- `manufacturer`: Apple
- **`model`: HomePod Mini**
- `sw_version`: 26.4 (audioOS)
- `connections`: `[["mac", "4e:87:56:a0:97:aa"]]`

L'intégration native HA `apple_tv` couvre **les deux familles
d'appareils** (Apple TV + HomePod) car ils partagent les protocoles
AirPlay 2 / MRP. C'est ce qui a induit la confusion historique : le hub
`Wiki/10_Domaines/Domotique/_Index.md` listait "Apple TV salle de bain"
parce que les entités HA ont la plateforme `apple_tv`.

## How to apply

- Si une fiche, doc, automation ou conversation parle d'« Apple TV
  salle de bain », **corriger en HomePod Mini salle de bain**.
- Les capacités sont différentes : pas d'écran, pas de menus tvOS,
  pas de commandes `KEY_*` pertinentes. Focus sur AirPlay 2, volume,
  play/pause, et `media_player.play_media` avec URI audio.
- Si Mickaël installe une vraie Apple TV à l'avenir, créer une fiche
  séparée — ne pas tout mélanger sous le même nom.
- L'ancienne fiche `Apple TV salle de bain.md` a été supprimée du vault
  S79 après validation explicite Mickaël.

## Liens

- Fiche correcte : `Wiki/10_Domaines/Domotique/HomePod Mini salle de bain.md`
- Archive session : `memory/historique/2026-04-30_session_79_hub_domotique.md`
- Tâche associée : T#80 (Compléter hub Domotique)
