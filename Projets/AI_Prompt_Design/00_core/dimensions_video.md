# Dimensions vidéo — extension Option A des 12 dimensions image

> **Décision Q3 (S90, 03/05/2026) — Option A** : on garde les **12
> dimensions canoniques image** dans `prompt_template_global.md` et on
> ajoute **3 dimensions vidéo séparées** dans ce fichier. Le scoring image
> reste **/50** ; le scoring vidéo devient **/65** (50 + 15 dim vidéo).

## Rappel : 12 dimensions image (inchangées)

Voir `00_core/prompt_template_global.md` :
1. Sujet
2. Cadrage
3. Lumière
4. Palette
5. Style
6. Médium
7. Ambiance
8. Focale
9. Mouvement (figé pour image, ne pas confondre avec dim 13 ci-dessous)
10. Texture
11. Contexte
12. Qualité

## 3 dimensions vidéo additionnelles

### 13. Duration (durée du clip)

Choix de la durée et impact sur la cohérence.

| Critère scoring (/5) | Description |
|---|---|
| 5 | Durée optimale pour l'action (ni trop courte ni trop longue) |
| 4 | Durée acceptable, légère perte de cohérence |
| 3 | Durée mal calibrée (sujet morphing en fin de clip) |
| 1-2 | Durée incompatible avec l'action prévue |

**Guide pratique** : un beat narratif = 5 s. Multi-beats = 10 s seulement
si la séquence est claire dès l'image de départ.

### 14. Camera Movement (mouvement caméra)

Vocabulaire EN précis et fidélité du mouvement obtenu.

| Critère scoring (/5) | Description |
|---|---|
| 5 | Mouvement caméra exactement comme prompté, fluide |
| 4 | Mouvement présent mais légèrement décalé (vitesse, axe) |
| 3 | Mouvement ambigu, modèle a interprété autrement |
| 1-2 | Mouvement absent ou totalement différent du prompt |

**Référence vocabulaire** : `_video_common/camera_vocabulary_global.md`.

### 15. Audio (Veo 3.1, Sora 2, Hailuo si activé)

Cohérence et synchronisation de l'audio avec l'image.

| Critère scoring (/5) | Description |
|---|---|
| 5 | Dialogue lip-sync parfait + SFX synchros + ambient cohérent |
| 4 | Audio bon mais 1 décalage mineur (SFX en avance, ambient flou) |
| 3 | Dialogue intelligible mais lip-sync approximatif |
| 1-2 | Audio cassé (désynchronisé, dialogue inintelligible, SFX absent) |
| N/A | Modèle sans audio (Runway, Pika, Kling, Luma) |

**Syntaxe Veo 3.1** :
```
Audio:
- Dialogue: "<phrase 4-10 mots>" (entre guillemets doubles)
- SFX: <son spécifique tied to action>
- Ambient noise: <one-clause soundscape>
- Music: <mood/texture, pas tempo>
```

## Scoring grid étendu pour vidéo

- **Image dimensions** : 12 critères × 5 = **/60** (grille `00_core/scoring_grid.md`
  utilise une notation /50 = critères pondérés ; conserver la pondération
  existante pour image)
- **Vidéo dimensions** : 3 critères × 5 = **/15** ajouté quand vidéo
- **Total vidéo** : **/65** (image /50 + vidéo /15)

> ⚠️ Si modèle sans audio (Runway, Pika, Kling, Luma) : ne scorer que
> Duration + Camera Movement → vidéo /10, total /60.

## Convergence

- **≥ 52/65** (vidéo avec audio) ou **≥ 48/60** (vidéo sans audio) →
  capitalisation et fin de boucle.
- **<** seuil → v2 ciblée sur le critère le plus bas.
- **Audio désynchronisé persistant** sur Veo 3.1 → souvent dialogue trop
  long, raccourcir à 4-6 mots.

## Modèles couverts

| Modèle | Audio natif ? | Score max applicable |
|---|---|---|
| Runway Gen-4 / Aleph | ❌ | /60 |
| Pika 2.x | ❌ | /60 |
| Kling 2.1 / Master | ❌ | /60 |
| Luma Ray2 | ❌ | /60 |
| Sora 2 | ✅ | /65 |
| Veo 3.1 | ✅ | /65 |
| Hailuo 02 | ✅ (limité) | /62 (audio /2 max) |

---

*Créé S90 (03/05/2026) — décision Q3 audit S69 actée Option A.*
