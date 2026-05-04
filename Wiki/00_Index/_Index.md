---
title: Index Wiki Jarvis
created: 2026-04-25
updated: 2026-04-30
tags: [moc, index]
status: actif
---

# Index Wiki Jarvis

Point d'entrée principal du vault. À mettre à jour quand de nouveaux
domaines ou références sont ajoutés.

> **Règle structurelle (S81)** : le vault contient uniquement de la **connaissance pure**. Pas de projets (vivent dans `Projets/` racine), pas d'archives (vivent dans `Archives/` racine), pas de conversations verbatim. Voir [[../10_Domaines/ADR/accepted/ADR-A004-vault-connaissance-pure|ADR-A004]].

## Domaines actifs

- [x] **Home Assistant** — [[../10_Domaines/HomeAssistant/_Index|HomeAssistant]] *(12 atomes)*
- [x] **Cloudflare** — [[../10_Domaines/Cloudflare/_Index|Cloudflare]] *(hub-atome)*
- [x] **Frisquet (chaudière)** — [[../10_Domaines/Frisquet/_Index|Frisquet]] *(hub-atome)*
- [x] **Cameras Dahua** — [[../10_Domaines/Cameras/_Index|Cameras]] *(2 atomes)*
- [x] **Domotique appareils** — [[../10_Domaines/Domotique/_Index|Domotique]] *(7 atomes — Dyson, Samsung Q80, HomePod, Music Assistant + 3 coquilles HomeKit/EcoFlow/Imprimante 3D)*
- [x] **Réseau & Sécurité** — [[../10_Domaines/Reseau/_Index|Reseau]] *(8 atomes)*
- [x] **Email & MCP Gmail** — [[../10_Domaines/Email/_Index|Email]] *(1 hub + 6 atomes — S44)*
- [x] **Outils & productivité** — [[../10_Domaines/Outils/_Index|Outils]] *(1 hub + 6 atomes)*
- [x] **Traduction** — [[../10_Domaines/Traduction/_Index|Traduction]] *(1 hub + 4 atomes)*
- [x] **Vie perso** — [[../10_Domaines/ViePerso/_Index|ViePerso]] *(1 hub + 10 atomes)*
- [x] **Procédures** — [[../10_Domaines/Procedures/_Index|Procedures]] *(7 atomes : backup, débans, rotation, recovery, etc.)*
- [x] **Hardware** — [[../10_Domaines/Hardware/_Index|Hardware]] *(5 atomes : PC, dongles Zigbee, onduleurs, fibre)*
- [x] **Inventaire (pièces)** — [[../10_Domaines/Inventaire/_Index|Inventaire]] *(10 atomes pièces — coquilles, à compléter au fil de l'eau)*
- [x] **Skills Jarvis** — [[../10_Domaines/Skills_Jarvis/_Index|Skills_Jarvis]] *(MOC des 32 skills `.claude/skills/` — 6 atomes-catégories)*
- [x] **ADR (Architecture Decision Records)** — [[../10_Domaines/ADR/_Index|ADR]] *(4 accepted + 7 rejected — depuis ADR-A004 S81)*
- [x] **Veille** — [[../10_Domaines/Veille/_Index|Veille]] *(6 atomes : LLM, providers, MCP, articles, issues GitHub, landscape)*

## Hors vault (pour mémoire — pointeurs lecture seule)

- **Projets actifs** — `Projets/` racine du repo (Hardware_Upgrade, Cookbook_Hermes_RTX3090, Jarvis_Hermes_Projet, AI_Prompt_Design, etc.)
- **Archives** — `Archives/` racine du repo
- **Sessions historiques** — `memory/historique/` racine du repo
- **Skills Jarvis source** — `.claude/skills/` racine du repo
- **Auto-memories Cowork** — `memory/*.md` racine du repo (auto-memory CLI local)
