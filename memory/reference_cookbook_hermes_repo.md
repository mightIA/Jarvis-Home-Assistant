---
name: Repo Cookbook Hermès RTX 3090
description: Pointeur vers github.com/mightIA/hermes-agent-rtx3090-cookbook (S64, public, MIT, FR, 1286 lignes, caviardé 100%, capitalisation S57→S63).
type: reference
---

# Repo `mightIA/hermes-agent-rtx3090-cookbook` (S64, 26/04/2026)

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

## Suite à reporter dans le repo (P3)

- Retests T#76 (modèles antérieurs post-update Hermès) + T#77 (Hermes 4 70B Q3 HuggingFace) → futurs commits dans `docs/journey-s57-s63.md` ou nouveau fichier `docs/p3-retests.md`.
- Traduction EN du repo (après vérif technique sérieuse).

## Source

S64 (26/04/2026) — voir `memory/historique/2026-04-26_session_64_repo_cookbook_publie.md`.
Procédure de création réutilisable : `memory/reference_github_repo_public_init.md`.
