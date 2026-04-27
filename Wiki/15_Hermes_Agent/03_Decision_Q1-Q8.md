---
title: 03 — Décisions Mickael (Ch.6.3 source)
created: 2026-04-27
migrated_from: Projets/Jarvis_Hermes_Projet/Projet_Complet.md (Ch.6.3, lignes 414-422)
date_origine: 2026-04-24 (session 36)
type: decisions-projet
domaine: Hermes_Agent
status: 3-prises-1-en-attente
tags: [hermes, agent, decisions, mickael, s36]
---

# 03 — Décisions Mickael (synthèse Ch.6.3 source)

> ℹ️ **Note de cadrage** : le titre de fichier `03_Decision_Q1-Q8` provient du plan de reprise S67. Le source S36 mentionne en réalité **4 décisions formelles** (D1-D4), pas 8. La numérotation Q1-Q7 du Ch.5 (questions initiales Mickael session 36) est **distincte** et concerne la phase de découverte produit Hermès, pas le phasage projet.

Cette fiche **suit l'état des décisions** dans le temps : chaque décision a son statut S36 (origine) + son statut post-S68 (avancement réel).

---

## D1 — Lancer Phase 1bis ou reporter

**Source S36** : « décision à prendre ponctuellement ».

**Statut post-S68** : ✅ **PRISE — lancée**.

**Avancement réel** :
- **1bis-a** Obsidian vault setup ✅ S41 (25/04/2026, ~50 min)
- **1bis-b** Mistral Doc AI test ✅ S45-S46 (test 2 v2 EN réussi 18/30 vs pdf-toolkit 5/30)
- **1bis-c** Hermes Agent install ✅ S48 (~3h30 mode normal forfait Max)
- **1bis-d β1** `enable_tool_search` ON ✅ S53 (lecture HA validée, écriture KO confirmée)
- **1bis-d retest post update** ✅ S63 (qwen35-agent V1 3/3 scénarios validés)

**Bilan** : Phase 1bis a duré **~5 sessions** au lieu de 1 prévue, mais a couvert 4 sous-phases au lieu d'1 phase unique. ROI très positif.

---

## D2 — Lancer Phase 2 (installation effective)

**Source S36** : « après lecture rapport Phase 1bis ».

**Statut post-S68** : ✅ **PRISE — anticipée dans Phase 1bis-c**.

**Avancement réel** :
- WSL2 Ubuntu 24.04 LTS installé S47
- Ollama installé S47 (4 modèles ~35 Go)
- Hermes Agent v0.11.0 installé S47-S48
- 6 modèles cumulés à fin S58 (~71 Go / 886 Go libres)
- Gateway HA (add-on `homeassistant-ai/ha-mcp`) installée S15-S16, exposée via Cloudflare Tunnel
- Gateway Telegram **non activée** (pas de besoin actuel signalé Mickael)

**Bilan** : Phase 2 fusionnée avec Phase 1bis-c. Pas de rapport `Rapport_Phase1bis.md` formel produit (le travail est documenté en archives de session + auto-memories + cookbook public GitHub).

---

## D3 — Budget OpenRouter (création compte + dépôt initial)

**Source S36** : « création compte + dépôt 5–10 $ initial ».

**Statut post-S68** : ✅ **PRISE — exécutée S55**.

**Avancement réel** :
- Compte OpenRouter créé S55 (might57290@gmail.com via Google OAuth)
- Email vérifié
- **Dépôt $20 USD** en mode `Use one-time payment methods` (CB non sauvegardée, auto top-up neutralisé)
- Clé API `Hermes-Jarvis` créée avec **cap $5/mois reset Monthly midnight UTC**
- Clé injectée dans `~/.hermes/.env` côté WSL2 via pattern sécurisé `read -s` (perms 600)
- Test `/auth/key` OK : `limit=5`, `limit_remaining=5`, `usage=0`

**Bilan** : budget initial **plus généreux** que prévu S36 ($20 vs 5-10 $) pour avoir de la marge. Cap mensuel strict $5 garde le risque sous contrôle.

---

## D4 — Priorité de migration des skills Phase 3

**Source S36** : « valider l'ordre de migration des skills en Phase 3 ».

**Statut post-S68** : ⏳ **EN ATTENTE Mickael**.

**Proposition source S36** :
1. `tri-email-gmail` (ROI le plus fort, tourne plusieurs fois par jour)
2. `check-jarvis-alert` (Mode Réactif, tourne quotidiennement)
3. `rapport-journalier-reactif` (tourne quotidiennement)
4. Autres skills, selon fréquence d'usage

**Bloqueurs identifiés post-S68** :
- **T#11** — 3 patterns sensibles ha-mcp (secret_path + clé OpenRouter + entry_id HA) à arbitrer avant tout début de Phase 3. Voir TASKS.md racine pour les valeurs précises (filtre vault).
- **Hermès écriture HA validée S63** mais pas encore testée sur skills réelles — risque de comportement différent vs scénarios audit.
- **Pattern `brain (Cowork) + hands (Claude Code CLI)`** établi pour Gmail write — à statuer si on bascule en `brain (Cowork) + hands (Hermès local)` pour les skills Phase 3.

**Décision pendante** : Mickael peut soit **valider la priorité S36** telle quelle, soit la **réviser** en fonction du contexte S67 (Mode Réactif fonctionne déjà 100 % CLI, le tri Gmail tourne en CLI — la Phase 3 n'est plus critique).

---

## Synthèse une ligne

> **3 décisions sur 4 prises et exécutées (D1, D2, D3) entre S41 et S55. D4 (priorité migration skills) reste en attente Mickael, dépendante de T#11 (3 patterns sensibles).**

## Liens

- Plan complet : [`02_Plan_Phase1bis.md`](02_Plan_Phase1bis.md)
- Rapport source intégral : [`01_Rapport_Phase1.md`](01_Rapport_Phase1.md)
- INDEX domaine : [`INDEX.md`](INDEX.md)
- T#11 (3 patterns sensibles) : voir `TASKS.md` racine projet

---

## Notes de migration vault (S68)

- Document **dérivé** du Ch.6.3 de `Projets/Jarvis_Hermes_Projet/Projet_Complet.md` (lignes 414-422 du source).
- Format adapté : tableau de 4 décisions avec statut S36 (origine) + statut post-S68 (avancement réel).
- Aucun pattern sensible détecté.
- Le titre de fichier `03_Decision_Q1-Q8` est conservé pour cohérence avec le Plan_Reprise S67, mais le contenu réel = 4 décisions D1-D4 (cohérent avec le source).
