---
id: 75
title: "Création d'un repo GitHub public dédié regroupant l'install Hermès + parcours..."
status: done
priority: P3
session_opened: S63
session_closed: S64
tags: [hermes, mcp]
source: "Session 63 / Demande Mickael + verdict mature"
---

# T#75 — Création d'un repo GitHub public dédié regroupant l'install Hermès + parcours...

## Description

**[NOUVELLE session 63 — Repo GitHub `mightIA/hermes-agent-rtx3090-cookbook`]** Création d'un repo GitHub public dédié regroupant l'install Hermès + parcours S57→S63 (5 modèles KO → audit méthodologique 2 → fix `reasoning_content`) + verdict (qwen35-agent V1 viable). **Audience** : autres utilisateurs RTX 3090 + Hermès Agent + Ollama local. **Plan en 4 étapes** : (1) structure README + Modelfile + commandes audit `git log` + tests A/B/C ; (2) caviardage URLs HA (`mcp.might.ovh`), secret_path, IPs locales, identifiants ; (3) push GitHub `mightIA` (fonction sauvegarde hors maison aussi) ; (4) référencement commits Hermès clés (`5ae60815`, `f93d4624`, `63bf7a29`, `9daa0620`) + issues Ollama compatibles. **Référence** : auto-memories S63 + archive `memory/historique/2026-04-26_session_63_audit_methodologique_2_succes.md` + idée Mickael S63 « est-ce utile de faire un GitHub ? ». **Durée estimée** : 60-90 min. **STATUT S64 (26/04/2026)** : repo public publié `https://github.com/mightIA/hermes-agent-rtx3090-cookbook` commit `de7e268` 7 fichiers 1286 lignes contenu FR caviardé License MIT. Local `Projets/Cookbook_Hermes_RTX3090/`. Caviardage 100% (triple grep zéro fuite). Voir auto-memory `reference_cookbook_hermes_repo.md` + procédure `reference_github_repo_public_init.md` + archive `memory/historique/2026-04-26_session_64_repo_cookbook_publie.md`.

## Source / Échéance

Session 63 / Demande Mickael + verdict mature

## Statut

**FAIT (S64)** + **complément S65** : `docs/publication-s64.md` 264 lignes procédure init repo public détaillée (caviardage triple grep, garde-fous email no-reply, 4 pièges P1-P4 publication) + section S64 dans `journey-s57-s63.md` + encart README "Publié sur GitHub". Commit `bc58b15` poussé sur `origin/main`
