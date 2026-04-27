---
type: feedback
session_origine: 49
date: 2026-04-25
applies_to: ["CLAUDE.md", "METRIQUES.md", ".claude/rules/", "tout fichier réinjecté à chaque tour"]
tags: [claudemd, metriques, decongestion, tokens, best-practices]
---

# Décongestion CLAUDE.md / METRIQUES.md — règle "pointer, don't embed"

## Règle

Tout fichier **réinjecté à chaque tour** (CLAUDE.md, frontmatter
METRIQUES.md, fichiers dans le contexte global) doit rester **lean** :
pointeurs vers ressources, pas embedding du contenu.

**Cible** : CLAUDE.md ≤ 200 lignes, METRIQUES.md tableaux uniquement,
zéro bloc historique embedded ; toute information détaillée vit dans
`memory/historique/`, `Ressources/`, ou `.claude/skills/` (chargement à
la demande).

## Pourquoi

Diagnostic communautaire 2026 (10+ sources convergentes — doc Anthropic,
DEV Community, GitHub citypaul/.dotfiles, abhishekray07/claude-md-templates,
DataCamp, Builder.io, Medium…) :

1. **Réinjection à chaque tour** : si CLAUDE.md = 5 000 tokens, on paye
   5 000 tokens à chaque message, chaque tool call, chaque /clear.
   À 25-30 K tokens (cas Jarvis avant S49), c'est 25-30 K tokens × N tours.
2. **Dégradation > 200 lignes** : Claude commence à ignorer certaines
   règles "noyées" dans le contexte. Conformité chute mesurablement.
3. **Mémoire effective réduite** : un CLAUDE.md bloated mange l'espace
   disponible pour le code et la conversation utile.

## Comment l'appliquer

### En écriture (à chaque archivage de session)

**Pas comme ça** (anti-pattern actuel CLAUDE.md S36 → S48) :
```
*Fin de CLAUDE.md — version 3.18 — 25 avril 2026 (MAJ session 48 :
Phase 1bis-c Hermes Agent CLÔTURÉE 100% (~3h30) + bonus durcissement
sécurité. (a) Cleanup ~/hermes-agent + ollama rm llama3.2:1b. (b) Pivot
sécurité Stratégie 2 : régénération secret_path add-on ha-mcp...
[+ 200 lignes embedded])
```

**Comme ça** :
```
*Fin de CLAUDE.md — version 3.X — 25 avril 2026

Dernière session : S48 (25/04/2026) — Phase 1bis-c Hermes Agent CLÔTURÉE.
Voir `memory/historique/2026-04-25_session_48_phase1bisc_cloture.md`.

Index complet sessions : `memory/MEMORY.md`*
```

### En frontmatter METRIQUES.md / TASKS.md

Pareil — `last_update:` doit être une mention courte avec pointeur vers
l'archive, pas un dump du contenu de la session.

### Pour les détails

- **Détails opérationnels** → `memory/historique/AAAA-MM-JJ_session_NN.md`
- **Procédures réutilisables** → `Ressources/Competences/<sujet>.md` ou
  `Ressources/Protocoles/<sujet>.md`
- **Règles transversales** → auto-memory `memory/feedback_*.md` ou
  `memory/reference_*.md`
- **Skills** → `.claude/skills/<skill>/SKILL.md` (chargement à la demande)

## Les 5 leviers complémentaires (synthèse communautaire)

1. **Pointer, don't embed** (règle ci-dessus, gain le plus fort)
2. **Limite ~200 lignes par fichier réinjecté**
3. **Pattern `@import`** — syntaxe `@chemin/fichier.md` dans CLAUDE.md.
   ⚠️ N'économise PAS le contexte récurrent (les imports sont chargés
   au démarrage), mais améliore l'organisation et la maintenance
4. **`.claude/rules/*.md` path-scoped** — frontmatter `applies_to:` avec
   globs pour ne charger que si Claude touche les chemins concernés.
   Témoignage monorepo : -80 % de word count total
5. **Promotion vers Skill** — chargement à la demande pour règles
   spécialisées (déjà appliqué pour les skills techniques Jarvis)

## Anti-règle

NE PAS confondre `@import` avec une économie de tokens. Les `@import`
servent à **mieux organiser** un CLAUDE.md, pas à le rendre plus léger
côté contexte récurrent.

Pour économiser des tokens : il faut soit **ne pas charger** (skills,
path-scoped rules), soit **pointer plutôt qu'embedder** (archives,
ressources externes).

## Sources

- [Best Practices for Claude Code (doc Anthropic)](https://code.claude.com/docs/en/best-practices)
- [How Claude remembers your project (doc Anthropic)](https://code.claude.com/docs/en/memory)
- [SPLIT-CLAUDE-MD-PLAN.md (citypaul/.dotfiles)](https://github.com/citypaul/.dotfiles/blob/main/SPLIT-CLAUDE-MD-PLAN.md)
- [Claude Code Token Optimization Full System Guide 2026](https://buildtolaunch.substack.com/p/claude-code-token-optimization)

Voir archive S49 pour la liste complète des 11 sources.
