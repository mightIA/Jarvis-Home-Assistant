---
title: Inventaire physique maison
created: 2026-04-27
updated: 2026-04-27
tags: [inventaire, moc, domaine]
status: stub
domaine: Inventaire
remplissage_attendu: Mickael
---

# MOC — Inventaire physique de la maison

Inventaire physique complet de la maison Mickael à Seremange-Erzange (57).
Couvre le matériel, l'électroménager, les piles, les équipements connectés et non connectés, les meubles et éléments fixes, pièce par pièce.
Complément de [Home Assistant — Inventaire (hors vault)](../../../Ressources/Competences/Home_Assistant_Inventaire.md) qui couvre, lui, le côté HA/numérique (intégrations, add-ons, dépôts, raccourcis).

> **État actuel : COQUILLE.** Les templates sont en place, le remplissage demande Mickael lors d'une session dédiée (photos pièce par pièce + factures + captures HA).

---

## Navigation par pièce

- [[Salon]] — TV, ampli, console(s), enceintes, ampoules connectées, prises, capteurs
- [[Cuisine]] — gros et petit électroménager, ampoules, transmetteurs IR, capteurs
- [[Chambre_principale]] — éclairage, MightTab, prises, capteurs
- [[Autres_chambres]] — chambres enfants (par enfant si pertinent)
- [[Salle_de_bain]] — chauffage, capteurs humidité, ampoules, Apple TV
- [[Bureau]] — PC MIGHT-1000D, périphériques Logitech + Razer Tartarus, écrans, audio
- [[Garage_Cave]] — chaudière Frisquet, onduleurs APC, Pi5, dongles Zigbee, stockage
- [[Exterieur]] — caméras Dahua, capteurs météo, jardin
- [[Reseau_Maison]] — Livebox Orange, switches, points d'accès Wifi, IPs fixes
- [[Batteries_Piles]] — inventaire transverse des piles à surveiller (Zigbee, télécommandes, capteurs)

---

## Conventions

- **Une pièce = un fichier**, sauf transverses (`Reseau_Maison`, `Batteries_Piles`).
- Tableau "Équipements connectés (HA / Zigbee / WiFi)" → mappe vers entité HA quand connue (`light.salon_principal`, `sensor.cuisine_temp`, etc.).
- Tableau "Équipements non connectés" → date achat + garantie + numéro de série quand utile.
- Liens internes vers `10_Domaines/Hardware/*` pour le matériel détaillé déjà documenté.
- Liens vers `10_Domaines/ViePerso/Garanties_Factures` pour les factures associées (à créer si besoin).

---

## Sources de remplissage à venir (toutes pièces)

- Photos pièce par pièce (à faire avec Mickael)
- Factures dans dossier physique Mickael
- Captures écran HA dashboards (Lovelace par pièce)
- Export ZHA / Zigbee2MQTT (liste des devices avec batteries / link quality)
