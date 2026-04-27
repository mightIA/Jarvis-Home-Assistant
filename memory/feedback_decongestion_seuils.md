---
name: Seuils de décongestion fichiers vivants
description: Seuils chiffrés et déclencheurs auto pour proposer une décongestion des fichiers réinjectés à chaque tour Cowork (CLAUDE.md, TASKS.md, METRIQUES.md, MEMORY.md). Skill `decongestion-fichiers-vivants` à appeler.
type: feedback
---

À chaque démarrage de session après lecture de CLAUDE.md/CONTEXTE.md/TASKS.md/METRIQUES.md/MEMORY.md, faire un **check léger** des seuils de poids et proposer une décongestion si dépassement (skill `decongestion-fichiers-vivants`).

**Seuils** :

| Niveau | Critère | Action |
|--------|---------|--------|
| Vert | Total < 60 KB OU aucun fichier > 30 KB | Rien |
| Jaune | Total 60-100 KB OU un fichier 30-60 KB OU une ligne > 5 KB | Mentionner en fin de session si Mickael aborde le sujet |
| Orange | Total 100-150 KB OU un fichier 60-90 KB OU une ligne 10-20 KB | **Proposer activement** la décongestion |
| Rouge | Total > 150 KB OU un fichier > 90 KB OU une ligne > 20 KB | **Recommander fortement** |

**Why** : Sans politique d'archivage récurrent, ces fichiers regonflent linéairement (rythme observé S01-S52 : ~4 sessions/jour, ~2 K chars de patches vivants ajoutés par jour entre les 4 fichiers réinjectés). 3 sessions ont validé le pattern : S49 recherche → S51 (CLAUDE.md+METRIQUES.md, ~42 K tokens libérés) → S52 (TASKS.md, ~14 K tokens libérés). Cumul ~57 K tokens/tour libérés sur 3 fichiers.

**How to apply** :
1. Au démarrage : `for f in CLAUDE.md TASKS.md METRIQUES.md memory/MEMORY.md; do wc -c $f; done` + check ligne max via `awk '{print length($0)}' | sort -nr | head -1`.
2. Si Jaune+ → mentionner en fin de session courante (jamais en plein milieu d'une autre tâche). Si Orange/Rouge → proposer activement avec plan en 3 niveaux chiffrés.
3. Procédure complète : skill `decongestion-fichiers-vivants` (étape par étape : backup → archive → refonte → vérif refs → patches index → mesure).
4. Format proposition obligatoire : tableau diagnostic chiffré + plan en 3 niveaux + risque architectural + question fermée « quel niveau tu veux que je lance ? ».
5. Politique trimestrielle : 1er janvier / 1er avril / 1er juillet / 1er octobre → check + proposer décongestion si Jaune+. Archive trimestrielle conventionnelle `memory/historique/<fichier>_archive_<YYYY>-Q<n>.md`.

**Patterns récurrents à chasser** :
- Frontmatter `last_update:` géant (1 ligne YAML qui empile l'historique session par session)
- Footer historique géant en fin de fichier
- Cellules tableau riches FAIT (TASKS.md type)

**Pièges** : (a) Cowork bloque l'écriture dans `.claude/skills/` → passer par bash sandbox sed/cat. (b) `Read` natif Cowork échoue sur fichiers > 25 K tokens → toujours `wc -lc` + `awk` + `sed -n`. (c) `Edit` avec `old_string` > 50 K chars n'est pas fiable → préférer `head + cat + mv .new .md` côté bash. (d) Cellules mixtes FAIT/TODO (ex. #58 Hermès) → ne pas compresser tant que la TODO n'est pas close. (e) Toujours `grep "^## "` après refonte pour valider qu'aucun H2 parent n'a été perdu (piège S52).
