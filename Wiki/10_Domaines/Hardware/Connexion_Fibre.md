---
title: Connexion fibre Mickael — vitesse réelle
created: 2026-04-27
migrated_from: memory/reference_mickael_connexion_fibre.md (auto-memory Cowork)
type: atome
domaine: Hardware
debit_mesure: 110 MB/s soutenu
tags: [hardware, reseau, fibre, debit, telechargement]
---

# Connexion fibre — vitesse de téléchargement réelle

Mickael dispose d'une **fibre ~1 Gbps quasi pleine côté débit utile**, mesurée S48 (25/04/2026) sur un pull Ollama de 20 Go en environ 3 minutes (~110 MB/s soutenu, ~880 Mbps effectifs).

## Référence pratique

| Taille | Durée réelle (~110 MB/s) | Durée à éviter de prédire |
|---|---|---|
| 1 Go | ~10 s | ~1 min |
| 5 Go | ~45 s | ~3-5 min |
| 10 Go | ~1 min 30 | ~5-10 min |
| 20 Go | ~3 min | ~10-15 min |
| 50 Go | ~7-8 min | ~30 min |
| 100 Go | ~15-16 min | ~1 h |

## Pourquoi cette fiche existe

Mickael a explicitement signalé S48 (25/04/2026) que mes estimations de téléchargement (basées sur ~30-50 MB/s par défaut) étaient grossièrement majorées. **Estimation surdimensionnée = on choisit "plus tard" alors qu'on pouvait attendre 3 min. À éviter.**

## Comment l'appliquer

- Pour tout pull / téléchargement (`ollama pull`, npm/pip install, clone Git, install système, etc.), **partir de ~100 MB/s** comme baseline.
- Mentionner la fourchette serveur si CDN saturé / lointain (ex. registry Ollama parfois ~50 MB/s aux heures pleines), donc dire « 1-3 min pour 20 Go selon CDN » plutôt que « 10-15 min ».
- Pour les très gros téléchargements (>50 Go), prévoir aussi le temps **d'écriture disque** (NVMe Samsung 970 ~3 GB/s en pic, sustained plus bas) + checksum / extraction côté Ollama qui peut prendre 30 s à 2 min après le download lui-même.
- **Ne jamais** redonner des estimations conservatrices type « 10-15 min pour 20 Go » → frustre Mickael qui aime avancer.
- Si on doit attendre un téléchargement → proposer de faire autre chose en parallèle pendant les 1-3 min réelles, pas attendre passivement.

## Liens

- [`_Index.md`](_Index.md) — MOC Hardware
- [`PC_MIGHT-1000D.md`](PC_MIGHT-1000D.md) — config PC qui exploite cette fibre
- [Cookbook Hermes RTX 3090 — README](../../15_Hermes_Agent/Cookbook_RTX3090/README.md) — pulls modèles Ollama 17-34 GB sur cette fibre
