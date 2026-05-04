---
title: BoM v4 finalisée — Session 101 (4 mai 2026)
description: Bill of Materials final validé prêt à commander pour PC bureau (nouveau) + PC domo (Proxmox)
session: 101
date: 2026-05-04
total_eur: 3662.44
status: ready_to_order
supersedes: 09_BoM_v3_finale_S94.md
---

# BoM v4 finalisée — Hardware Upgrade Session 101

> **Statut** : prête à commander. PDF récapitulatif :
> [`10_Recap_Commande_S101.pdf`](10_Recap_Commande_S101.pdf).
> Décision T#73 reste `cancelled` (S65 + S95 + S101). BoM livrée hors
> tâche.
>
> **Supersede** : remplace `09_BoM_v3_finale_S94.md` (ajustements RAM
> DDR4, CM Hero standard au lieu de Dark Hero, alim neuve HX1500i Shift,
> CPU sécurisé Amazon direct).

---

## 1. Architecture cible

| PC | Boîtier | CPU | RAM | GPU | Refroid. | OS visé |
|----|---------|-----|-----|-----|----------|---------|
| **BUREAU** (neuf) | Corsair 1000D existant | 9950X3D | 96 Go DDR5 EXPO | RTX 3090 récup | 2 boucles WC Corsair | Windows 11 Pro |
| **DOMO** (Proxmox) | Boîtier Mickael existant | i9-9900K récup | 64 Go DDR4 | IGP UHD 630 | Dark Rock 4 (Mickael) | Proxmox VE + HA OS VM |

---

## 2. Achats Amazon FR — PC BUREAU

> Tous expédiés par Amazon FR (smid `A1X6FK5RDHNB96`) sauf indication
> contraire. Cliquer le composant pour ouvrir la fiche produit.

| # | Composant | ASIN | Prix | Assurance | Livraison |
|---|-----------|------|------|-----------|-----------|
| 1 | [Corsair HX1500i Shift (2025) — 1500W ATX 3.1 / PCIe 5.1](https://www.amazon.fr/gp/product/B0F3JHTL2R/) | B0F3JHTL2R | 269,90 € | — | Aujourd'hui 17h-22h |
| 2 | [AMD Ryzen 9 9950X3D — 16C/32T, 3D V-Cache](https://www.amazon.fr/gp/product/B0DVZSG8D5/) | B0DVZSG8D5 | 711,48 € | 29,49 € | Demain 5 mai |
| 3 | [ASUS ROG Crosshair X870E Hero — AM5 ATX](https://www.amazon.fr/gp/product/B0DDZSP2BG/) | B0DDZSP2BG | 709,95 € | 29,49 € | Aujourd'hui 17h-22h |
| 4 | [Corsair Vengeance RGB DDR5 96 Go (2×48) 6000 CL36 EXPO](https://www.amazon.fr/gp/product/B0F7RVMYZQ/) | B0F7RVMYZQ | 1 149,86 € | — | Mer. 6 mai |
| 5 | [Corsair XC7 RGB ELITE LCD — Waterblock CPU 480×480](https://www.amazon.fr/gp/product/B0CDHDS799/) | B0CDHDS799 | 201,69 € | — | Demain 5 mai |
| 6 | [Samsung SSD 9100 Pro 2 To NVMe PCIe 5.0](https://www.amazon.fr/gp/product/B0DWFLPMM5/) | B0DWFLPMM5 | 297,99 € | 3,59 € | Demain 5 mai |
| | **SOUS-TOTAL AMAZON** | | | | **3 403,44 €** |

---

## 3. Achat tiers — RAM DDR4 PC DOMO (déjà commandé)

| Élément | Détail |
|---------|--------|
| Vendeur | Schnaeppchen-Schuppen |
| Numéro de commande | **MEZHAB5** |
| Produit | Corsair Vengeance RGB DDR4 64 Go (2×16) 3600 MHz CL18 |
| Référence | CMW32GX4M2Z3600C18 (kit identique au pré-existant) |
| Prix | 259,00 € |
| Frais de port | 0,00 € |
| Livraison | jeudi 7 mai - mercredi 13 mai |
| Destination | PC DOMO (compléter les 32 Go récup pour atteindre 64 Go total) |

> ⚠️ **Note compatibilité 9900K** : DDR4 3600 officiellement non supportée
> par 9900K (max 2666 officiel) mais fonctionne via XMP activé dans BIOS
> Z370/Z390. Vérifier que les 4×16 Go (anciens + nouveaux) ont bien les
> mêmes timings/voltage avant montage. Mismatch fatal documenté S94.

---

## 4. PC BUREAU — composants récupérés (0 €)

- **Corsair 1000D Super-Tower** (existant, vidé pour nouvelle config)
- **NVIDIA RTX 3090** (24 Go VRAM, récupérée du PC actuel)
- **2× SSD SATA 1 To** (2.5", récupérés du PC actuel — data/jeux)
- **2 boucles watercooling Corsair** (existantes — 1 CPU + 1 GPU/SSD M.2)

---

## 5. PC DOMO — composition complète

> **0 € d'achat supplémentaire** au-delà des 32 Go DDR4 déjà commandés.

| Composant | Source | Note |
|-----------|--------|------|
| Carte mère actuelle | Récup PC bureau | Z370/Z390 LGA 1151 v2 |
| CPU Intel Core i9-9900K | Récup | 8C/16T, IGP UHD 630 |
| RAM 32 Go DDR4 actuelle (2×16) | Récup | + 32 Go neufs Schnaeppchen → 64 Go total |
| SSD Samsung 970 Pro NVMe | Récup | Système Proxmox |
| HDD 2 To | Récup | Stockage froid / backups |
| be quiet! Dark Rock 4 | Déjà à toi | Refroidissement air actif (135 mm) |
| Boîtier PC domo | Déjà à toi | (modèle non spécifié) |
| Alimentation Corsair HX1000i | Récup PC bureau | Déplacée du 1000D vers boîtier domo |
| GPU intégré Intel UHD 630 | Intégré 9900K | Suffit pour Proxmox + HA headless |

---

## 6. Total final

| Source | Total |
|--------|-------|
| Amazon FR (PC bureau, 6 articles + 3 assurances) | **3 403,44 €** |
| Schnaeppchen-Schuppen (RAM DDR4 PC domo) | **259,00 €** |
| **TOTAL GÉNÉRAL** | **3 662,44 €** |

**Évolution vs panier initial Mickael** (`achat.pdf`, 2 950,16 €) :
**+712,28 €** répartis sur :

- **HX1500i Shift neuf** (alim future-proof PCIe 5.1) : +269,90 €
- **CPU sécurisé Amazon direct** (vs Abracadabra23 vendeur tiers 70 % ⭐) : +29,88 €
- **Waterblock prix Amazon majoré** (180,08 → 201,69 €) : +21,61 €
- **Assurances dommage accidentel** CPU + SSD : +33,08 €
- **RAM DDR4 PC domo** ajoutée au scope : +259,00 €

Tous les autres articles (CM, RAM DDR5, SSD 9100 Pro) inchangés.

---

## 7. Plan de migration recommandé (10 étapes)

| Étape | Action | Quand |
|-------|--------|-------|
| 1 | Réception colis Amazon (alim + CM aujourd'hui ; CPU + WB + SSD demain ; RAM DDR5 mer. 6) | 4-6 mai |
| 2 | Sauvegarde complète PC bureau actuel (image disque + données critiques) | Avant démontage |
| 3 | Démontage PC bureau actuel : extraction CM + 9900K + 32 Go DDR4 + 970 Pro + HX1000i du Corsair 1000D | 4-6 mai |
| 4 | Réception RAM DDR4 chez Schnaeppchen-Schuppen | Jeu. 7 - mer. 13 mai |
| 5 | Montage PC domo dans son boîtier : CM + 9900K + 4×16 Go DDR4 (timings vérifiés) + 970 Pro + HDD 2 To + Dark Rock 4 + HX1000i | Sem. 7-13 mai |
| 6 | Installation Proxmox VE + HA OS en VM (cf. [`06_Migration_HA_Pi5_Proxmox.md`](06_Migration_HA_Pi5_Proxmox.md)) | Sem. 13-20 mai |
| 7 | Migration HA Pi5 → Proxmox (snapshot + transfert config + tests) | Sem. 13-20 mai |
| 8 | Vidage complet du Corsair 1000D + nettoyage + maintenance boucles WC | Mai |
| 9 | Montage nouveau PC bureau dans 1000D : X870E Hero + 9950X3D + waterblock XC7 LCD + 96 Go DDR5 + 9100 Pro Gen5 + HX1500i Shift + RTX 3090 récup + 2 SSD SATA récup + connexion 2 boucles WC (1 CPU XC7 LCD, 1 GPU + SSD M.2) | Sem. 13-20 mai |
| 10 | Installation Windows 11 Pro + drivers Ryzen + iCUE + tests stabilité (Cinebench R23 30 min, OCCT, FurMark, IA Hermès Qwen 3 32B) | Sem. 13-20 mai |

---

## 8. Points de vigilance figés (pièges S101)

1. **Mismatch RAM DDR4** : vérifier strictement timings + voltage entre les 4×16 Go avant montage PC domo (mismatch fatal documenté S94).
2. **XMP DDR4 sur 9900K** : activer XMP dans BIOS Z370/Z390 sinon RAM tournera à 2666 MHz.
3. **EXPO DDR5 sur X870E Hero** : activer profil EXPO dans BIOS pour atteindre 6000 MHz CL36 (sinon défaut 4800 MHz).
4. **PCIe 5.0 SSD heat** : le 9100 Pro chauffe énormément en Gen5, vérifier dissipateur intégré du slot M.2_1 X870E Hero monté correctement.
5. **Câble 12V-2×6 RTX 3090** : la 3090 a besoin de 2× 8-pins, pas du 12V-2×6 (réservé RTX 40/50). Utiliser les câbles 8-pins de la HX1500i Shift.
6. **Connecteurs côté HX1500i Shift** : les câbles sortent du **côté** de la PSU, pas du fond. Câblage différent à anticiper dans le 1000D.
7. **Transients RTX 3090** : pic ~400-500 W, l'HX1500i Shift gère sans souci (charge ~53 % pic).

---

## 9. Auto-memories Cowork capitalisées

- `project_hardware_upgrade_bom_v4_s101.md` — pointeur BoM v4
- `feedback_dram_ddr5_2026_marche_casse.md` — règle vérification prix réels
- `feedback_btf_motherboard_requires_btf_case.md` — règle compat BTF
- `feedback_amd_ddr5_max_6000_mhz.md` — sweet spot strict AMD AM5

Voir [`memory/MEMORY.md`](../../memory/MEMORY.md) section **Architecture & projets actifs**.

---

*BoM v4 finalisée Session 101 — 4 mai 2026. Mickael peut commander en l'état.*
