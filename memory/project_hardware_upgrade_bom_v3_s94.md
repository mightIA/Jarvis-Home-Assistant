---
name: Projet Hardware Upgrade — BoM v3 finale S94
description: BoM definitive mai 2026, 7 composants a acheter, 3290 EUR total, ref RAM existante figee, prix DRAM/NAND crisis assumés, PDF livré racine projet
type: project
status: ready_to_order
created: 2026-05-03
updated: 2026-05-03
session: S94
tags: [project, hardware, upgrade, bom-v3, t73, ryzen-9950x3d, custom-loop, asus-proart, corsair, samsung-990-pro, wd-purple]
references:
  - projets: Projets/Hardware_Upgrade/02_BoM_finalisee.md (V1, périmée prix)
  - projets: Projets/Hardware_Upgrade/08_Audit_S63_et_re_evaluation_hardware.md (S65)
  - projets: Projets/Hardware_Upgrade/09_BoM_v3_finale_S94.md (V3, à créer en parallèle)
  - memory: reference_ram_corsair_pc_actuel.md
  - memory: reference_dram_nand_crisis_2026.md
  - memory: project_hardware_upgrade.md (S56, à conserver pour historique BoM V1)
  - racine: Configuration_PC_Bureau_et_Domo.pdf (livrable v3)
---

# Hardware upgrade Jarvis — BoM v3 finale (mai 2026)

Finalisation S94 (3 mai 2026) de la BoM `Projets/Hardware_Upgrade/02_BoM_finalisee.md` (S55-S56) avec arbitrages composants 2026 + ajustements multi-itérations + prix DRAM/NAND crisis assumés.

## Architecture cible

- **PC Bureau** = nouveau PC cerveau IA AM5 sur lequel migre la RTX 3090 actuelle. Custom loop watercooling Corsair Hydro X complet existant réutilisé (pompe + radiateur + tubes + raccords G1/4" BSPP), seul le waterblock CPU AM5 est ajouté. Alim Corsair 1000W et boîtier Corsair 1000D existants conservés.
- **PC Domotique** = i9-9900K recyclé en serveur Proxmox 24/7 (HA OS migré du Pi5, Frigate VM, Docker host MQTT/Grafana/InfluxDB/Node-RED, PBS). Carte mère ASUS ROG MAXIMUS XI HERO Z390 et i9-9900K conservés. SSD 1 To migré du PC bureau actuel pour le système Proxmox.

## Composants à acheter (7 lignes)

### PC Bureau

| # | Composant | Référence | Prix mai 2026 | Lien |
|---|---|---|---|---|
| 1 | AMD Ryzen 9 9950X3D | (16C/32T, 4.3/5.7 GHz, 144 Mo cache, 3D V-Cache 2e gen, 170W AM5) | ~735 € | [Amazon.fr B0DVZSG8D5](https://www.amazon.fr/dp/B0DVZSG8D5) (3 en stock le 03/05) |
| 2 | Corsair iCUE XC7 RGB Elite LCD Stealth Gray | waterblock CPU custom loop, écran 2.1" 480×480 IPS, USB-C, AM5 | ~165 € | [Amazon.fr B0CDHDS799](https://www.amazon.fr/dp/B0CDHDS799) (14 en stock) |
| 3 | ASUS ProArt X870E-CREATOR WIFI | ATX AM5, 16+2+2 phases, 4×M.2, USB4 dual, 10G LAN, WiFi 7 | ~370 € | [Amazon.fr B0DF123GCV](https://www.amazon.fr/dp/B0DF123GCV) |
| 4 | Corsair Vengeance RGB DDR5 64 Go | 2×32 Go DDR5-6000 CL30 EXPO (CMH64GX5M2B6000Z30) | ~1 050 € | [Materiel.net recherche](https://www.materiel.net/recherche/?search=Corsair+Vengeance+RGB+64+Go+DDR5+6000+CL30+EXPO) |
| 5 | Samsung 990 Pro 2 To NVMe | M.2 PCIe 4.0 x4, 7450/6900 MB/s (MZ-V9P2T0BW) | ~440 € | [Amazon.fr B0B9C4DKKG](https://www.amazon.fr/dp/B0B9C4DKKG) |
| | **Sous-total PC Bureau** | | **2 760 €** | |

### PC Domotique

| # | Composant | Référence | Prix mai 2026 | Lien |
|---|---|---|---|---|
| 6 | WD Purple 8 To 3.5" SATA 6Gb/s | WD85PURZ, 256 Mo cache, 180 To/an workload | ~250 € | [Materiel.net recherche](https://www.materiel.net/recherche/?search=WD+Purple+8+To+WD85PURZ) |
| 7 | Corsair Vengeance RGB Pro SL DDR4 32 Go | 2×16 Go DDR4-3600 CL18 (CMW32GX4M2Z3600C18, **identique à l'existant** Might-1000D) | ~280 € | [Materiel.net recherche](https://www.materiel.net/recherche/?search=Corsair+Vengeance+RGB+Pro+SL+32+Go+DDR4+3600+CL18) |
| | **Sous-total PC Domotique** | | **530 €** | |

### TOTAL : 3 290 €

Dépassement budget initial 2 500 € : **+880 € / +37 %**, attribuable à la **crise mémoire et NAND 2026**. Voir `memory/reference_dram_nand_crisis_2026.md`.

## Composants existants réutilisés

### PC Bureau
- Alimentation Corsair 1000W (économie 200 €)
- Boîtier Corsair 1000D (économie 180 €)
- Custom loop Hydro X complet (pompe + réservoir + radiateur + tubes + raccords G1/4" BSPP)
- Carte graphique RTX 3090 24 Go (migrée depuis l'i9-9900K)
- Pâte thermique XTM70 fournie avec waterblock XC7 Elite LCD (économie 10 €)

### PC Domotique
- Carte mère ASUS ROG MAXIMUS XI HERO Z390
- CPU Intel i9-9900K
- **RAM existante** 2× 16 Go Corsair Vengeance RGB Pro SL DDR4-3600 CL18 (`CMW32GX4M2Z3600C18`, slots A2 + B2). Voir `memory/reference_ram_corsair_pc_actuel.md`
- Alimentation et boîtier actuels
- **SSD 1 To migré du PC bureau actuel** (réaffecté au système Proxmox, économie 70 €)
- Switch **TP-Link LS108G existant** (8 ports Gigabit, suffit pour 5-6 cams 4K + Frigate, économie 130 €)
- Coral USB Accelerator + 2× dongles Sonoff Zigbee 3.0 USB Dongle Plus (transferts depuis Pi5)
- Câbles réseau achetés séparément par Mickael (économie 30 €)

## Choix non retenus (pour mémoire)

- **Refroidissement** : NH-D15 (économie marginale, pas de LCD), AIO Nautilus 360 RS LCD (mais Mickael a son custom loop), module LCD Nautilus seul (n'est pas un système de refroidissement)
- **Carte mère** : ROG Crosshair X870E EXTREME (1000 €, redondant avec écran XC7 LCD), DARK HERO (700 €, +120 € pour ~3 % gain X3D), Gigabyte X670E AORUS Elite AX (BoM initiale, dépassée par ProArt mai 2026)
- **RAM Bureau** : G.Skill Trident Z5 NEO 64 Go (BoM initiale), Corsair Vengeance 192 Go 4×48 (refusé compatibilité AM5 4 DIMM = 3600-3800 MHz officiel + sur-dimensionné), Vengeance 96 Go (réfléchi puis 64 Go suffisent)
- **RAM Bureau RGB** : Corsair Dominator Titanium (premium, +150-200 € vs Vengeance RGB pour mêmes specs perf)
- **SSD système** : Samsung 9100 Pro PCIe 5.0 (+110-180 €, gain réel ~0 sur le profil Mickael), 2e Samsung 990 Pro 2 To (Mickael recycle son SSD 1 To actuel à la place)
- **CPU** : Ryzen 9 9950X non-X3D (perd le 3D V-Cache, intéressant pour cache-heavy workloads / LLM local)
- **HDD Domo** : WD Red Plus 1 To NAS (Mickael revient au 8 To pour la marge avant NAS dédié)
- **RAM Domo** : Crucial CT2K16G4DFRA266 DDR4-2666 CL19 (BoM initiale) — **EXPLICITEMENT REFUSÉ S94** : mismatch fatal avec l'existant Corsair 3600 CL18

## Étapes prochaines

1. ⏳ Validation finale Mickael de cette BoM v3 — **VALIDÉ S94** (« c'est bon clôture la discussion »)
2. ⏳ Vérification prix jour J multi-vendeurs (LDLC + Materiel.net + Amazon.fr + idealo)
3. ⏳ Vérification stock Ryzen 9 9950X3D (3 unités Amazon.fr alerte rouge)
4. ⏳ Commande groupée ou répartie selon meilleurs prix
5. ⏳ Phase A (test Hermès post-update v0.12.0 sur stack actuelle, déjà fait S93b)
6. ⏳ Phase B (achat) → Phase C (montage PC Bureau) → Phase D (recyclage i9-9900K en Proxmox) → Phase E (migration HA Pi5 → VM) → Phase F (Frigate) → Phase G (monitoring)

Phasage A → G inchangé vs `Projets/Hardware_Upgrade/03_Phasage_A_a_G.md`.

## Statut backlog

- **T#73** (projet hardware upgrade) reste **ouverte** avec BoM v3 finalisée. Pas de NO-GO acté. Décision Mickael : on commande quand prêt, sans attendre la fin de la crise mémoire.
- Pas de nouvelle tâche créée S94. Conservation du statut existant.

## Livrables S94

- **Configuration_PC_Bureau_et_Domo.pdf** (racine projet) — PDF v3 livré, 2 pages, 7 composants, encadré bleu réf RAM existante, colonne stock Amazon.fr, encadré rouge crisis prix mai 2026
- **memory/historique/2026-05-03_session_94_hardware_upgrade_bom_v3.md** — archive session complète
- **memory/reference_ram_corsair_pc_actuel.md** — réf RAM existante figée
- **memory/reference_dram_nand_crisis_2026.md** — multiplicateurs prix mémoire 2026
- **memory/project_hardware_upgrade_bom_v3_s94.md** — ce fichier (BoM v3 finalisée)
- **Projets/Hardware_Upgrade/09_BoM_v3_finale_S94.md** — équivalent côté projet (cf. step 7 plan S94)
