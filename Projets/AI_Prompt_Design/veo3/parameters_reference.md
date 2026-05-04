# Veo 3.1 — référence paramètres

## Paramètres Veo 3.1

| Param | Valeurs | Effet |
|---|---|---|
| Duration | 8 s par défaut | Configurable selon endpoint |
| Resolution | 720p, 1080p, 4K | 4K disponible |
| Aspect ratio | 16:9, 9:16, 1:1, 4:3, 3:4 | — |
| Image input | upload | Image-to-video |
| Audio | on / off | Audio natif (dialogue lip-sync, SFX, ambient, music) |
| Seed | int aléatoire ou fixé | Reproductibilité |
| Prompt format | structuré ou libre | Structuré recommandé (voir structured_prompt_format.md) |

## Accès endpoints

| Endpoint | URL | Notes |
|---|---|---|
| Gemini Advanced | `gemini.google.com` | Interface user, abonnement |
| Vertex AI | `console.cloud.google.com/vertex-ai` | Entreprises, billing GCP |
| Gemini API | `ai.google.dev/gemini-api/docs/video` | Dev, intégration custom |

## Combinaisons typiques Mickael

### Génération standard avec audio
```
Veo 3.1, 8s, 1080p, 16:9, audio: on, prompt: structuré
```

### Sans dialogue (SFX + ambient seulement)
```
Veo 3.1, 8s, 1080p, audio: on (sans Dialogue dans le bloc)
```

### Texte to video pur sans audio
```
Veo 3.1, 8s, 1080p, audio: off
```

### Livrable 4K
```
Veo 3.1, 8s, 4K, audio: on
```

## Sources

- Prompting guide : `https://cloud.google.com/blog/products/ai-machine-learning/ultimate-prompting-guide-for-veo-3-1`
- Gemini API : `https://ai.google.dev/gemini-api/docs/video`
