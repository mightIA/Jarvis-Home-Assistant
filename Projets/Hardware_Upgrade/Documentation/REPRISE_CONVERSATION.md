# Reprise de conversation — Projet Hardware Upgrade

**Document de continuité** pour relancer une nouvelle conversation Cowork sans perte de contexte.

**Version** : 1.0
**Date** : 26/04/2026 (S59)
**Auteur** : Jarvis Cowork
**Périmètre projet** : `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Projets\Hardware_Upgrade\`

> ⚠️ **Règle session :** Ce document a été produit sous périmètre strict — uniquement le projet Hardware Upgrade. Aucune modification d'autres dossiers du projet Jarvis. Toute reprise doit conserver cette discipline tant que Mickael ne demande pas autre chose.

---

## 1. Phrase d'amorce pour relancer une nouvelle conv

```
Bonjour Jarvis. On reprend le projet Hardware Upgrade (T#73,
brain/body distribué Ryzen + Proxmox). Lis d'abord
Hardware_Upgrade/Documentation/REPRISE_CONVERSATION.md puis
charge les memories listées dedans. Périmètre strict : uniquement
le dossier Hardware_Upgrade, aucune modification ailleurs.
```

Avec ça, une nouvelle conv Cowork peut reprendre exactement où on s'est arrêté.

---

## 2. Statut actuel — Phase 0 verrouillée

| Aspect | État | Note |
|---|---|---|
| **Phase** | 🟡 Phase 0 — pré-requis validés, BoM finale | En attente Phase A |
| **Budget** | **2 410 €** (budget cible 2 500 €) | Marge 90 € |
| **Architecture** | Verrouillée S56 | Brain/body 2 machines |
| **3 audits pré-achat** | ✅ Tous validés | CM IOMMU, dongles Zigbee, onduleurs |
| **8 documents projet** | ✅ Rédigés | dans `Hardware_Upgrade/` |
| **Sources externes** | ✅ Archivées | Conv ChatGPT capturée S59 |
| **Bloqueur en cours** | ⚠️ Phase A Hermès | 3 modèles à tester avant achat |

**Statut une ligne** : *Tout est prêt à acheter, sauf qu'on doit d'abord valider qu'au moins un modèle Hermès local ou cloud-Haiku écrit correctement dans HA.*

---

## 3. Décisions verrouillées (ne pas remettre en question sans accord Mickael)

### S56 (26/04/2026 matin)

| # | Décision | Justification |
|---|---|---|
| D1 | Budget 2 500 € en un coup (achat groupé) | Évite les arbitrages partiels |
| D2 | **Ryzen 9 7950X** dans tous les cas | Anticipation usage IA futur (16C/32T, AVX-512 optionnel) |
| D3 | RTX 3090 conservée (transfert depuis i9 actuel) | 24 Go VRAM = sweet spot LLM 32B Q4 |
| D4 | 3 → 5-6 caméras Frigate à terme | Frigate VM dimensionnée 12 Go RAM |
| D5 | Onduleurs déjà possédés (SMT2200IC + BR900G-FR) | Pas d'achat onduleur |
| D6 | Dongles Zigbee migrent en l'état (pas de reflash) | Network keys dans flash dongle |
| D7 | 7 phases A→G étalées sur 3-4 weekends | Migration progressive avec rollback chaud Pi5 |

### S57 (26/04/2026 après-midi)

| # | Décision | Justification |
|---|---|---|
| D1-S57 | Modelfile Qwen3 durci adopté | Patch validé bout-en-bout via Hermès + ha-mcp |
| D2-S57 | Pivot Phase B vers 3 modèles T#73 | Abandon Hermes 4 70B "modèle maison" |
| D3-S57 | qwen3-agent gardé comme baseline référence | Phase C comparaison |
| D4-S57 | Archivage propre + nouvelle conv pour Phase B | Conv parallèle T#73 reprend la suite |

### S59 (26/04/2026 soir — cette session)

| # | Décision | Justification |
|---|---|---|
| D1-S59 | Production document `.md` reprise + PDF V3 architecture | Demande Mickael |
| D2-S59 | Conv ChatGPT archivée brute dans `Documentation/Sources/` | Avant disparition côté ChatGPT |
| D3-S59 | Niveau technique détaillé pour le PDF | Réf personnelle + maintenance future |
| D4-S59 | 6 apports ChatGPT intégrés au PDF | 3 niveaux IA, mini-agent FastAPI, pipeline détaillé, Redis/PostgreSQL, LXC vs VM, Double Take |

---

## 4. Mémoires Cowork à charger en priorité

À lire en début de chaque nouvelle conv sur ce projet :

```text
memory/project_hardware_upgrade.md          ← projet principal
memory/reference_pc_config_might.md         ← config i9-9900K actuelle
memory/reference_zigbee_dongles_might.md    ← 2× ZBDongle-P avec n° série
memory/reference_onduleurs_might.md         ← SMT2200IC + BR900G-FR
memory/feedback_qwen3_32b_ecriture_bloquee.md  ← réhabilité S57
memory/reference_modelfile_qwen3_durci.md   ← pattern Modelfile validé S57
memory/feedback_audit_communautaire_avant_verdict.md  ← méthodo Phase B
memory/reference_openrouter_setup_garde_fous.md  ← clé Hermes-Jarvis $5/mois
memory/reference_mickael_connexion_fibre.md ← 1 Gbps, ne plus mal estimer pulls
memory/reference_ha_mcp_addon.md            ← endpoint URL publique
```

**Auto-memories liées (bonus)** :

```text
memory/feedback_pas_a_pas_attente_retour.md   ← règle pas-à-pas Mickael
memory/feedback_titre_conversation_fr.md      ← proposer titre FR en début
memory/feedback_label_application_blocs.md    ← étiqueter blocs à coller
memory/feedback_forfait_max_pas_econome.md    ← mode normal par défaut
```

---

## 5. Documents du projet (8 + 2 nouveaux)

Tous dans `Hardware_Upgrade/` :

| Fichier | Contenu | Pages | Statut |
|---|---|---|---|
| `README.md` | Vue d'ensemble + architecture une page | 1 | ✅ |
| `00_Decisions_et_audits.md` | 7 décisions Mickael + 3 audits validés | 2 | ✅ |
| `01_Architecture_cible.md` | Schéma + rôles + allocation VM + comm | 4 | ✅ |
| `02_BoM_finalisee.md` | BoM 2 410 € + variantes éco + liens | 3 | ✅ |
| `03_Phasage_A_a_G.md` | 7 phases avec checklist | 4 | ✅ |
| `04_Risques_et_mitigations.md` | 10 risques cotés + plans rollback | 3 | ✅ |
| `05_Onduleurs_NUT.md` | Config NUT Proxmox + apcupsd Ryzen | 2 | ✅ |
| `06_Migration_HA_Pi5_Proxmox.md` | Procédure pas-à-pas T-7j → T+90j | 5 | ✅ |
| `07_Frigate_VM_Coral.md` | Sortie Supervisor + Coral passthrough | 3 | ✅ |
| **`Documentation/REPRISE_CONVERSATION.md`** | Ce document | ~5 | ✅ S59 |
| **`Documentation/Architecture_Jarvis_v3.pdf`** | PDF entreprise 18-20 pages | 18-20 | ✅ S59 |
| **`Documentation/Sources/ChatGPT_Conv_Originale.md`** | Conv ChatGPT brute archivée | ~30 | ✅ S59 |

---

## 6. Phase A — la seule chose qui bloque l'achat

**Objectif** : valider qu'au moins une combinaison `Hermès + modèle` écrit correctement dans HA via ha-mcp avant d'engager 2 410 €.

3 tests à mener (cf TASKS.md T#73 Phase A) :

| Test | Modèle | Statut hardware | Coût |
|---|---|---|---|
| A1 | `mistral-nemo:12b` (Ollama local) | Déjà installé S48 | Gratuit (RTX 3090) |
| A2 | `Llama 3.3 70B Q3` (Ollama local) | À pull (~30 Go) | Gratuit, ~3 min download fibre |
| A3 | OpenRouter Claude Haiku 4.5 | Clé `Hermes-Jarvis` prête S55 | Cap $5/mois |

**Critère GO/NO-GO** : au moins 1 des 3 doit réussir un appel `ha_call_write_tool` propre (création notification, modif état entité, etc.) sans tomber dans le bug "empty after tool calls".

**Référence baseline S57** : `qwen3-agent` (Modelfile durci) y arrive mais avec dérive sémantique → garde comme plan B fragile, pas comme solution pour Mode Réactif.

**Référence méthodo S57** : audit communautaire AVANT verdict (issues GitHub upstream + Reddit + benchmarks BFCL). Voir `feedback_audit_communautaire_avant_verdict.md`.

---

## 7. Risques principaux (top 4 sur 10)

| # | Risque | Mitigation |
|---|---|---|
| R1 | Migration Zigbee casse devices (~30 appareils) | Migration physique dongles + backup ZHA + tests T-1j |
| R2 | Hermès local n'écrit pas dans HA | **Phase A AVANT achat**, fallback hybride OpenRouter Haiku |
| R3 | IOMMU mal configuré sur i9 → passthrough USB casse | Audit live Linux Phase D + ACS Override fallback |
| R4 | Cloudflare Tunnel cassé pendant migration HA | Test post-migration avant bascule DNS public + plan B |

10 risques cotés en détail dans `Hardware_Upgrade/04_Risques_et_mitigations.md`.

---

## 8. Pièges connus (à ne pas répéter)

| Piège | Origine | Comment éviter |
|---|---|---|
| Cold start qwen3:32b mal estimé (90s vs 12m55s) | S57 | Toujours warmup avant test, mesurer en réel |
| Dérive sémantique action vs script (qwen3 transforme "crée notification" en "crée un script qui créera une notification") | S57 | Tester avec prompts simples ET complexes |
| TASKS.md trop gros pour Read direct (>25k tokens) | S57 P3 | Grep + Edit chirurgical au lieu de Read entier |
| Conv parallèle S56 active pendant S57 | S57 P4 | Lire METRIQUES.md mid-session pour synchro |
| Pip install impossible dans sandbox Cowork (sortie réseau OFF) | S27 + projet | Vérifier libs préinstallées avant de planifier des installs |
| Ne pas confondre `/home/agent/` (Hermès interne) et `/home/might/` (vrai WSL2) | S53 | Ouvrir un second terminal, ne pas coller dans Hermès actif |

---

## 9. Glossaire des acronymes du projet

| Terme | Signification |
|---|---|
| **brain/body** | Architecture distribuée : un PC pour l'intelligence (brain), un pour les capteurs/actionneurs (body) |
| **BoM** | Bill of Materials — liste des pièces avec prix |
| **BPS** | Backup Power Supply (= onduleur) |
| **CF Tunnel** | Cloudflare Tunnel — exposition HTTPS sans port-forward |
| **HA OS** | Home Assistant Operating System (image officielle pour VM/Pi) |
| **ha-mcp** | Add-on MCP custom community pour HA, expose 80+ outils `ha_*` |
| **Hermès Agent** | Orchestrateur multi-LLM Nous Research (MIT, 02/2026) |
| **IOMMU** | Input-Output Memory Management Unit — clé pour passthrough GPU/USB |
| **LXC** | Linux Containers Proxmox (plus léger qu'une VM, moins isolé) |
| **MCP** | Model Context Protocol (Anthropic, RFC stdio + HTTP streamable) |
| **MQTT** | Message Queuing Telemetry Transport — bus pub/sub temps réel |
| **NUT** | Network UPS Tools — pilotage onduleur depuis Linux |
| **PBS** | Proxmox Backup Server — VM dédiée backup VMs |
| **RTO** | Recovery Time Objective — temps max pour rétablir un service |
| **RPO** | Recovery Point Objective — perte de données max acceptable |
| **T#73** | Tâche 73 dans TASKS.md = ce projet |
| **TODO Mode Réactif** | Pipeline alertes `[JARVIS-ALERT]` Gmail → scheduled CLI 15min → action HA |
| **vCPU** | Virtual CPU — coeur logique alloué à une VM |
| **ZHA** | Zigbee Home Automation — intégration HA native (pas Zigbee2MQTT) |

---

## 10. Pré-flight checklist nouvelle session

À lancer en début de chaque nouvelle conv qui reprend le projet :

```
[ ] Lire ce fichier (REPRISE_CONVERSATION.md) en entier
[ ] Charger les 10 memories listées section 4
[ ] Vérifier METRIQUES.md pour le n° de session courant
[ ] Confirmer que la conv parallèle T#73 (Phase B Hermès) n'est plus active
[ ] Confirmer périmètre strict (uniquement Hardware_Upgrade/)
[ ] Proposer un titre FR clair (règle S53)
[ ] Demander à Mickael : "On reprend où ? Phase A tests Hermès, ou autre angle ?"
```

---

## 11. Liens utiles côté code et docs

| Quoi | Où |
|---|---|
| Projet hardware (racine) | `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Projets\Hardware_Upgrade\` |
| Source ChatGPT brute | `Hardware_Upgrade\Documentation\Sources\ChatGPT_Conv_Originale.md` |
| PDF architecture V3 | `Hardware_Upgrade\Documentation\Architecture_Jarvis_v3.pdf` |
| Archive S56 (déroulé décisions) | `memory/historique/2026-04-26_session_56_hardware_upgrade.md` |
| Archive S57 (qwen3-agent stabilisé) | `memory/historique/2026-04-26_session_57_qwen3_agent_stabilise.md` |
| TASKS.md tâche projet | T#73 — Projet upgrade hardware Proxmox + Ryzen + IA distribuée |

---

## 12. Notes de fin de session S59

- Aucun fichier hors `Hardware_Upgrade/` n'a été modifié au cours de cette session.
- 3 fichiers créés dans `Hardware_Upgrade/Documentation/` : ce fichier, `Sources/ChatGPT_Conv_Originale.md`, `Architecture_Jarvis_v3.pdf`.
- Les memories existantes restent à jour, aucune nouvelle memory créée pendant cette session (par périmètre strict demandé).
- Si une nouvelle session veut acter des éléments dans la memory globale, elle devra demander explicitement à Mickael de lever la restriction de périmètre.

---

*Fin du document de reprise. Version 1.0 — 26/04/2026.*
