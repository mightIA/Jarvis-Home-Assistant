---
title: Idées macros clavier / pad pour workflow Jarvis
status: BROUILLON v1 — à reprendre lors de la session dédiée config raccourcis
created: 2026-04-22 (session 27)
moved: 2026-04-23 (session 33) — depuis Projets/Macros_Clavier/IDEES_v1.md vers Ressources/Competences/Macros_Clavier.md
materiel:
  - Clavier Logitech G915 (full size, AZERTY, Lightspeed) — 5 macros G1-G5 × 3 modes M1/M2/M3 = 15 slots
  - Souris Logitech G502 Lightspeed — 11 boutons programmables × G-Shift = ~22 actions
  - Pad Razer Tartarus V2 — 20 touches + D-pad 8 dir + molette + bouton pouce (Hypershift ×2) = ~60 slots
  - Total potentiel : ~100 actions dispo à répartir
logiciels:
  - Logitech G HUB (clavier + souris)
  - Razer Synapse 3 ou 4 (Tartarus V2)
  - Les 2 déclenchent un profil quand Cowork.exe (ou claude.exe) devient foreground
---

# Macros Jarvis — catalogue v1 (idées)

> Brouillon session 27. À reprendre quand Mickael voudra configurer ses
> raccourcis. Le fichier liste les phrases et usages pertinents à assigner
> aux touches programmables. Trier par fréquence d'usage avant
> d'affecter aux touches (les + fréquentes sur la 1ère couche, les
> rares sur Hypershift/M2/M3).

## 1. Démarrage de session

| Nom court | Phrase à injecter (macro Texte) | Usage |
|---|---|---|
| **Bonjour** | `Bonjour Jarvis, nouvelle session. Lis CLAUDE.md + CONTEXTE.md + TASKS.md + METRIQUES.md + MEMORY.md et confirme que tu es opérationnel.` | Ouverture standard d'une session Cowork ou Claude Code |
| **Reprise** | `Reprise de session sur [SUJET]. Lis les 3 derniers historiques dans memory/historique/ pour retrouver le contexte.` | Quand on enchaîne plusieurs convs sur le même sujet |
| **J'ai perdu le fil** | `Où on en était ? J'ai perdu le fil. Résume-moi les 5 derniers échanges + l'objectif en cours + la prochaine étape.` | Reprise après pause, digression, ou fatigue |
| **Mode Plan** | `Ne fais rien, expose juste ton plan d'action. Je valide avant exécution.` | Mode réflexion avant toute exécution lourde |

## 2. Actions Jarvis courantes

| Nom | Phrase | Usage |
|---|---|---|
| **Statut HA** | `Donne-moi un statut HA complet : entités critiques (Frisquet, cameras, Dyson), dernières automations déclenchées, alertes en cours.` | Point rapide le matin |
| **Tri Gmail supervisé** | `Lance la skill tri-email-gmail sur might57290@gmail.com. Mode V1 supervisé, je valide chaque lot.` | Tri manuel |
| **Tri Outlook** | `Lance la skill tri-email-outlook sur might@live.fr. Mode supervisé.` | Tri manuel Outlook |
| **Débannir IP** | `Lance la skill debannissement-ip. Méthode 1 (SSH) en priorité, fallback MCP si KO.` | Ban IP à traiter |
| **Snapshots cameras** | `Prends un snapshot des 3 cameras (entree, jardin, garage) via la skill cameras-dahua.` | État visuel rapide maison |
| **Chaudière** | `Skill chaudiere-frisquet : état actuel (preset, température, consommation) + programme de la semaine.` | Vérif chauffage |

## 3. Fin de session (gros gain de temps)

| Nom | Phrase | Usage |
|---|---|---|
| **Clôture complète** | `Clôture de session. Propose-moi le menu AskUserQuestion sauvegarde totale / archive seule, puis exécute l'option choisie : archive memory/historique/AAAA-MM-JJ_session_NN_titre.md, MAJ TASKS.md + METRIQUES.md + CLAUDE.md footer, regen Jarvis_Audits_Todo.md si audit touché.` | Fin de session propre |
| **Archive courte** | `Crée juste l'archive memory/historique/ de cette session sans toucher au reste.` | Session courte sans MAJ infra |
| **Regen Mode_Chat** | `Regénère les 3 .md de Ressources/Mode_Chat (Profil, Instructions, Audits_Todo) + Description.md à partir des fichiers vivants (CLAUDE.md, CONTEXTE.md, TASKS.md).` | Après modif majeure à propager en fallback Claude.ai |

## 4. Formats de réponse / modes

| Nom | Phrase | Usage |
|---|---|---|
| **Mode terse iPhone** | `Réponds en 3 lignes max pour les prochains messages, je suis sur iPhone.` | Quand Mickael passe en mobilité |
| **Mode détaillé PC** | `Reprise mode PC, réponses détaillées autorisées (tableaux/listes/blocs code).` | Retour sur PC |
| **Bloc code ON** | `Mets systématiquement en bloc de code tout ce qui est à copier. Rappel règle feedback_copy_paste_code_blocks.` | Forcer le format copiable |
| **Règle 0 rappel** | `Rappel Règle 0 données sensibles : bloque avant toute page/action qui expose mdp/token.` | Avant navigation sensible |

## 5. Vie perso (Ressources/Competences/Vie_Perso.md)

| Nom | Phrase | Usage |
|---|---|---|
| **Lancer Vie perso V1** | `Ouvre le projet Vie perso. Prompt de démarrage : voir Ressources/Competences/Vie_Perso.md section V1.` | Démarrage Vie perso |
| **Point du jour** | `Liste mes 3 priorités du jour + événements calendrier + rappels SMS Free actifs (si implémentés).` | Début de journée |

## 6. Spécial Gmail MCP Phase 5 (tâche #45)

| Nom | Phrase | Usage |
|---|---|---|
| **Test V1 Gmail** | `Lance la skill tri-email-gmail en mode V1 manuel supervisé. Propose chaque action par lot de 10 emails max, je valide 1 par 1.` | Test Phase 5 V1 |
| **Test V2 Gmail** | `Lance la skill tri-email-gmail en mode V2 semi-auto. Lots de 50, validation globale. Mesure coût tokens.` | Test Phase 5 V2 |
| **Créer label+filtre** | `Crée le label Gmail Jarvis-RapportTri via get_or_create_label, puis le filtre natif via create_filter (critère from:me subject:"[Jarvis] Rapport tri emails", actions addLabelIds label + removeLabelIds INBOX). Affiche les IDs.` | Setup initial Phase 5 |

## 7. À explorer plus tard

- Macros vocales (Tartarus a un micro jack ? Non, mais G HUB supporte parfois déclenchement par commande vocale Windows)
- Macros séquentielles Jarvis → HA (un appui touche déclenche un curl webhook HA qui lance une automatisation)
- Intégration Claude in Chrome : touche qui ouvre un nouveau tab et injecte un prompt dans la zone de saisie
- Macros "récap jour" : une touche qui demande "résume les 3 dernières conversations Jarvis avec bullet points des décisions"

---

## Méthodologie de configuration (pour session dédiée)

1. **Phase 0** — Mickael choisit 10-15 phrases parmi le catalogue qu'il
   utilise le plus souvent. On les assigne à la **1ère couche** (pas de
   modifier, accès direct).
2. **Phase 1** — Les 20-30 suivantes vont sur **G-Shift (souris)** /
   **M2 (clavier)** / **Hypershift (Tartarus)**.
3. **Phase 2** — Les rarement utilisées sur **M3** ou en **macros
   combinées** (suite de 2 touches).
4. **Phase 3** — Mapping visuel : je génère un PDF ou PNG avec le layout
   des 3 appareils + les phrases assignées, à imprimer/afficher à côté
   du PC.
5. **Phase 4** — Usage réel 1-2 semaines, puis itération : on retire les
   phrases jamais utilisées, on ajoute celles qui manquent.

## Liens de référence

- Aide-mémoire Claude Code : `Ressources/Competences/Claude_Code_Aide_Memoire.md`
- Auto-memory Cowork capacités : `.auto-memory/reference_cowork_capacites.md`
- Protocole Gmail : `Ressources/Protocoles/Gmail.md`
- CLAUDE.md section 5 skills disponibles

---

*Fichier brouillon — à reprendre lors de la tâche #47 "Config macros clavier/pad".*
