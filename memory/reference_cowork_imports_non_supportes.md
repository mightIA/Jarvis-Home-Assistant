---
name: Cowork desktop ne résout pas la syntaxe @imports
description: Fait établi par test phrase-canari S75 (28/04/2026). La syntaxe officielle Claude Code @path/file.md n'est pas résolue par Cowork desktop — le fichier référencé n'est PAS inclus automatiquement dans le system-reminder de démarrage. Conséquence : refonte CLAUDE.md vers <100 lignes via @imports impossible sur Cowork.
type: reference
last_update: 2026-04-28
---

# Cowork desktop — `@imports` officielle Claude Code non supportée

## Fait établi (S75, 28/04/2026)

La syntaxe officielle d'imports `@path/to/file.md` documentée par Anthropic
pour Claude Code (récursion max 5 niveaux, fonctionne dans CLAUDE.md, README,
auto-resolves au démarrage) **n'est pas appliquée par Cowork desktop**.

## Protocole de vérification — phrase-canari

Pour re-vérifier ultérieurement (par exemple après une mise à jour Cowork) :

1. Choisir un mot inhabituel (ex `LIBELLULE-3742`).
2. Le placer **uniquement** dans un fichier référencé par `@`, jamais dans
   le fichier appelant. Idéalement dans le frontmatter, par exemple :
   ```yaml
   ---
   canari_test_imports: LIBELLULE-3742
   ---
   ```
3. Dans le fichier appelant (ex `CLAUDE.md`), ajouter une ligne du type
   `Voir @memory/reference_xxx.md` sans répéter le mot canari.
4. Ouvrir une **nouvelle conversation** Cowork (le system-reminder est
   réinjecté à ce moment).
5. Demander à Jarvis : *« Cite la phrase-canari sans utiliser le tool
   `Read` ni aucun autre tool. Si tu ne la connais pas, dis-le. »*
6. Verdict :
   - Jarvis cite directement le mot → `@imports` fonctionne.
   - Jarvis dit ne pas le connaître ou tente un `Read` → `@imports`
     n'est PAS appliqué par Cowork.

## Pourquoi ne pas re-tester à chaque session

- Le test consomme une nouvelle conversation pour rien si rien n'a changé
  côté Cowork.
- Avant de re-tester, vérifier si une nouvelle release Cowork desktop a
  été annoncée ou si Mickael a mis à jour Claude desktop.
- Le test reste recommandé après chaque mise à jour majeure de Claude
  desktop (Cowork est un mode de cette app).

## Conséquences pratiques

- Pour CLAUDE.md : pas de réduction massive vers <100 lignes via imports.
  Refonte conservatrice possible (footer externalisé, hygiène lignes
  longues), mais le détail des sections doit rester inline OU être lu
  manuellement par Jarvis via `Read` quand un sujet émerge.
- Pour les autres fichiers vivants (`TASKS.md`, `METRIQUES.md`,
  `CONTEXTE.md`, `MEMORY.md`) : même contrainte. Privilégier les liens
  markdown classiques `[texte](path)` plutôt que `@path` — ils sont
  équivalents en lisibilité humaine et plus honnêtes côté agent.
- Pour les skills, sub-agents, hooks : ils sont chargés par Cowork via
  d'autres mécanismes (frontmatter de skill, settings.json), pas via
  `@imports`. Pas de problème de ce côté.

## Alternatives explorées en S75

- **Stratégie Y — synthèse agressive** : réécrire en versions ultra-courtes,
  perdre du détail. Pas appliquée S75, à évaluer si seuil Orange dépassé.
- **Stratégie Z — instruction explicite §1** : ajouter au démarrage la
  lecture systématique de fichiers `memory/instructions_*.md`. Pas
  appliquée S75, à évaluer si gain en lisibilité humaine du CLAUDE.md
  prime sur le coût de +N `Read` au démarrage.

## Sources

- Test S75 (28/04/2026) — phrase-canari `LIBELLULE-3742` non vue par
  Cowork desktop, retour Mickael explicite.
- Historique S75 : `memory/historique/2026-04-28_session_75_refonte_claudemd_option_c.md`.
- T#81 (archivée S75) : `tasks/archive_2026-Q2/task_081.md`.
- Doc Anthropic officielle imports : <https://code.claude.com/docs/en/memory>.
