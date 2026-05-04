---
title: Skills Workflow & Communication
created: 2026-04-27
updated: 2026-05-02
tags: [atome, skill, workflow, meta]
status: actif
domaine: Skills_Jarvis
---

# Skills Workflow & Communication

Catégorie regroupant les 3 skills méta qui régulent la **manière** dont Jarvis travaille avec Mickael (gestion de session, communication, langues, hygiène des fichiers).

> **Note S84 (2026-05-02)** : suppression de 2 skills obsolètes —
> `bascule-conversation` et `guidage-photo-etape` (T#24 cancelled). Ces skills
> étaient conçues pour le mode iPhone à captures saturées, devenu marginal
> depuis l'instauration du mode PC permanent S24 (CLAUDE.md §4 RÈGLE PRINCIPALE).
> Pour la limite contexte : `/compact` ou nouvelle conv (auto-memory
> `feedback_compact_vs_bascule_proposition`). Pour le pas-à-pas : règle
> CLAUDE.md §4 RÈGLE PAS-À-PAS (S53).

## Skills incluses

### `session-closure`

- **Déclencheur** : fin de session importante, "on va s'arrêter là", "fin de session", après une série de modifs significatives.
- **Rôle** : proposer la régénération d'un `.md` daté dans `memory/historique/`, MAJ skills/protocoles modifiés, regen `Jarvis_Audits_Todo.md` (format `.md` depuis S33), MAJ `CLAUDE.md` si arborescence évolue, MAJ `METRIQUES.md`.
- **Dépendances** :
  - Format archive : `AAAA-MM-JJ_session_NN_titre.md`
  - 3 fichiers fallback Claude.ai en `.md` (Profil + Instructions + Audits_Todo)
  - Description Cowork : `Ressources/Mode_Chat/Description.md`
  - Instructions Cowork Desktop : `Ressources/Cowork/Instructions.md`
- **Détail exécutable** : `.claude/skills/session-closure/SKILL.md`
- **Lien obligatoire fin de session** : `mcp__cowork__askUserQuestion` avec 2 options (Sauvegarde totale / Archives uniquement) — cf. auto-memory `feedback_fin_session_menu_archivage`

### `traduction`

- **Déclencheur** : "traduis", "translate", "übersetze", texte FR/EN/DE collé avec demande de sens, message à un correspondant non francophone.
- **Rôle** : traduction FR↔EN↔DE avec 4 modes adaptatifs.
- **Modes** :
  - **Professionnel** (registre soutenu)
  - **Accessible** (vocabulaire simple, non-bilingues)
  - **Technique** (glossaire spécialisé)
  - **Personnel** (style de Mickael appris au fil du temps)
- **Dépendances** :
  - Glossaire dans `Ressources/Competences/`
  - Fichier de style personnel Mickael (appris)
- **Détail exécutable** : `.claude/skills/traduction/SKILL.md`
- **Auto-memory** : `reference_traduction_skill`

### `decongestion-fichiers-vivants`

- **Déclencheur** :
  - **Automatique en début de session** : check léger des seuils après lecture des 5 fichiers d'amorçage (`CLAUDE.md`, `CONTEXTE.md`, `TASKS.md`, `METRIQUES.md`, `memory/MEMORY.md`)
  - **Manuel** : "ça rame", "ça coûte cher en tokens"
  - **Après ajout** : grosse cellule TASKS.md ou patch CLAUDE.md/METRIQUES.md
- **Rôle** : mesurer poids/lignes/ligne unique, appliquer seuils Vert/Jaune/Orange/Rouge, proposer décongestion structurée (backup → archive trimestrielle `memory/historique/<scope>_archive_YYYY-Qn.md` → refonte → vérif refs → patches index → mesure).
- **Dépendances** :
  - Pattern « pointer, don't embed » établi S49 → S52 (~57 K tokens libérés sur 3 fichiers)
  - Format archive trimestrielle
- **Détail exécutable** : `.claude/skills/decongestion-fichiers-vivants/SKILL.md`
- **Auto-memory** : `feedback_decongestion_seuils`

## Patterns d'usage transversaux

### Mode PC Cowork par défaut (S24 + S44)

Jarvis considère **toujours** que Mickael est sur PC en mode Cowork. Réponses détaillées autorisées par défaut (markdown, tableaux, listes, blocs de code). Pas de "iPhone" ou "3 lignes max" sans demande explicite.

**Exception rare** : si Mickael écrit "là je suis sur iPhone" → mode terse pour la session courante uniquement.

Hors `guidage-photo-etape` qui force lui-même le mode 2-3 lignes.

### Forfait Max — pas de mode économe par défaut (S44)

Mode économe activé **uniquement** sur signalement explicite (% restant bas, "économe", "opération non risquée"). Ne pas hériter du mode économe d'une session précédente.

### Règle pas-à-pas avec attente de retour (S53)

Toute procédure impliquant des manips Mickael : livrer **UNE étape à la fois** et **attendre le retour** avant de donner la suivante. Anti-pattern : balancer R1+R2+R3+R4 d'un coup. Exception : actions automatisées Claude (Read/Edit/Write/Bash sans intervention Mickael) peuvent être enchaînées. Cf. auto-memory `feedback_pas_a_pas_attente_retour`.

### Règle titre conversation FR (S53)

En début de chaque nouvelle conversation Cowork, **proposer immédiatement un titre clair en français** (5-10 mots, format `<Domaine> — <Action>`). Cf. auto-memory `feedback_titre_conversation_fr`.

### Règle label blocs (S48 + S53)

Avant chaque bloc de code/commande à coller, **étiqueter clairement l'app cible** (Ubuntu / WSL2 bash / PowerShell / Hermès chat / Claude Code CLI / Brave / HA UI / Notepad / etc.). Mickael jongle entre nombreux terminaux. Cf. auto-memory `feedback_label_application_blocs`.

### Règle compact vs bascule (S53)

À l'approche de la limite contexte, **toujours proposer LES 2 solutions** (`/compact` ET bascule conv), avec reco motivée selon valeur du contexte courant. Cf. auto-memory `feedback_compact_vs_bascule_proposition`.

### Liens cliquables / blocs de code

- Toute URL à ouvrir → lien markdown `[texte](url)`
- Tout texte à coller → bloc triple backtick (bouton copier)

Cf. auto-memories `feedback_clickable_urls`, `feedback_copy_paste_code_blocks`.

## Voir aussi

- [[_Index]] — MOC Skills Jarvis
- `CLAUDE.md` § 4 — règles de communication
- `CLAUDE.md` § 8 — fin de session
