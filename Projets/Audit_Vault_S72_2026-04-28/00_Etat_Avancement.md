# Audit Vault Obsidian — S72 — État d'avancement

**Date début** : 2026-04-28
**Périmètre** : `Wiki/` (143 fichiers .md)
**Mode** : autonome, sous-agents en parallèle, checkpoints réguliers

## Vagues

### Vague 1 — analyses globales (TERMINÉE)
- [x] Agent A — Liens cassés + atomes orphelins → `01_Agent_A_Liens_Orphelins.md`
- [x] Agent B — Frontmatter + tags + encodage → `02_Agent_B_Frontmatter_Encodage.md`
- [x] Agent C — Hubs `_Index.md` désynchronisés → `03_Agent_C_Hubs_Desynchronises.md`
- [x] Agent D — Patterns sensibles (Règle 0) → `04_Agent_D_Patterns_Sensibles.md`

**Findings vague 1 (résumé)** :
- Wikilinks cassés : **36** (8,1% sur 445) — foyer Skills_Jarvis (préfixe `Wiki/` superflu × 9)
- Liens markdown : 0 cassé (excellent)
- Atomes orphelins : **11** (Email × 5, ViePerso × 2, Hardware_Upgrade × 2, autres × 2)
- Hubs désynchronisés : **2** (`00_Index/_Index.md` avec 3 entrées mortes, `Domotique/_Index` partiel)
- Frontmatter manquant : **1** (`Wiki/Wiki/Email/Gmail_MCP_Custom.md`)
- Encodage / BOM / line endings : OK (100% UTF-8 sans BOM)
- Sécurité Règle 0 : **0 hit critique** — caviardage S69/S70 correctement appliqué
- Anomalie majeure : `Wiki/10_Domaines/Email/Gmail_MCP_Custom.md` au chemin imbriqué `Wiki/Wiki/...`

### Vague 2 — cohérence factuelle par domaine (TERMINÉE)
- [x] Agent E — HomeAssistant + Reseau + Procedures + Hardware → `05_Agent_E_Coherence_Technique.md`
- [x] Agent F — Email + Traduction + ViePerso + Inventaire + Outils + Domotique → `06_Agent_F_Coherence_Workflow.md`
- [x] Agent G — ADR + Veille + Skills_Jarvis + Hermes_Agent + Hardware_Upgrade → `07_Agent_G_Coherence_Projets.md`

**Findings vague 2 (résumé)** :
- **Cohérence technique** : 0 contradiction factuelle sur 45 atomes (URLs, versions, IPs, ports, sécurité tous alignés)
- **Doublon Browser Mod** : 95% identique entre `Domotique/` et `Outils/` — fusion recommandée (garder Outils, plus riche)
- **Débannissement IP × 4** : redondance INTENTIONNELLE (audiences différentes : hub/synthèse/skill/procédure) — garder tous mais améliorer cross-links
- **Gmail MCP custom × 3** : Hub `Email/Gmail MCP custom.md` + source technique `Ressources/Competences/Gmail_MCP_Custom.md` complémentaires + **fichier orphelin imbriqué `Wiki/Wiki/...` à SUPPRIMER**
- **Bascule conversation × 2** : pas un doublon, audiences complémentaires (skill technique vs procédure pédagogique)
- **Inventaire** : 10 atomes pièces à 95% vides (status `coquille`, attendu)
- **ADR** : 3 accepted + 7 rejected cohérents, dette mineure (cross-référencement A003 ↔ ADR-002/003 rejected)
- **Hermes_Agent** : phases 1bis-a/b/c/d cohérentes avec mémoire S41/46/48/53
- **Hardware_Upgrade** : files 02/03 ne renvoient pas vers 08_Audit_S63 (contexte changé post-S63)

### Vague 3 — synthèse + plan correction (TERMINÉE)
- [x] Rapport consolidé → `99_Rapport_Final_Synthese.md`
- [x] Patch list priorisée P0/P1/P2/P3 (10 actions, ~30-45 min effort total)

### Vague 4 — corrections autonomes (TERMINÉE 28/04/2026)

Corrections appliquées directement (non-risquées) :

- [x] **P0.2** — 9 wikilinks `Wiki/10_Domaines/...` corrigés dans 6 fichiers `Skills_Jarvis/*.md`
- [x] **P1.1** — `00_Index/_Index.md` : 3 entrées mortes nettoyées + ajout 7 domaines manquants (ADR, Hardware, Inventaire, Procedures, Skills_Jarvis, Veille, Hermès Agent) + 2 projets actuels (Hardware_Upgrade, AI_Prompt_Design)
- [x] **P1.4 + P2.4 / P2.5 / P2.7** — 4 wikilinks divers corrigés (accents, cibles renommées, dossiers déplacés)
- [x] **P1.3** — orphelins ajoutés : 6 atomes manquants dans `ViePerso/_Index.md` ; tableau `Hardware_Upgrade/README.md` transformé en wikilinks actifs (10 fichiers)
- [x] **P2.2** — notes ajoutées dans `Hardware_Upgrade/01_Architecture_cible.md` et `03_Phasage_A_a_G.md` renvoyant vers `08_Audit_S63` ; Phase A marquée `VALIDÉE S63`
- [x] **P2.3** — section « Leçons des rejets antérieurs » ajoutée dans `ADR-A003-rtx3090-suffisant-hermes.md` avec cross-réf vers ADR-002 et ADR-003 rejected
- [x] **P3.5** — cross-link bidirectionnel ajouté entre `Outils/Bascule conversation` et `Procedures/Bascule Conversation Limite Contexte`
- [x] **P3.6** — lien vers `Macros clavier` ajouté dans `Email/Redaction email.md`
- [x] **P3.1** — tous les "placeholders" de l'audit étaient des **faux positifs** (entre backticks, contexte pédagogique). Aucune correction nécessaire.

**Vérifications post-corrections** :
- 0 occurrence résiduelle de `Wiki/10_Domaines/` (préfixe superflu)
- 0 référence aux dossiers inexistants `Procedures_Rares` / `Reseau_Securite`
- 0 wikilink vers ancienne cible `Hermes_Agent/_Index`
- Toutes nouvelles cibles confirmées présentes sur disque (`15_Hermes_Agent/INDEX`, `Reseau/_Index`, `Procedures/_Index`)

### Vague 5 — actions risquées validées par Mickaël (TERMINÉE 28/04/2026)

- [x] **P0.1** — `Wiki/Wiki/10_Domaines/Email/Gmail_MCP_Custom.md` SUPPRIMÉ (+ dossiers parent vides)
- [x] **P1.2** — Fusion `Browser Mod.md` faite : enrichissement de `Outils/Browser Mod.md` avec contenu unique de Domotique, suppression de `Domotique/Browser Mod.md`, redirection dans le hub `Domotique/_Index.md`
- [x] **Artefact .txt** — `Projets/Audit_Vault_S72/01_Agent_A_Liens_Orphelins.txt` SUPPRIMÉ
- [x] **P2.8** — cible validée : `[[Cloudflare_Access_HA]]` → `[[10_Domaines/Reseau/Cloudflare_Setup]]` dans `Setup_Install.md`
- [x] **P3.3** — champ `updated:` introduit dans 138 fichiers du vault (19 fichiers S72 → `2026-04-28`, 119 autres → valeur `created:`, 3 déjà présents)

**Vault après corrections** : 141 fichiers (143 - 2 suppressions = -1 orphelin imbriqué -1 fusion Browser Mod).

### Actions encore à clarifier / arbitrer
- [ ] **P2.6** — décider du sort du lien `Inventaire/_Index → Ressources/Competences/Home_Assistant_Inventaire.md` (hors vault)
- [ ] **P3.2** — décision normalisation tags (220 distincts, mix flat/hiérarchique)
- [ ] **Domotique/_Index** — compléter les 6 équipements TODO (TV, Apple TV, EcoFlow, prises, imprimante 3D, Music Assistant)

---

## Synthèse audit

**Verdict global : BON — vault structurellement sain à 92%.**

**À corriger en P0 (2 actions, trivial)** :
1. Supprimer `Wiki/Wiki/10_Domaines/Email/Gmail_MCP_Custom.md` (orphelin imbriqué)
2. `sed` préfixe `Wiki/` dans `Skills_Jarvis/*.md` (corrige 9 wikilinks + résout 5 orphelins par effet de bord)

**Effets prévisibles après P0+P1** :
- 36 wikilinks cassés → ~5 (1,1%)
- 11 orphelins → ~3
- 1 doublon réel → 0
- 24 hubs → 100% synchronisés

**Sécurité Règle 0 : EXCELLENT (0 hit critique).**

## Anomalies déjà repérées (avant sous-agents)

1. **Doublons probables** (à arbitrer en V2) :
   - `Débannissement IP` : 3 fichiers (HomeAssistant/, Outils/, Procedures/)
   - `Browser Mod` : 2 fichiers (Domotique/, Outils/)
   - `Bascule conversation` : 2 fichiers (Outils/, Procedures/)
   - `Gmail MCP custom` vs `Gmail_MCP_Custom` (le second en chemin imbriqué)

2. **Anomalie majeure** : fichier au chemin imbriqué `Wiki/10_Domaines/Email/Gmail_MCP_Custom.md` — vraisemblablement un artefact créé par erreur lors d'une session passée.
