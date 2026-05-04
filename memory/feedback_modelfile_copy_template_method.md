---
name: Modelfile copy-template — recette pour transférer le comportement custom à un nouveau modèle
description: S98 04/05/2026 — Quand un nouveau modèle Ollama a un comportement dégradé vs version précédente (langue, sémantique, format), copier le Modelfile de la version qui marchait + swap juste FROM. Le SYSTEM custom + params optim sont la sauce secrète, pas le modèle de base.
type: feedback
---

# Modelfile copy-template — recette pour transférer le comportement custom à un nouveau modèle

## Règle

Quand un nouveau modèle Ollama (sortie récente, upgrade de version, etc.)
présente un comportement dégradé par rapport à un modèle équivalent qui
marchait (réponses dans une autre langue, sémantique cassée, format
imposé non demandé, dérive vers narration), **ne pas conclure trop vite
sur le modèle**. Tester d'abord en transférant le Modelfile durci de la
version précédente (SYSTEM + RENDERER/PARSER + PARAMETER) sur le nouveau
modèle de base.

## Why

S98 (04/05/2026) — Test T#76 Phase 1 : `qwen3.6:27b` brut a renvoyé en
anglais sans accents avec un format de tableau imposé non demandé, alors
que `qwen35-agent` (Modelfile durci sur `qwen3.5:27b` avec SYSTEM FR +
params optim) répond en français concis et idiomatique sur le même
prompt. Conclusion erronée possible : "Qwen 3.6 est mauvais en FR / en
tool calling". Conclusion correcte : le **SYSTEM prompt + paramètres**
(`temperature 0.3`, `top_k 40`, `top_p 0.9`, `presence_penalty 1.5`,
`num_ctx 65536`) sont ce qui produit le bon comportement. Sans eux, le
modèle brut applique ses biais d'entraînement (Qwen = corpus EN
majoritaire → réponse EN par défaut).

Après création de `qwen3.6-agent` (Modelfile copié de `qwen35-agent`
avec juste `FROM qwen3.6:27b`), le comportement langue + sémantique
+ format est revenu à la qualité attendue. Latence reste 3m25s vs
baseline qwen35 2m40s sur Test B (verdict latence séparé), mais la
**comparaison équitable** ne peut se faire qu'avec le Modelfile transféré.

## How to apply

Procédure en 5 étapes WSL2 Ubuntu :

```bash
# 1. Extraire le Modelfile du modèle qui marche (custom durci)
ollama show <ancien-agent-ok> --modelfile > ~/Modelfile-<nouveau-nom>

# 2. Swap uniquement la ligne FROM vers le nouveau modèle de base
sed -i 's|^FROM .*$|FROM <nouveau-modele-tag>|' ~/Modelfile-<nouveau-nom>

# 3. (Si architecture différente) ajuster RENDERER/PARSER
# Ex : qwen3.5 vs qwen3.6 → tester d'abord avec qwen3.5 conservé,
# puis si bug parsing tool calls → essayer qwen3.6 ou supprimer.
# Ollama accepte silencieusement les renderer/parser inconnus.

# 4. Build le nouveau modèle (instantané si blobs poids déjà sur disque)
ollama create <nouveau-agent> -f ~/Modelfile-<nouveau-nom>

# 5. Test fonctionnel sur Test B référence (lecture température cuisine)
# Comparer langue, sémantique, format avec ancien-agent
```

**Variantes utiles** :

- Si le nouveau modèle a un SYSTEM différent au build (cas rare), ne pas
  le mélanger avec le SYSTEM du Modelfile copié — le copy-template
  prime, le nouveau SYSTEM brut est ignoré.
- Pour tester si la régression vient du modèle ou du Modelfile : créer
  un Modelfile minimal (FROM seul, pas de SYSTEM ni PARAMETER) et
  comparer avec le copy-template. Si le minimal est aussi dégradé que
  le tag direct, le bug est dans le modèle. Sinon, le problème vient
  d'un autre PARAMETER spécifique.

## Cas où la méthode ne marche pas

- **Architecture trop différente** : ex Llama → Qwen, le RENDERER/PARSER
  sera incompatible et `ollama create` peut échouer. Dans ce cas, pas
  de copy-template direct, écrire un Modelfile from scratch.
- **Format prompt template différent** : si le modèle attend
  ChatML strict et que le copy-template injecte le format de l'ancien
  modèle, dérive. Vérifier le `TEMPLATE` du Modelfile.
- **Tokenization incompatible** : observé S98 — Qwen 3.6 perd les
  accents FR (« trouve », « entite ») là où Qwen 3.5 les rendait
  correctement. Ne casse pas le sens mais cosmétique. Pas réglable
  via Modelfile, c'est dans le tokenizer du modèle.

## Lien

- T#76 Phase 1 résultats : `tasks/task_076.md`
- Cookbook Hermès journey : `Projets/Cookbook_Hermes_RTX3090/docs/journey-s57-s63.md`
- Auto-memory protocole tests : `memory/reference_protocole_tests_modeles_hermes.md`
- Auto-memory Qwen 3.6 ratée veille : `memory/project_qwen36_sortie_avril_2026.md`
