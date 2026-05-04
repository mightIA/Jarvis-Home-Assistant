---
title: Hardware Upgrade — BoM v4 finalisée (S101)
description: BoM v4 prête à commander mai 2026 (3 662,44 €), supersede BoM v3 S94. PDF + markdown livrés. T#73 reste cancelled, BoM hors tâche.
type: project
session: 101
date: 2026-05-04
total_eur: 3662.44
status: ready_to_order
supersedes: project_hardware_upgrade_bom_v3_s94.md
---

# Hardware Upgrade — BoM v4 finalisée (Session 101)

> Supersede : remplace [`project_hardware_upgrade_bom_v3_s94.md`](project_hardware_upgrade_bom_v3_s94.md)
> (BoM v3 du 03/05/2026, 3 290 €).
>
> **PDF + markdown source** : voir
> [`Projets/Hardware_Upgrade/10_Recap_Commande_S101.pdf`](../Projets/Hardware_Upgrade/10_Recap_Commande_S101.pdf)
> et [`10_BoM_v4_S101_validee_pour_commande.md`](../Projets/Hardware_Upgrade/10_BoM_v4_S101_validee_pour_commande.md).
>
> **Statut** : prête à commander. T#73 reste `cancelled` (S65 + S95 +
> S101). BoM livrée hors tâche.

## Architecture cible

| PC | Boîtier | CPU | RAM | GPU | Refroid. |
|----|---------|-----|-----|-----|----------|
| **BUREAU** (neuf) | Corsair 1000D existant | 9950X3D | 96 Go DDR5 | RTX 3090 récup | 2 boucles WC Corsair |
| **DOMO** (Proxmox) | Boîtier Mickael existant | i9-9900K récup | 64 Go DDR4 | IGP UHD 630 | Dark Rock 4 |

## Récap chiffré

| Source | Montant |
|--------|---------|
| Amazon FR (PC bureau, 6 articles + 3 assurances) | **3 403,44 €** |
| Schnaeppchen-Schuppen (RAM DDR4 PC domo, déjà commandée) | **259,00 €** |
| **TOTAL** | **3 662,44 €** |

## Composants Amazon FR (PC bureau)

| # | Composant | ASIN | Prix | Livraison |
|---|-----------|------|------|-----------|
| 1 | Corsair HX1500i Shift 1500W ATX 3.1 | B0F3JHTL2R | 269,90 € | Aujourd'hui 17h-22h |
| 2 | AMD Ryzen 9 9950X3D | B0DVZSG8D5 | 711,48 € + 29,49 € | Demain 5 mai |
| 3 | ASUS ROG Crosshair X870E Hero | B0DDZSP2BG | 709,95 € + 29,49 € | Aujourd'hui 17h-22h |
| 4 | Corsair Vengeance RGB DDR5 96 Go (2×48) 6000 CL36 EXPO | B0F7RVMYZQ | 1 149,86 € | Mer. 6 mai |
| 5 | Corsair XC7 RGB ELITE LCD Waterblock | B0CDHDS799 | 201,69 € | Demain 5 mai |
| 6 | Samsung SSD 9100 Pro 2 To NVMe Gen5 | B0DWFLPMM5 | 297,99 € + 3,59 € | Demain 5 mai |

## RAM DDR4 PC domo (déjà commandée)

- **Vendeur** : Schnaeppchen-Schuppen
- **Commande** : MEZHAB5
- **Produit** : Corsair Vengeance RGB DDR4 64 Go (2×16) 3600 MHz CL18
  (CMW32GX4M2Z3600C18, kit identique au pré-existant)
- **Prix** : 259,00 € (frais 0 €)
- **Livraison** : jeudi 7 mai - mercredi 13 mai

## Évolution vs BoM v3 (S94)

| Différence | v3 (S94) | v4 (S101) |
|------------|----------|-----------|
| Carte mère | ProArt X870E-CREATOR | **ROG Crosshair X870E Hero** |
| RAM PC bureau | 64 Go DDR5 6000 CL30 EXPO | **96 Go DDR5 6000 CL36 EXPO** (Z36) |
| SSD PC bureau | Samsung 990 Pro 2 To | **Samsung 9100 Pro 2 To** Gen5 |
| Alim PC bureau | Conservation HX1000 actuelle | **HX1500i Shift NEUF** (HX1000i descend en domo) |
| RAM PC domo | À acheter (32 Go) | **Déjà commandée 32 Go Schnaeppchen** |
| Total | 3 290 € | **3 662,44 €** (+372 €) |

## Apprentissages clés capitalisés (S101)

1. **DRAM/NAND crisis 2026 confirmée et amplifiée** : marché DDR5 96 Go
   complètement cassé en mai 2026 (1 100-1 800 € selon refs). Situation
   contre-intuitive où **64 Go CL30 coûte plus cher que 96 Go CL36**
   chez tous les revendeurs FR (LDLC, Materiel.net, TopAchat, Amazon FR).
   Le panier initial Mickael (96 Go Z36 1 149 €) = **meilleur deal du
   marché FR**. Estimations idealo « starting from » souvent obsolètes
   (dropshippers fantômes/ruptures). **Règle figée** : avant proposer
   alternative DDR5, vérifier prix réels chez 2-3 revendeurs sérieux.
2. **BTF nécessite boîtier BTF + GPU BTF** : les cartes mères BTF (Hero
   BTF, Pano 100, etc.) ont connecteurs cachés à l'arrière du PCB. Le
   Corsair 1000D n'est PAS BTF (plateau standard). Slot GPU 600W BTF 2.0+
   inutile sans GPU BTF (RTX 50 BTF). **Règle figée** : ne jamais
   proposer carte mère BTF sans confirmer 1000D ou autre boîtier BTF
   compatible + GPU BTF compatible.
3. **AMD AM5 strict 6000 MHz** : au-delà, FCLK passe en ratio 2:1 →
   dégrade les perfs au lieu de les améliorer. **Refuser** systématiquement
   DDR5 6400+ pour AMD, même certifié XMP. Sweet spot = 6000 MHz CL30 ou
   CL32 EXPO strict.
4. **Suffixe RAM Corsair Z vs C** : suffixe **Z** = AMD EXPO + Intel XMP
   (préféré sur AMD), suffixe **C** = Intel XMP only. Sur AM5, refuser
   les kits suffixe C même à prix équivalent.
5. **Vendeur Amazon Marketplace < 95 % positives = à éviter** sur
   high-tech > 500 €. Norme Amazon ≥ 95 %. À 70 % (Abracadabra23 sur ce
   panier), risques marketplace gris (CPU usés/retests), boîte ouverte,
   SAV compliqué, garantie AMD contestée. Pour CPU/CM/GPU > 500 €,
   exiger « Vendu et expédié par Amazon » (smid `A1X6FK5RDHNB96`).

## Pointeurs

- Archive narrative session :
  [`memory/historique/2026-05-04_session_101_hardware_upgrade_bom_v4_finale.md`](historique/2026-05-04_session_101_hardware_upgrade_bom_v4_finale.md)
- BoM v4 markdown :
  [`Projets/Hardware_Upgrade/10_BoM_v4_S101_validee_pour_commande.md`](../Projets/Hardware_Upgrade/10_BoM_v4_S101_validee_pour_commande.md)
- PDF récap :
  [`Projets/Hardware_Upgrade/10_Recap_Commande_S101.pdf`](../Projets/Hardware_Upgrade/10_Recap_Commande_S101.pdf)
- BoM v3 supersede :
  [`memory/project_hardware_upgrade_bom_v3_s94.md`](project_hardware_upgrade_bom_v3_s94.md)
- Plan migration HA Pi5 → Proxmox :
  [`Projets/Hardware_Upgrade/06_Migration_HA_Pi5_Proxmox.md`](../Projets/Hardware_Upgrade/06_Migration_HA_Pi5_Proxmox.md)
- DRAM/NAND crisis 2026 :
  [`memory/reference_dram_nand_crisis_2026.md`](reference_dram_nand_crisis_2026.md)
- RAM existante PC actuel :
  [`memory/reference_ram_corsair_pc_actuel.md`](reference_ram_corsair_pc_actuel.md)

---

*BoM v4 finalisée S101 — 4 mai 2026. Mickael peut commander en l'état.*
