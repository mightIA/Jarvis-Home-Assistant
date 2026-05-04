---
title: Glossaire technique
created: 2026-04-25
updated: 2026-04-25
tags: [atome, traduction, traduction/glossaire, domaine/traduction]
status: actif
parent: "[[_Index]]"
source: Ressources/Competences/Traduction_Glossaire.md
---

# Glossaire technique

Fichier source **canonique** : `Ressources/Competences/Traduction_Glossaire.md`.
Cet atome sert de **pointeur + carte des sections** pour le mode Technique de
la skill `traduction`. Toute modification se fait dans le fichier source,
pas ici.

## Format d'entrée

```
| terme FR | terme EN | terme DE | contexte / note |
```

## Sections couvertes (état au 25/04/2026)

- **Domotique / Home Assistant** — 20 entrées (capteur, thermostat, chaudière,
  automation, Zigbee, firmware, bannissement IP, etc.).
- **Contrôle non destructif (CND)** — 13 entrées (ultrason, ressuage, soudure,
  fissure, qualification niveau 1/2/3 EN ISO 9712, etc.).
- **Termes généraux administratifs** — 9 entrées (facture, devis, bon de
  commande, SAV, garantie, remboursement, etc.).
- **Informatique / réseau** — 10 entrées (navigateur, 2FA, VPN, reverse proxy,
  pare-feu, etc.).

## Règles d'enrichissement

1. **Avant toute traduction technique** : vérifier si le terme figure déjà.
2. **Nouveau terme rencontré** : proposer l'ajout au glossaire **après** la
   traduction, avec exemple de phrase si pertinent.
3. **Divergence de traduction** : si un même terme se traduit différemment
   selon le contexte, inscrire **les deux** avec note contextuelle.

## Termes intraduisibles (à conserver)

Quelques exemples issus du glossaire :

- Protocoles : `Zigbee`, `Z-Wave`, `Matter`, `Thread`.
- Termes dashboard / infra : `Dashboard`, `Firewall`, `Firmware`, `Backup`,
  `API`.
- Acronymes CND à garder tels quels : `NDT` (EN), `ZfP` (DE), `CND` (FR),
  avec leurs sous-acronymes `PT`, `MT`, `RT`, `ET`.

---

*Atome créé S43. Ne pas dupliquer le glossaire ici — lire directement le
fichier source quand le mode Technique est actif.*
