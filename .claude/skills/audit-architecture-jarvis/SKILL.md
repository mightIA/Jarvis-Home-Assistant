---
name: audit-architecture-jarvis
description: Audit architecture complet du projet Jarvis — mesure les fichiers vivants, compare aux best practices Claude Code (post claude-code-from-source + docs Anthropic + forums), identifie les dérives (mémoire, sub-agents, hooks, skills), produit un plan de remédiation chiffré P1/P2/P3/P4. À déclencher trimestriellement (1er janvier/avril/juillet/octobre) ou quand Mickael sent une dérive ("ça rame", "je trouve qu'on s'éloigne des standards", "fais un point sur l'architecture"). Sortie : analyse longue + plan d'action priorisé avec efforts/gains chiffrés. Première application S72 (28/04/2026) — phases P1+P2 réalisées.
---

# Skill : Audit architecture Jarvis (méta)

## Quand cette skill est déclenchée

- **Trimestriel** : 1er janvier, 1er avril, 1er juillet, 1er octobre.
  Comme la rotation archives historiques.
- **Sur signal Mickael** : « est-ce qu'on a dérivé ? », « fais un point
  architecture », « audit complet », « est-ce que notre setup colle aux
  best practices ? ».
- **Après upgrade majeur Claude Code / Cowork** : nouvelle version qui
  apporte des features structurantes (sub-agents v2.1.33, skills
  context:fork, etc.).
- **Quand un fichier vivant approche le seuil Rouge** de la skill
  `decongestion-fichiers-vivants` ET d'autres signes de dérive
  (skills sans `when_to_use`, `.claude/agents/` vide, etc.).

## Pourquoi cette skill existe

Première application S72 (28/04/2026) après que Mickael ait demandé
« j'ai l'impression qu'on a dérivé sur ton architecture ». Diagnostic :
5 dérives identifiées (METRIQUES.md hypertrophié, aucun sub-agent,
hooks zéro, skills sans progressive disclosure, frontmatter non-standard).
Plan P1+P2+P3+P4. P1+P2 exécutées en S72.

Sans audit récurrent, l'architecture dérive linéairement (constat S49 :
~75 K tokens taxés/tour). La skill capitalise la méthodo de l'audit S72.

## Procédure (5 phases)

### Phase 1 — Lecture du post de référence

Source canonique : `claude-code-from-source.com` (livre reverse-engineerisé
des sources Claude Code par Alejandro Balderas, ~18 chapitres).

Chapitres à lire prioritairement :

| Chapitre | Sujet | Pourquoi |
|---|---|---|
| `ch01-architecture` | 6 abstractions fondamentales | Vue d'ensemble |
| `ch11-memory` | Système de mémoire (4 types, MEMORY.md cap 200/25KB) | Comparer notre `memory/` |
| `ch12-extensibility` | Skills + Hooks (frontmatter, hooks lifecycle) | Comparer nos skills |
| `ch15-mcp` | MCP — 8 transports, 7 sources | Comparer notre `.mcp.json` |
| `ch08-sub-agents` | Tasks et sub-agents | Vérifier `.claude/agents/` |

Accès : si claude-code-from-source.com est bloqué allowlist, cloner le
miroir GitHub `https://github.com/alejandrobalderas/claude-code-from-source`
en shallow clone (`git clone --depth 1`).

### Phase 2 — Cartographie de l'état actuel

```bash
cd "$(pwd)"

echo "=== Tailles fichiers vivants ==="
wc -l -c CLAUDE.md CONTEXTE.md TASKS.md METRIQUES.md memory/MEMORY.md

echo ""
echo "=== Inventaire .claude/ ==="
ls -la .claude/agents/ .claude/skills/ .claude/hooks/ .claude/commands/

echo ""
echo "=== Skills count + frontmatter audit ==="
for skill in .claude/skills/*/SKILL.md; do
  HAS_WHEN=$(grep -c "^when_to_use" "$skill")
  HAS_PATHS=$(grep -c "^paths" "$skill")
  HAS_FORK=$(grep -c "^context:" "$skill")
  printf "%-40s when=%d paths=%d fork=%d\n" "$(dirname $skill | xargs basename)" "$HAS_WHEN" "$HAS_PATHS" "$HAS_FORK"
done

echo ""
echo "=== Connecteurs MCP actifs ==="
jq '.mcpServers | keys[]' .mcp.json
```

### Phase 3 — Recherche pratiques communautaires

WebSearch ciblées (résumés courts, pas full fetch — pages docs.claude.com
font >1 MB et débordent le contexte) :

- `Claude Code best practices CLAUDE.md memory <année> sub-agents`
- `Claude Code skills frontmatter when_to_use paths context fork official`
- `Claude Code hooks PreToolUse blocking exit code 2 security`
- `"writing a good CLAUDE.md" humanlayer 300 lines context dilution`

Sources de référence (avril 2026) :

- HumanLayer (CLAUDE.md < 60 lignes idéal, < 300 lignes max)
- Anthropic docs `code.claude.com/docs/en/best-practices`
- alexop.dev / claudelog.com (deep dives techniques)

### Phase 4 — Diagnostic des dérives

5 axes de comparaison :

| Axe | Bench post | Mesure projet | Verdict |
|---|---|---|---|
| **Mémoire** | MEMORY.md cap 200 lignes / 25 KB, 4 types frontmatter (user/feedback/project/reference) | `wc -l memory/MEMORY.md` + audit frontmatter | Aligné / Dérive |
| **Skills** | Frontmatter avec `when_to_use`, `paths`, `context:fork`, progressive disclosure | Pourcentage de skills avec ces fields | Aligné / Dérive |
| **Sub-agents** | `.claude/agents/*.md` pour tâches longues (audit, recherche, traduction) | Nombre d'agents définis | Aligné / Dérive |
| **Hooks** | `.claude/settings.json` champ `hooks` PreToolUse exit 2 sur secrets | Hook actif ou non | Aligné / Dérive |
| **MCP** | OAuth lazy, stdio/HTTP, in-process pour built-in | Audit `.mcp.json` | Aligné / Dérive |

### Phase 5 — Plan de remédiation chiffré

Format obligatoire : 4 phases priorisées P1/P2/P3/P4 avec :

| Phase | Effort | Gain immédiat | Risque |
|---|---|---|---|
| P1 | 1 session | Mesurable (tokens libérés, etc.) | Faible/Moyen |
| ... | ... | ... | ... |

Chaque phase doit pouvoir être exécutée **indépendamment** des autres.
Toujours commencer par la phase au plus gros ratio gain/effort/risque.

## Modèle de rapport (template S72)

```markdown
# Audit architecture Jarvis — SNN (date)

## 1. Ce que dit le post (résumé fidèle)
[6 abstractions, patterns clés]

## 2. Mon architecture aujourd'hui (cartographie objective)
[arborescence + tailles + connecteurs MCP]

## 3. Ce que recommandent les forums et docs officielles
[CLAUDE.md, mémoire, sub-agents, skills, hooks]

## 4. Verdict honnête : où on a dérivé
- 4.1 Là où c'est solide (à conserver)
- 4.2 Les N vraies dérives par ordre de gravité
- 4.3 Faux positifs

## 5. Plan de remédiation (par priorité)
| Phase | Effort | Gain | Risque |

## Sources
[markdown hyperlinks]
```

## Pièges connus

- **claude-code-from-source.com bloqué allowlist** : passer par
  `https://github.com/alejandrobalderas/claude-code-from-source` (shallow
  clone). github.com est dans l'allowlist par défaut.
- **WebFetch sur docs.claude.com retourne >1 MB** : trop gros pour le
  contexte. Utiliser WebSearch (qui résume) ou viser une URL très ciblée.
- **Trop d'objectivité** : ne pas mâcher ses mots dans le verdict
  « dérives ». Mickael a explicitement demandé « analyse profonde,
  honnête » en S72. Lister les 5 dérives sans enrobage.
- **Mode pas-à-pas Mickael** : la skill produit un long rapport en bloc,
  mais l'**exécution** des phases de remédiation suit la règle pas-à-pas
  (CLAUDE.md §4 — règle S53 attente retour).

## Politique d'application

- L'audit lui-même ne modifie **aucun fichier** — il produit du diagnostic
  + plan.
- L'exécution des phases P1/P2/P3/P4 se fait en sessions dédiées,
  une phase par session minimum.
- Backup obligatoire avant toute refonte (cf. skill
  `decongestion-fichiers-vivants` étape 1).

## Sources

- Post `claude-code-from-source` — <https://claude-code-from-source.com>
  (miroir GitHub : `alejandrobalderas/claude-code-from-source`).
- Docs Claude Code officielles : <https://code.claude.com/docs/>
- HumanLayer CLAUDE.md guide : <https://www.humanlayer.dev/blog/writing-a-good-claude-md>
- Audit S72 (28/04/2026) — première application, archive
  `memory/historique/2026-04-28_session_72b_audit_architecture_P1_P2.md`.
- Skill connexe `decongestion-fichiers-vivants` (mesure fichiers vivants).
- Skill connexe `hook-add-pattern` (extension hook sécurité).
