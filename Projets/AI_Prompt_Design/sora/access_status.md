# Statut d'accès Sora 2 — état mai 2026

## Timeline officielle

| Date | Événement |
|---|---|
| 30 sept 2025 | Sora 2 lancé |
| courant 2025-2026 | Accès gated (waitlist + ChatGPT Pro) |
| **26 avril 2026** | 🔴 **Web et app discontinued** (consumer access) |
| courant mai-sept 2026 | API encore active, accès dev uniquement |
| **24 sept 2026** | 🔴 **API discontinuée** — fin totale de Sora 2 |

## Accès actuel (mai 2026)

- ❌ Web `sora.com` : fermé
- ❌ App mobile : retirée des stores
- ❌ ChatGPT UI : Sora 2 retiré
- ✅ **API OpenAI** : encore active jusqu'au 24/09/2026
  - `client.videos.generate(model="sora-2", ...)` (vérifier nom exact endpoint)
  - Crédits API standard
  - Pas de waitlist

## Recommandation Mickael

| Cas | Action |
|---|---|
| Tests ponctuels d'ici 09/2026 | OK via API |
| Workflows long terme | ❌ Migrer vers Veo 3.1 |
| Cameos archivés | Conserver les clips finis (les prompts seront inutiles post-09/2026) |
| Capitalisation prompts | Porter les meilleurs vers Veo 3.1 (voir `audio_prompting_guide.md` section Migration) |

## Successeurs potentiels (rumeurs)

| Modèle | Statut mai 2026 | Probabilité de remplacer Sora 2 |
|---|---|---|
| Veo 3.1 (Google) | ✅ Disponible | **Forte** — couvre audio + image-to-video |
| Runway Gen-4 + Aleph | ✅ Disponible | Forte sur édition vidéo, pas d'audio natif |
| OpenAI "Sora 3" | ❌ Pas annoncé | Inconnue |
| Adobe Firefly Video | 🟡 Beta | Émergent, audio absent |

## Sources

- Page dépréciation OpenAI : `https://help.openai.com/en/articles/20001152-what-to-know-about-the-sora-discontinuation`
- Status API : `https://community.openai.com/t/is-the-sora2-api-still-working/1379946`
- OpenAI Status : `https://status.openai.com/`

---

*À mettre à jour si OpenAI annonce une prolongation ou un remplaçant.*
