---
id: 91
title: "Veille automatisée hebdomadaire écosystème MCP / add-ons HA / plugins Claude Code"
status: open
priority: P3
session_opened: S92
tags: [veille, mcp, automation, ha, cowork, mode-reactif]
source: "Session 92 / Demande Mickael (post-abandon T#48)"
---

# T#91 — Veille auto écosystème MCP / add-ons / plugins

## Description

Mettre en place une **veille automatisée hebdomadaire** sur les nouveautés
écosystème pertinentes pour le stack Jarvis. Objectif : recevoir chaque
dimanche un rapport synthétique avec les nouveautés intéressantes à tester,
sans avoir à scruter manuellement les registres / GitHub / forums.

**Contexte d'origine** : T#48 (MCP Outlook softeria) abandonnée S92 après
2 murs Microsoft pour comptes perso `@live.fr`. Mickael ne veut pas
re-lancer un setup tel que celui-ci à la main. Une veille auto permet de
détecter quand un nouveau MCP Outlook 1-clic émerge OU quand softeria
patche son app reg shared (issue #288 et apparentées) → réactivation
automatique de T#48 le moment venu.

## Spec validée S92

### Trigger

- **Scheduled Task Windows** : `Jarvis-Veille-Ecosystem-Hebdo`
- **Fréquence** : hebdomadaire, **dimanche 04h00** (heure creuse, quota Max préservé)
- **Pattern d'exécution** : `claude -p` headless CLI (analogue mode réactif S78)
- **Durée estimée par run** : 5-15 min selon nombre de sources scrutées

### Périmètre couvert

| # | Catégorie | Sources |
|---|-----------|---------|
| 1 | **MCP servers** | Anthropic registry + mcpservers.org + lobehub.com/mcp + GitHub topic `mcp-server` + awesome-mcp-servers list |
| 2 | **Add-ons HA** | Repo officiel HA + community + HACS marketplace |
| 3 | **Plugins Claude Code** | Marketplace officiel + GitHub topic `claude-code-plugin` |
| 4 | **Updates majeures MCPs installés** | ha-mcp + gmail-mcp-local + pdf-toolkit (versions majeures uniquement) |
| 5 | **Veille T#48 spécifique** | softeria patches issue #288 + autres MCPs Outlook compatibles compte perso → alimente critères de réactivation T#48 |

### Filtres "intéressant"

Une nouveauté est retenue dans le rapport si **TOUS** les critères suivants sont vrais :

- Pertinent pour stack Jarvis (HA / email / automation perso / sécurité / domotique / pdf / vie perso)
- Maintenu (last commit < 6 mois)
- Stars GitHub > 50 **OU** explicitement maintenu par éditeur reconnu (Anthropic, Cloudflare, Microsoft, etc.)
- Pas de CVE haute/critique non patchée (`npm audit` / `pip-audit` selon stack)
- Pas déjà recommandé dans un précédent rapport (anti-doublon, mémoire courte 4 semaines)

### Output

- **Fichier rapport** : `memory/historique_reactif/AAAA-MM-JJ_veille_ecosystem.md`
- **Notification email** : vers `might57290@gmail.com` via `notify.might57290_gmail_com` HA (sans PJ, lien vers fichier dans le corps)
- **Label Gmail** : `Jarvis-Veille` (à créer S92 ou première exécution)
- **Format rapport** : 5 sections (1 par catégorie périmètre), chacune avec tableau :

  | Nom | Catégorie | Pourquoi intéressant | Effort test estimé | Lien |

  + section **"Recommandations Mickael"** en haut (top 3 à tester ce mois-ci, justifié)

### Critères de succès

1. 1er rapport complet généré + reçu par email + 1-2 propositions de test pertinentes pour Jarvis
2. Anti-doublons fonctionnel (vérification : 2 rapports consécutifs ne doivent pas re-citer la même nouveauté en "à tester")
3. Pas de faux positifs criants (rapport ne doit pas pousser des MCPs morts / abandonnés / hors scope)

## Pré-requis identifiés

- ✅ Mode Réactif Phase 1 opérationnel (Task Scheduler + claude -p headless validés S78)
- ✅ Notify HA `notify.might57290_gmail_com` opérationnel
- ❌ Skill nouvelle à créer : `veille-ecosystem` (pattern analogue `tri-email-gmail-quotidien`)
- ❌ Label Gmail `Jarvis-Veille` à créer (CLI via gmail-mcp-local `create_label`)

## Plan d'implémentation (5 phases)

### Phase 0 — Recherche et structure (~30 min)

- Lister les 5 sources de veille avec URLs précises
- Définir format de mémoire courte (anti-doublon) : fichier `memory/veille_blacklist.md` ou similaire
- Concevoir le prompt de veille (template `claude -p` headless)

### Phase 1 — Création skill `veille-ecosystem` (~45 min)

- `.claude/skills/veille-ecosystem/SKILL.md`
- Description claire pour auto-déclenchement
- Procédure étape par étape (recherche → filtre → rapport → notif)

### Phase 2 — Test manuel premier rapport (~20 min)

- Exécution interactive pour valider le format
- Itération sur le prompt si rapport médiocre
- Validation par Mickael

### Phase 3 — Automatisation Scheduled Task (~15 min)

- Création de la Scheduled Task Windows
- Test de déclenchement manuel
- Validation que claude -p tourne bien sans interactivité

### Phase 4 — Production + monitoring (~10 min sur 2-3 semaines)

- Run pendant 2-3 dimanches
- Ajustements filtres / prompt selon retour Mickael
- Si stabilisé → close-task

## Statut

🟢 `open` — créée S92 (03/05/2026), à planifier en P3 (pas urgent).
Trigger probable : prochaine session Cowork dédiée veille (estimée 1-2h
total pour Phase 0+1+2 puis automatisation Phase 3).

## Sources / refs

- Précédent T#48 abandon S92 : `memory/project_t48_outlook_mcp_abandon_s92.md`
- Pattern Mode Réactif S78 : `Ressources/Competences/Mode_Reactif.md`
- Skill `tri-email-gmail-quotidien` (pattern analogue) : `.claude/skills/tri-email-gmail-quotidien/`
