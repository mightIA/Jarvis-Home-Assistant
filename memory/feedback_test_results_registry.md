---
name: Registry des tests modèles Hermès — usage prompts.yaml + results.csv
description: S98 04/05/2026 — Système d'enregistrement des résultats tests modèles. Prompts FIGÉS dans prompts.yaml (jamais dévier), résultats append-only dans results.csv. Permet tableaux comparatifs à la demande sur N'IMPORTE QUEL pivot.
type: feedback
---

# Registry des tests modèles Hermès — usage prompts.yaml + results.csv

## Règle

Chaque test exécuté sur un modèle dans la stack Hermès+ha-mcp DOIT être
enregistré dans `Projets/Cookbook_Hermes_RTX3090/tests/results.csv` avec
**toutes les colonnes** remplies. Les prompts sont FIGÉS dans
`prompts.yaml` — ne JAMAIS dévier de la formulation exacte sous peine
d'invalider les comparaisons inter-modèles.

## Why

S98 (04/05/2026) — campagne T#76 Phase 1 : 6 tests exécutés sur 3
modèles différents (qwen3.6:27b, MoE 35B-A3B, qwen3.6-agent custom). Si
on n'enregistre pas en CSV append-only, impossible de comparer
proprement plus tard. Idée Mickael : à la demande, pouvoir sortir des
**tableaux comparatifs** sur n'importe quel pivot (par modèle, par
test, par session, par variant) sans avoir à refaire les tests.

## Files

| Path | Format | Contenu | Modifiable ? |
|------|--------|---------|--------------|
| `Projets/Cookbook_Hermes_RTX3090/tests/prompts.yaml` | YAML | Registry des prompts canoniques (Tests A à H) | Append uniquement (nouveau Test_X). Modifier un prompt existant invalide les anciens résultats. |
| `Projets/Cookbook_Hermes_RTX3090/tests/results.csv` | CSV | Append-only des résultats (1 ligne = 1 exécution) | Append uniquement. Jamais éditer ni supprimer une ligne. |

## Schéma colonnes results.csv (16 colonnes)

| Colonne | Type | Valeurs |
|---------|------|---------|
| date | YYYY-MM-DD | 2026-05-04 |
| session | string | S98, S63... |
| test_id | enum | A, B, C, D, E, F, G, H |
| model | string Ollama | qwen3.5:27b, qwen3.6:27b, qwen3.6:35b-a3b... |
| model_variant | string | brut-tag-direct-Q4_K_M, custom-Modelfile-...-Q5, MoE-tag-direct-Q4_K_M |
| hermes_version | string | v0.12.0-post-update, v0.12.0-minus-18... |
| enable_tool_search | bool | true / false |
| num_ctx | int | 32768, 65536... |
| latency_seconds | int | secondes (160 = 2m40s) |
| tool_calls_count | int | 0, 1, 2... |
| semantic_score | int 0-3 | 0=KO total, 1=cassé, 2=OK, 3=excellent |
| factual_accuracy | bool | true (cite valeur exacte) / false |
| language | enum | fr / en |
| format_compliance | bool | true (suit consigne) / false (dérive ASCII / dump) |
| write_success | bool ou null | true / false / null si pas de write attendu |
| notes | string court | observation libre, format CSV-safe (pas de virgule non quotée) |

## Comment ajouter un résultat

```bash
# Fin de test, observer les métriques dans Hermès
# Puis append au CSV (attention au quoting CSV)

cat >> Projets/Cookbook_Hermes_RTX3090/tests/results.csv <<EOF
2026-05-04,S98,C,qwen3.6-agent,custom-Modelfile-copy-from-qwen35-Q4_K_M,v0.12.0-post-update,false,65536,205,2,3,true,fr,true,true,Test C OK — Modelfile durci sème cite 22.12°C agit conditionnellement
EOF
```

Ou via Edit tool si on est en Cowork/CLI : ajouter la ligne en fin de
fichier en respectant les 16 colonnes.

## Comment générer un tableau comparatif

### Pivot par modèle (compare 1 modèle sur tous ses tests)

```bash
awk -F',' '$4 == "qwen3.6-agent" || NR == 1' \
  Projets/Cookbook_Hermes_RTX3090/tests/results.csv \
  | column -t -s',' -o' | '
```

### Pivot par test_id (compare tous les modèles sur 1 test)

```bash
awk -F',' '$3 == "B" || NR == 1' \
  Projets/Cookbook_Hermes_RTX3090/tests/results.csv \
  | column -t -s',' -o' | '
```

### Pivot par session (snapshot d'une campagne)

```bash
awk -F',' '$2 == "S98" || NR == 1' \
  Projets/Cookbook_Hermes_RTX3090/tests/results.csv \
  | column -t -s',' -o' | '
```

### Conversion Markdown (pour rapports)

```bash
python3 -c "
import csv
with open('Projets/Cookbook_Hermes_RTX3090/tests/results.csv') as f:
    rows = list(csv.reader(f))
header, data = rows[0], rows[1:]
print('| ' + ' | '.join(header) + ' |')
print('|' + '|'.join(['---'] * len(header)) + '|')
for r in data:
    print('| ' + ' | '.join(r) + ' |')
"
```

## Anti-patterns

1. **Modifier un prompt après publication** : invalide tous les
   résultats antérieurs sur ce test_id. Si évolution nécessaire, créer
   `Test_X_v2` avec nouveau prompt, garder Test_X figé.
2. **Sauter une colonne** : append-only avec 16 colonnes obligatoires.
   Si une métrique n'a pas été mesurée (pas de write attendu, etc.),
   utiliser valeur null/empty mais garder la colonne (séparateur
   présent).
3. **Reformuler le prompt à la volée** ("c'est presque la même chose")
   : NON. Copier-coller le prompt depuis `prompts.yaml` exactement.
4. **Mélanger versions Hermès** dans le même tableau sans le préciser :
   colonne `hermes_version` essentielle. Comparer S63 (v0.11.0
   post-update) avec S98 outdated v0.12.0-minus-18 sans le noter
   = piège méthodologique.

## Usage typique

À la demande Mickael : *"sors-moi un tableau Markdown des Tests B, C, D
de tous les modèles qwen sur Hermès post-S93"* → Jarvis fait awk +
filter + format Markdown depuis results.csv.

À la demande Mickael : *"qu'est-ce qu'on a déjà testé sur qwen3.6-agent ?"*
→ Jarvis fait `grep "qwen3.6-agent" results.csv` et retourne le tableau.

## Lien

- Registry prompts : `Projets/Cookbook_Hermes_RTX3090/tests/prompts.yaml`
- Log résultats : `Projets/Cookbook_Hermes_RTX3090/tests/results.csv`
- Protocole tests : `memory/reference_protocole_tests_modeles_hermes.md`
- Méthode Modelfile : `memory/feedback_modelfile_copy_template_method.md`
- T#76 (campagne en cours) : `tasks/task_076.md`
