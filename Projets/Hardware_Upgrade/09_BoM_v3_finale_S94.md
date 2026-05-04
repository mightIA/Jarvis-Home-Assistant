---
title: BoM v3 finale — hardware upgrade S94
date: 2026-05-03
session: S94
version: 3.0
status: validated_by_mickael
budget_total_eur: 3290
budget_initial_cible_eur: 2500
depassement_eur: 790
depassement_pct: 32
cause_depassement: dram_nand_crisis_2026
---

# 09 — BoM v3 finale (mai 2026)

**Version** : 3.0 (post DRAM/NAND crisis 2026)
**Date** : 03/05/2026 (S94)
**Statut** : ✅ Validé Mickael — prêt à commander

Suite directe de :
- `02_BoM_finalisee.md` (V1, S55-S56, prix avril 2026 désormais périmés)
- `08_Audit_S63_et_re_evaluation_hardware.md` (S65, qwen35-agent V1 validé sur RTX 3090 actuelle)

---

## ⚠ Avertissement prix mai 2026

Les composants **mémoire** (DDR5) et **SSD** (NAND) subissent une forte inflation depuis fin 2025 (DRAM crisis + NAND crisis liées au pic de demande HBM pour l'IA). Multiplicateurs ×3 à ×5 sur certains kits par rapport aux prix BoM avril 2026.

Détail dans `memory/reference_dram_nand_crisis_2026.md`. Mickael a explicitement validé le dépassement budget : *« on peut depasser le budget au vue des circonstances »*.

Stocks Amazon.fr vérifiés le 03/05/2026 mais fluctuent rapidement. Prix à reconfirmer le jour J.

---

## 1. PC Bureau — Cerveau IA (Ryzen 9 9950X3D)

### Composants à acheter

| # | Composant | Modèle exact | Prix EUR | Vendeur | Stock 03/05 |
|---|---|---|---|---|---|
| 1 | CPU | AMD Ryzen 9 9950X3D (16C/32T, 4.3/5.7 GHz, 144 Mo cache, 3D V-Cache 2e gen, 170W AM5) | 735 | [Amazon.fr](https://www.amazon.fr/dp/B0DVZSG8D5) | ⚠ 3 en stock |
| 2 | Refroidissement | Corsair iCUE XC7 RGB Elite LCD Stealth Gray (waterblock CPU custom loop, écran 2.1" 480×480, USB-C) | 165 | [Amazon.fr](https://www.amazon.fr/dp/B0CDHDS799) | 14 en stock |
| 3 | Carte mère | ASUS ProArt X870E-CREATOR WIFI (ATX AM5, 16+2+2 phases, 4×M.2, USB4 dual, 10G LAN, WiFi 7) | 370 | [Amazon.fr](https://www.amazon.fr/dp/B0DF123GCV) | Dispo |
| 4 | RAM | Corsair Vengeance RGB DDR5 64 Go (2×32) 6000 MHz CL30 EXPO (`CMH64GX5M2B6000Z30`) | 1050 | [Materiel.net](https://www.materiel.net/recherche/?search=Corsair+Vengeance+RGB+64+Go+DDR5+6000+CL30+EXPO) | Vérifier |
| 5 | SSD système | Samsung 990 Pro 2 To NVMe Gen4 (7450/6900 MB/s, `MZ-V9P2T0BW`) | 440 | [Amazon.fr](https://www.amazon.fr/dp/B0B9C4DKKG) | Dispo |
| | **Sous-total PC Bureau** | | **2 760** | | |

### Composants existants réutilisés (pas d'achat)

- ✅ **Alimentation Corsair 1000W** déjà possédée (économie 200 €)
- ✅ **Boîtier Corsair 1000D** déjà possédé (économie 180 €)
- ✅ **Custom loop watercooling Corsair Hydro X complet** : pompe + réservoir + radiateur + tubes + raccords G1/4" BSPP. Seul le waterblock CPU AM5 (XC7 Elite LCD) est ajouté
- ✅ **Carte graphique RTX 3090 24 Go** migrée depuis l'i9-9900K (pas d'achat GPU)
- ✅ **Pâte thermique XTM70** pré-appliquée sur le waterblock (économie 10 € NT-H2)

### Notes techniques

- **CPU 9950X3D** : sweet spot 3D V-Cache 2e gen pour LLM local (Hermès Agent qwen35-agent V1 validé S63 sur RTX 3090 actuelle). 144 Mo cache + 16C/32T = excellent en cache-heavy workloads. Pâte XTM70 pré-appliquée.
- **Waterblock XC7 Elite LCD** : G1/4" BSPP standard = compatible custom loop Hydro X existant. Écran 2.1" 480×480 IPS connecté en USB-C interne (header USB 2.0 onboard ProArt). iCUE software pour personnalisation (Windows only).
- **CM ProArt X870E-CREATOR** : sweet spot perf/prix vs ROG Crosshair X870E EXTREME (1000 €) ou DARK HERO (700 €). Comparatif honnête : VRM 16+2+2 suffit pour 9950X3D non-OC, 4 slots M.2 (2 PCIe 5 + 2 PCIe 4), 10G LAN Marvell AQC113, dual USB4 40 Gbps, WiFi 7 BE200. Esthétique sobre cohérente avec usage PC bureau.
- **RAM 2×32 6000 CL30** : sweet spot AM5 + 9950X3D (2 DIMM single-rank stable à 6000 MHz EXPO, 4 DIMM = downclock à 3600-3800 officiel + risque instabilité). RGB validé pour cohérence iCUE avec waterblock LCD.
- **SSD 990 Pro 2 To** : 1 seul (pas 2) car le SSD 1 To du PC bureau actuel migrera sur le PC domo. Choix Samsung vs Crucial T500 = même perf en LLM (chargement séquentiel), Samsung préféré pour cohérence Magician.

---

## 2. PC Domotique — Proxmox (i9-9900K recyclé)

### Composants à acheter

| # | Composant | Modèle exact | Prix EUR | Vendeur | Stock 03/05 |
|---|---|---|---|---|---|
| 6 | HDD surveillance | WD Purple 8 To 3.5" SATA 6Gb/s (`WD85PURZ`, 256 Mo cache, 180 To/an workload) | 250 | [Materiel.net](https://www.materiel.net/recherche/?search=WD+Purple+8+To+WD85PURZ) | Vérifier |
| 7 | RAM (2e kit identique) | Corsair Vengeance RGB Pro SL DDR4 32 Go (2×16) 3600 MHz CL18 (`CMW32GX4M2Z3600C18`) | 280 | [Materiel.net](https://www.materiel.net/recherche/?search=Corsair+Vengeance+RGB+Pro+SL+32+Go+DDR4+3600+CL18) | Vérifier |
| | **Sous-total PC Domotique** | | **530** | | |

### 📌 Référence RAM existante (à racheter identique)

Identifiée S94 via `Get-CimInstance Win32_PhysicalMemory` :

- **Modèle** : Corsair Vengeance RGB Pro SL DDR4-3600 CL18
- **Référence Corsair** : `CMW32GX4M2Z3600C18`
- **Configuration actuelle** : kit dual channel 2× 16 Go = 32 Go total
- **Fréquence** : 3600 MHz (XMP activé) — **Timings** : CL18-22-22-42 — **Tension** : 1.35 V
- **Format** : Low-profile SL (36 mm)
- **Slots utilisés** : ChannelA-DIMM2 + ChannelB-DIMM2 (slots A2 + B2)
- **Action** : acheter un 2e kit identique → 4× 16 Go = 64 Go cohérents (limite officielle Intel i9-9900K)

Voir `memory/reference_ram_corsair_pc_actuel.md` pour la fiche détaillée.

### ⚠ Ne PAS prendre la RAM Crucial DDR4-2666 prévue dans la BoM V1

`Crucial CT2K16G4DFRA266` DDR4-2666 CL19 (BoM V1) → **mismatch fatal** : downclock à 2666 MHz + timings très différents → risque instabilité.

### Composants existants réutilisés (pas d'achat)

- ✅ Carte mère ASUS ROG MAXIMUS XI HERO Z390
- ✅ CPU Intel i9-9900K
- ✅ **RAM existante 2× 16 Go Corsair Vengeance RGB Pro SL DDR4-3600 CL18** (slots A2 + B2)
- ✅ Alimentation et boîtier actuels
- ✅ **SSD 1 To migré du PC bureau actuel** (réaffecté au système Proxmox, économie 70 € vs Crucial P3 Plus prévu BoM V1)
- ✅ **Switch TP-Link LS108G existant** (8 ports Gigabit, suffit pour 5-6 cams 4K + Frigate, économie 130 € vs TP-Link 2.5G prévu BoM V1)
- ✅ Coral USB Accelerator + 2× dongles Sonoff Zigbee 3.0 USB Dongle Plus (transferts depuis Pi5 lors de la migration HA)
- ✅ **Câbles réseau achetés séparément par Mickael** (économie 30 €)

### Notes techniques

- **HDD WD Purple 8 To** : conservé après réflexion sur NAS séparé. Le 8 To donne plusieurs années de marge en attendant l'achat d'un NAS dédié pour la surveillance Frigate. Aucun risque de manquer d'espace.
- **2 DIMM ajoutés en slots A1 + B1** (les 2 DIMM existants restent en A2 + B2). Configuration 4× 16 Go cohérente, XMP 3600 MHz CL18 1.35V tous identiques.
- **Note 4 DIMM Z390 + i9-9900K** : le contrôleur mémoire peut auto-downclock à 3200 ou 3000 MHz en 4 DIMM (limite plateforme), sans impact sur usage serveur Proxmox.
- **Switch LS108G 1G largement suffisant** : 5-6 cams 4K RTSP = ~50-60 Mbps cumulés, on utilise ~6 % du Gigabit. Bottleneck WAN reste la fibre Orange 1 Gbps. Upgrade vers 2.5G pertinent uniquement si 8+ cams ou NAS multi-clients.

---

## 3. Récapitulatif budget

| Bloc | Prix EUR |
|---|---|
| PC Bureau | 2 760 |
| PC Domotique | 530 |
| **TOTAL MATÉRIEL** | **3 290** |
| Budget cible initial S55-S56 | 2 500 |
| **Dépassement** | **+790 € / +32 %** |

### Économies déjà réalisées vs BoM V1

| Économie | Montant |
|---|---|
| Alim Corsair 1000W gardée (vs RM1000x neuf) | -200 € |
| Boîtier Corsair 1000D gardé (vs Define 7) | -180 € |
| Custom loop Hydro X gardé (waterblock seul vs AIO complet) | -110 € |
| Switch LS108G 1G gardé (vs TP-Link 2.5G) | -130 € |
| SSD 1 To recyclé pour PC domo (vs Crucial P3 Plus) | -70 € |
| 1× Samsung 990 Pro au lieu de 2× | -440 € |
| Pâte thermique XTM70 fournie | -10 € |
| Câbles achetés séparément | -30 € |
| **Total économies** | **-1 170 €** |

Sans ces économies, le total serait **4 460 €**. Donc on a contenu la dérive crisis mémoire d'un facteur 2 grâce aux réutilisations.

---

## 4. Étapes prochaines (phasage A → G inchangé)

1. ✅ Validation finale Mickael BoM v3 (S94)
2. ⏳ Vérification stocks et prix jour J multi-vendeurs
3. ⏳ Commande groupée ou répartie
4. ⏳ Phase A test Hermès post-update v0.12.0 (déjà OK S93b)
5. ⏳ Phase B achat
6. ⏳ Phase C montage PC Bureau (Ryzen 9950X3D + waterblock dans loop existant + RAM Corsair RGB)
7. ⏳ Phase D recyclage i9-9900K en Proxmox + ajout 2× 16 Go DDR4 + migration SSD 1 To + WD Purple 8 To
8. ⏳ Phase E migration HA Pi5 → VM Proxmox
9. ⏳ Phase F Frigate VM + passthrough Coral USB
10. ⏳ Phase G monitoring Grafana/Prometheus + bascule définitive

Détail dans `03_Phasage_A_a_G.md`.

---

## 5. Liens fichiers complémentaires

- [02_BoM_finalisee.md](02_BoM_finalisee.md) — V1 historique S55-S56 (prix avril 2026 périmés)
- [03_Phasage_A_a_G.md](03_Phasage_A_a_G.md) — phasage 7 phases inchangé
- [08_Audit_S63_et_re_evaluation_hardware.md](08_Audit_S63_et_re_evaluation_hardware.md) — variantes 1/2/3 explorées S65
- `memory/reference_ram_corsair_pc_actuel.md` — fiche RAM existante détaillée
- `memory/reference_dram_nand_crisis_2026.md` — multiplicateurs prix mémoire 2026
- `memory/project_hardware_upgrade_bom_v3_s94.md` — auto-memory projet
- `memory/historique/2026-05-03_session_94_hardware_upgrade_bom_v3.md` — archive session
- `Configuration_PC_Bureau_et_Domo.pdf` (racine projet) — PDF v3 livré (2 pages, 7 composants, encadrés stocks/crisis prix/réf RAM)

---

*Fin de 09_BoM_v3_finale_S94.md — version 3.0 — 03 mai 2026 (S94)*
