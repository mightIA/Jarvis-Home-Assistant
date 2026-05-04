---
id: 76
title: "Retest modèles Hermès — Phase 1 Qwen 3.6 NO-GO, Phase 2/3 + modèles modernes 2026"
status: testing
priority: P3
session_opened: S63
session_phase1_closed: S98
session_reconstructed: S109
tags: [hermes, mode-reactif, modeles-llm, benchmark]
source: "Session 63 / Verdict audit méthodologique 2 — enrichi S98 — reconstruit S109 après troncature silencieuse"
---

> **ℹ État S109 (04/05/2026)** : fichier reconstruit de bout en bout après troncature silencieuse (corps coupé à 34 lignes en plein header tableau Phase 1, frontmatter intact). Cause probable : hook destructif S108 ou Edit interrompu (cf. [`memory/feedback_troncature_silencieuse_task_files.md`](../memory/feedback_troncature_silencieuse_task_files.md)). Reconstruction depuis `Projets/Cookbook_Hermes_RTX3090/tests/results.csv` + archive S98. Aucune donnée perdue (toutes les sources annexes étaient préservées). Anti-récidive ouverte en T#97 (linter `< 500 bytes` dans `rebuild_tasks_index.py`).

# T#76 — Retest modèles Hermès Agent

## Description

Évaluation continue des modèles LLM locaux sur stack Hermès Agent +
ha-mcp + RTX 3090 24 GB. Baseline `qwen35-agent` (qwen3.5:27b custom
Modelfile durci) sur 3 tests référence S63 :

| Test | Latence baseline | Description |
|------|------------------|-------------|
| A | 5m06s (306 s) | Action simple write (notification persistante) |
| B | 2m40s (160 s) | Lecture multi-sensors + comparaison sémantique |
| C | 2m57s (177 s) | Multi-step conditionnel (read + write conditionnel) |

Protocole détaillé : [`memory/reference_protocole_tests_modeles_hermes.md`](../memory/reference_protocole_tests_modeles_hermes.md)
Registre prompts canoniques : [`Projets/Cookbook_Hermes_RTX3090/tests/prompts.yaml`](../Projets/Cookbook_Hermes_RTX3090/tests/prompts.yaml)
Log résultats append-only : [`Projets/Cookbook_Hermes_RTX3090/tests/results.csv`](../Projets/Cookbook_Hermes_RTX3090/tests/results.csv)
Skill associée : [`.claude/skills/benchmark-modele-hermes/SKILL.md`](../.claude/skills/benchmark-modele-hermes/SKILL.md)

---

## Phase 1 — Qwen 3.6 (S98 04/05/2026) — NO-GO upgrade

3 variantes Qwen 3.6 testées sur Test B + Test C, après update Hermès v0.11→v0.12 (18 commits ingérés) :

| Modèle | Test B | Test C | Verdict |
|--------|-------:|-------:|---------|
| `qwen3.6:27b` brut (Hermès -18 commits) | 3m31s | — | ❌ Sémantique cassée (interprète outputs comme inputs), réponse EN |
| `qwen3.6:27b` brut (post-update Hermès) | 3m05s | — | ⚠ Sémantique OK (cite 22.12°C cuisine), mais réponse EN sans Modelfile durci |
| `qwen3.6:35b-a3b` MoE | 3m42s | — | ❌ Dump shotgun 111 entités, valeur fausse (24.7°C au lieu de 22.12°C), format ASCII non demandé |
| `qwen3.6-agent` (Modelfile copy-template depuis qwen35-agent) | 3m25s | 5m11s | ⚠ Sémantique excellente, FR sans accents, mais +28% B et **+76% C** vs baseline |

**Verdict S98 (D3-S98) : NO-GO upgrade Qwen 3.6.** `qwen35-agent` reste champion Hermès Agent. Aucune variante Qwen 3.6 ne bat la baseline sur Test B + Test C combinés malgré le Modelfile copy-template (sauce SYSTEM+params).

### Bugs / limites Qwen 3.6 notés

- **Bug encoding HTML entities** (`Je cr&e-acute;e` au lieu de `créé`) sur 1ère bulle Test C puis correct sur 2ème — à surveiller pour TTS / exports.
- **Tokenization Qwen 3.6 perd les accents FR** (« trouve » → « trouve », « entité » → « entite ») — cosmétique, non réglable via Modelfile.
- **MoE 35B-A3B** tunée coding/SWE-bench (variants `coding-mxfp8`, `nvfp4` sur Ollama), pas adaptée tool calling FR.

### Capitalisation S98 (livrables Phase 1)

- Skill [`benchmark-modele-hermes`](../.claude/skills/benchmark-modele-hermes/SKILL.md) (workflow 8 étapes, 230 lignes) — SKILLS_INDEX.md +1 = **32 actives**
- Registry tests [`prompts.yaml`](../Projets/Cookbook_Hermes_RTX3090/tests/prompts.yaml) — **8 prompts FIGÉS A→H** (status `figé` A/B/C, `à_figer` D/E/F, `planifié` G/H)
- Log append-only [`results.csv`](../Projets/Cookbook_Hermes_RTX3090/tests/results.csv) — 16 colonnes standardisées, 9 lignes initiales (3 baselines S63 + 6 mesures Qwen 3.6 S98)
- 3 auto-memories : `feedback_modelfile_copy_template_method.md`, `reference_protocole_tests_modeles_hermes.md`, `feedback_test_results_registry.md`
- Modelfile durci `qwen3.6-agent` Ollama (côté WSL2 Mickael, conservé pour investigation)

### Pièges Phase 1 documentés

| ID | Piège | Mitigation |
|----|-------|------------|
| P1-S98 | Namespace Ollama périmé (`batiai/qwen3.6-27b`) | Vérifier ollama.com/library/<nom> AVANT pull |
| P2-S98 | Hermès commits behind casse Qwen 3.x | Toujours `hermes update` avant la campagne |
| P3-S98 | Modèle brut sans Modelfile = verdict erroné | Copy-template avant de conclure NO-GO |
| P4-S98 | Conclure sur Test B latence pure | Toujours faire au moins Test C si Étage 1 ≥ 3/4 |
| P5-S98 | Cowork Write bloqué sur `.claude/skills/<nouveau>/` | Workaround `mkdir -p` + heredoc bash |
| P6-S98 | YAML quote pour les `:` dans tags Ollama | `default: 'qwen3.6:27b'` (single quotes) |
| P7-S98 | Bug encoding HTML entities Qwen 3.6 | À surveiller (TTS/exports) |
| P8-S98 | Tokenization Qwen 3.6 perd les accents FR | Cosmétique, non réglable |

---

## Phase 2 — Modèles éliminés S57/S58/S60 à retester

Quatre modèles déclarés KO en Phase 0 (S57/S58/S60), à retester avec **Modelfile copy-template + Hermès post-v0.12.0** (l'update débloque potentiellement le tool calling cassé, cf. cas qwen3:32b S57→S57 réhabilité) :

| Modèle | Verdict initial | Hypothèse retest |
|--------|-----------------|------------------|
| `mistral-nemo:12b` | Template cassé S57, OK compression | Vérifier si v0.12.0 répare le template tool calling |
| `llama3.3:70b-instruct-q3_K_M` | KO sévère S58 (>10m52s, JSON dans content) | RAM 28 GB (.wslconfig pattern) + Modelfile copy-template |
| `qwen3:32b` | Bloqué écriture HA S57, RÉHABILITÉ avec Modelfile durci | Confirmer protocole 2 étages (Test B + Test C) |
| `qwen2.5-coder:32b` | Recommandé doc Hermès, jamais testé en clair | Tag direct vs Modelfile copy-template (comparer) |

**Workflow** : skill `benchmark-modele-hermes` étapes 1→8 (identifier → pull → décision Modelfile → backup config → restart Hermès → Tests A/B/C → append CSV → tableau comparatif).

---

## Phase 3 — Modèles modernes 2026

Modèles à tester en priorité (ordre indicatif) :

| Modèle | Profil | Justification |
|--------|--------|---------------|
| **Hermes 4 70B** | Match parfait Hermès Agent | Modèle MAISON Nous Research conçu pour Hermès — voir [T#77](task_077.md) |
| **Llama 4 Maverick** | 1M tokens contexte | Pour rapports journaliers Niveau H + workflows longs |
| **Carnice MoE 35B-A3B** | Tuné Hermès | Variante MoE pensée tool calling (vs qwen3.6-35b-a3b coding) |
| **Qwen 3 8B** | Compact (~6 GB VRAM) | Baseline rapide, latence basse, étalon léger |

**Ordre conseillé** : Hermes 4 70B (objectif final stratégique) → Carnice MoE 35B-A3B → Llama 4 Maverick (RAM 28 GB requis) → Qwen 3 8B (étalon compact).

---

## Pré-requis Phase 2/3

- Hermès Agent à jour (post-v0.12.0 minimum) — `hermes update` au début si commits behind dans bannière
- Pattern `.wslconfig` **28 GB pour modèles 70B** (`memory=28GB swap=8GB` + `wsl --shutdown`) — cf. [`reference_wslconfig_28gb_pattern.md`](../memory/reference_wslconfig_28gb_pattern.md)
- WebSearch ollama.com/library/<nom> AVANT chaque pull (anti-piège namespace périmé S98)
- Modelfile copy-template depuis `qwen35-agent` comme base de test équitable
- Backup `~/.hermes/config.yaml` avant chaque swap modèle

---

## Livrables attendus

- (a) **Phase 2** : 4 modèles testés avec Modelfile copy-template, `results.csv` mis à jour, tableau comparatif Markdown
- (b) **Phase 3** : 4 modèles modernes 2026 testés, `results.csv` mis à jour, recommandation **champion** ou maintien qwen35-agent
- (c) Tests D/E/F passés du statut `à_figer` à `figé` après 1ère exécution
- (d) Tests G (tri email) + H (rapport journalier) à activer une fois blockers levés (`gmail-mcp` branché Hermès, MCP file system)
- (e) Auto-memories complétées si nouveaux apprentissages
- (f) Si nouveau champion : MAJ doc + bascule `~/.hermes/config.yaml default:`

---

## TODOs résiduels Phase 1 (S98 → futures sessions)

1. **Vérifier notif HA UI "Cuisine chaude"** pour write_success Test C qwen3.6-agent (ligne CSV 9 = `true` provisoire à confirmer)
2. **Niveau D non testé** sur qwen3.6-agent (multi-reads agrégation + write notif "Bilan thermique") — bonne candidate pour validation qualité raisonnement multi-step
3. **Rebascule config Hermès** `default: qwen35-agent` — **fait S102** (cf. [`reference_rebascule_qwen35_s100.md`](../memory/reference_rebascule_qwen35_s100.md))

---

## Liens

- Skill workflow : [`.claude/skills/benchmark-modele-hermes/SKILL.md`](../.claude/skills/benchmark-modele-hermes/SKILL.md)
- Protocole 2 étages : [`memory/reference_protocole_tests_modeles_hermes.md`](../memory/reference_protocole_tests_modeles_hermes.md)
- Prompts canoniques : [`Projets/Cookbook_Hermes_RTX3090/tests/prompts.yaml`](../Projets/Cookbook_Hermes_RTX3090/tests/prompts.yaml)
- Log results : [`Projets/Cookbook_Hermes_RTX3090/tests/results.csv`](../Projets/Cookbook_Hermes_RTX3090/tests/results.csv)
- Récit S98 complet : [`memory/historique/2026-05-04_session_98_qwen36_phase1_test_registry.md`](../memory/historique/2026-05-04_session_98_qwen36_phase1_test_registry.md)
- Tâche liée : [T#77 Modèle MAISON Nous Research conçu pour Hermès Agent](task_077.md)
- Auto-memory Qwen 3.6 sortie avril 2026 : [`memory/project_qwen36_sortie_avril_2026.md`](../memory/project_qwen36_sortie_avril_2026.md)
