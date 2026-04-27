---
title: Macros clavier / souris / pad — catalogue
created: 2026-04-25
tags: [vieperso/macros, productivite]
parent: "[[_Index]]"
status: brouillon-v1
---

# Macros clavier — catalogue v1

Pointeur vers `Ressources/Competences/Macros_Clavier.md` (créé S27,
déplacé S33). Brouillon en attente d'une session dédiée
**configuration des raccourcis** (TASKS.md #47).

## Matériel disponible

| Périphérique | Slots disponibles |
|---|---|
| **Logitech G915** (full size, AZERTY, Lightspeed) | 5 macros G1-G5 × 3 modes M1/M2/M3 = **15 slots** |
| **Logitech G502 Lightspeed** | 11 boutons programmables × G-Shift = **~22 actions** |
| **Razer Tartarus V2** | 20 touches + D-pad 8 dir + molette + bouton pouce (Hypershift ×2) = **~60 slots** |
| **TOTAL** | **~100 actions disponibles** |

## Logiciels

- Logitech G HUB (clavier + souris)
- Razer Synapse 3 ou 4 (Tartarus V2)
- Les 2 déclenchent un **profil quand `Cowork.exe` (ou `claude.exe`)
  devient foreground**.

## Catégories prévues (extraits du catalogue v1)

### 1. Démarrage de session

- **Bonjour** : `Bonjour Jarvis, nouvelle session. Lis CLAUDE.md +
  CONTEXTE.md + TASKS.md + METRIQUES.md + MEMORY.md et confirme que tu
  es opérationnel.`
- **Reprise** : reprise sur sujet, lit 3 derniers historiques
- **J'ai perdu le fil** : reprise après pause/digression
- **Mode Plan** : ne fais rien, expose ton plan, je valide

### 2. Actions Jarvis courantes

- **Statut HA** : entités critiques + automations + alertes
- **Tri Gmail supervisé** : skill `tri-email-gmail` mode V1
- **Tri Outlook** : skill `tri-email-outlook` supervisé
- **Débannir IP** : `[[10_Domaines/Outils/Debannissement IP]]`
- **Snapshots cameras** : 3 cameras via skill `cameras-dahua`
- **Chaudière** : skill `chaudiere-frisquet` état + programme

### 3. Fin de session

- **Clôture complète** : menu AskUserQuestion + archive + MAJ TASKS +
  METRIQUES + CLAUDE.md footer + regen Mode_Chat si audit touché
- **Archive courte** : juste l'archive sans MAJ infra
- **Regen Mode_Chat** : régénère les 3 `.md` Mode_Chat depuis fichiers vivants

### 4. Formats / modes

- **Mode terse iPhone** : 3 lignes max
- **Mode détaillé PC** : tableaux/listes/blocs code
- **Bloc code ON** : tout ce qui se copie en bloc triple backtick
- **Règle 0 rappel** : bloque avant pages mdp/token

### 5. Vie perso

- **Lancer Vie perso V1** : ouvre projet + prompt `[[Prompt Vie perso]]`
- **Point du jour** : 3 priorités + événements calendrier + rappels SMS

### 6. Spécial Gmail MCP

- **Test V1 Gmail** : skill `tri-email-gmail` V1 lots 10 emails
- **Test V2 Gmail** : V2 semi-auto lots 50, mesure tokens
- **Créer label+filtre** : `Jarvis-RapportTri` + filtre natif

## Méthodologie de configuration (session dédiée)

| Phase | Action |
|---|---|
| Phase 0 | Mickael choisit 10-15 phrases les + utilisées → 1ère couche (accès direct, sans modifier) |
| Phase 1 | 20-30 suivantes sur G-Shift (souris) / M2 (clavier) / Hypershift (Tartarus) |
| Phase 2 | Rarement utilisées sur M3 ou macros combinées (suite 2 touches) |
| Phase 3 | Mapping visuel : PDF/PNG layout 3 appareils + phrases assignées (à imprimer) |
| Phase 4 | Usage réel 1-2 semaines, puis itération (retirer non utilisées, ajouter manquantes) |

## À explorer plus tard

- Macros vocales (Tartarus jack micro ? Non, mais G HUB peut déclencher
  par commande vocale Windows)
- Macros séquentielles Jarvis → HA (touche → curl webhook HA → automatisation)
- Intégration Claude in Chrome : touche qui ouvre nouveau tab + injecte prompt
- Macros "récap jour" : touche qui demande résumé 3 dernières conv + décisions

## Liens

- Source complète : `Ressources/Competences/Macros_Clavier.md`
- Tâche TASKS.md : #47 "Config macros clavier/pad"
- Vie perso liée : `[[Prompt Vie perso]]`
- Aide-mémoire Claude Code : `Ressources/Competences/Claude_Code_Aide_Memoire.md`
