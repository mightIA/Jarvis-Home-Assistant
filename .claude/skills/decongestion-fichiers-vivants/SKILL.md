---
name: decongestion-fichiers-vivants
description: Mesure les fichiers réinjectés à chaque tour Cowork (CLAUDE.md, TASKS.md, METRIQUES.md, memory/MEMORY.md) et propose à Mickael une décongestion structurée quand un seuil de poids/lignes/ligne unique est dépassé. Applique le pattern "pointer, don't embed" établi S49→S52 (déplacer le contenu inerte vers memory/historique/, garder seulement les TODO/règles vivantes + 1 ligne pointeur). À déclencher : (a) automatiquement en début de session après lecture des 5 fichiers d'amorçage, (b) quand Mickael évoque la lenteur/coût des sessions, (c) après ajout d'une grosse cellule TASKS.md ou d'un patch CLAUDE.md/METRIQUES.md.
---

# Skill : Décongestion des fichiers vivants

## Quand cette skill est déclenchée

- **Automatique en début de session** : après la lecture standard
  (`CLAUDE.md`, `CONTEXTE.md`, `TASKS.md`, `METRIQUES.md`, `memory/MEMORY.md`),
  faire un check léger des seuils. Si un seuil est dépassé : proposer
  une décongestion en fin de session courante (jamais en plein milieu
  d'une autre tâche).
- **Sur déclenchement Mickael** : « ça rame », « ça coûte cher en tokens »,
  « le projet devient lourd », « est-ce qu'on devrait nettoyer ? ».
- **Après modification importante** : ajout d'une cellule riche dans
  `TASKS.md` (≥ 3 K chars), patch de plusieurs sessions dans le frontmatter
  `last_update:` ou le footer CLAUDE.md, ajout de plusieurs auto-memories
  d'un coup.

## Pourquoi cette skill existe

Trois sessions ont validé le pattern (S49 recherche → S51 application
CLAUDE.md+METRIQUES.md → S52 application TASKS.md) :

| Session | Fichier | Avant | Après | Tokens libérés/tour |
|---------|---------|-------|-------|---------------------|
| S51 | `CLAUDE.md` | 124 KB | 12 KB | ~28 K |
| S51 | `METRIQUES.md` | 97 KB | 40 KB | ~14 K |
| S52 | `TASKS.md` | 124 KB | 66 KB | ~14 K |
| **Cumul** | **3 fichiers** | **345 KB** | **118 KB** | **~57 K** |

Sans politique d'archivage récurrent, ces fichiers regonflent linéairement
(rythme observé S01-S52 : ~4 sessions/jour, ~2 K chars de patches vivants
ajoutés par jour entre les 4 fichiers réinjectés).

## Seuils de déclenchement

| Niveau | Critère | Action |
|--------|---------|--------|
| **Vert** | Total < 60 KB combiné OU aucun fichier > 30 KB | Rien à faire |
| **Jaune** | Total 60-100 KB OU un fichier 30-60 KB OU une ligne unique > 5 KB | Mentionner en fin de session, proposer si Mickael aborde le sujet |
| **Orange** | Total 100-150 KB OU un fichier 60-90 KB OU une ligne unique 10-20 KB | **Proposer activement** la décongestion en fin de session |
| **Rouge** | Total > 150 KB OU un fichier > 90 KB OU une ligne unique > 20 KB | **Recommander fortement** (impact tokens/tour mesurable) |

## Procédure de mesure (1 commande Bash)

```bash
cd "/sessions/cool-charming-tesla/mnt/Jarvis - Home Assistant"
echo "=== Fichiers réinjectés à chaque tour Cowork ==="
for f in CLAUDE.md TASKS.md METRIQUES.md memory/MEMORY.md; do
  if [ -f "$f" ]; then
    SIZE=$(wc -c < "$f")
    LINES=$(wc -l < "$f")
    MAX_LINE=$(awk '{print length($0)}' "$f" | sort -nr | head -1)
    MAX_LINE_NUM=$(awk '{print length($0), NR}' "$f" | sort -nr | head -1 | awk '{print $2}')
    printf "%-25s : %6d chars / %4d lignes / ligne max L%-3d %d chars\n" \
      "$f" "$SIZE" "$LINES" "$MAX_LINE_NUM" "$MAX_LINE"
  fi
done
echo ""
TOTAL=$(cat CLAUDE.md TASKS.md METRIQUES.md memory/MEMORY.md 2>/dev/null | wc -c)
echo "TOTAL combiné : $TOTAL chars (~$((TOTAL / 4)) tokens/tour)"
```

## Procédure de décongestion (méthodologie validée S51-S52)

### Étape 1 — Backup local (obligatoire avant toute refonte)

```bash
mkdir -p memory/_decongestion_backup_sNN
cp CLAUDE.md memory/_decongestion_backup_sNN/CLAUDE.md.bak.sNN
cp TASKS.md memory/_decongestion_backup_sNN/TASKS.md.bak.sNN
cp METRIQUES.md memory/_decongestion_backup_sNN/METRIQUES.md.bak.sNN
```

Le backup est local (pas de Git) — cohérent avec auto-memory
`feedback_git_sandbox_cowork_bloque`. Rollback trivial : `cp ... .bak.sNN .md`.

### Étape 2 — Identifier les zones à décongestionner

3 patterns récurrents :

1. **Frontmatter `last_update:` géant** (1 ligne YAML qui empile l'historique
   de toutes les sessions). Pattern : `awk 'NR==3{print length($0)}'`. Si
   > 10 K chars → compresser en 1 ligne courte avec pointeur archive.
2. **Footer historique géant** (CLAUDE.md L225 type). Pattern : dernière
   ligne du fichier qui contient l'historique de toutes les versions.
   Si > 10 K chars → compresser à 5 lignes pointeur.
3. **Cellules tableau riches FAIT** (TASKS.md). Pattern : cellule contenant
   « FAIT » + multi-paragraphes d'historique. Si > 1 K chars **et** statut
   FAIT clair → compresser à 1 ligne avec lien archive.

### Étape 3 — Construire l'archive

Format conventionnel : `memory/historique/<scope>_archive_<periode>.md`.
Exemples validés :

- `memory/historique/TASKS_archive_2026-Q2.md` (S52)
- *(à venir)* `memory/historique/CLAUDE_history_2026-S01-S51.md`

Structure type de l'archive :

```markdown
---
title: Archive <scope> <période>
periode: <date début> → <date fin>
created: <date> (session SNN)
source: extraction depuis <fichier> lors de la décongestion SNN
---

# Archive <scope> <période>

Cette archive contient :
1. <description bloc 1>
2. <description bloc 2>
...

Pointeur retour : `<fichier_vivant>` allégé contient uniquement <ce qui reste>.

---

## 1. <Bloc 1>
<contenu archivé>

## 2. <Bloc 2>
...
```

### Étape 4 — Refondre le fichier vivant

Stratégie selon volume :

- **< 50 KB** : `Edit` direct sur les zones identifiées (rapide, sûr).
- **50-100 KB** : `head` + `tail` + `cat` côté Bash, fichier reconstruit
  ligne par ligne. Voir `refondre_tasks.sh` pattern S52.
- **> 100 KB** : pareil mais ATTENTION au piège **P1-S51** : l'outil `Read`
  natif Cowork échoue sur fichiers > 25 K tokens. Toujours passer par
  `wc -lc` + `awk` + `sed -n` pour mesurer/lire des portions.

### Étape 5 — Vérifier les références vivantes (CRITIQUE)

Avant de valider la refonte, grep des numéros de ligne et motifs spécifiques :

```bash
# Références de type "TASKS.md L86" ou "TASKS.md ligne 86"
grep -rnE "<fichier>\.md L[0-9]+|<fichier>\.md ligne [0-9]+" \
  --include="*.md" --exclude-dir=memory/_decongestion_backup_* . \
  | grep -v "^./memory/historique/"
```

**Règle** : si grep remonte des refs vivantes (hors `memory/historique/` qui
est gelé) → patcher AUSSI ces fichiers. Si grep remonte 0 → safe.

### Étape 6 — Patcher les fichiers index

Toujours mettre à jour 3 fichiers minimum :

1. `memory/MEMORY.md` : ajouter 1-2 lignes pointeur archive + skill
   appliquée.
2. `METRIQUES.md` : ajouter 1 ligne `Date décongestion <fichier>` avec
   gain mesuré.
3. `CLAUDE.md` : si la skill ou l'arborescence a évolué, bumper la
   version footer + section dernière session.

### Étape 7 — Mesure avant/après et bilan

```bash
BEFORE=$(wc -c < memory/_decongestion_backup_sNN/<fichier>.bak.sNN)
AFTER=$(wc -c < <fichier>)
DIFF=$((BEFORE - AFTER))
PCT=$((DIFF * 100 / BEFORE))
TOKENS=$((DIFF / 4))
echo "Gain : $DIFF chars libérés ($PCT% réduction)"
echo "      ~$TOKENS tokens/tour libérés"
```

## Règles de sécurité

1. **Toujours backup avant refonte** — étape 1 non négociable.
2. **Ne jamais toucher aux archives `memory/historique/`** — règle S33
   (`feedback_projets_vs_runtime`). Les archives sont gelées par
   convention, on ne les réécrit pas lors d'un déplacement.
3. **Cellules mixtes (FAIT partiel + TODO)** — ne pas compresser. Exemple :
   #58 Hermès (Phase 1bis-a/b/c FAIT, 1bis-d TODO). À traiter seulement
   après clôture complète, ou via compression *partielle* qui garde la
   phase TODO en clair.
4. **Vérifier que le fichier reste cohérent** — `grep "^## "` après refonte
   pour s'assurer qu'aucun H2 parent n'a été perdu (piège S52 :
   `## Plugins Cowork et skills HA — etat final` était à la ligne 294
   archivée et avait disparu du nouveau fichier).
5. **Confirmer avant écraser** — règle CLAUDE.md générale. La proposition
   doit présenter un plan chiffré (tokens libérés estimés, fichiers
   touchés, backup prévu) AVANT l'exécution.

## Format de proposition à Mickael

Toujours présenter sous cette forme (pour cohérence avec S51/S52) :

> **Diagnostic chiffré**
>
> | Fichier | Avant | Cible | Tokens libérés/tour |
> |---------|-------|-------|---------------------|
> | <f1>    | X KB  | Y KB  | ~N K                |
>
> **Plan en 3 niveaux**
> - Niveau 1 (sûr, ~M tokens) : <quoi>
> - Niveau 2 (cellules FAIT, ~M tokens) : <quoi>
> - Niveau 3 (compressions agressives, ~M tokens) : <quoi>
>
> **Risque architectural** : <fichier(s)> n'est pas une source runtime
> → aucun impact MCP/skills/scripts. Seul risque = perte historique inline,
> mitigé par archive `memory/historique/...`.
>
> **Quel niveau tu veux que je lance ?**

## Politique d'archivage récurrente (à adopter)

À l'issue de chaque trimestre (1er janvier, 1er avril, 1er juillet,
1er octobre), proposer automatiquement :

1. Mesurer les 4 fichiers réinjectés.
2. Si Jaune ou pire → décongestion trimestrielle.
3. Archive trimestrielle : `memory/historique/<fichier>_archive_<YYYY>-Q<n>.md`.

Cette skill peut être appelée explicitement avec `/decongestion-fichiers-vivants`
ou se déclenche d'elle-même selon la description.

## Ouvertures

- **Niveau 3 différé** : la cellule #58 Hermès Agent (~18 K chars, mixte)
  reste à décongestionner après clôture Phase 1bis-d. Gain bonus estimé
  ~3 K tokens/tour.
- **Suppression backups anciens** : `memory/_decongestion_backup_s51/` et
  `_s52/` à proposer à la suppression vers S54+ si aucun rollback effectué.
- **Pattern transposable** : si d'autres fichiers gros apparaissent
  (`Ressources/Competences/<X>.md` qui dépasse 50 KB par exemple), la même
  méthode s'applique (scinder en sous-fichiers ou archiver l'historique).

## Sources

- Auto-memory `memory/feedback_claudemd_decongestion.md` (S49) — règle
  « pointer, don't embed », 5 leviers communautaires identifiés.
- Auto-memory `memory/feedback_decongestion_seuils.md` (S52) — seuils de
  déclenchement formalisés.
- Archive `memory/historique/2026-04-25_session_49_recherche_claudemd_volumineux.md`
  — recherche communautaire 11 sources convergentes.
- Archive `memory/historique/2026-04-25_session_51_decongestion_claudemd_metriques.md`
  — première application validée (CLAUDE.md + METRIQUES.md).
- Archive `memory/historique/2026-04-25_session_52_decongestion_tasksmd.md`
  — deuxième application validée (TASKS.md).
- Archive `memory/historique/TASKS_archive_2026-Q2.md` — premier exemple
  d'archive trimestrielle (pattern transposable).
