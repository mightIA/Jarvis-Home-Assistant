---
name: Reference RAM Corsair PC actuel Might-1000D
description: Modele exact RAM existante PC Might-1000D, a racheter identique pour atteindre 64 Go sur PC domotique Proxmox, eviter mismatch Crucial 2666 CL19
type: reference
created: 2026-05-03
updated: 2026-05-03
session: S94
tags: [reference, ram, corsair, ddr4, pc-domotique, proxmox]
---

# RAM existante PC Might-1000D

Identifiée via script PowerShell `Get-CimInstance -ClassName Win32_PhysicalMemory` en S94 (3 mai 2026).

## Spécifications exactes

- **Modèle** : Corsair Vengeance RGB Pro SL DDR4-3600 CL18
- **Référence Corsair** : `CMW32GX4M2Z3600C18`
- **Configuration actuelle** : kit dual channel 2× 16 Go = 32 Go total
- **Fréquence** : 3600 MHz (XMP activé)
- **Timings** : CL18-22-22-42
- **Tension** : 1.35 V (XMP, Windows affiche 1.2 V SPD JEDEC nominal)
- **Format** : Low-profile SL (Slim, hauteur 36 mm)
- **Slots utilisés** : ChannelA-DIMM2 + ChannelB-DIMM2 (slots A2 + B2 — config recommandée pour 2 barrettes)

## Action prévue (BoM v3 hardware upgrade S94)

Pour atteindre 64 Go sur le PC domotique Proxmox (i9-9900K recyclé, limite officielle Intel 64 Go), **acheter un 2e kit identique** `CMW32GX4M2Z3600C18` → total 4× 16 Go cohérents (mêmes timings, fréquence, tension, format).

Estimé prix mai 2026 : ~280 €.

## ⚠ NE PAS prendre

- **Crucial CT2K16G4DFRA266** DDR4-2666 CL19 (initialement prévu BoM avril 2026) — incompatible : downclock à 2666 + timings très différents → risque instabilité

## Note compatibilité 4 DIMM Z390 + i9-9900K

Le contrôleur mémoire i9-9900K peut **auto-downclock à 3200 ou 3000 MHz** en 4 DIMM (limite plateforme), mais sans impact sur usage serveur Proxmox. La cohérence 4 barrettes identiques garantit la stabilité.

## Liens recherche valide

- [Materiel.net — recherche kit Corsair Vengeance RGB Pro SL CMW32GX4M2Z3600C18](https://www.materiel.net/recherche/?search=Corsair+Vengeance+RGB+Pro+SL+32+Go+DDR4+3600+CL18)
- [Amazon.com — fiche produit (US)](https://www.amazon.com/dp/B082DGZJ9C)
- [Corsair officiel — fiche produit](https://www.corsair.com/us/en/p/memory/cmw32gx4m2z3600c18/vengeance-rgb-pro-32gb-2-x-16gb-ddr4-dram-3600mhz-cl18-memory-kit-cmw32gx4m2z3600c18)
