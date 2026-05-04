# Vocabulaire caméra — référence transverse vidéo

Vocabulaire **commun à tous les modèles vidéo** (Runway, Pika, Kling, Luma,
Sora 2, Veo 3.1, Hailuo). Chaque dossier modèle peut surcharger ou
restreindre via son `camera_vocabulary.md` local.

## Mouvements de translation

| Terme EN | Effet | Note |
|---|---|---|
| `dolly in` / `dolly out` | Caméra avance / recule (sur rails ou steadicam) | Mouvement le plus fiable cross-modèles |
| `truck left` / `truck right` | Caméra se déplace latéralement parallèle au sujet | — |
| `pedestal up` / `pedestal down` | Caméra monte / descend verticalement (sans rotation) | Souvent confondu avec `tilt` par les modèles |
| `crane up` / `crane down` | Mouvement vertical large (drone, grue) | Préférer pour grandes amplitudes |

## Mouvements de rotation (caméra fixe)

| Terme EN | Effet |
|---|---|
| `pan left` / `pan right` | Rotation horizontale (axe vertical) |
| `tilt up` / `tilt down` | Rotation verticale (axe horizontal) |
| `roll clockwise` / `roll counter-clockwise` | Rotation autour de l'axe optique |
| `dutch angle` | Inclinaison statique (pas un mouvement) |

## Mouvements composés

| Terme EN | Effet |
|---|---|
| `orbit` / `arc shot` | Caméra tourne autour du sujet en gardant le focus |
| `tracking shot` | Caméra suit le sujet en mouvement |
| `push in` / `pull out` | Synonymes prudents de dolly in/out (plus naturels en EN) |
| `zoom in` / `zoom out` | Changement de focale (différent d'un dolly !) |
| `whip pan` | Pan rapide avec flou de mouvement |

## Styles de captation

| Terme EN | Effet |
|---|---|
| `handheld` | Caméra à l'épaule, micro-tremblements |
| `Steadicam` | Stabilisation, mouvement fluide |
| `static shot` | Caméra immobile, le sujet bouge |
| `drone shot` / `aerial` | Vue aérienne |
| `POV shot` | Caméra subjective |
| `first-person view` | Synonyme de POV, plus explicite |

## Cadrages de référence

| Terme EN | Effet |
|---|---|
| `wide shot` / `establishing shot` | Plan large, contexte |
| `medium shot` | Cadre buste/taille |
| `close-up` | Cadre visage |
| `extreme close-up` | Détail (œil, main) |
| `over-the-shoulder` | OTS, perspective d'épaule |
| `low angle` / `high angle` | Contre-plongée / plongée |

## Pièges cross-modèles

- ❌ **Mélanger zoom et dolly** dans le même prompt → confusion garantie.
  Choisir un seul concept par mouvement.
- ❌ **`cut to`, `next scene`, `meanwhile`** → les modèles font UN shot
  continu, jamais du montage. Ces termes sont ignorés ou mal interprétés.
- ❌ **Vocabulaire français** → systématiquement EN, même pour Mickael.
- ⚠️ **`tilt`** est souvent confondu avec `pedestal` par certains modèles
  (Pika, Hailuo notamment). Pour un vrai mouvement vertical sans rotation,
  préférer `pedestal` et l'expliciter ("camera moves vertically up,
  framing stays the same").

## Ressources

- _video_common/temporal_cues.md — passage du temps en clip 5-10s
- _video_common/image_to_video_workflow.md — frame de départ + animation only
- 00_core/dimensions_video.md — 3 dimensions vidéo ajoutées aux 12 image
