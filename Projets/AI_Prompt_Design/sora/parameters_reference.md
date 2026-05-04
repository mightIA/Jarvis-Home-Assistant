# Sora 2 — référence paramètres

> 🔴 API discontinuée le **24/09/2026**. Voir [README.md](README.md).

## Paramètres Sora 2 (API)

| Param | Valeurs | Effet |
|---|---|---|
| Duration | 5 s à 60 s (Pro), 5-20 s (Plus) | Plus = plus court, Pro = plus long |
| Resolution | 480p, 720p, 1080p | 1080p standard |
| Aspect ratio | 16:9, 9:16, 1:1 | — |
| Image input | upload | Image-to-video |
| Audio | on / off | Audio natif (dialogue, SFX, ambient, music) |
| Watermark | obligatoire (gratuit), optionnel (Pro) | — |
| Cameos | référence vidéo personne | Feature unique Sora |

## Combinaisons typiques (jusqu'au 24/09/2026)

### Test ponctuel
```
Sora 2, 10s, 1080p, 16:9, audio: on
```

### Comparatif vs Veo 3.1
```
Même brief sur les 2 modèles, scoring /65 (avec audio)
```

### Cameo (rare)
```
Sora 2, 10s, audio: on, cameo: <référence vidéo personne>
```

## Sources

- Doc historique : `https://openai.com/index/sora-2/`
- Status dépréciation : `https://help.openai.com/en/articles/20001152-what-to-know-about-the-sora-discontinuation`
