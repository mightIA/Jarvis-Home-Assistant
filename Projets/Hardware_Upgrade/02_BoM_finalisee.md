# 02 — Bill of Materials finalisée

**Date** : 26/04/2026 (S55)
**Budget cible** : 2500 €
**Statut** : ⏳ En attente validation Mickael avant commande

---

## ⚠️ Avertissements

1. **Prix indicatifs** au 26/04/2026, à reconfirmer le jour de la commande
2. **Dispos AM5** : checker stock chez 3 vendeurs (LDLC, TopAchat, Materiel.net)
3. **Coordonner achat** : commande groupée ou répartie selon ports de stock
4. **Cartes graphiques** : la RTX 3090 actuelle migre, pas d'achat GPU

---

## 1. PC Ryzen — Cerveau IA

### Composants principaux

| Catégorie | Composant | Modèle proposé | Prix indicatif EUR |
|---|---|---|---|
| CPU | Processeur AM5 | **AMD Ryzen 9 7950X** (16C/32T, 4.5/5.7 GHz, 170W TDP) | 580 |
| Refroidissement CPU | Ventirad | **Noctua NH-D15 chromax.black** (compatible AM5, dissipe 230W spike) | 110 |
| Carte mère | X670E ATX | **Gigabyte X670E AORUS Elite AX** (4× M.2 PCIe 5/4, 2.5G LAN, WiFi 6E, 16+2+2 phases) | 280 |
| RAM | DDR5 EXPO 64 Go | **G.Skill Trident Z5 NEO 2×32 Go DDR5-6000 CL30** (réf F5-6000J3040G32GX2-TZ5N) | 240 |
| Alimentation | ATX 1000W | **Corsair RM1000x 80+ Gold modulaire** (2024 revision, conforme ATX 3.0) | 200 |
| Boîtier | ATX silencieux | **Fractal Design Define 7** (insonorisé, 8× emplacements 3.5", flux d'air optimisé) | 180 |
| SSD système | NVMe Gen4 2 To | **Samsung 990 Pro 2 To** (7450/6900 MB/s, fiabilité top) | 170 |
| SSD modèles IA | NVMe Gen4 2 To | **Crucial T500 2 To** (7400/7000 MB/s, modèles Ollama + cache Hermès) | 130 |
| Pâte thermique | Noctua | **Noctua NT-H2** (3.5g, fournie d'origine avec NH-D15 mais spare) | 10 |
| **Sous-total Ryzen** | | | **1900** |

### Notes techniques

- **CPU** : le 7950X est un sweet-spot perf/prix vs le 9950X (Zen 5, +10% perf, +120 € prix). Garder l'argent pour upgrade futur RAM ou 9950X3D.
- **CM Gigabyte X670E AORUS Elite AX** : choix VFM, 4× M.2 NVMe (système + IA + 2 spare futurs), VRM 16+2+2 phases (overclock potentiel), 2.5 GbE Realtek + WiFi 6E.
- **RAM 2×32** au lieu de 4×16 : AM5 préfère 2 barrettes pour stabilité 6000 MHz CL30. Upgrade futur 128 Go = racheter 2×32 du même kit.
- **Alim 1000W** : RTX 3090 = 350W TDP + spike 480W ; Ryzen 7950X = 230W spike → headroom + efficacité 80+ Gold.
- **Boîtier Define 7** : silencieux (panneaux insonorisés), bonne ventilation, support 8× HDD si évolution NAS futur.

### Choix non retenus (pour mémoire)

| Composant | Alternative | Pourquoi écarté |
|---|---|---|
| CPU | Ryzen 9 9950X (Zen 5) | +120 € pour +10% perf, AM5 garantit upgrade futur |
| CPU | Ryzen 9 7900X | -120 € pour 12C/24T au lieu de 16C/32T, marge insuffisante pour parallèle Hermès+Ollama+Cowork |
| CM | ASUS ROG STRIX X670E-E | +100 €, esthétique RGB inutile pour ce projet |
| RAM | 4×16 Go DDR5-5600 | AM5 instable en 4 barrettes |
| Refroidissement | AIO 360mm (Corsair iCUE H150i) | Pompe = pièce d'usure, NH-D15 silencieux et fiable 10 ans |
| Boîtier | Lian Li O11 Dynamic | Verre trempé, esthétique gaming, moins silencieux |

---

## 2. Proxmox add-ons (sur i9-9900K existant)

### Composants à acheter

| Catégorie | Composant | Modèle proposé | Prix indicatif EUR |
|---|---|---|---|
| RAM additionnelle | DDR4 2×16 Go | **Crucial CT2K16G4DFRA266** (2×16 DDR4-2666 CL19) | 80 |
| SSD système Proxmox | NVMe Gen3 1 To | **Crucial P3 Plus 1 To** (5000/3600 MB/s, fiable, prix correct) | 70 |
| HDD surveillance | 3.5" 8 To 7200 rpm | **WD Purple WD85PURZ 8 To** (NVR optimisé, 256 Mo cache, 180 To/an workload) | 200 |
| **Sous-total Proxmox** | | | **350** |

### Notes techniques

- **RAM** : 2×16 Go à ajouter aux 2×16 actuels = 4×16 Go = 64 Go (limite officielle Intel i9-9900K). JEDEC 2666 CL19 = standard, stable sans XMP.
- **SSD Proxmox** : Crucial P3 Plus est un SSD entry-level mais largement suffisant pour OS + VMs (pas de DB transactionnelle). Optionnellement : 2× P3 Plus 1 To en miroir ZFS pour redondance (~140 € au lieu de 70 €). À arbitrer.
- **HDD WD Purple** : conçu pour vidéo surveillance 24/7, MTBF 1.5M heures. Alternative : Seagate Skyhawk 8 To (~190 €), équivalent.

### Composants existants (réutilisés, ne pas racheter)

- ✅ Carte mère : ASUS ROG MAXIMUS XI HERO (WI-FI) Z390
- ✅ CPU : Intel i9-9900K
- ✅ RAM existante : 2×16 Go DDR4 (à compléter)
- ✅ Alimentation : à vérifier modèle exact (probablement >= 650W déjà OK pour Proxmox sans GPU)
- ✅ Boîtier : actuel
- ✅ Coral USB Accelerator (transfert depuis Pi5)
- ✅ Dongles Sonoff Zigbee 3.0 USB Dongle Plus ×2 (transfert depuis Pi5)

---

## 3. Réseau

| Catégorie | Composant | Modèle proposé | Prix indicatif EUR |
|---|---|---|---|
| Switch 2.5G | 8 ports | **TP-Link TL-SG108-M2** (8× 2.5 GbE, non managé, fanless) | 130 |
| Câbles | Cat6A 1m × 5 | Lot Vention / Belkin Cat6A | 30 |
| **Sous-total réseau** | | | **160** |

### Pourquoi 2.5G

- 5-6 caméras IP RTSP @ 4K = ~50 Mbps continu
- Frigate VM ↔ HDD vidéo : transferts importants
- LAN actuel probablement 1 Gbps (box Orange + switch standard)
- Le bottleneck WAN reste 1 Gbps (fibre Orange) → mais LAN à 2.5G débloque les transferts intra-LAN
- Pas besoin de 10 GbE (overkill, coût prohibitif)

---

## 4. Onduleurs (déjà possédés, configuration uniquement)

| Onduleur | Modèle | État | Action |
|---|---|---|---|
| Smart-UPS 2200 | **APC SMT2200IC** | Possédé | Câble USB-B → Proxmox host + config NUT |
| Back-UPS Pro 900 | **APC BR900G-FR** | Possédé | Câble USB → PC Ryzen + config apcupsd ou NUT |

Voir `05_Onduleurs_NUT.md` (à créer) pour la procédure détaillée.

---

## 5. Récapitulatif budget

| Bloc | Sous-total EUR |
|---|---|
| PC Ryzen (cerveau IA) | 1900 |
| Proxmox add-ons | 350 |
| Réseau | 160 |
| **Total matériel** | **2410** |
| **Marge sur 2500 €** | **90 €** (consommables, frais port, imprévus) |

### Si économie nécessaire (variantes -100 à -300 €)

| Choix | Économie | Impact |
|---|---|---|
| Ryzen 9 7900X au lieu de 7950X (12C au lieu de 16C) | -120 € | Acceptable, marge moindre pour modèles 70B futurs |
| Crucial T500 2 To au lieu de Samsung 990 Pro (système) | -40 € | Acceptable, T500 = très bon SSD aussi |
| be quiet! Pure Base 500DX au lieu de Define 7 | -100 € | Moins silencieux mais OK |
| Pas de switch 2.5G | -130 € | Garder LAN 1 GbE actuel (suffit pour 3 cams, à monter avec 5-6) |

### Si budget supplémentaire dispo (+200 à +500 €)

| Choix | Surcoût | Bénéfice |
|---|---|---|
| 2× SSD Proxmox en miroir ZFS | +70 € | Redondance système, pas d'arrêt si 1 SSD lâche |
| 128 Go DDR5 (4×32) au lieu de 64 Go | +250 € | Modèles 70B Q4 viable (Llama 3.3, Qwen 72B) |
| AP9631 Network Management Card SMT2200IC | +250 € | Monitoring SNMP, alertes mail directes onduleur |
| 2e HDD WD Purple 8 To en miroir | +200 € | Frigate vidéo redondant |

---

## 6. Liens d'achat à valider (LDLC, TopAchat, Materiel.net)

| Composant | LDLC | TopAchat | Materiel.net |
|---|---|---|---|
| Ryzen 9 7950X | À chercher | À chercher | À chercher |
| Gigabyte X670E AORUS Elite AX | À chercher | À chercher | À chercher |
| G.Skill Trident Z5 NEO 64 Go DDR5-6000 | À chercher | À chercher | À chercher |
| Noctua NH-D15 chromax.black | À chercher | À chercher | À chercher |
| Corsair RM1000x | À chercher | À chercher | À chercher |
| Fractal Design Define 7 | À chercher | À chercher | À chercher |
| Samsung 990 Pro 2 To | À chercher | À chercher | À chercher |
| Crucial T500 2 To | À chercher | À chercher | À chercher |
| WD Purple 8 To | À chercher | À chercher | À chercher |
| Crucial DDR4 2×16 Go 2666 | À chercher | À chercher | À chercher |
| Crucial P3 Plus 1 To | À chercher | À chercher | À chercher |
| TP-Link TL-SG108-M2 | À chercher | À chercher | À chercher |

➡️ **Tâche prochaine session** : remplir ce tableau avec les URLs et prix exacts du jour J pour la commande.

---

## 7. Prochaines étapes

1. ⏳ Validation finale Mickael de cette BoM
2. ⏳ Génération `03_Phasage_A_a_G.md` (les 7 phases d'exécution)
3. ⏳ Génération `04_Risques_et_mitigations.md`
4. ⏳ Génération `05_Onduleurs_NUT.md`
5. ⏳ Validation Phase 1bis-d Hermès **AVANT** achat (test mistral-nemo:12b ou Llama 3.3 70B Q3 sur RTX 3090 actuelle)
6. ⏳ Audit IOMMU live Linux sur i9-9900K (procédure dans `03_Phasage`)
7. ⏳ Comparaison prix sur 3 vendeurs (LDLC / TopAchat / Materiel.net)
8. ⏳ Commande groupée
9. ⏳ Phase 2 : montage PC Ryzen
