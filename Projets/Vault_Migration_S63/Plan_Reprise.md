---
title: Plan de reprise — Vault Migration S63
created: 2026-04-27
session_origine: S67
---

# Plan de reprise migration vault

Ce plan documente exactement ce qui reste à faire après la session S67
(27/04/2026), pour permettre une reprise propre dans une future session
sans re-décortiquer le contexte.

## Phrase d'amorce reprise conv

> « Je veux finir la migration vault Jarvis. Lis le rapport
> `Projets/Vault_Migration_S63/README.md` puis le `Plan_Reprise.md`
> du même dossier, puis exécute les actions restantes en mode
> copie-only strict (aucun fichier source modifié). »

## Règles à respecter (rappel)

1. **COPIE-ONLY** : aucun fichier existant déplacé, supprimé, écrasé.
2. **Edit autorisé uniquement** sur les fichiers que Jarvis vient de créer
   dans `Wiki/` (correction patterns sensibles, MAJ MOC).
3. **Filtres sécurité actifs** :
   - `private_PfjEvJTqhCdo9ELRqCPADlzo`, `private_Q49aOxbSlqkilVOMVrlE4g`
   - `sk-or-v1-`, `sk-ant-`, `sk-`, `eyJ`
   - chaînes base32 16+ chars majuscules+chiffres
   - `01KPJ1CDZ8X7CYKBZRTKCZV2D4`
   - mdp, CB, IBAN, SS, adresse postale précise
   - **EXCEPTION** : numéros de série dongles Zigbee = OK (équivalent MAC)
4. **Au moindre doute** : pas propager, créer une note dans T#11 pour décision Mickael.

## Actions restantes par priorité

### Priorité 1 — T#3 Hardware (échec quota S67)

**3 sous-tâches** :

#### A. Copie totale `Projets/Hardware_Upgrade/` vers `Wiki/20_Projets/Hardware_Upgrade/`

Fichiers à copier (avec frontmatter enrichi) :
- `README.md`
- `00_Decisions_et_audits.md`
- `01_Architecture_cible.md`
- `02_BoM_finalisee.md`
- `03_Phasage_A_a_G.md`
- `04_Risques_et_mitigations.md`
- `05_Onduleurs_NUT.md`
- `06_Migration_HA_Pi5_Proxmox.md`
- `07_Frigate_VM_Coral.md`
- `Documentation/REPRISE_CONVERSATION.md`
- `Documentation/Sources/ChatGPT_Conv_Originale.md`

(PDF `Architecture_Jarvis_v3.pdf` reste en place, pas copié.)

Frontmatter type :
```yaml
---
title: <titre>
created: 2026-04-27
migrated_from: Projets/Hardware_Upgrade/<fichier>
status: en-attente-phase-A-Hermes
phase: 0
budget_target: 2410 EUR
bloqueur: hermes-phase-1bis-d
tags: [projet, hardware, proxmox, ryzen]
---
```

#### B. Copie totale `Projets/Cookbook_Hermes_RTX3090/` vers `Wiki/15_Hermes_Agent/Cookbook_RTX3090/`

Fichiers à copier :
- `README.md`
- `docs/journey-s57-s63.md`
- `docs/troubleshooting.md`
- `docs/configs.md`
- `docs/audit-methodologique.md`

(Pas LICENSE, pas .git/, pas .gitignore.)

Plus créer un `_Index.md` à la racine listant les 5 docs.

Frontmatter type :
```yaml
---
title: <titre>
created: 2026-04-27
migrated_from: Projets/Cookbook_Hermes_RTX3090/<fichier>
status: stable
applicabilité: hardware-upgrade-phase-A
gpu_requirement: RTX3090-24GB
verdict: gpu-suffisant
tags: [hermes, cookbook, rtx3090]
---
```

#### C. Création `Wiki/10_Domaines/Hardware/` MOC + atomes

6 fichiers à créer :
1. `_Index.md` — MOC
2. `PC_MIGHT-1000D.md` — config PC (i9-9900K + 32 GB + RTX 3090). Source : `reference_pc_config_might.md`
3. `Dongles_Zigbee.md` — 2× Sonoff ZBDongle-P. Source : `reference_zigbee_dongles_might.md`
4. `Onduleurs_APC.md` — APC SMT2200IC + BR900G-FR. Source : `reference_onduleurs_might.md`
5. `Inventaire_HA.md` — synthèse 10 lignes + lien vers `Ressources/Competences/Home_Assistant_Inventaire.md`
6. `Connexion_Fibre.md` — fibre Mickael ~100 MB/s. Source : `reference_mickael_connexion_fibre.md`

### Priorité 2 — T#4 Hermès Agent

**Conv parallèle Hermès est fermée S67** (confirmation Mickael en fin de session). Donc plus de risque collision.

3 fichiers à créer dans `Wiki/15_Hermes_Agent/` :
1. `INDEX.md` — overview, statut Phase 1bis-d, bloqueur, lien conv live
2. `01_Rapport_Phase1.md` — copie de `Projets/Jarvis_Hermes_Projet/Projet_Complet.md` (597 lignes) avec frontmatter enrichi
3. `02_Plan_Phase1bis.md` — extract Ch.6 du même fichier source
4. `03_Decision_Q1-Q8.md` — summary Ch.6.3

### Priorité 3 — T#12 vérification post-migration

Audit qualité des 60 fichiers créés en S67 :
- Grep sécurité : `private_OR|private_Q4|sk-or-v1-|sk-ant-|eyJ|01KPJ1CDZ` dans `Wiki/`
- Liens cassés : recherche `[[...]]` qui pointent vers fichiers inexistants
- Frontmatter : tous les fichiers ont les champs minimaux ?
- MAJ MOC vault parents

### Priorité 4 — T#13 MOC AI_Prompt_Design

Créer `Wiki/20_Projets/AI_Prompt_Design/INDEX.md` (simple pointeur).

### Priorité 5 — T#11 remédiation données sensibles

Voir §3 du rapport audit Drive. 3 décisions Mickael requises :
1. Secret_path ha-mcp : régénérer pour de bon ou statu quo + filtre vault ?
2. Vérification visuelle `sk-or-v1-148...1a1` (S55 L92) : entière ou tronquée ?
3. Vérification `01KPJ1CDZ8X7CYKBZRTKCZV2D4` (S20) : entry_id HA ou TOTP ?

## Effort estimé reprise

| Priorité | Tâche | Estimation | Mode |
|---|---|---|---|
| 1 | T#3 Hardware (3 sous-tâches) | 30-45 min | Direct ou sub-agent (quota reset 5h Paris) |
| 2 | T#4 Hermès Agent | 20-30 min | Direct ou sub-agent |
| 3 | T#12 vérification | 30-60 min | Direct (grep + Read ciblés) |
| 4 | T#13 MOC AI_Prompt_Design | 5 min | Direct |
| 5 | T#11 remédiation | Décision Mickael + 10-15 min exécution | Interactif |
| **TOTAL** | — | **~2 h** | — |
