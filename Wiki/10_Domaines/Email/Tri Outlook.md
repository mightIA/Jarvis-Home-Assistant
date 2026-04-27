---
title: Tri Outlook
created: 2026-04-25
tags: [email, email/outlook, email/tri, domaine/email]
status: actif
parent: "[[_Index]]"
source_skills:
  - .claude/skills/tri-email-outlook/SKILL.md
  - .claude/skills/tri-email-outlook-priorites/SKILL.md
---

# Tri Outlook

Tri de la boîte `might@live.fr` (Outlook). Pas de MCP officiel Microsoft
Graph côté Cowork à ce jour — le tri passe par **Brave + Claude in Chrome**.

## Deux skills complémentaires

| Skill                               | Mode          | Quand l'utiliser                                                 |
|-------------------------------------|---------------|------------------------------------------------------------------|
| `tri-email-outlook`                 | Automatisé    | Tri quotidien whitelist / blacklist / scores + rapport auto.     |
| `tri-email-outlook-priorites`       | Interactif    | Tri par priorités, validation Mickael par recap numéroté.        |

### `tri-email-outlook` — automatisé

Pendant longtemps géré comme `tri-email-gmail` : whitelist / blacklist /
learning_log + rapport envoyé. Patterns dans `Ressources/Data/outlook_patterns/`
(auto-memory `reference_outlook_patterns`).

### `tri-email-outlook-priorites` — interactif (S28)

Créé S28. Tri par lot avec **4 dossiers cibles** :

| Dossier         | Contenu                                                       |
|-----------------|---------------------------------------------------------------|
| `Urgent`        | Action rapide requise (factures, alertes sécurité).           |
| `Perso`         | Famille, amis, correspondance privée.                         |
| `Info`          | Newsletters utiles, presse, suivi d'abonnements.              |
| `À supprimer`   | Validé par Mickael avant vidage manuel.                       |

Mickael valide par numéro avec un format type `Urgent 1 sup, 2-3 non lu, ...`.
Workflow Brave + `Claude in Chrome` (`navigate`, `find`, `left_click`,
`form_input`).

## Pièges Outlook (S28)

| Piège                                                       | Contournement                                                                                                                  |
|-------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------|
| Menu *Déplacer* ne liste pas les dossiers récents (Urgent). | Taper le nom dans la zone de recherche du menu, ou drag-drop manuel.                                                           |
| Popup *Ne jamais envoyer ce courrier au dossier indésirable*. | Apparaît lors d'un déplacement depuis Courrier indésirable. **DÉCOCHER la case pré-cochée** sinon Outlook débloque les scammers. |
| Drag-drop instable.                                         | Toujours fiable comme fallback si `find` + `left_click` ratent une référence (ref_XXX).                                       |

Voir auto-memory `feedback_outlook_popup_never_send`.

## Volumétrie observée (S28)

- 25 mails inbox + 8 spam = **33 traités**.
- Résultat : inbox vide, spam vide, 22 dans `À supprimer` prêts à vider.
- 8 conservés (4 Urgent non lus + 3 Perso + 1 Archive MSF reçu fiscal).

## MCP Outlook futur

Tâche **#48** : install d'un MCP Microsoft Graph API pour exposer Outlook
nativement (`search`, `move`, `delete`, `send`). Tant que non installé, le
tri Outlook reste manuel + Claude in Chrome.

## Liens

- Skill auto : `.claude/skills/tri-email-outlook/SKILL.md`
- Skill priorités : `.claude/skills/tri-email-outlook-priorites/SKILL.md`
- Patterns : `Ressources/Data/outlook_patterns/`
- Boîtes : [[Boites email]]

---

*Atome créé S44. Tri Outlook 100% Brave en attente du MCP Microsoft Graph.*
