---
id: 93
title: "Bug hook check-secrets.sh — chemins Windows avec espaces"
status: open
priority: P3
session_opened: S95
tags: [hooks, security, bash, windows, paths]
source: "Session 95 / Découvert pendant test T#34 piste (a)"
---

# T#93 — Bug hook `check-secrets.sh` — chemins Windows avec espaces

## Description

Le hook PreToolUse `.claude/hooks/check-secrets.sh` (créé S72, voir `memory/reference_hooks_securite_p2.md`) émet une erreur silencieuse à chaque action Bash quand le projet Jarvis est ouvert sur un chemin Windows contenant des espaces (`D:\Might\IA\Projets Cowork\Jarvis - Home Assistant`). Symptôme observé S95 lors du test interactif claude CLI sur la skill `ha-logs-archive` :

```
PreToolUse:Bash hook error
⎿  Failed with non-blocking status code: bash: /d/Might/IA/Projets: No such file or directory
```

Erreur **non-bloquante** (claude continue son travail), mais :
- Pollue stdout claude à chaque appel d'outil Bash
- Peut masquer d'autres erreurs vraies dans les logs
- Peut faire douter Mickael qu'un truc cloche dans la skill alors que c'est juste le hook

## Cause technique

Le hook utilise une variable de path projet (`$CLAUDE_PROJECT_DIR` ou `$PWD` — à confirmer en lecture du fichier) sans la quoter. Git Bash convertit `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant` en `/d/Might/IA/Projets Cowork/Jarvis - Home Assistant` correctement, mais bash sans quotes lit jusqu'au premier espace : `/d/Might/IA/Projets:` → No such file or directory.

## Plan de résolution

1. **Lire** `.claude/hooks/check-secrets.sh` et identifier les variables de path
2. **Identifier** toutes les utilisations non-quotées : `$VAR` au lieu de `"$VAR"`
3. **Corriger** par quoting systématique : `"$VAR"`, `[ -f "$VAR/..." ]`, etc.
4. **Tester** :
   - Reproduire le bug avant correction (lancer une skill quelconque qui invoque Bash, observer le message d'erreur)
   - Appliquer le patch
   - Re-tester pareil, vérifier que le message d'erreur disparaît
   - Vérifier que les 14/14 tests originaux du hook (S72) passent toujours
5. **Documenter** dans `memory/reference_hooks_securite_p2.md` (note du fix S96)

## Source / Échéance

Découvert S95 (03/05/2026 22h15) pendant test interactif claude CLI sur la skill ha-logs-archive (voir `memory/feedback_check_secrets_hook_chemins_windows.md`). Pas urgent (non-bloquant), à traiter quand l'occasion se présente.

## Statut

🟢 `open` — bug identifié, plan de résolution rédigé, en attente d'une session sans urgence pour corriger.
