---
name: Protocole tests modèles Hermès — 2 étages (rapidité+cohérence puis complexité)
description: S98 04/05/2026 — Méthode standardisée pour évaluer un nouveau modèle LLM local sur stack Hermès+ha-mcp. Étage 1 = Test B rapide (latence+cohérence). Étage 2 = Test C+A (multi-step+write). Critères : latence, sémantique, précision factuelle, langue, format.
type: reference
---

# Protocole tests modèles Hermès — 2 étages

## Contexte

Évaluer un nouveau modèle LLM local pour Hermès Agent (sur stack
ha-mcp 87+ tools, RTX 3090) requiert plus que la pure latence. Un
modèle plus lent peut être préférable si la **qualité de raisonnement**
sur tâches complexes compense, surtout pour le Mode Réactif où
la fiabilité prime.

Méthode formalisée S98 (04/05/2026) après campagne T#76 Phase 1 où le
verdict initial Test B (latence pure) ratait la dimension qualité.

## Étage 1 — Quick check : rapidité + cohérence

**But** : éliminer rapidement les modèles qui dérivent (langue,
sémantique, format) avant d'investir du temps sur les tests complexes.

**Test B référence S63** : *« Recherche dans Home Assistant l'entité
qui correspond à la température ambiante de ma cuisine. »*

- 1 tool call attendu : `ha_search_entities` avec query `cuisine
  température` (ou variante sémantique)
- Réponse attendue : identifie `sensor.capteur_temp_cuisine_temperature`
  à la valeur lue (généralement ~22°C)
- Latence baseline qwen35-agent (Q5_K_M, num_ctx 65536) : **2m40s**
  (S63, reproduit S93 et S98)

**Critères Étage 1** (4 points, OK/KO) :

| Critère | OK si... | KO si... |
|---------|----------|----------|
| Latence | < baseline +30% | > baseline +50% |
| Sémantique | Identifie le sensor cuisine température | Dump zone entière, ou interprète son output comme input |
| Précision | Cite la valeur exacte (ex 22.12°C) | Cite une autre zone ou une mauvaise valeur |
| Langue + format | FR concis (ou EN propre si SYSTEM le permet) | Dérive narration, format ASCII non demandé, accents perdus |

**Décision Étage 1** :
- **3-4 critères OK** → passer à Étage 2
- **2 critères OK** : essayer copy-template Modelfile
  (cf. `feedback_modelfile_copy_template_method.md`) puis re-tester Étage 1
- **0-1 critère OK** : éliminer, NO-GO ferme

## Étage 2 — Complexité : raisonnement + écriture HA

**But** : juger la qualité de chaînage de tool calls, le respect des
conditions, la précision factuelle, et la fiabilité de l'écriture HA
(point sensible historique : qwen3:32b S57 dérive sémantique sur
write, qwen2.5-coder:32b S60 narration only sur write).

### Test C — Multi-step conditionnel

*« Lis la température ambiante de la cuisine. Si elle est strictement
supérieure à 22°C, crée une notification persistante dans Home
Assistant avec le titre "Cuisine chaude" et le message "La cuisine est
à X°C, c'est au-dessus du seuil de 22°C." (remplace X par la valeur
lue). Si elle est inférieure ou égale, dis-moi simplement la valeur
sans créer de notif. »*

- 2 tool calls attendus : 1 read + 1 write conditionnel
- Latence baseline qwen35-agent : **2m57s** (S63)
- Doit citer la valeur exacte, évaluer la condition, agir conditionnellement

### Test A — Action simple write (en option)

*« Crée une notification persistante dans Home Assistant avec le titre
"Test [nom-modèle]" et le message "Si tu vois ça, le tool calling HA
fonctionne avec [nom-modèle]." »*

- 1 tool call attendu : `ha_call_service` (`persistent_notification.create`)
- Latence baseline qwen35-agent : **5m06s** (S63)
- Test stress write pure, pas de condition

**Critères Étage 2** (6 points pondérés) :

| Critère | Poids | OK si... |
|---------|-------|----------|
| Test C latence | 1× | < baseline +30% |
| Test C exactitude valeur | 2× | Cite la valeur exacte lue |
| Test C condition évaluée | 2× | Verbalise l'évaluation de la condition |
| Test C action conditionnelle | 2× | Agit (ou pas) selon la condition, pas en aveugle |
| Test A write réussi | 2× | Notif visible dans HA UI, pas "empty after tool calls" |
| Format réponse | 1× | Court, factuel, FR (ou langue forcée par SYSTEM) |

**Score** : / 10. ≥ 8 = candidat upgrade. 6-7 = match nul, peser
spécifiquement la qualité raisonnement vs latence baseline. < 6 = NO-GO.

## Verdict consolidé

Combiner Étage 1 + Étage 2 dans un tableau récap :

| Modèle | Étage 1 | Test C latence | Test C qualité | Test A write | Verdict |
|--------|---------|----------------|----------------|--------------|---------|
| qwen35-agent (référence) | OK 4/4 | 2m57s | Parfait | OK 5m06s | 🟢 Champion |
| ... | ... | ... | ... | ... | ... |

**Format conclusion** : 1 phrase de verdict + 1 phrase de recommandation
(garde / upgrade / Modelfile durci à créer / éliminer définitivement).

## Niveaux de tests complexes (S98, idées Mickael)

Une fois Étage 1+2 validés, on peut pousser sur des scénarios plus
représentatifs des workflows Jarvis quotidiens :

| Niveau | Scénario | Périmètre | Pré-requis Hermès |
|--------|----------|-----------|-------------------|
| **D** | Multi-reads températures + agrégation + write notif "Bilan thermique" | ha-mcp | aucun (déjà OK) |
| **E** | Lister automations avec condition température + générer YAML reactivation | ha-mcp | aucun |
| **F** | Diagnostic chaudière Frisquet + write notif "Alerte Frisquet" | ha-mcp | aucun |
| **G** | Tri email Jarvis (le workflow quotidien Mickael) | gmail-mcp | brancher gmail-mcp-local à `~/.hermes/config.yaml` (~30 min setup) |
| **H** | Génération rapport journalier complet (équivalent rapport-journalier-reactif 23h30) | ha-mcp + write fichier | skill `email/himalaya` bundled si envoi mail |

**Niveau G (tri email)** est le proxy le plus représentatif du métier
Jarvis. À implémenter quand on aura connecté `gmail-mcp-local` (custom
stdio) à Hermès — Hermès supporte les MCP stdio (contrairement à Cowork
desktop).

## Pièges historiques à éviter

1. **Conclure sur Test B seul** (S98 erreur initiale) : la latence pure
   masque les gains de qualité. Toujours faire Étage 2 si Étage 1 ≥ 3/4.
2. **Tester sans Modelfile durci** (S58 mistral-nemo, S60 qwen2.5) :
   souvent élimine à tort un modèle qui aurait pu marcher. Toujours
   copy-template du modèle baseline si Étage 1 dérive sur langue/format.
3. **Ne pas vérifier `nvidia-smi`** : un modèle qui semble lent peut
   être en offload CPU à cause d'un `num_ctx` trop élevé. Vérifier
   utilisation VRAM + GPU pendant le test.
4. **Ignorer Hermès `commits behind`** (S98 piège) : Hermès en retard
   peut casser les modèles Qwen 3.x via bugs `reasoning_content`.
   Toujours faire `hermes update` avant la campagne (cf.
   `reference_hermes_v012_update_procedure.md`).

## Lien

- Cookbook Hermès journey : `Projets/Cookbook_Hermes_RTX3090/docs/journey-s57-s63.md`
- Configs reproductibles : `Projets/Cookbook_Hermes_RTX3090/docs/configs.md`
- Méthode Modelfile copy-template : `memory/feedback_modelfile_copy_template_method.md`
- T#76 (campagne en cours) : `tasks/task_076.md`
