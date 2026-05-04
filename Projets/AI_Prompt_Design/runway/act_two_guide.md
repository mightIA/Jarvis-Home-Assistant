# Guide Act-Two — motion capture facial Runway

> Act-Two **remplace Act-One** depuis 2026. Act-One reste utilisable mais
> n'est plus maintenu activement. Pour les nouveaux projets : Act-Two.

## Principe

Act-Two transpose une **performance vidéo réelle** (toi avec ton iPhone)
sur un **personnage cible** (image ou vidéo). Le résultat = ton expression
faciale, ton mouvement de tête, ton regard, sur le visage du personnage.

## Workflow

```
1. Driver video       2. Target character    3. Act-Two           4. Output
   (toi acteur)          (image personnage)     (Runway)              (clip animé)

   ┌───────────┐         ┌───────────┐         ┌───────────┐        ┌───────────┐
   │ iPhone    │         │ Generated │         │ Apply     │        │ Personnage│
   │ selfie    │ ───┐    │ via MJ /  │ ───┐    │ performance│ ───>  │ exécute la│
   │ 5-10 s    │    ├──> │ FLUX /    │    ├──> │ to target │        │ performance│
   └───────────┘    │    │ gpt-image2│    │    └───────────┘        │ de l'acteur│
                    │    └───────────┘    │                          └───────────┘
   ┌───────────┐    │                     │
   │ Lighting  │    │                     │
   │ frontal   │ ───┘                     │
   │ stable    │                          │
   └───────────┘                          │
                                          │
                                  Vertical / horizontal au choix
```

## Bonnes pratiques driver video

- **Lighting frontal stable** (pas d'ombre traversant le visage)
- **5 à 10 s** de performance suffisent
- **Caméra fixe** (pas de mouvement caméra dans le driver)
- **Visage centré dans le cadre**, pas trop près du bord
- **Expression neutre au début**, expression cible vers le milieu
- **Pas de lunettes** (peut interférer avec le tracking)

## Bonnes pratiques target character

- **Visage net** dans la frame de référence
- **Position 3/4 face ou face**, pas profil pur
- **Pas de masque ou occlusion**
- **Lighting cohérent** avec le driver (sinon résultat artificiel)

## Différences Act-One → Act-Two

| Feature | Act-One | Act-Two |
|---|---|---|
| Modèle | Gen-3 Alpha Turbo | Gen-4 |
| Résolution | jusqu'à 1080p | jusqu'à 4K |
| Vertical video | ✅ | ✅ |
| Tracking expression | bon | excellent |
| Tracking yeux | moyen | excellent |
| Coût crédits | bas | médium |

## Pièges

- ❌ Driver video avec mouvement caméra fort → tracking dégradé
- ❌ Target character avec visage occlusé → résultat artificiel
- ❌ Lighting incohérent driver/target → "uncanny valley"
- ❌ Driver > 30 s → coût explose, qualité ne s'améliore pas

## Sources

- Doc Act-Two : `https://help.runwayml.com` (chercher "Act-Two")
