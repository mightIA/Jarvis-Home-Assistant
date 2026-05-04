---
name: Repo Cookbook Hermès RTX 3090
description: Pointeur vers github.com/mightIA/hermes-agent-rtx3090-cookbook (S64 init public MIT FR 1286 lignes ; S108 ajout registry tests benchmarks Hermès — 8 tests A→H + results.csv 7 lignes).
type: reference
last_update: 2026-05-04 (S108 — registry tests benchmarks Hermès ajouté)
---

# Repo `mightIA/hermes-agent-rtx3090-cookbook` (S64 + S108)

**URL** : https://github.com/mightIA/hermes-agent-rtx3090-cookbook

## État au 26/04/2026 (commit `de7e268`)

- Public, License MIT, branche `main`, langue **FR** (traduction EN reportée).
- 7 fichiers, 1286 lignes ajoutées (1 root-commit).
- Local : `Projets/Cookbook_Hermes_RTX3090/` synchronisé avec `origin/main`.

## Contenu

| Fichier | Lignes | Sujet |
|---|---|---|
| `README.md` | 116 | TL;DR, audience, stack, latences, démarrage rapide |
| `LICENSE` | 21 | MIT 2026 mightIA |
| `.gitignore` | 25 | Standard + protections sensibles |
| `docs/audit-methodologique.md` | 147 | Pattern 6 phases + heuristique stop + hiérarchie patterns N1/N2/N3 |
| `docs/troubleshooting.md` | 379 | 9 symptômes Hermès + causes racines + fixes validés |
| `docs/configs.md` | 316 | 6 configs reproductibles (Modelfile, `.hermes/config.yaml`, `.wslconfig`, ha-mcp) |
| `docs/journey-s57-s63.md` | 282 | Récit chronologique 7 sessions |

## Caviardage (vérifié triple grep S64)

**Patterns retirés** : domaines `*.might.ovh`, IPs `192.168.x.x`, secret_path, emails Mickaël, prénom, lieu (Seremange-Erzange), hostname (`MIGHT-1000D`), paths WSL2 (`/home/might/`), tokens, hashes blob, session IDs Hermès.

**Patterns conservés (publics)** : commits Hermès, versions (`v0.11.0`), modèles Ollama (`qwen3.5:27b`), hardware générique (RTX 3090, i9-9900K, 32 GB), latences mesurées, numéros d'issues Ollama publiques.

## État au 04/05/2026 (commit `9007fe4`, S108)

**+1 dossier ajouté** : `tests/` (registry benchmarks Hermès).

| Fichier | Lignes | Sujet |
|---|---|---|
| `tests/prompts.yaml` | 178 | 8 prompts canoniques figés (Test_A→H, étages 1/2/3) avec baselines qwen35-agent S63 + variables substituables (`${MODEL_NAME}`, `${GMAIL_ACCOUNT}`) |
| `tests/results.csv` | 9 (1 header + 7 résultats) | Registry append-only 16 colonnes (date, session, test_id, model, hermes_version, latency_seconds, semantic_score, etc.) |

**Caviardage S108** : `might57290@gmail.com` → variable `${GMAIL_ACCOUNT}` documentée dans `prompt_variables` (cohérent pattern Test_A `${MODEL_NAME}`).

## Suite à reporter dans le repo (P3)

- Retests T#76 Phase 2/3 (modèles modernes 2026) → enrichir `tests/results.csv` au fil de l'eau.
- T#77 (Hermes 4 70B Q3 HuggingFace) → futurs commits dans `docs/journey-s57-s63.md` ou nouveau fichier `docs/p3-retests.md`.
- Traduction EN du repo (après vérif technique sérieuse).

## Source

- S64 (26/04/2026) init public — voir `memory/historique/2026-04-26_session_64_repo_cookbook_publie.md`.
- S108 (04/05/2026) registry tests — voir `memory/historique/2026-05-04_session_108_ccusage_hook_destructif_t96_push_massif.md`.
- Procédure de création réutilisable : `memory/reference_github_repo_public_init.md`.
