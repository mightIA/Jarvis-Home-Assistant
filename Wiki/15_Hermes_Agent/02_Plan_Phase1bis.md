---
title: 02 — Plan Phase 1bis (extract Ch.6 source)
created: 2026-04-27
migrated_from: Projets/Jarvis_Hermes_Projet/Projet_Complet.md (Ch.6, lignes 341-426)
date_origine: 2026-04-24 (session 36)
type: plan-phasage
domaine: Hermes_Agent
status: 1bis-d-en-cours
tags: [hermes, agent, phasage, phase1bis, plan, s36]
---

# 02 — Plan Phase 1bis (extract Ch.6)

Extrait du chapitre 6 « Phasage et timeline » du `Projet_Complet.md` rédigé en session 36 (24/04/2026). Document de référence pour le plan d'implémentation Hermès.

> ⚠️ **Annotations post-S68** ajoutées en encart à chaque phase pour refléter l'avancement réel constaté en sessions S39-S67. Le texte source est repris intégralement.

---

## 6.1 Vue d'ensemble des phases

![Timeline du projet Jarvis → Hermes Agent](schemas/07_timeline.png)

> 🔎 **Annotation post-S68** : le schéma `schemas/07_timeline.png` n'a pas été migré dans le vault (image embarquée du PDF). Voir `Projets/Jarvis_Hermes_Projet/` pour la version PDF originale (`Projet_Complet.pdf` ou `Projet_Complet_v2.pdf`).

## 6.2 Détail de chaque phase

### Phase 1 — Étude LLM Wiki Karpathy (fait, session 36)

**Livrable** : rapport de 12 pages `Projets/Jarvis_Hermes_Projet/Rapport_Phase1.md` + PDF équivalent.

**Conclusion** : refonte complète en pattern Karpathy pur = NON (Jarvis déjà à 130–165 .md dans la zone où Zafer Dace a documenté une panne à 80–100 articles ; doublon à 90 % avec l'infrastructure Jarvis existante ; mismatch entre le cas d'usage encyclopédique du pattern et le cas d'usage opérationnel de Jarvis).

### Découverte Hermes Agent (fait, session 36)

Suite aux questions de Mickael (Q1–Q7), recherche intensive sur "Hermès + Claude + Obsidian". **Découverte majeure** : Hermes Agent existe déjà, produit Nous Research MIT lancé 02/2026, qui implémente nativement ce que le schéma de Mickael décrivait. On ne fabrique rien, on installe un produit existant.

**Livrable** : 6 auto-memories créées, archive session exhaustive, décisions Q1–Q4 validées par Mickael.

### Phase 1bis — Étude de faisabilité Hermes sur la config Mickael (à venir)

**Durée estimée** : 1 session dédiée (~1 h).

**Pré-requis** : Mickael partage un descriptif PC complet (Speccy Publish Snapshot, DxDiag complet, ou HWiNFO64). Le DxDiag partiel reçu en session 36 confirme l'essentiel (i9-9900K, 32 Go RAM, Windows 11 Pro build 26200, dGPU présent) mais la section Display Devices manque pour la VRAM RTX 3090 exacte, et Disk pour le stockage NVMe.

**Livrable attendu** : rapport `Projets/Jarvis_Hermes_Projet/Rapport_Phase1bis.md` détaillant le plan d'installation pas-à-pas, la liste exacte des modèles à télécharger, le plan de migration des skills Jarvis, le budget tokens prévisionnel, et l'application de la Règle 0.

> 🔎 **Annotation post-S68** : Phase 1bis a été décomposée en 4 sous-phases :
> - **1bis-a** Obsidian vault setup ✅ FAIT S41
> - **1bis-b** Mistral Doc AI test ✅ CLÔTURÉE S46 (recommandation stack hybride pdf-toolkit + Mistral OCR)
> - **1bis-c** Hermes Agent install ✅ CLÔTURÉE 100 % S48 (4 modèles testés, V1 partiellement validé)
> - **1bis-d β1** activation `enable_tool_search` côté add-on ha-mcp ✅ ON S53 (lecture OK 100 %, écriture KO confirmée pattern S48)
> - **1bis-d retest post `hermes update`** ✅ VALIDÉ V1 3/3 S63 (qwen35-agent + 4 commits critiques `reasoning_content`)

### Phase 2 — Installation effective (à venir)

**Durée estimée** : 2–3 sessions, ~3–5 h cumulées.

Étapes :

1. Installation WSL2 Ubuntu 24.04 sur le PC Windows (si pas déjà fait)
2. Installation NVIDIA CUDA drivers pour WSL2 (GPU passthrough)
3. Installation Ollama dans WSL2, configuration
4. Téléchargement modèles (`ollama pull qwen3:32b`, etc.)
5. Installation Hermes Agent (`curl install.sh | bash`)
6. Configuration `~/.hermes/config.yaml` — providers, MCPs, gateways
7. Activation gateway Home Assistant (add-on HA à installer ou webhook)
8. Activation gateway Telegram (création bot, token, config)
9. Test V1 sur 1 tâche simple (tri d'un email de test) 
10. Validation Mickael → Phase 3

> 🔎 **Annotation post-S68** : Phase 2 a été **anticipée** dans Phase 1bis-c (S48) : install WSL2 + Ollama + Hermès + 4 modèles + ha-mcp gateway tous faits. Reste : test V1 tâche simple validation Mickael → Phase 3. La gateway Telegram n'a pas été activée (pas de besoin actuel).

### Phase 3 — Migration progressive des skills (semaines à mois)

Chaque skill Jarvis actuelle (`.claude/skills/*`) est migrée **une à une** sous Hermès :

- Priorité 1 : `tri-email-gmail` (ROI le plus fort, tourne plusieurs fois par jour)
- Priorité 2 : `check-jarvis-alert` (Mode Réactif, tourne quotidiennement)
- Priorité 3 : `rapport-journalier-reactif` (tourne quotidiennement)
- Priorité 4+ : les autres skills, selon fréquence d'usage

Pour chaque migration :

1. Skill dupliquée sous Hermès (Skill memory)
2. Test en parallèle sur 1 semaine (Cowork + Hermès tournent tous les deux, comparaison des résultats)
3. Si Hermès donne résultats équivalents ou meilleurs → la skill Cowork est marquée OBSOLETE
4. Si problème détecté → rollback immédiat, investigation

**Principe** : Cowork reste **source de vérité** tant que la skill Hermès n'est pas validée. Aucun risque de perte fonctionnelle.

> 🔎 **Annotation post-S68** : Phase 3 **non démarrée** — bloquée tant que la décision T#11 sur les 3 patterns sensibles n'est pas prise. Voir `03_Decision_Q1-Q8.md`.

### Régime croisière (cible)

Une fois la migration stabilisée :

- Hermès tourne 24 h/24 en daemon WSL2
- Cowork s'ouvre à la demande pour les sessions créatives riches
- Mickael pilote Jarvis principalement via l'app HA sur iPhone (mobile) ou via Cowork (PC)
- Claude Max est préservé, OpenRouter consomme peu
- La mémoire d'Hermès compound au fil des semaines

> 🔎 **Annotation post-S68** : régime croisière **pas encore atteint**. État actuel = Hermès installé mais pas en daemon 24/7 (lancé à la demande). Cowork reste l'outil principal pour Mickael (>99 % des sessions).

## 6.3 Points de décision côté Mickael

> 📋 Détail complet des 4 décisions dans [`03_Decision_Q1-Q8.md`](03_Decision_Q1-Q8.md).

Quatre décisions formelles sont attendues :

1. **Lancer Phase 1bis ou reporter** → décision à prendre ponctuellement *(✅ lancée S41+)*
2. **Lancer Phase 2** → après lecture rapport Phase 1bis *(✅ anticipée S48 via Phase 1bis-c)*
3. **Budget OpenRouter** → création compte + dépôt 5–10 $ initial *(✅ FAIT S55, $20 dépôt one-time, cap $5/mois)*
4. **Priorité de migration** → valider l'ordre de migration des skills en Phase 3 *(⏳ en attente Mickael)*

Aucune de ces décisions n'est urgente ni irréversible.

> 🔎 **Annotation post-S68** : 3 décisions sur 4 ont été prises et exécutées entre S41 et S55. Reste **D4** (priorité migration skills Phase 3) en attente. La décision est dépendante de **T#11** (3 patterns sensibles ha-mcp).

---

## Liens

- Source intégrale : [`01_Rapport_Phase1.md`](01_Rapport_Phase1.md)
- Décisions détaillées : [`03_Decision_Q1-Q8.md`](03_Decision_Q1-Q8.md)
- INDEX domaine : [`INDEX.md`](INDEX.md)
- Cookbook RTX 3090 : [`Cookbook_RTX3090/_Index.md`](Cookbook_RTX3090/_Index.md)
- Projet hardware lié : [`Wiki/20_Projets/Hardware_Upgrade/`](../20_Projets/Hardware_Upgrade/)

---

## Notes de migration vault (S68)

- Document **dérivé** du Ch.6 de `Projets/Jarvis_Hermes_Projet/Projet_Complet.md` (lignes 341-426 du source).
- Texte source repris intégralement, **annotations post-S68 ajoutées en encart** pour refléter l'avancement réel S39-S67.
- Aucun pattern sensible détecté.
