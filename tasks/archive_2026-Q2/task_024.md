---
id: 24
title: "Calibrer la valeur `LIMITE_OBSERVEE` dans `guidage-photo-etape/SKILL"
status: cancelled
priority: P2
session_opened: S12
session_closed: S84
source: "Session 12 / Skill guidage-photo"
---

# T#24 — Calibrer la valeur `LIMITE_OBSERVEE` dans `guidage-photo-etape/SKILL

## Description

**[NOUVELLE]** Calibrer la valeur `LIMITE_OBSERVEE` dans `guidage-photo-etape/SKILL.md` + memoire `feedback_anticipation_limite_images.md`. **Décision S29 (22/04/2026)** : on se limite à **1 seul compteur calibré en 4K** (résolution par défaut des captures Mickael). Valeur provisoire : ~25 captures (à affiner lors d'une session 4K saturée). La résolution influence nettement la consommation de tokens — calibrer 4K uniquement simplifie le skill.

## Source / Échéance

Session 12 / Skill guidage-photo

## Statut

❌ **Cancelled — S84 (02/05/2026)**.

Raison : la skill `guidage-photo-etape` (ainsi que sa skill compagnon
`bascule-conversation`) ont été **supprimées** en S84. Ces 2 skills étaient
conçues pour le mode iPhone à captures saturées, devenu marginal depuis
l'instauration du mode PC permanent (CLAUDE.md §4 RÈGLE PRINCIPALE, S24).
Calibration sans objet — il n'y a plus de skill à calibrer.

**Fichiers nettoyés en S84** :
- Skills : `.claude/skills/guidage-photo-etape/`, `.claude/skills/bascule-conversation/` → supprimées (PowerShell Mickael)
- Index : `memory/SKILLS_INDEX.md` (32 → 30), `CLAUDE.md` §5 (compteur)
- Vault Obsidian : `Wiki/10_Domaines/Outils/_Index.md`, `Wiki/10_Domaines/Procedures/_Index.md`, `Wiki/10_Domaines/Skills_Jarvis/_Index.md`, `Wiki/10_Domaines/Skills_Jarvis/Workflow_Communication.md`, `Wiki/10_Domaines/Inventaire/_Index.md` (références retirées)
- Fichiers vault à supprimer (PowerShell Mickael) : `Outils/Guidage photo etape.md`, `Outils/Bascule conversation.md`, `Procedures/Bascule Conversation Limite Contexte.md`
- À éditer manuellement (PowerShell Mickael) : `.claude/skills/cloudflare-access-ha/SKILL.md` (chaînage retiré, edit Cowork bloqué)

**Substituts pour les usages historiques** :
- Mode pas-à-pas → règle CLAUDE.md §4 « RÈGLE PAS-À-PAS » (S53).
- Limite contexte conversation → `/compact` ou nouvelle conv (auto-memory `feedback_compact_vs_bascule_proposition`).
