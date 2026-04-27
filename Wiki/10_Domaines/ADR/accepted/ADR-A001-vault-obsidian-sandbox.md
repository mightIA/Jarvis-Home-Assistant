---
title: ADR-A001 — Vault Obsidian sandbox Phase 1bis-a
created: 2026-04-27
tags: [adr, accepted, obsidian, vault, architecture]
status: accepted
session_origine: S41
---

# ADR-A001 — Vault Obsidian `Wiki/` co-localisé dans le projet Jarvis

## Contexte

Phase 1bis-a (S41) : première sous-étape Hermès Agent, créer un vault Obsidian Desktop sur le PC pour préparer la couche "deuxième cerveau" (D2-S36). Question structurante : où poser le vault ? Trois options évaluées :

1. `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Wiki\` — co-localisé dans le projet
2. `D:\Might\IA\Obsidian_Vault_Jarvis\` — séparé hors projet
3. `D:\Might\OneDrive\Obsidian_Vault_Jarvis\` — sur OneDrive

## Décision

**ACCEPTÉE** le 25/04/2026 (S41). Vault posé en `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Wiki\` avec structure PARA + Karpathy LLM Wiki (préfixes numériques `00_Index/`, `10_Domaines/`, `20_Projets/`, `30_References/`, `90_Archives/`) + 4 plugins gratuits validés (Dataview / Templater / Excalidraw / Git).

## Conséquence

- **Versionnement naturel** avec le projet Jarvis (futur repo Git unique) — backup et revue diff cohérents, pas de chemin séparé à mémoriser.
- **Avertissement Obsidian** documenté : ne PAS ouvrir le dossier projet racine comme vault (1000+ fichiers skills/scripts/memory indexés = perf dégradée + confusion sémantique vault/code). Ouvrir uniquement le sous-dossier `Wiki/`.
- **Structure prête** pour Phase 1bis-d (sub-agents `wiki_*` Hermès Agent qui lisent/écrivent dans le vault).
- **Pattern méthodologique capitalisé** : sandbox vault dédiée évite la pollution du wiki par les fichiers techniques du projet (CLAUDE.md, TASKS.md, .mcp.json, etc.).

## Alternative écartée

- **`D:\Might\IA\Obsidian_Vault_Jarvis\`** (séparé hors projet) — perte de cohérence avec `Ressources/`, `memory/`, `Projets/` racine.
- **`D:\Might\OneDrive\Obsidian_Vault_Jarvis\`** — risque conflit avec Obsidian Git (2 mécanismes de sync concurrents).
- **Plugin Smart Connections payant** écarté en parallèle (voir [[ADR-007-smart-connections-payant]]).

## Source

- `memory/historique/2026-04-25_session_41_phase1bisa_obsidian.md`
- `Ressources/Competences/Obsidian.md` (doc install 185 lignes)
- Auto-memory `reference_obsidian_vault.md`
- Auto-memory `reference_obsidian_install.md`
