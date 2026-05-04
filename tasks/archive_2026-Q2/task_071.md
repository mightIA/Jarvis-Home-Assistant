---
id: 71
title: "La variable `MISTRAL_API_KEY` est présente dans `~/"
status: done
priority: P2
session_opened: S55
session_closed: S70
tags: [hermes, openrouter, brave]
source: "awk -F= '{print length($2)}'` (longueur > 0 = clé présente), (b) si clé active : aller dans `console.mistral.ai/api-keys` côté Brave, lister les clés, révoquer celle utilisée Phase 1bis-c S48 (test OC"
---

# T#71 — La variable `MISTRAL_API_KEY` est présente dans `~/

## Description

**[NOUVELLE session 55 — auditer MISTRAL_API_KEY dans .env Hermès + révoquer si actif]** La variable `MISTRAL_API_KEY` est présente dans `~/.hermes/.env` (constatée S55 lors de l'injection OpenRouter). Valeur jamais affichée. Compte Mistral Scale résilié S55, donc une clé API encore active = surface d'attaque inutile. **Étapes** : (a) vérifier si la valeur est non-vide via `grep '^MISTRAL_API_KEY=' ~/.hermes/.env

## Source / Échéance

awk -F= '{print length($2)}'` (longueur > 0 = clé présente), (b) si clé active : aller dans `console.mistral.ai/api-keys` côté Brave, lister les clés, révoquer celle utilisée Phase 1bis-c S48 (test OCR REST 5s 124 584 chars), (c) après révocation : nettoyer la ligne dans `.env` via `sed -i '/^MISTRAL_API_KEY=/d' ~/.hermes/.env` ou la laisser vide selon convention Hermès, (d) backup `.env.bak-pre-mistral-revoke` avant modif. **Durée estimée** : ~10 min. **Référence connexe** : S48 archive Phase 1bis-c, T#70 suppression carte Mistral, S55 archive.

## Statut

Session 55 / Hygiène sécu post-résiliation Mistral | **FAIT S70 (27/04/2026, ~10 min)** — Audit lecture seule confirme `MISTRAL_API_KEY` présente dans `~/.hermes/.env` (1 ligne, droits `-rw-------` 600 OK, taille fichier 19170 bytes). Console Mistral vérifiée côté Brave : **0 clé active + 0 plan actif** → la clé locale était déjà orpheline depuis longtemps (côté serveur déjà neutralisée, surface d'attaque déjà nulle). Cleanup `.env` via `sed -i '/^MISTRAL_API_KEY=/d'` côté Ubuntu (bash) : ligne supprimée (`grep -c ^MISTRAL_API_KEY` 1→0), backup `.env.bak.s70-mistral-removal` (19170 bytes), `.env` final 19121 bytes (-49 bytes). Aucun script/skill/daemon/scheduled task n'utilisait la clé (grep transverse projet 0 hit actif hors mentions documentaires Hermes_Agent). Si Phase 1bis-d `wiki_ingestor` demande Mistral OCR plus tard → regen clé fraîche en 30s côté `console.mistral.ai/api-keys/`. Auto-memory `feedback_terminologie_ubuntu.md` créée S70 pendant cette tâche (préférence "Ubuntu" vs "WSL2").
