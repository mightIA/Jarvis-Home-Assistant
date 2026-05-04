---
title: Traduction — Hub
created: 2026-04-25
updated: 2026-04-25
tags: [moc, traduction, domaine/traduction]
status: actif
source_skill: .claude/skills/traduction/SKILL.md
source_ressources:
  - Ressources/Competences/Traduction_Glossaire.md
  - Ressources/Competences/Traduction_Style_Personnel.md
---

# Traduction — Hub central

Point d'entrée du domaine **Traduction** de Jarvis. Skill FR / EN / DE avec
4 modes adaptatifs et enrichissement progressif du glossaire et du style
personnel de Mickael.

## Atomes du domaine

- [[Modes de traduction]] — les 4 modes (Professionnel, Accessible, Technique, Personnel).
- [[Langues et directions]] — FR / EN / DE, 6 directions supportées, limites.
- [[Glossaire technique]] — pointeur vers `Ressources/Competences/Traduction_Glossaire.md` + sections couvertes.
- [[Style personnel]] — pointeur vers `Ressources/Competences/Traduction_Style_Personnel.md` + formules de politesse habituelles.

## Workflow standard (7 étapes)

Extrait de la skill `traduction` pour rappel rapide :

1. Identifier langue **source** et langue **cible** (demander si ambigu).
2. Identifier le **mode** (demander si non précisé). Défauts : Pro pour emails,
   Accessible pour proche, Technique pour domotique/CND, Personnel si Mickael le
   demande.
3. **Charger** les références selon le mode (glossaire ou style personnel).
4. **Traduire** en respectant les règles du mode.
5. **Présenter** la traduction avec rappel du mode utilisé.
6. **Proposer** les alternatives si une phrase a plusieurs traductions valables.
7. **Enrichir** le glossaire ou le fichier style après validation Mickael.

## Déclencheurs de la skill

- « traduis / translate / übersetze ».
- « en anglais / in German / auf Deutsch ».
- Texte étranger collé sans contexte → demande de sens ou de résumé FR.
- Rédaction d'un message pour un correspondant non francophone.

## Règles transverses (rappel)

- **Toujours** indiquer direction + mode au-dessus de la traduction.
- **Jamais** inventer un terme technique : signaler l'incertitude.
- **Jamais** mélanger les modes dans une même traduction (proposer 2 versions).
- Conserver mise en forme source (listes, paragraphes, ponctuation).
- Noms propres et lieux : ne pas traduire sauf équivalent établi
  (`Germany` → `Allemagne`, `Nuremberg` reste `Nuremberg`).

## Règle 0 — Données sensibles

Contenu sensible (données perso, credentials, informations bancaires,
tokens) : appliquer la **Règle 0** `CLAUDE.md` section 0 **AVANT** de traduire.
ARRÊT systématique, description de ce qui serait vu, accord explicite requis.

## Liens externes

- Skill : `.claude/skills/traduction/SKILL.md`
- Glossaire source : `Ressources/Competences/Traduction_Glossaire.md`
- Style personnel source : `Ressources/Competences/Traduction_Style_Personnel.md`

---

*Hub créé S43 (25/04/2026). Convention atomique stricte D4-S42.*
