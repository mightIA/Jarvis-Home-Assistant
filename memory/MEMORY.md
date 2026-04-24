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

---

*Fichier cree lors de la migration architecture le 19 avril 2026, clarifie le
20 avril 2026 (session 17) pour distinguer les scopes CLI local vs Cowork web.*
