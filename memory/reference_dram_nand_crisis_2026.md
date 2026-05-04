---
name: DRAM crisis et NAND crisis 2026
description: Inflation prix mémoire x3-5 entre 2025 et mai 2026, cause HBM IA, impact direct BoM hardware upgrade Jarvis
type: reference
created: 2026-05-03
updated: 2026-05-03
session: S94
tags: [reference, prix, dram, nand, ram, ssd, hardware-upgrade, crisis-2026]
---

# DRAM crisis et NAND crisis 2026

Découverte critique en S94 (3 mai 2026) lors de la finalisation de la BoM hardware upgrade : les prix mémoire (DDR5) et SSD (NAND) ont **explosé** entre fin 2025 et mai 2026, multiplicateurs ×3 à ×5 sur certains kits.

## Multiplicateurs confirmés

| Composant | Prix avril 2026 (BoM Jarvis S55-S56) | Prix mai 2026 (Mickael LDLC verif) | Multiplicateur |
|---|---|---|---|
| DDR5 96 Go (2×48) 6000 CL30 EXPO RGB | ~360 € | **1 494 €** (Corsair Vengeance) | **×4.15** |
| DDR5 64 Go (2×32) 6000 CL30 EXPO RGB | ~240 € | **~1 050 €** (extrapolé Corsair) | **×4.4** |
| Samsung 990 Pro 2 To NVMe Gen4 | 170 € | **~440 €** (idealo / dropreference) | **×2.6** |
| DDR4 32 Go (2×16) 3600 CL18 | ~120 € | **~280 €** (Corsair RGB Pro SL) | **×2.3** |
| HDD WD Purple 8 To | 200 € | **~250 €** (estimé) | ×1.25 |

## Multiplicateurs trimestriels NAND (TrendForce)

- **Q4 2025** : NAND +33-38 %
- **Q1 2026** : NAND +85-90 %
- **Q2 2026** (en cours) : prévu +70-75 %
- Cumul fin 2025 → mi-2026 : **×3 à ×5** sur certains segments

## Cause structurelle

- Pic de demande HBM (High Bandwidth Memory) pour accélérateurs IA depuis fin 2024
- Fabs Samsung / Micron / SK Hynix réorientent production DRAM grand public vers HBM3/HBM4 (marges ×10)
- Effet domino : HBM → DDR5 → DDR4 (moins impacté) → NAND (réorientation chaînes wafer mémoire)
- Samsung 990 Pro 2 To passé de 189 $ (2025) à 478 $ (avril 2026) selon dropreference

## Détente prévue

- **2027-2028** quand SK Hynix HBM4 monte en cadence et libère les chaînes DDR5
- Pas de baisse significative prévue avant fin 2026

## Conséquence pour le projet hardware upgrade Jarvis

- **Budget cible initial** : 2 500 € (BoM S55-S56)
- **Total mai 2026 (BoM v3 S94)** : 3 290 €
- **Dépassement** : +880 € / +37 % attribuable principalement à la crise mémoire
- **Décision Mickael** : *« on peut depasser le budget au vue des circonstances »* — pas attendre la baisse, livrer le projet en mai-juin 2026

## Pièges à éviter

1. **WebSearch retombe sur prix US 2024-2025** : Newegg, Amazon US, PCPartPicker souvent obsolètes. Toujours **multi-source FR jour J** : LDLC + Materiel.net + idealo.fr + TopAchat
2. **Liens LDLC parfois morts** : URLs `PB***` peuvent être retirées. Préférer Amazon.fr (ASIN stable B0xxxxxxxx) en lien primaire, Materiel.net en fallback
3. **Idealo.fr très utile** : comparateur multi-vendeurs FR, donne souvent un prix « depuis X € » à recouper
4. **Stock tendu sur certains composants** : Ryzen 9 9950X3D = 3 unités Amazon.fr le 03/05/2026

## Sources

- [TrendForce — NAND price increase 2026 forecast](https://dropreference.com/en/blog/news/ssd-price-increase-2026-nand-flash-crisis)
- Mickael LDLC vérification kit Corsair 96 Go = 1 494 € (mai 2026)
- [Idealo.fr Samsung 990 Pro 2 To](https://www.idealo.fr/prix/202132324/samsung-990-pro-2-to.html)
