# Error patterns — défauts fréquents et correctifs

Catalogue des défauts récurrents en génération d'image, avec correctifs
prompt-side et paramètres.

---

## 1. Anatomie / mains

| Symptôme | Cause | Correctif MJ | Correctif DALL·E | Correctif SD |
|----------|-------|--------------|------------------|--------------|
| Mains à 6 doigts / déformées | Modèle peine sur les mains, surtout en arrière-plan | `--no malformed hands, extra fingers` ; cadrer pour cacher mains | "hands hidden in pockets" ; éviter de demander gros plan sur mains | Negative `bad hands, extra fingers, fused fingers, malformed hands, mutated hands` ; LoRA Hands Helper |
| Visage asymétrique | Génération basse résolution ou prompt vague | Préciser `symmetric face, detailed eyes` ; `--s 250` | "with detailed symmetric features" | `(detailed face:1.2), symmetric features, sharp eyes` |
| Yeux anormaux (vairons / pupilles décalées) | Bug fréquent SD/MJ | `--no crossed eyes, lazy eye` | "with normal aligned eyes" | Negative `crossed eyes, asymmetric eyes, deformed pupils` |
| Membres en plus | Confusion sur poses dynamiques | Pose simple, `--no extra limbs` | "with two arms and two legs clearly visible" | Negative `extra limbs, missing limbs, extra arms, extra legs` |

## 2. Texte dans l'image

| Symptôme | Cause | Correctif MJ | Correctif DALL·E | Correctif SD |
|----------|-------|--------------|------------------|--------------|
| Texte illisible | MJ et SD sont mauvais en texte | À éviter ou utiliser `--style raw` | **DALL·E 3 / gpt-image-1 = meilleur choix** ; quote le texte voulu | SD3 / FLUX mieux que SDXL ; SD 1.5 = à oublier |
| Texte parasite involontaire | Watermarks de training data | `--no text, watermark, signature, letters` | "without any text or letters" | Negative `text, watermark, signature, letters, words, characters` |

## 3. Cohérence / proportions

| Symptôme | Cause | Correctif |
|----------|-------|-----------|
| Tailles relatives fausses (ex : chat plus gros qu'un chien) | Modèle peine sur scale | Ajouter "<sujet1> next to <sujet2>, with <sujet1> visibly smaller than <sujet2>" |
| Perspective brisée | Composition complexe | Préciser `correct perspective, single vanishing point` ; cadrer plus simple |
| Objets flottants | Pas de gravité | Ajouter "resting on the ground", "casting a shadow" |

## 4. Style qui dérape

| Symptôme | Cause | Correctif |
|----------|-------|-----------|
| Trop "stylisé MJ" alors qu'on voulait réaliste | Default MJ pousse l'esthétique | `--style raw` + `--s 50` (au lieu de 100) |
| DALL·E ajoute des éléments non demandés | ChatGPT réécrit le prompt | Préfixer "Use this exact prompt without rewriting:" |
| SD trop saturé / "AI look" | CFG trop haut | Baisser CFG à 5-6 ; sampler `DPM++ 2M Karras` ; modèle photoréaliste (RealisticVision) |
| Rendu "AI generated" évident | Prompt trop générique | Ajouter spécificités (focale exacte, photographe ref, défaut volontaire type "slight grain") |

## 5. Couleur / exposition

| Symptôme | Cause | Correctif |
|----------|-------|-----------|
| Sur-saturation | Default modèle ou prompt insistant | Ajouter "muted colors, natural saturation, desaturated" ; baisser CFG (SD) |
| Sous-exposition / image sombre | Lighting mal spécifié | Ajouter "well-lit, balanced exposure, soft fill light" |
| Cramé / sur-exposé | "bright sunny" trop fort | Préciser "soft diffused lighting, slightly overcast" |
| Palette imposée non respectée | Compétition avec autres mots | Mettre la palette en début de prompt + pondération SD `(blue palette:1.3)` |

## 6. Composition

| Symptôme | Cause | Correctif |
|----------|-------|-----------|
| Sujet centré alors qu'on voulait off-center | Default model | "subject positioned on the right third, rule of thirds composition" |
| Manque de profondeur | Pas de DOF | Ajouter "shallow depth of field, blurred background, bokeh" |
| Plan trop serré / trop large | Cadrage absent du prompt | Préciser "wide-angle establishing shot" / "tight close-up" / "medium shot" |
| Fond chargé au lieu de neutre | Pas de précision | "clean minimalist background", "seamless white backdrop" |

## 7. Spécifique Midjourney

| Symptôme | Correctif |
|----------|-----------|
| Trop "fantasy" par défaut | `--style raw` |
| Saturation excessive V7 | `--s 50` au lieu de 100-250 |
| Compositions trop épiques | Demander composition simple, baisser `--s` |
| Random sur les détails | `--c 0` (chaos = 0) pour reproductibilité |

## 8. Spécifique DALL·E

| Symptôme | Correctif |
|----------|-----------|
| ChatGPT réécrit le prompt | "Use this exact prompt without rewriting:" en préfixe |
| Modération bloque (ex : violence subtile) | Reformuler en termes neutres ; éviter blood/weapon explicite |
| Polish excessif / "trop propre" | "with imperfections, slight grain, candid feel" |
| Personne nommée refusée | Décrire physiquement plutôt que nommer (sauf personnages historiques publics anciens) |

## 9bis. Spécifique vidéo (ajout S90 — patch P1-17)

| Symptôme | IA(s) concernée(s) | Cause | Correctif |
|---|---|---|---|
| **Morphing facial** sur 5-10 s | Toutes vidéo | Sujet trop complexe ou clip trop long | Réduire durée à 5 s, simplifier action, frame de départ plus nette ; sur Runway → Aleph relighting plutôt que regen |
| **Mains qui se dédoublent** en milieu de clip | Pika, Hailuo, Sora 2 | Sujet en mouvement avec mains visibles | Cadrer pour cacher mains (mains hors champ ou dans poches dans la frame de départ) |
| **Texte se déforme** progressivement | Toutes | Modèles vidéo gèrent mal le texte dynamique | Inclure le texte dans la frame de départ (image), pas dans le prompt vidéo. Pour vidéo "vraie" avec texte qui bouge → After Effects en post |
| **`cut to`, `next scene` ignorés** | Toutes | Modèles génèrent UN shot continu | Pas de mots de montage dans le prompt. Pour vraie séquence multi-shots → composer 2 clips 