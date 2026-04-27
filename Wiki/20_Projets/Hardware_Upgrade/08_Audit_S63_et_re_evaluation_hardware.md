---
title: 08 — Audit S63 et ré-évaluation hardware
created: 2026-04-27
migrated_from: Projets/Hardware_Upgrade/08_Audit_S63_et_re_evaluation_hardware.md
status: en-attente-decision-mickael
phase: 0
budget_target: variable (V1 2410 / V2 2150-2290 / V3 1100-1400 EUR)
bloqueur: arbitrage-variante-bom
tags: [projet, hardware, proxmox, ryzen, audit, re-evaluation]
---

# Audit S63 et ré-évaluation hardware

**Date** : 27/04/2026 (S65 Cowork — suite directe S63 audit méthodologique 2)
**Auteur** : Jarvis Cowork, sur demande Mickael
**Statut** : 🟢 Document de référence — l'upgrade hardware **reste d'actualité**, le périmètre est juste re-cadré
**Réfèrent décision** : Mickael uniquement

---

## 🎯 Pourquoi ce document

L'audit méthodologique 2 conduit en S63 (26/04/2026) a produit deux résultats qui touchent directement le projet d'upgrade hardware :

1. **Hermès local fonctionne** sur la RTX 3090 actuelle après `hermes update` (4 commits critiques `reasoning_content` ingérés). Le modèle `qwen35-agent` V1 valide trois scénarios test (action 5m6s, lecture 2m40s, multi-step 2m57s).
2. Le facteur GPU n'est donc **plus le goulot d'étranglement** prioritaire pour le cerveau IA.

Sans ce document, on risquait deux dérives opposées :

- **Dérive A** — acter un NO-GO total sur l'upgrade alors que **Pi5 reste limité côté Proxmox/Frigate** et que la consolidation services en Proxmox garde toute sa valeur.
- **Dérive B** — partir sur la BoM Ryzen 9 7950X complète sans re-questionner la pertinence du haut de gamme CPU, alors que l'argument "futur LLM 70B local" perd de sa force avec qwen35-agent V1 qui suffit.

Ce document recadre donc le périmètre, sans modifier les fichiers de spec existants (BoM, phasage, architecture). Mickael validera plus tard l'éventuelle bascule vers une variante BoM ajustée.

---

## 🧾 Constats S63 (rappel synthétique)

| Élément | État pré-S63 | État post-S63 |
|---|---|---|
| Hermès local écriture HA | ❌ KO ("empty after tool calls") | ✅ OK 3/3 scénarios |
| Latence action HA via Hermès local | non mesurable | 5m6s |
| Latence lecture multi-sensors | non mesurable | 2m40s |
| Latence multi-step | non mesurable | 2m57s |
| Modèle de référence local | qwen3:32b durci (S57, dérive sémantique) | **qwen35-agent V1** post-update |
| Pattern PDF v2 viable | hybride OpenRouter dominant | **Hermès local 75% + Claude délégation 20% + OpenRouter 5%** |

Détails techniques complets dans `Projets/Cookbook_Hermes_RTX3090/docs/audit-methodologique.md` et l'archive de session `memory/historique/2026-04-26_session_63_audit_methodologique_2_succes.md`.

---

## 🪜 Ce qui change pour le projet hardware

### Ce qui ne change PAS

1. **Pi5 reste limité côté domotique** — il ne peut pas raisonnablement héberger Proxmox, plusieurs caméras Frigate, et les VM services (MQTT, Grafana, etc.). Cette limite était la justification première du projet et reste intacte.
2. **i9-9900K en Proxmox** — la consolidation des services côté machine actuelle reste pertinente : HA OS migré du Pi5, Frigate VM avec passthrough Coral USB, Docker host pour MQTT/Portainer/Grafana, Proxmox Backup Server.
3. **Architecture brain/body 2 machines** — le découplage cerveau IA / corps domotique reste l'objectif cible.
4. **Onduleurs APC SMT2200IC + BR900G-FR** — déjà possédés, plan d'affectation Phase D/C inchangé.
5. **Réseau TP-Link TL-SG108-M2** — toujours utile (commun aux deux scénarios).
6. **Phasage A→G** — la séquence reste valide, seule la Phase B (achat) peut être ajustée selon variante BoM.

### Ce qui peut être réinterrogé

1. **Justification "Ryzen 9 7950X"** — l'argument central était "anticiper LLM 70B local". Avec qwen35-agent V1 OK sur RTX 3090 actuelle (qui sera **migrée** dans le nouveau PC, pas remplacée), un Ryzen 7700X ou 7900X **pourrait suffire** pour le cerveau IA. Économie potentielle : 120-260 €.
2. **Justification "64 Go DDR5-6000"** — utile pour Hermès + Cowork + sessions multiples. Mais 32 Go pourrait couvrir les besoins courants. À arbitrer selon usage réel observé en S63+ (mesure RAM dans WSL2 sous charge).
3. **Calendrier d'achat** — moins d'urgence puisque Mode Réactif fonctionne déjà sur la stack actuelle. La fenêtre s'ouvre, plus besoin de précipiter.
4. **Phase E (migration HA Pi5 → VM Proxmox)** — gagne en priorité relative dans le projet, puisque c'est elle qui débloque vraiment la valeur (Pi5 hors-jeu, Frigate proprement isolée).

---

## 🛒 Variantes BoM envisageables

Sans valider quoi que ce soit, voici les trois pistes à arbitrer plus tard avec Mickael :

### Variante 1 — BoM originale (S56)
- Ryzen 9 7950X + 64 Go DDR5-6000 + RTX 3090 (réutilisée) + Proxmox add-ons + switch 2.5G
- Total ~2410 €
- Justification : marge de manœuvre maximale pour LLM 70B éventuels, multi-tâche lourd
- Risque : sur-dimensionnement si Hermès local 32B suffit durablement

### Variante 2 — BoM allégée CPU (proposition S65)
- Ryzen 7 7700X **ou** Ryzen 9 7900X + 64 Go DDR5-6000 + RTX 3090 (réutilisée) + Proxmox add-ons + switch 2.5G
- Total ~2150-2290 €
- Justification : qwen35-agent V1 valide la stack actuelle, pas de besoin urgent 16C/32T
- Économie : 120-260 €

### Variante 3 — BoM minimale Proxmox uniquement (à évaluer)
- Pas de nouveau PC cerveau IA — on reste sur l'i9-9900K **actuel** comme cerveau IA
- Achat **uniquement** : Mini-PC Proxmox (ex. NUC Ryzen 7) + 32 Go RAM + 1 To NVMe + 8 To HDD Frigate + Coral USB + switch 2.5G
- Total ~1100-1400 €
- Justification : on règle le problème Pi5 sans toucher au cerveau IA
- Risque : pas de redondance / résilience brain ↔ body comme prévu en V1, et perd l'argument "ne plus polluer le PC bureautique avec l'IA"
- À mesurer : i9-9900K + RTX 3090 tient-il Cowork + Hermès + bureautique sans gêne ?

Aucune de ces variantes n'est recommandée à ce stade — elles sont listées pour décision Mickael ultérieure.

---

## 📌 Conséquences sur le backlog

| Tâche | Impact |
|---|---|
| **T#73** (projet hardware upgrade) | Reste **ouverte**. Ré-évaluer la BoM (variante 1, 2 ou 3) avant commande. NO-GO **non acté**. |
| **T#41** (migration HA Pi5 → Proxmox) | Reste **dépendante du projet hardware**. Pi5 toujours actuel jusqu'à Phase E. |
| **T#42** (snapshot+rollback API Proxmox) | Reste **dépendante du projet hardware**. À traiter Phase E/F. |
| **T#69** (bascule modèle Hermès Haiku) | Annulée S63 — Hermès local 75% suffit, OpenRouter reste exception ~5%. Pas de revirement nécessaire. |
| **T#76** (retest 4 modèles Phase B post-update) | **Indépendante du hardware**. À exécuter sur stack actuelle pour confirmer qwen35-agent V1 reste le meilleur choix local. |
| **T#77** (Hermes 4 70B HuggingFace) | **Indépendante du hardware**. Si OK, renforce Variante 2 ou 3. Si KO sévère, renforce Variante 1. |

---

## 🔒 Garde-fous

1. **Aucune modification des fichiers `00_Decisions_et_audits.md` / `02_BoM_finalisee.md` / `03_Phasage_A_a_G.md` / `04_Risques_et_mitigations.md`** dans le cadre de cet audit. Mickael validera plus tard si on les met à jour ou si on les laisse comme référence historique pour un retour sur Variante 1.
2. **Aucune suppression** dans le dossier `Documentation/` (PDF + sources ChatGPT). Vérification avant toute suppression future.
3. **Aucune commande matériel** sans arbitrage explicite Mickael entre Variantes 1/2/3 (ou Variante 4 si une nouvelle apparaît).

---

## 🔗 Références

- Audit méthodologique 2 (S63) : `Projets/Cookbook_Hermes_RTX3090/docs/audit-methodologique.md`
- Verdict qwen35-agent V1 : `memory/historique/2026-04-26_session_63_audit_methodologique_2_succes.md`
- BoM originale S56 : `02_BoM_finalisee.md`
- Phasage A→G : `03_Phasage_A_a_G.md`
- Auto-memory hardware : `memory/project_hardware_upgrade.md` (à MAJ ultérieurement avec ce ré-cadrage)
- Auto-memory qwen35-agent : `memory/reference_qwen35_agent_v1_postupdate_validated.md` (créée S63)

---

*Fin de 08_Audit_S63_et_re_evaluation_hardware.md — version 1.0 — 27 avril 2026*

---

## Notes de migration vault (S68)

- Document copié depuis `Projets/Hardware_Upgrade/08_Audit_S63_et_re_evaluation_hardware.md` (S65).
- **Hors plan d'origine S67** (créé en S65 après planification S67), migré sur accord Q1 Mickael S68.
- Aucun pattern sensible détecté.
- Aucune modification de contenu.
