---
id: 81
title: "Refonte CLAUDE.md vers <100 lignes via @imports (P2 audit S74)"
status: done
priority: P2
session_opened: S74
session_closed: S75
tags: [claude-md, decongestion, audit, imports, t-081]
source: "Session 74 — Audit structure fichiers vivants (28/04/2026)"
---

# T#81 — Refonte CLAUDE.md vers <100 lignes via `@imports`

## Description

Suite à l'audit structure S74, CLAUDE.md fait actuellement **266 lignes / 12.7 KB** soit **2-3× au-dessus** des standards communautaires (Karpathy 65 lignes, HumanLayer <60 lignes, BSWEN dégradation au-delà de 200-300 lignes). Le footer narratif S66→S74 est précisément l'anti-pattern n°4 documenté (état volatile dans CLAUDE.md).

**Objectif** : ramener CLAUDE.md à <100 lignes / <2 KB au root via la mécanique officielle Anthropic d'imports `@path/to/file.md` (récursion max 5 niveaux), tout en préservant l'intégralité des §0-§9.

## Plan d'attaque (4 étapes)

### Étape 1 — Externaliser le footer narratif S66→S74 (~15 min, gain ~2 KB)

- Créer `memory/historique/INDEX_sessions.md` avec liste chronologique des sessions + 1 ligne pointeur par session
- Remplacer dans CLAUDE.md le footer (lignes ~248-266) par :
  ```
  *Dernière session : voir @memory/historique/INDEX_sessions.md*
  ```

### Étape 2 — Splitter §3, §4, §6, §8 en imports (~30 min, gain ~5 KB)

Sections à externaliser via imports `@memory/instructions_*.md` :

- §3 « Modifications de configuration HA » → `@memory/instructions_modifications_ha.md`
- §4 « Mode de travail et communication » → `@memory/instructions_communication.md`
- §6 « Connecteurs MCP » → `@memory/reference_mcp_connecteurs.md`
- §8 « Fin de session » → `@memory/instructions_fin_session.md`

Sections **conservées au root** (règles dures) :

- §0 « Données sensibles » (priorité absolue, jamais loin)
- §0-bis « Mode d'exécution »
- §1 « Démarrage de session » (lectures auto)
- §2 « Connexion HA » (URLs critiques)
- §5 + §5-bis (pointeurs courts vers SKILLS_INDEX et reference_sub_agents_p3)
- §7 « Limites » (très court)
- §9 « Rotation archives » (1 ligne)

### Étape 3 — Hygiène markdown (~5 min)

- Casser ligne 197 (553 caractères, bullet PDF Tools) en 4-5 sous-bullets de 80-100 caractères max
- Vérifier qu'aucune ligne >150 caractères ne subsiste

### Étape 4 — Validation auto via linter (~5 min)

- Lancer côté **PowerShell Mickael** :
  ```powershell
  cd "D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant"
  npx claudelint .
  ```
- Si `claudelint` indispo : essayer `npx @carlrannaberg/cclint`
- Vérifier que tous les `@imports` résolvent + que le total reste <2 KB / <100 lignes

## Pré-requis

- **Test à faire d'abord** : confirmer que Cowork supporte la syntaxe `@path/to/file.md` (officielle Claude Code mais pas certaine sur Cowork desktop). Test = mettre 1 import dans CLAUDE.md et observer si le contenu importé apparaît dans le system-reminder réinjecté en début de conversation.
- **Backup obligatoire** : `cp CLAUDE.md memory/_decongestion_backup_s74/CLAUDE.md.bak` avant toute modif structurelle.

## Sources

- Audit S74 (28/04/2026) — `memory/historique/2026-04-28_session_74_audit_structure_fichiers_vivants.md`
- [Best Practices for Claude Code (Anthropic)](https://code.claude.com/docs/en/best-practices)
- [How Claude remembers your project — imports `@`](https://code.claude.com/docs/en/memory)
- [Karpathy's 65-Line CLAUDE.md](https://www.knightli.com/en/2026/04/19/karpathy-claude-md-ai-coding-rules/)
- [Writing a good CLAUDE.md — HumanLayer](https://www.humanlayer.dev/blog/writing-a-good-claude-md)
- Linter : [felixgeelhaar/cclint](https://github.com/felixgeelhaar/cclint), [pdugan20/claudelint](https://github.com/pdugan20/claudelint)

## Effort / Risque

- **Effort** : ~1h (4 étapes)
- **Risque** : moyen — si Cowork ne supporte pas `@imports`, fallback nécessaire (rester sur la décongestion conservatrice du footer S66+ uniquement, sans imports). Backup S74 indispensable.

## Statut

🟢 `open` — créée S74 (28/04/2026). À démarrer en S75 ou ultérieur.

✅ `done` — clôturée S75 (28/04/2026, ~22h00). **Option C appliquée** suite test
phrase-canari `LIBELLULE-3742` concluant : Cowork desktop **ne résout PAS** la
syntaxe officielle Claude Code `@path/file.md`. Refonte massive vers <100
lignes impossible. Refonte conservatrice exécutée à la place :

- Footer narratif S65→S74 externalisé vers `memory/historique/INDEX_sessions.md`
  (~3.2 KB déplacés).
- §6 Connecteurs MCP : ligne 197 PDF Tools (553 chars unique) cassée en 1 bullet
  parent + 3 sous-bullets ≤100 chars (Permissions / Pièges / `fill_pdf`).
- `memory/reference_mcp_connecteurs.md` créé comme référence enrichie
  complémentaire au §6 (lecture sur demande).
- Bilan octets injectés au démarrage : 12 687 → 12 687 (Δ 0). Le footer sorti
  est compensé par §6 plus aéré. **C'est la limite intrinsèque de l'option C.**

**Acquis durables** : info `@imports` non supporté Cowork (auto-mémoire
`memory/reference_cowork_imports_non_supportes.md` créée), mécanique
`INDEX_sessions.md` en place pour les sessions futures, §6 lisible.

**Alternatives pour décongestion future** (à réévaluer si seuil Orange
dépassé) :

- Stratégie Y — synthèse agressive (1-2 lignes par règle clé, perte de
  détail).
- Stratégie Z — instruction explicite §1 ajoutant lecture systématique de
  4 fichiers `memory/instructions_*.md` au démarrage de session (+4 Read).

Détail clôture : `memory/historique/2026-04-28_session_75_refonte_claudemd_option_c.md`.
Backup S74 conservé : `memory/_decongestion_backup_s74/CLAUDE.md.bak`.
