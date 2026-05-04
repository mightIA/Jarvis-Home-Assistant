# Memoire Jarvis — Index (Claude Code CLI local)

Ce fichier indexe les auto-memories CLI local (versionnées Git, scope `memory/` local).
**Complémentaire** aux auto-memories Cowork web listées dans `METRIQUES.md` section dédiée.

- **CLI local** (ce fichier) : visible sur le poste, écrit depuis Claude Code.
- **Cowork web** (`METRIQUES.md`) : serveur claude.ai, réinjecté auto en conv Cowork.

---

## Référence rapide

- Sessions historiques : `memory/historique/AAAA-MM-JJ_session_NN_titre.md`
- Profil + contexte : `CONTEXTE.md` (racine)
- Tâches : `TASKS.md` (index) + `tasks/task_NNN.md` (détail) + `tasks/archive_2026-Q2/`
- Métriques : `METRIQUES.md` (compteurs) + archive : `memory/historique/METRIQUES_archive_2026-Q2.md`
- Skills : `.claude/skills/<nom>/SKILL.md` — index détaillé : `memory/SKILLS_INDEX.md`

---

## Entrées mémoire CLI local

### Projets en cours

- [Projet AI Prompt Design](project_ai_prompt_design.md) — framework prompts 3 IA images + 7 IA vidéo, workflow itératif scoring /50 et /65, T#74 in_progress, v1.1 stabilisée S91 (3 mai 2026).
- [Projet Hardware Upgrade BoM v3 S94](project_hardware_upgrade_bom_v3_s94.md) — *(superseded par v4 S101)* BoM v3 mai 2026 (3 290 €, 7 composants), CPU 9950X3D + waterblock XC7 LCD + ProArt X870E + 64 Go DDR5 + 990 Pro 2 To. DRAM/NAND crisis assumée.
- [Projet Hardware Upgrade BoM v4 S101](project_hardware_upgrade_bom_v4_s101.md) — **BoM finale mai 2026 prête à commander (3 662,44 €)**, panier Amazon 6 articles + RAM DDR4 PC domo Schnaeppchen-Schuppen 259 € déjà commandée. Décisions clés : ROG Hero standard (pas BTF/Extreme), 96 Go Z36 CL36 = meilleur deal marché DDR5 cassé, SSD 9100 Pro Gen5, alim HX1500i Shift NEUF + HX1000i ancienne en PC domo, CPU sécurisé Amazon direct vs Abracadabra23. T#73 reste cancelled, BoM hors tâche. PDF + markdown livrés `Projets/Hardware_Upgrade/10_*`.

### Hardware — références figées

- [RAM existante PC Might-1000D](reference_ram_corsair_pc_actuel.md) — Corsair Vengeance RGB Pro SL DDR4-3600 CL18 `CMW32GX4M2Z3600C18` (slots A2+B2). Racheter identique pour 64 Go PC domo, surtout PAS Crucial 2666 CL19 (mismatch fatal).
- [DRAM/NAND crisis 2026](reference_dram_nand_crisis_2026.md) — multiplicateurs prix mémoire ×3-5 entre 2024-2025 et mai 2026, cause HBM IA, détente prévue 2027-2028. Toujours valider prix multi-source jour J (LDLC + Materiel.net + Amazon.fr ASIN + idealo).

### Règles d'écriture / formatage

- [notify gmail target requis](feedback_notify_gmail_target.md) — `data.target=["..."]` obligatoire sinon HTTP 500.
- [Pièges pandoc + LaTeX custom](feedback_pandoc_template_pieges.md) — 4 pièges XeLaTeX (babel→polyglossia, `$`, MakeUppercase, DejaVu).
- [Préférence "Ubuntu" vs "WSL2"](feedback_terminologie_ubuntu.md) — S70 : dans blocs à coller, dire "Ubuntu (bash)".
- [Set-Content -Encoding UTF8 = BOM en PS 5.1](feedback_set_content_utf8_bom_ps51.md) — S108 : éviter dans Git commit messages / JSON / YAML, utiliser `[System.IO.File]::WriteAllText(... UTF8Encoding($false))`.

### Tri email — pièges UI

- [Outlook mode Sélection sticky → F5](feedback_outlook_sticky_select_mode.md) — S82 : Sélection ne se désactive pas (re-clic ni Esc), F5 obligatoire pour faire réapparaître « Vider le dossier ».

### Décongestion / pattern fichiers vivants

- [Décongestion CLAUDE.md / METRIQUES.md](feedback_claudemd_decongestion.md) — S49 : règle "pointer, don't embed". 5 leviers communautaires. Appliqué S51 (~42 K tokens/tour libérés).
- [Seuils décongestion](feedback_decongestion_seuils.md) — S52 : Vert/Jaune/Orange/Rouge, mesure 1 commande Bash, skill `decongestion-fichiers-vivants`, politique trimestrielle.

### Obsidian / vault

- [Obsidian vault Wiki Jarvis](reference_obsidian_vault.md) — S41 : `Wiki/`, structure PARA, 4 plugins gratuits (Dataview/Templater/Excalidraw/Git).
- [Obsidian install Desktop](reference_obsidian_install.md) — S41 : procédure réinstall (mode "Juste pour moi", pièges plugin Git).
- [Pas de plugin payant Obsidian](feedback_obsidian_pas_de_plugin_payant.md) — Phase 1bis-a : Hermès + Qwen Embedding 4B local fait mieux.

### Git / GitHub

- [Git Jarvis repo S42](reference_git_jarvis_repo.md) — repo `main` commit `3a63421`, 130 fichiers, .gitignore strict Q1-Q4.
- [Sandbox Cowork bash bloque Git](feedback_git_sandbox_cowork_bloque.md) — git via PowerShell uniquement, pattern brain+hands.
- [Sandbox Cowork ne mappe pas `D:\Might\Claude\Scheduled\`](feedback_sandbox_cowork_scheduled_dir.md) — S96 : suppression Cowork scheduled task via UI Cowork ou PowerShell `Remove-Item`, jamais Bash. Toujours désactiver avant de supprimer.
- [Procédure init repo public mightIA](reference_github_repo_public_init.md) — S64 : 4 étapes réutilisables.
- [Repo Cookbook Hermès RTX 3090](reference_cookbook_hermes_repo.md) — S64 : `github.com/mightIA/hermes-agent-rtx3090-cookbook`, public, MIT.
- [Caviardage email no-reply](feedback_github_noreply_email.md) — S64 : `user.email = 278813549+mightIA@users.noreply.github.com`.

### Sécurité — hooks et garde-fous

- [Hook PreToolUse check-secrets — Renfort Règle 0](reference_hooks_securite_p2.md) — S72 (P2) : `.claude/hooks/check-secrets.sh` exit 2 sur credentials/secrets/SSH/.env/.mcp.json. 7 règles, 14/14 tests OK.
- [Bug hook check-secrets sur chemins Windows espacés (T#93)](feedback_check_secrets_hook_chemins_windows.md) — S95 : erreur `bash: /d/Might/IA/Projets: No such file or directory` à chaque action Bash claude CLI dans projet Jarvis (chemin avec espaces). Non-bloquant. Cause : variables path non quotées. Fix prévu T#93.

### Cowork desktop — limites techniques

- [Cowork ne résout pas @imports](reference_cowork_imports_non_supportes.md) — S75 : test phrase-canari `LIBELLULE-3742` concluant. Syntaxe officielle Claude Code `@path/file.md` non appliquée par Cowork desktop. Conséquence : refonte massive CLAUDE.md via imports impossible.
- [4 toggles "Capacités" Cowork](reference_cowork_capacites.md) — S83 : Artefacts/Visualisations/Exécution code ON, Sortie réseau OFF (sécurité). Impact concret par toggle, recommandations.
- [Cowork Desktop — Paramètres avancés](reference_cowork_parametres_avances.md) — S83 : Général/Claude Code/Cowork/App bureau (Général/Extensions/Développeur). Posture sécurité validée. "Maintenir actif" passé ON pour T#52.

### Connecteurs MCP — référence enrichie

- [Connecteurs MCP — détails Permissions/Pièges](reference_mcp_connecteurs.md) — S75 : compagnon §6 CLAUDE.md, détaille Gmail/HA/Chrome/PDF Tools (3 sous-bullets `pdf-toolkit`).
- [Audit workflows Brave/Chrome → MCP (T#49)](reference_audit_workflows_brave_mcp_s84.md) — S84 : 8 skills auditées, T#48 débloque 3, T#87 teste Cloudflare MCP, 3 cas non-migrables documentés. Source règle CLAUDE.md §4.
- [MCP `ha_call_service` pour script — entity_id dans data](feedback_mcp_call_service_script_entity_id.md) — S84 : pour appeler un script via MCP, `entity_id: "script.NAME"` dans `data` (pas target) sinon HTTP 500. Astuce empirique T#53.

### Home Assistant — TTS / vocal

- [HA TTS URL locale renvoyée en distance](feedback_ha_tts_url_locale_distance.md) — S84 : HA renvoie `http://192.168.1.11:2096/api/tts_proxy/...` même en distant. Browser Mod / clients distants ne peuvent pas joindre. À corriger via `external_url`. T#89.
- [Canal TTS TV Samsung Q80 via Music Assistant DLNA](reference_canal_tts_tv_q80_dlna.md) — S91 (T#89) : Samsung Smart TV WS muet pour TTS. Solution `media_player.samsung_q80_series_65_2` (Music Assistant) + désactivation toggle « Enable AirPlay support » force DLNA. Pattern transposable Tizen Q60/Q70/Q80/Q90.

### Home Assistant — mobile / iOS

- [VPN iPhone bloque HA Companion](feedback_iphone_vpn_bloque_ha.md) — S91 (T#89) : VPN actif iPhone bloque totalement notifs `notify.mobile_app_might_iphone` (silence complet). Différent de T#88 (titre OK / message vide). Tests `script.jarvis_voice` : désactiver VPN d'abord.

### Architecture — sub-agents

- [Sub-agents P3 (audit/email/ban-IP)](reference_sub_agents_p3.md) — S73 (P3) : 3 sub-agents `.claude/agents/*.md` (audit-securite-ha opus, redacteur-email sonnet, debannissement-ip sonnet). Format `mcp__<server>__<tool>` validé, test grandeur nature S74.

### Home Assistant / sécurité

- [Bypass MCP HA via hass.callWS](feedback_hass_callws_bypass_mcp.md) — S50 : fallback quand MCP HA cassé. 5 étapes documentées.
- [Délai rendu vue type sections](feedback_lovelace_sections_render_delay.md) — S50 : 1er reload après save = page vide 5-7s. Naviguer ailleurs et revenir.
- [Rotation secret = preuve curl OBLIGATOIRE](feedback_rotation_secret_curl_obligatoire.md) — S70 : curl 405 nouveau + 404 ancien AVANT propagation patches.
- [HomePod Mini ≠ Apple TV salle de bain](feedback_homepod_vs_appletv.md) — S79 : confusion historique (intégration `apple_tv` couvre les 2). model=HomePod Mini, audioOS 26.4.

### Recherche / documentation externe

- [Vidéo ParlonsIA Obsidian + Claude](reference_video_parlonsia_obsidian_claude.md) — S38 : 3 idées techniques retenues (Mistral OCR, Qwen Embedding 4B, sub-agents wiki_*).
- [Disclaimer YouTube IA](feedback_video_disclaimer_voix_ia.md) — règle : voix IA, recouper systématiquement avec source primaire.
- [Doc Hardware_Upgrade](../Projets/Hardware_Upgrade/Documentation/) — S59 : PDF 36 p + REPRISE_CONVERSATION.md + archive ChatGPT.

### Archives sessions importantes (pointeurs)

- S43 hub Traduction → `historique/2026-04-25_session_43_hub_traduction.md`
- S44 hub Email → `historique/2026-04-25_session_44_hub_email.md`
- S45 hubs Outils + Vie perso (Phase A vault terminée 5/5) → `historique/2026-04-25_session_45_hubs_outils_vieperso.md`
- S46 Phase 1bis-b Mistral CLÔTURÉE → `historique/2026-04-25_session_46_phase1bisb_cloture.md`
- S47 Phase 1bis-c install Hermès Agent → `historique/2026-04-25_session_47_phase1bisc_hermes_install.md`
- S49 recherche décongestion → `historique/2026-04-25_session_49_recherche_claudemd_volumineux.md`
- S50 refonte vue Réseaux HA → `historique/2026-04-25_session_50_refonte_vue_reseaux.md`
- S51 décongestion CLAUDE+METRIQUES → `historique/2026-04-25_session_51_decongestion_claudemd_metriques.md`
- S52 décongestion TASKS → `historique/2026-04-25_session_52_decongestion_tasksmd.md`
- S54 fix connecteur Cowork ha-mcp → `historique/2026-04-26_session_54_fix_connecteur_cowork.md`
- S59 PDF Architecture Hardware → `historique/2026-04-26_session_59_pdf_architecture_v3_reprise_conv.md`
- Archive Q2 2026 TASKS → `historique/TASKS_archive_2026-Q2.md`
- Archive Q2 2026 METRIQUES → `historique/METRIQUES_archive_2026-Q2.md` (créée S71, enrichie S72)
- S72b audit architecture P1+P2 (décongestion METRIQUES + hooks §0) → `historique/2026-04-28_session_72b_audit_architecture_P1_P2.md`
- S73 P3 audit architecture (3 sub-agents `.claude/agents/`) → `historique/2026-04-28_session_73_p3_sub_agents.md`
- S74 audit structure fichiers vivants P0+P1 (7 anomalies corrigées, T#81 créée P2) → `historique/2026-04-28_session_74_audit_structure_fichiers_vivants.md`
- S75 refonte CLAUDE.md T#81 option C (test @imports concluant non supporté Cowork, footer externalisé, T#81 fermée) → `historique/2026-04-28_session_75_refonte_claudemd_option_c.md`

### Home Assistant — recorder / logs (T#34, S91)

- [HA recorder purge_keep_days](reference_ha_recorder_purge_keep_days.md) — Distinction BD recorder (purgée) vs LTS (∞). Valeur initiale 1, modifiée 35 S91. Restart Core obligatoire, pas d'effet rétroactif.
- [ha_get_logs source=error_log → 404](feedback_ha_get_logs_error_log_404.md) — Endpoint inexistant cette version HA. Workaround `source=system` (ERROR + WARNING). 5 pièges combinés à connaître pour skill ha-logs-archive.

### Claude Code CLI — limites sandbox

- [Sandbox CLI bloque Archives gitignored](feedback_claude_code_cli_sandbox_archives.md) — claude CLI v2.1.119 refuse l'écriture dans dossiers .gitignored même avec dangerouslyDisableSandbox. Cowork desktop OK, CLI bloqué. **DÉBLOQUÉ S95** par patch `.gitignore` (négation `Archives/ha_logs/`).
- [`--dangerously-skip-permissions` confirm 1ère fois](feedback_dangerously_skip_permissions_first_use.md) — S95 : flag déclenche menu interactif `1.No / 2.Yes` à la 1ère utilisation, bloque silencieusement le mode `-p` headless (run_*.txt à 0 octet). Solution : accepter une fois en interactif, choix mémorisé.
- [T#34 piste (a) — combo schtasks + claude CLI -p](reference_t34_piste_a_resolution.md) — S95 : pattern complet validé. 4 patches : `.gitignore` négation + `.bat` chemin absolu + diags pré-flight + `--dangerously-skip-permissions` accepté en interactif. Réutilisable pour toute skill HA Jarvis en background.

### Outlook MCP — T#48 ABANDONNÉE S92

- [T#48 abandon S92 + critères de réactivation](project_t48_outlook_mcp_abandon_s92.md) — Microsoft refuse app reg perso @live.fr (directory-less + sandbox Dev Program). 5 critères de réouverture listés. Veille auto via T#91. Workflow Brave conservé.
- [Bug softeria + --public-url + app reg default](feedback_softeria_redirect_uri_app_reg.md) — connaissance technique conservée (utile pour T#91 veille). Microsoft refuse redirect_uri custom car app reg softeria shared ne le whiteliste pas.
- [Tri Outlook Cowork report PC domotique](project_tri_outlook_cowork_report_pc_domotique.md) — S96 : `tri-email-outlook-quotidien` Cowork laissée enabled (seul dispositif might@live.fr) jusqu'à upgrade hardware. Re-éval post-PC domo (option D Windows ou D++ MCP IMAP).
- [Infra outlook-mcp S88 OBSOLÈTE](reference_setup_outlook_mcp_s88.md) — démantelée S92. Conservée pour contexte historique uniquement.

### Hermès Agent — update + tool calling

- [Procédure update Hermès v0.11→v0.12](reference_hermes_v012_update_procedure.md) — S93 : `hermes update`, drop stash auto (lockfiles npm cosmétiques), `git checkout` lockfile post-rebuild, restart + test fonctionnel S63 Test A. Pattern réutilisable pour les futures updates.
- [enable_tool_search OFF pour qwen35](reference_ha_enable_tool_search_qwen35.md) — S63 confirmé S93 : OFF (87 tools en clair) pour ≥27B Q4-Q5, ON (~20 tools filtrés) pour ≤14B. **Annule** auto-memory Cowork S53 qui disait toggle ON.
- [Qwen 3.6 sortie avril 2026 ratée par veille](project_qwen36_sortie_avril_2026.md) — S93 : 27B (22/04) + 35B-A3B MoE (16/04) ratés ~2 semaines. Confirme valeur T#91. À tester dans T#76 enrichi (4→6 modèles).
- [Modelfile copy-template](feedback_modelfile_copy_template_method.md) — S98 : si nouveau modèle a comportement dégradé (langue/sémantique/format), copier Modelfile baseline qui marche + swap FROM. Le SYSTEM+params font le bon comportement, pas le tag.
- [Protocole tests modèles 2 étages](reference_protocole_tests_modeles_hermes.md) — S98 : Étage 1 quick check Test B (4 critères OK/KO). Si OK 3/4 → Étage 2 Test C+A (6 critères /10). Anti-pattern conclure sur Test B seul.
- [Registry tests modèles Hermès](feedback_test_results_registry.md) — S98 : prompts.yaml FIGÉS + results.csv append-only 16 colonnes (`Projets/Cookbook_Hermes_RTX3090/tests/`). Tableaux comparatifs à la demande via awk/python pivot.

### Wyoming HA / TTS — bugs documentés S93

- [Bug Wyoming Piper switch voix par défaut](feedback_wyoming_piper_voice_switch_bug.md) — S93 : changer voix par défaut Piper + restart CASSE intégration Wyoming HA (entité unavailable). **Solution fiable** : restart HA Core complet.
- [reload_config_entry MCP insuffisant Wyoming](feedback_reload_config_entry_mcp_insuffisant.md) — S93 : `homeassistant.reload_config_entry` retourne success mais ne répare pas. Fausse impression de succès. Restart HA Core fiable à 100 %.
- [Pipeline Assist HA "Home Assistant" TTS=Aucun](project_pipeline_assist_tts_aucun.md) — S93 : Assist ne répond jamais à voix haute car TTS pas branché. À corriger en sélectionnant Piper. Hors scope T#92/T#89.

---

*Index créé S17 (20/04/2026), refondu S71 (28/04/2026) : groupement par thème + raccourcissement hooks ≤150 chars + retrait redondances. Voir `memory/_decongestion_backup_s71/MEMORY.md.bak` pour version pré-refonte.*
