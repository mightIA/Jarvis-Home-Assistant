# Memoire Jarvis — Index (Claude Code CLI local)

Ce fichier indexe les auto-memories ecrites depuis **Claude Code CLI local**
(harness desktop). Elles sont stockees sous forme de fichiers `.md` dans ce
dossier `memory/` et versionnees avec le projet.

**Complementaire** aux **auto-memories Cowork web (serveur Anthropic)**
listees dans `METRIQUES.md` section "Auto-memories Cowork web (serveur)".
Les deux scopes coexistent :

- **CLI local** (ce fichier) : visible sur le poste, ecrit depuis Claude Code.
- **Cowork web** (METRIQUES.md) : visible cote serveur claude.ai, reinjecte
  automatiquement dans les conversations Cowork web.

---

## Reference

- Historique des sessions : `memory/historique/AAAA-MM-JJ_session_NN_titre.md`
- Profil et contexte stable : `CONTEXTE.md` (a la racine)
- Taches et audits : `TASKS.md` (a la racine)
- Metriques (+ index Cowork web) : `METRIQUES.md` (a la racine)

---

## Entrees memoire (CLI local)

<!-- Liens vers les fichiers memoire auto-generes, un par ligne, format :
- [Titre](fichier.md) — description courte
-->

- [notify gmail target requis](feedback_notify_gmail_target.md) — `notify.might57290_gmail_com` exige `data.target=["might57290@gmail.com"]`, sinon HTTP 500 ValueError.
- [Pièges pandoc + template LaTeX custom](feedback_pandoc_template_pieges.md) — 4 pièges XeLaTeX à connaître avant d'écrire un template custom (babel→polyglossia, `$` comme variable pandoc, MakeUppercase+color, DejaVu sans emojis).
- [Vidéo ParlonsIA Obsidian + Claude 4.7](reference_video_parlonsia_obsidian_claude.md) — source S38 pour Phase 1bis : 3 idées techniques piochées (Mistral OCR, Qwen Embedding 4B, 3 sub-agents wiki_*), formation auteur écartée, thèse complot Karpathy non retenue.
- [Pas de plugin payant Obsidian](feedback_obsidian_pas_de_plugin_payant.md) — règle Phase 1bis-a : ne pas activer/acheter le plugin de vectorisation propriétaire Obsidian. Hermès + Qwen 3 Embedding 4B local fait mieux gratuitement.
- [Disclaimer YouTube "Contenu modifié ou synthétique"](feedback_video_disclaimer_voix_ia.md) — règle d'évaluation : voix probablement IA, recouper systématiquement avec source primaire avant de retenir le contenu pédagogique.
- [Obsidian vault Wiki Jarvis](reference_obsidian_vault.md) — S41 25/04/2026 : chemin `Wiki/` dans projet Jarvis, structure PARA 5 dossiers, 4 plugins gratuits (Dataview/Templater/Excalidraw/Git), conventions nommage et tags
- [Obsidian install Desktop](reference_obsidian_install.md) — S41 : procédure transposable réinstall (option "Juste pour moi", piège mode restreint formulation FR contre-intuitive, piège plugin "Git" pas "Obsidian Git" dans catalogue)
- [Décongestion CLAUDE.md / METRIQUES.md](feedback_claudemd_decongestion.md) — S49 25/04/2026 : règle "pointer, don't embed" pour tout fichier réinjecté à chaque tour. 5 leviers communautaires (pointeur, ≤200 lignes, @import attention pas d'éco contexte, .claude/rules/ path-scoped, promotion skill). **APPLIQUÉ S51 — gain mesuré ~42 261 tokens/tour libérés (-76,5 % poids combiné CLAUDE.md + METRIQUES.md)**
- Archive S49 recherche décongestion — `historique/2026-04-25_session_49_recherche_claudemd_volumineux.md` (recherche communautaire 11 sources convergentes, tâche #61 créée priorité MOYENNE pour refonte CLAUDE.md/METRIQUES.md en session dédiée)
- [Git Jarvis repo S42](reference_git_jarvis_repo.md) — *réplique CLI local* — repo Git racine projet créé S42, branche `main`, commit `3a63421` 130 fichiers, .gitignore strict Q1-Q4, .mcp.json.template versionné, push GitHub mightIA reporté. Stratégie + procédure clone ailleurs documentée
- [Sandbox Cowork bash bloque Git](feedback_git_sandbox_cowork_bloque.md) — *réplique CLI local* — toutes les commandes git doivent passer par PowerShell côté Mickael (pattern brain+hands), pas par `mcp__workspace__bash`. Pièges encodage `.git/config` et permissions sandbox
- Archive S43 hub Traduction vault — `historique/2026-04-25_session_43_hub_traduction.md` (1 hub + 4 atomes dans Wiki/10_Domaines/Traduction/, mini-op économe forfait 78 %, D4-S42 atomique strict, pas d'auto-memory)
- Archive S44 hub Email vault — `historique/2026-04-25_session_44_hub_email.md` (1 hub + 6 atomes dans Wiki/10_Domaines/Email/, retour mode normal forfait Max après bascule mid-session, auto-memory `feedback_forfait_max_pas_econome` créée Cowork)
- Archive S45 hubs Outils + Vie perso vault — `historique/2026-04-25_session_45_hubs_outils_vieperso.md` (2 hubs + 10 atomes dans Wiki/10_Domaines/Outils/ + ViePerso/, **Phase A vault TERMINÉE 5/5 hubs alimentés**, D4-S42 atomique strict, pas d'auto-memory pendant Phase A — la session a continué avec Phase 1bis-b ensuite, voir bloc enrichi de l'archive)
- Phase 1bis-b démarrée même session S45 — `historique/2026-04-25_session_45_hubs_outils_vieperso.md` section enrichie + 4 auto-memories Cowork créées (`reference_mistral_le_chat`, `feedback_mistral_lechat_limites`, `feedback_pdf_toolkit_chromium_fonts`, `project_mistral_doc_ai_phase1bisb_partiel`). Test 1 complet Mistral 19/30 vs pdf-toolkit 17/30, test 2 partiel (pdf-toolkit échec fonts custom + Mistral tronqué+traduit), test 3 + relance test 2 + rapport final reportés S46+
- Archive S46 Phase 1bis-b CLÔTURÉE — `historique/2026-04-25_session_46_phase1bisb_cloture.md` (rapport final `Projets/Mistral_Doc_AI_Test/Rapport_Mistral_Doc_AI.md` 9 sections ~700 lignes, test 2 v2 EN RÉUSSI 18/30 vs pdf-toolkit 5/30, test 3 abandonné 3 pièges dématérialisation, reco Phase 1bis-c stack hybride pdf-toolkit + Mistral OCR API REST routing intelligent, 3 décisions D1/D2/D3-S46, auto-memory `project_mistral_doc_ai_phase1bisb_partiel` Cowork mise à jour → CLÔTURÉE, pas de skill créée/MAJ)
- Archive S47 Phase 1bis-c install Hermes Agent — `historique/2026-04-25_session_47_phase1bisc_hermes_install.md` (~2h30 mode normal forfait Max, install bouclée à 90% : WSL2 Ubuntu 24.04 + Ollama 0.21.2 + 4 modèles 35.4 Go + Hermes Agent v0.11.0 sur RTX 3090 + clé API Mistral type Studio testée HTTP 200, reste S48 config ha-mcp + test V1 final, doc équivalente skill créée `Ressources/Competences/Hermes_Agent.md` car `.claude/` bloqué Cowork, 5 nouvelles auto-memories Cowork + 5 décisions D1-D5/S47)
- Archive S50 refonte vue Réseaux HA — `historique/2026-04-25_session_50_refonte_vue_reseaux.md` (refonte via `hass.callWS` bypass car MCP HA `Session terminated` toute la session, layout masonry 1 col → `type: sections, max_columns: 2`, suppression 2 cartes vitesse redondantes + carte AdGuard 13 entités mortes, ajout history-graph 24h combiné ↓+↑, 11 badges préservés, view 4044→3530 chars, tâche #62 monitoring OpenRouter ajoutée TASKS.md, 6 décisions D1-D6/S50, 4 pièges P1-P4/S50, 2 nouvelles auto-memories `feedback_hass_callws_bypass_mcp` + `feedback_lovelace_sections_render_delay`)
- [Bypass MCP HA via hass.callWS](feedback_hass_callws_bypass_mcp.md) — S50 25/04/2026 : règle transposable. Quand MCP HA cassé (Session terminated, add-on inactif, tunnel CF down), basculer sur `hass.callWS` JS direct dans Brave MCP (méthode officielle CLAUDE.md §3). 5 étapes documentées (lire config, modifier, save, vérifier, rollback)
- [Délai rendu vue type sections + badges](feedback_lovelace_sections_render_delay.md) — S50 25/04/2026 : règle. 1er reload après save d'une vue qui passe de masonry → `type: sections` + badges browser_mod = page vide 5-7s voire screenshot timeout 30s. Ne pas rollback prématurément, naviguer ailleurs puis revenir débloque
- Archive S51 décongestion CLAUDE.md / METRIQUES.md — `historique/2026-04-25_session_51_decongestion_claudemd_metriques.md` (tâche #61 FAIT en ~30 min, application règle « pointer, don't embed » S49 ; CLAUDE.md L225 footer 109 513 chars → 5 lignes pointeur ; METRIQUES.md L3 frontmatter 55 973 chars → 1 ligne pointeur ; gain ~169 047 chars / ~42 261 tokens libérés/tour ; -76,5 % poids combiné ; backup local `memory/_decongestion_backup_s51/` rollback safe ; aucune référence vivante cassée — vérifié grep skills/scripts/Ressources)

---

*Fichier cree lors de la migration architecture le 19 avril 2026, clarifie le
20 avril 2026 (session 17) pour distinguer les scopes CLI local vs Cowork web.*
