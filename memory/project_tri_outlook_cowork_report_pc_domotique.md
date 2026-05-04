---
name: tri-outlook-cowork-report-pc-domotique
description: Tri Outlook Cowork laissé enabled malgré fragilité — seul dispositif pour might@live.fr jusqu'au PC domotique séparé
type: project
---

La Cowork scheduled task `tri-email-outlook-quotidien` (06h03 quotidien, pilote Outlook Web via Claude in Chrome / Brave) reste **enabled** en S96 malgré sa fragilité reconnue.

État S96 (03/05/2026) :
- Dernier `lastRunAt` réussi : **22/04/2026** (12 jours sans run effectif)
- Pré-requis pour qu'elle tourne à 06h03 : PC allumé ✅ (24/7) + Cowork desktop ouvert + Brave ouvert avec session `might@live.fr` valide + Claude in Chrome connecté → alignement improbable
- Référence le SKILL.md à 2 PDF abandonnés depuis S33 (`Protocole_Outlook_might_live_fr.pdf` + `Supprimer_IP_bans_FINAL.pdf`)
- **Aucune alternative existante** pour might@live.fr en S96 :
  - Pas de MCP stdio Outlook (pas d'équivalent à `gmail-mcp-local`)
  - Pas de launcher PowerShell pour Task Scheduler Windows
  - T#48 (MCP Outlook softeria) a été tentée S87→S93 puis **cancelled** (voir `project_t48_outlook_mcp_abandon_s92.md` pour les 5 critères de réactivation)

**Why:** Décision Mickael S96 — *« on reporte une fois que j'aurais mon pc bureau et domotique »*. S'aligne avec `project_hardware_upgrade.md` (S56) et `project_hardware_upgrade_bom_v3_s94.md` (BoM v3 finale 3290 € prête à commander). Le PC domotique séparé permettra une autonomie 24/7 plus fiable, où la migration tri Outlook deviendra prioritaire. Garder la Cowork enabled = au moins une chance qu'elle tourne occasionnellement quand l'alignement est OK ; l'enlever = zéro tri auto sur might@live.fr d'ici 12 semaines.

**How to apply:** Ne pas re-proposer de supprimer / désactiver `tri-email-outlook-quotidien` Cowork tant que le PC domotique n'est pas en service. Re-évaluer après upgrade hardware avec deux pistes possibles :
- **Option D** : migration Task Scheduler Windows + Claude in Chrome via MCP HTTP (parallèle à `Jarvis-TriGmail-Quotidien`). Brave reste obligatoire.
- **Option D++** : MCP IMAP générique ou Microsoft Graph à surveiller via T#91 (veille auto hebdo) → casserait la dépendance Brave et apporterait `batch_modify` natif comme côté Gmail.
