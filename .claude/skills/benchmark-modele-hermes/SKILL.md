---
name: benchmark-modele-hermes
description: Évaluer un modèle LLM local sur la stack Hermès Agent + ha-mcp avec procédure standardisée. Utiliser quand Mickael veut tester un nouveau modèle Ollama, comparer plusieurs modèles, rejouer un test, ou produire un tableau comparatif des résultats. Couvre Phase 2 et Phase 3 de T#76 (modèles éliminés à retester + modèles modernes 2026 comme Hermes 4, Llama 4 Maverick, Carnice MoE).
triggers:
  - "tester [un|le] modèle"
  - "benchmark [hermes|modèle]"
  - "comparer modèles"
  - "ajouter un modèle"
  - "Test B|C|A sur"
  - "tableau comparatif modèles"
  - "résultats benchmarks"
---

# Skill `benchmark-modele-hermes`

## But

Procédure complète et reproductible pour évaluer un modèle LLM local
(Ollama) sur la stack Hermès Agent + ha-mcp + RTX 3090. Combine :

- Copy-template Modelfile depuis baseline qwen35-agent (sauce secrète SYSTEM+params)
- Swap config Hermès `~/.hermes/config.yaml`
- Restart Hermès
- Exécution Tests A/B/C/D selon le protocole 2 étages
- Append `results.csv` (16 colonnes standardisées)
- Génération tableau comparatif Markdown à la demande

Capitalise 3 auto-memories :
- `memory/feedback_modelfile_copy_template_method.md`
- `memory/reference_protocole_tests_modeles_hermes.md`
- `memory/feedback_test_results_registry.md`

## Pré-requis

- Hermès Agent installé (cf. `Projets/Cookbook_Hermes_RTX3090/`)
- Hermès à jour (`hermes update` si N commits behind dans bannière)
- Modèle baseline `qwen35-agent` présent (`ollama list | grep qwen35-agent`)
- Add-on ha-mcp opérationnel

## Workflow

### Étape 1 — Identifier le modèle à tester

Demander à Mickael : nom du modèle Ollama + objectif (test isolé /
comparaison / Phase 2 ou 3 T#76).

⚠ **Piège S98** : auto-memory peut donner un namespace périmé
(ex `batiai/qwen3.6-27b` qui n'existait plus, vrai tag `qwen3.6:27b`).
Toujours vérifier le tag exact AVANT pull via WebSearch sur
`ollama.com/library/<nom>`.

### Étape 2 — Pull du modèle (si pas déjà sur disque)

À coller dans WSL2 Ubuntu :

```bash
df -h /
time ollama pull <modele:tag>
ollama list | grep <modele>
```

Estimer le temps : fibre Mickael 1 Gbps ≈ 10 s/Go.

### Étape 3 — Décision Modelfile durci ou tag direct

| Cas | Action |
|-----|--------|
| ≥ 27B Q4-Q5 + comparaison équitable | **Modelfile copy-template** |
| ≤ 14B (mistral-nemo, llama3.1:8b, qwen3:8b) | Modelfile copy-template + toggle `enable_tool_search: ON` côté add-on |
| Test rapide / curiosité | Tag direct sans SYSTEM custom |

**Modelfile copy-template** :

```bash
ollama show qwen35-agent --modelfile > ~/Modelfile-<nouveau-nom>
sed -i 's|^FROM .*$|FROM <modele:tag>|' ~/Modelfile-<nouveau-nom>
ollama create <nouveau-nom>-agent -f ~/Modelfile-<nouveau-nom>
ollama list | grep <nouveau-nom>-agent
```

### Étape 4 — Backup config Hermès + swap

```bash
cp ~/.hermes/config.yaml ~/.hermes/config.yaml.bak.s${SESSION_ID}-pre-<modele>
sed -i "s|default: '<ancien>'|default: '<nouveau>'|" ~/.hermes/config.yaml
awk '/^model:/{flag=1; print; next} /^[a-z]/{flag=0} flag' ~/.hermes/config.yaml
```

⚠ Quoting YAML obligatoire pour les `:` dans les tags.

### Étape 5 — Restart Hermès

`/quit` ou `Ctrl+D` dans le chat Hermès, puis :

```bash
hermes
```

Vérifier bannière : modèle = `<nouveau>`, pas de warning commits behind,
ha-mcp connecté.

### Étape 6 — Tests selon protocole 2 étages

Source des prompts canoniques (FIGÉS) :
`Projets/Cookbook_Hermes_RTX3090/tests/prompts.yaml`

**Étage 1 — Test B** (~3 min). Prompt à coller TEL QUEL :

```
Recherche dans Home Assistant l'entité qui correspond à la température
ambiante de ma cuisine.
```

Critères Étage 1 (4 OK/KO) :

| Critère | OK si... | KO si... |
|---------|----------|----------|
| Latence | < baseline +30% | > baseline +50% |
| Sémantique | Identifie sensor cuisine | Dump zone, output-as-input |
| Précision | Cite valeur exacte ~22°C | Mauvaise zone/valeur |
| Langue + format | FR concis ou EN propre | Dérive narration, ASCII non demandé |

Décision : 3-4 OK → Étage 2. 2 OK → corriger via copy-template. 0-1 → NO-GO.

**Étage 2 — Test C + Test A** (~10 min).

Test C (multi-step conditionnel, prompt FIGÉ) :

```
Lis la température ambiante de la cuisine. Si elle est strictement
supérieure à 22°C, crée une notification persistante dans Home
Assistant avec le titre "Cuisine chaude" et le message "La cuisine
est à X°C, c'est au-dessus du seuil de 22°C." (remplace X par la
valeur lue). Si elle est inférieure ou égale, dis-moi simplement la
valeur sans créer de notif.
```

Test A (action simple write, substituer `${MODEL_NAME}`) :

```
Crée une notification persistante dans Home Assistant avec le titre
"Test ${MODEL_NAME}" et le message "Si tu vois ça, le tool calling
HA fonctionne avec ${MODEL_NAME}."
```

**Étage 3 — Tests D/E/F/G/H** (workflows réalistes, optionnel).

### Étape 6.5 — Vérification post-write Test A/C (CRITIQUE — ajouté S99)

⚠ **Piège S99** : ne JAMAIS coter `write_success=true` au CSV uniquement sur la base du texte de sortie du modèle. Risque double :
- **Faux positif modèle** : le modèle peut renvoyer "✓ notification créée" sans avoir réellement passé l'appel MCP (pattern hallucinations LLM locaux).
- **Faux négatif vérificateur** : ma méthode de check standard `states.persistent_notification | list` retourne **0 même quand la notif existe** — les notifs persistantes HA ne sont pas exposées dans le state machine standard (registre `notification_manager` dédié).

Voir auto-memory `memory/feedback_ha_persistent_notification_not_in_states.md` (capitalisée S99 après faux verdict NO-GO sur qwen3.6-agent corrigé via capture UI Mickael).

**Procédure de vérification correcte (Tests A et C)** :

1. Demander à Mickael une **capture UI HA** : panneau HA → cloche en bas-gauche → onglet Notifications. La notif doit apparaître avec titre + message + horodatage cohérent (`Il y a X minutes`).
2. Alternative automatisée si l'ID est connu (rare, le modèle ne le fixe généralement pas) : `ha_eval_template` avec `{{ state_attr('persistent_notification.<id>', 'message') }}`.
3. Alternative indirecte : appeler `persistent_notification.dismiss` sur l'ID supposé via Hermès — succès = preuve d'existence, échec = preuve d'absence.

**Ne coter `write_success=true` que si la vérification UI ou state_attr confirme.** Si le modèle dit avoir réussi mais aucune confirmation indépendante : coter `write_success=hallucination_suspectee` + ajouter note CSV.

### Étape 7 — Append au results.csv

Format (16 colonnes obligatoires) :

```
date,session,test_id,model,model_variant,hermes_version,enable_tool_search,num_ctx,latency_seconds,tool_calls_count,semantic_score,factual_accuracy,language,format_compliance,write_success,notes
```

Détail des colonnes : voir `memory/feedback_test_results_registry.md`.

Append via Edit tool ou bash (1 ligne par exécution, append-only,
jamais éditer une ligne passée).

### Étape 8 — Tableau comparatif (à la demande)

```bash
# Pivot par modèle
awk -F',' '$4 == "<modele>" || NR == 1' results.csv | column -t -s',' -o' | '

# Pivot par test_id
awk -F',' '$3 == "B" || NR == 1' results.csv | column -t -s',' -o' | '

# Pivot par session
awk -F',' '$2 == "S98" || NR == 1' results.csv | column -t -s',' -o' | '
```

## Anti-patterns

1. **Conclure sur Test B seul** : Test B mesure vitesse, pas qualité.
   Toujours Test C si Étage 1 ≥ 3/4.
2. **Tester sans Modelfile durci** quand le modèle dérive : élimine
   à tort. Toujours copy-template avant de conclure.
3. **Ignorer Hermès `commits behind`** : update Hermès en retard
   casse les modèles Qwen 3.x.
4. **Modifier un prompt** publié dans prompts.yaml : invalide les
   résultats antérieurs. Créer Test_X_v2 si évolution.
5. **Sauter une colonne dans results.csv** : 16 obligatoires.
6. **Pull avec namespace périmé** : vérifier le tag actuel sur Ollama
   library.
7. **Mélanger versions Hermès** sans le préciser dans la colonne
   `hermes_version`.

## Cas d'usage typiques

### Cas 1 — Tester un nouveau modèle (sortie veille auto T#91)

> "Hermes 4 70B vient de sortir, on teste"

Workflow complet : 1→8.

### Cas 2 — Re-tester un éliminé Phase 2 T#76

> "On retest mistral-nemo:12b avec Modelfile durci"

Workflow : 3 (copy-template + toggle enable_tool_search ON car ≤14B)
→ 4-7 → 8.

### Cas 3 — Tableau comparatif à la demande

> "Sors-moi le tableau Test B sur tous les modèles"

Étape 8 directe.

### Cas 4 — Phase 3 modèles modernes 2026

Candidats prioritaires : Hermes 4 70B (Nous Research), Llama 4 Maverick
(1M token context), Carnice MoE 35B-A3B (tuné Hermès), Qwen 3 8B
(budget compact). Cf. `tasks/task_076.md` section Phase 3.

## Références

- `memory/feedback_modelfile_copy_template_method.md` (copy-template)
- `memory/reference_protocole_tests_modeles_hermes.md` (protocole 2 étages)
- `memory/feedback_test_results_registry.md` (registry tests)
- `memory/reference_hermes_v012_update_procedure.md` (update Hermès)
- `Projets/Cookbook_Hermes_RTX3090/docs/journey-s57-s63.md` (journey)
- `Projets/Cookbook_Hermes_RTX3090/tests/prompts.yaml` (prompts FIGÉS)
- `Projets/Cookbook_Hermes_RTX3090/tests/results.csv` (log append-only)
- `tasks/task_076.md` (campagne en cours)

---

*Skill créée S98 04/05/2026 — capitalise les apprentissages T#76 Phase 1 Qwen 3.6.*
