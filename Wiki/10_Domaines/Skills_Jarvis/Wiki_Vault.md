---
title: Skills Wiki Vault — sub-agents (placeholder)
created: 2026-04-27
tags: [skill, wiki, sub-agent, placeholder, phase-1bis-d]
status: planifie
domaine: Skills_Jarvis
---

# Skills Wiki Vault — sub-agents (placeholder)

> **Statut** : placeholder. **Aucune skill encore créée**. Cette catégorie réserve la place pour les futurs sub-agents Hermès Agent prévus en **Phase 1bis-d** (post-Hardware T#73).

## Contexte

Le vault Obsidian (`Wiki/`) a été initialisé S41 (Phase 1bis-a) avec 4 plugins gratuits (Dataview, Templater, Excalidraw, Git) et la structure PARA. Cf. auto-memory `reference_obsidian_phase1bisa`.

Phase 1bis-d planifie 3 sub-agents Hermès Agent dédiés à l'exploitation du vault, configurés via `~/.hermes/hermes-agent/AGENTS.md` (équivalent `CLAUDE.md` côté Hermès) :

## Sub-agents prévus

### `wiki_ingestor` *(à créer)*

- **Rôle prévu** : ingestion de nouvelles notes dans le vault (capture web, fragments de conv Cowork, exports Hermès, OCR Mistral, etc.). Normalisation YAML frontmatter + tags + classement PARA (00..40).
- **Déclencheur prévu** : "ingère X dans le wiki", batch d'ingestion programmée, hook de fin de session.
- **Dépendances pressenties** :
  - Hermès Agent v0.11.0+
  - Sub-agent context fork (AGENTS.md)
  - Modèle Ollama compatible tool calling fiable (`qwen3:32b` Modelfile durci validé S57, ou OpenRouter Haiku 4.5 fallback)
  - Templates Templater dans `Wiki/_templates/`

### `wiki_librarian` *(à créer)*

- **Rôle prévu** : maintenance du vault — détection doublons, refactoring de hubs, mise à jour des MOC `_Index.md`, vérification de la cohérence des `[[wikilinks]]`, archivage trimestriel.
- **Déclencheur prévu** : "fais le ménage du wiki", cron mensuel, après gros batch d'ingestion.
- **Dépendances pressenties** :
  - Hermès Agent + sub-agent context fork
  - Plugin Obsidian Dataview (requêtes structurelles)
  - Modèle Ollama avec contexte étendu (>= 64K) pour traitement par lot

### `wiki_query` *(à créer)*

- **Rôle prévu** : interface de question/réponse sur le vault. Recherche sémantique + contexte enrichi par les liens, retour formaté avec sources `[[note]]`.
- **Déclencheur prévu** : "demande au wiki X", question de Mickael nécessitant connaissance privée non triviale.
- **Dépendances pressenties** :
  - Hermès Agent + sub-agent context fork
  - Embeddings locaux (à choisir : `nomic-embed-text` ou équivalent Ollama)
  - Index sémantique du vault (à construire en Phase 1bis-d)
  - Modèle Ollama tool calling pour orchestration des recherches

## Pré-requis avant création

- ✅ Vault initialisé (S41, Phase 1bis-a)
- ✅ Hermès Agent installé + configuré (S48, Phase 1bis-c)
- ✅ Modèle Qwen3:32b durci validé tool calling (S57)
- ⏳ Hardware upgrade Proxmox + Ryzen (T#73, Phase A→G — bloquant pour vrai serveur Hermès dédié)
- ⏳ AGENTS.md sub-agent pattern documenté (à valider en Phase 1bis-d)
- ⏳ Embeddings locaux choisis et benchmarkés
- ⏳ Index sémantique du vault construit (probablement via plugin Obsidian + cron)

## Voir aussi

- [[_Index]] — MOC Skills Jarvis
- [[Wiki/10_Domaines/Hermes_Agent/_Index]] — domaine Hermès Agent (T#4)
- [[Wiki/10_Domaines/Hardware/_Index]] — domaine Hardware (T#3, projet upgrade Proxmox + Ryzen)
- Auto-memory `reference_obsidian_phase1bisa` — vault initialisé Phase 1bis-a
- Auto-memory `reference_modelfile_qwen3_durci` — Modelfile durci tool calling validé S57
- Skill `hermes-agent` (`.claude/skills/hermes-agent/SKILL.md`) — déjà existante, couvre la stack Hermès actuelle
