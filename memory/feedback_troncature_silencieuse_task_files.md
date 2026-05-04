---
name: Troncature silencieuse fichiers tasks/*.md — détection + reconstruction
description: Pattern de détection et reconstruction d'un fichier tasks/task_NNN.md tronqué, et garde-fou à ajouter au script rebuild_tasks_index.py
type: feedback
---

Un fichier `tasks/task_NNN.md` peut être tronqué silencieusement (frontmatter intact + corps coupé en plein milieu d'une ligne) sans qu'aucune skill ou script de l'arborescence Jarvis ne s'en aperçoive. Cas observé S109 sur `tasks/task_076.md` (34 lignes au lieu d'environ 130, coupé sur "| Modèle | Test B | Test C | Verdi" en plein header de tableau Phase 1).

**Why:** la skill `regen-tasks-index` ne LIT que le frontmatter pour produire `TASKS.md` — elle ne contrôle ni la longueur du corps ni la cohérence interne. Le frontmatter restant valide, le fichier passe inaperçu dans la régénération. Cause probable de la troncature S109 : hook destructif `check-secrets.sh` lors d'un push massif S108 (328 fichiers) ou interruption Cowork pendant un Edit en streaming.

**How to apply:**

1. **Détection systématique** : si `wc -l tasks/task_NNN.md` < 30 OU `wc -c tasks/task_NNN.md` < 500 bytes pour une tâche complexe (status `testing` ou `in_progress`), lever un warning avant toute opération.

2. **Reconstruction** : les sources à lire dans l'ordre pour reconstruire :
   - `memory/historique/AAAA-MM-JJ_session_NN_*.md` (récit chronologique de la session de clôture/enrichissement)
   - `Projets/<projet>/tests/*.csv` ou `*.yaml` si test/benchmark associé (chiffres exacts append-only)
   - `.claude/skills/<skill_associée>/SKILL.md` (workflow capitalisé)
   - `memory/reference_*` thématiques (protocoles)
   - Frontmatter actuel du fichier tronqué (à conserver intégralement) + ajout `session_reconstructed: SNNN`

3. **Anti-récidive** : ajouter au script `rebuild_tasks_index.py` un check de longueur minimum (warning si < 500 bytes) — détecterait les futures troncatures lors de la prochaine régénération `TASKS.md`. Tâche à ouvrir si pas déjà fait.

4. **Investigation cause** : vérifier `git log --oneline -- tasks/task_NNN.md` après l'incident pour identifier le commit fautif. Si le commit était un push massif (>100 fichiers), suspecter le hook `check-secrets.sh` (cf. S108) ou une interruption Cowork. Si commit ciblé sur le fichier, suspecter Edit interrompu.

**Diagnostic confirmé S109 sur task_076.md** : `git log --oneline -- tasks/task_076.md` retourne UN seul commit (`971d838` chore S108 catch-up massif 328 fichiers). Le fichier a été ajouté à Git pour la première fois DÉJÀ tronqué dans le push S108 — aucune version intermédiaire à restaurer. La troncature s'est produite entre fin S98 (fichier complet local) et le commit S108 (même date, push massif). Cohérent avec un hook destructif déclenché juste avant le commit.
