---
name: Pas de plugin payant Obsidian
description: Règle Phase 1bis-a — ne PAS prendre le plugin de vectorisation propriétaire payant d'Obsidian. Hermes Agent + Qwen 3 Embedding 4B local sur RTX 3090 fait mieux gratuitement.
type: feedback
---

# Règle : pas de plugin payant Obsidian dans la stack Jarvis-Hermès

**Énoncé** : lors de l'install Obsidian Desktop (Phase 1bis-a, TASKS #58), **ne pas activer
ni acheter** le plugin propriétaire de vectorisation d'Obsidian. Privilégier Qwen 3 Embedding
4B en local via Ollama (Phase 1bis-c).

**Why** :
- La vidéo ParlonsIA (S38, 25/04/2026) a soulevé l'argument suivant : "le plugin officiel de
  vectorisation Obsidian est payant + facture la vectorisation à l'usage". Soupçon non
  démontré que ce serait l'objectif marketing du buzz Karpathy/Obsidian (spéculation à
  écarter, mais le plugin payant existe bien)
- Sur ta RTX 3090 24 Go (config validée S36), Qwen 3 Embedding 4B tourne sur 3 Go VRAM avec
  ~600 Mo / 100 000 chunks indexés — couvre largement un vault Jarvis prévisible
- Hermes Agent (D4 stack S36) supporte nativement les modèles d'embedding via Ollama, donc
  pas besoin d'une couche Obsidian payante
- Cohérence financière : la stack S36 vise -70-90% tokens Claude via Hermès, ajouter un
  abonnement Obsidian payant en plus contredit l'objectif

**How to apply** :
- Phase 1bis-a (install Obsidian) : **uniquement** plugins gratuits (Dataview, Templater,
  Excalidraw, Obsidian Git pour versionner le vault)
- Phase 1bis-c (install Hermès + Ollama) : télécharger Qwen 3 Embedding 4B explicitement
  (`ollama pull qwen3-embedding:4b` ou équivalent)
- Phase 1bis-d (config sub-agents) : `wiki_librarian` utilise le modèle d'embedding local via
  l'API Ollama, **pas** via l'API du plugin Obsidian
- Si plus tard Mickael envisage tout de même le plugin payant : refaire le calcul comparatif
  (coût mensuel plugin vs charge GPU locale + élec) avant d'acheter

**Exception possible** : si Hermès s'avère ingérable et qu'on revient à un setup Claude Code
+ Obsidian pur, le plugin pourrait redevenir une option à évaluer. Mais à ce stade (S38),
écarté par défaut.

---

*Posée S38 (25/04/2026) suite analyse vidéo ParlonsIA + cohérence stack Hermès D4 S36.*
