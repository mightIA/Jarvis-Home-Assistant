# Agent G — Audit Cohérence Projets et Décisions

**Date** : 2026-04-28
**Périmètre** : ADR + Veille + Skills_Jarvis + Hermes_Agent + Hardware_Upgrade + AI_Prompt_Design

## Verdict Global

**État : BON — cohérence établie, dettes documentaires mineures.**

## Section 1 — ADR : contradictions internes

- **3 ADR accepted** (A001 vault, A002 add-on ha-mcp, A003 RTX 3090 suffisant) s'articulent logiquement
- **7 ADR rejected** justifient les accepted (ex. tool calling Ollama cassé S58 → ADR-A003 « RTX 3090 suffisant car le problème était Hermès, pas le GPU »)
- **Contradiction mineure** : les rejets ADR-002 (S15-S60) et ADR-003 (S60) antérieurs au verdict A003 (S63) ne sont pas explicitement cross-référencés depuis A003.
- **Recommandation** : ajouter section « Leçons des rejets » dans `ADR-A003-rtx3090-suffisant-hermes.md` pointant vers les ADR-002/003 rejected.

## Section 2 — Veille : cohérence modèles/providers

- `Landscape_LLM_2026.md`, `Modeles_LLM_A_Tester.md`, `Provider_Benchmarks.md` convergent sur **qwen3.5:27b Q5** comme baseline validée post-S63.
- Cohérence horizontale : 100%.
- **Détection** : qwen2.5:32b (recommandé Hermès officiellement) jamais testé en principal. Ouverture d'une future tâche de retest post-update mémoire.

## Section 3 — Skills_Jarvis : wikilinks cassés

- 27 skills documentées dans `_Index.md` correspondent à la structure réelle.
- **1 wikilink cassée détectée par G** : `[[Wiki/10_Domaines/Hermes_Agent/_Index]]` → doit être `[[15_Hermes_Agent/_Index]]` (préfixe `Wiki/` superflu).
- **Note vs Agent A** : Agent A a relevé 9 wikilinks cassées dans `Skills_Jarvis/*` toutes liées au préfixe `Wiki/` superflu — Agent G ne mentionne qu'une seule occurrence : la liste exhaustive est dans `01_Agent_A_Liens_Orphelins.md`.

## Section 4 — Hermes_Agent : phases et décisions

- `01_Rapport_Phase1.md` (vision S36) + `02_Plan_Phase1bis.md` (phasage) + `03_Decision_Q1-Q8.md` (4 décisions Mickaël) : **entièrement cohérents**.
- Annotations post-S68 reflètent l'avancement réel :
  - Phase 1bis-a (vault) : OK S41
  - Phase 1bis-b (Mistral OCR) : OK S46
  - Phase 1bis-c (stack hybride) : OK S48
  - Phase 1bis-d β1 (enable_tool_search) : OK S53
  - Phase 3 (sub-agents wiki_*) : T#11 en attente
- **Cookbook RTX3090** (5 docs) : 100% aligné avec ADR-A003.

## Section 5 — Hardware_Upgrade : changement contextuel

- **Files 00/01/02/03** : cohérence interne excellente (décisions Mickaël S55 reproduites dans phasage)
- **File 08_Audit_S63** : ré-évaluation post-S63 (verdict RTX 3090 suffisant invalide la justification « Ryzen 7950X pour LLM 70B local »). Correctement documenté MAIS crée une dette : **les fichiers 02 et 03 ne renvoient pas vers 08**.
- **Phase A (pré-requis Hermès)** : déjà validée S63 mais présentée comme checklist future dans `03_Phasage_A_a_G.md` → rectification requise.
- `05_Onduleurs_NUT.md` cohérent avec `Hardware/Onduleurs_APC.md` : OK.

## Section 6 — Datation périmée

- Aucune référence périmée présentée comme actuelle.
- Toutes les sessions mentionnées (S36-S63) sont contemporaines et contextuellement appropriées.
- Aucun « as of S<N> » trompeur.

## Section 7 — AI_Prompt_Design

- Statut : opérationnel, en attente du premier brief Mickaël.
- Structure claire : `INDEX.md` pointeur vers `Projets/AI_Prompt_Design/` (pas de copie pour éviter le drift fichiers vivants).
- **Verdict** : sain.

## Section 8 — Cohérence cross-domaine

- **Skills_Jarvis ↔ ADR** : ADR-A002 (add-on ha-mcp) cohérent avec skill `Home_Assistant_Operations`.
- **Veille ↔ ADR rejected** : benchmarks providers + landscape LLM justifient correctement les rejets ADR-002/003/004/005.

## Section 9 — Recommandations

| Priorité | Action |
|----------|--------|
| P2 | Ajouter section « Leçons des rejets » dans ADR-A003 |
| P2 | Ajouter note dans Hardware_Upgrade/02 et /03 renvoyant à 08_Audit_S63 |
| P2 | Marquer Phase A « VALIDÉE S63 » dans `03_Phasage_A_a_G.md` |
| P1 | Corriger les 9 wikilinks cassées Skills_Jarvis (préfixe `Wiki/` superflu) — voir Agent A |
| P3 | Mettre à jour auto-memory `project_hardware_upgrade.md` (contexte S63) |
| P3 | Ouvrir tâche retest qwen2.5:32b en principal |

## Bloqueurs Actuels

- **D4** (priorité migration skills Phase 3) : en attente Mickaël (dépend T#11 patterns sensibles ha-mcp)
- **BoM variantes hardware** (V1/V2/V3) : arbitrage Mickaël post-S63 ré-évaluation

---

*Source : sortie Agent G sous-agent Explore — vague 2 audit S72 (rapport reconstitué à partir du résumé retourné, l'agent n'ayant pas écrit le fichier directement)*
