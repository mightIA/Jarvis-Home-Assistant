---
title: Home Assistant — Index du domaine
created: 2026-04-25
tags: [moc, ha]
status: actif
source: Ressources/Competences/Home_Assistant.md + Home_Assistant_Inventaire.md + Mode_Reactif.md
---

# Home Assistant — Index du domaine

Hub central pour tout ce qui touche à l'installation Home Assistant de
Mickael (Seremange-Erzange, 57). Toutes les notes atomiques sont dans
ce dossier.

## Connexion & sécurité

- [[Connexion et accès]] — URLs locale/distante, règle 401/403, SSH
- [[Débannissement IP]] — 2 méthodes (terminal SSH local, File Editor distant)
- [[../Cloudflare/_Index|Cloudflare]] — CF Access, bypass MCP, HSTS, MFA

## Administration

- [[Modifications config]] — recharger vs redémarrer (table de décision)
- [[Apps installées]] — 25 add-ons + 9 dépôts custom (HACS, ha-mcp, etc.)
- [[Intégrations]] — 62 intégrations configurées par catégorie
- [[Outils sidebar]] — 19 outils accessibles dans la barre latérale
- [[Procédures diagnostiques]] — appareil HS, interface qui ne charge pas
- [[Raccourcis clavier]] — A/C/E/D/M/Ctrl+K + piège Shift+? AZERTY

## Mode Réactif (v1.1, déployé S22-S32)

- [[Mode Réactif - Vue d'ensemble]] — principe, schéma global, ce qu'il n'est pas
- [[Mode Réactif - Niveaux d'autonomie]] — 5 niveaux (Off → Max auto)
- [[Mode Réactif - Pipeline alertes]] — label Gmail Jarvis-Alert, convention de sujet
- [[Mode Réactif - Décisions S31 CLI]] — bascule Option A, mitigation moindre privilège

## Devices (notes hors HA pur)

- [[../Frisquet/_Index|Chaudière Frisquet]]
- [[../Cameras/_Index|Caméras Dahua]]
- [[../Domotique/_Index|Domotique appareils]] (Dyson, Browser Mod, …)

## Recherche rapide

```dataview
TABLE WITHOUT ID file.link AS "Note", file.cday AS "Créée"
FROM "10_Domaines/HomeAssistant"
WHERE file.name != "_Index"
SORT file.name ASC
```

---

*MOC du domaine Home Assistant. Source : `Ressources/Competences/Home_Assistant*.md` + `Mode_Reactif.md`.*
