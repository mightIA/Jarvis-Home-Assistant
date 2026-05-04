---
name: ha-mcp enable_tool_search — bon réglage par taille de modèle
description: S63 confirmé S93 — enable_tool_search OFF (87 tools en clair) pour modèles ≥27B Q4-Q5, ON pour ≤14B. Cohérent avec qwen35-agent actuel. Annule l'auto-memory précédente Cowork S53.
type: reference
---

# ha-mcp `enable_tool_search` — bon réglage par taille de modèle

## Règle

Le toggle `enable_tool_search` côté add-on ha-mcp dépend de la **taille
du modèle Hermès** qui consomme l'API MCP :

| Taille modèle | enable_tool_search | Nombre tools côté Hermès | Pourquoi |
|---|---|---|---|
| **≥ 27B Q4-Q5** (qwen35, qwen3.6:27b, qwen3.6:35b-a3b...) | **OFF** | 87 (tous en clair) | Modèle assez capable pour gérer 87 outils dans le contexte sans dérive. Pas besoin de filtrage. |
| **≤ 14B** (mistral-nemo:12b, llama3.1:8b, qwen2.5:14b...) | **ON** | ~20 (filtrage dynamique) | Catalogue 87 outils sature le petit contexte / dégrade le tool calling. Le tool_search filtre dynamiquement ~20 tools pertinents par requête. |

## Validation S63 (Cookbook Hermès RTX 3090)

Verdict établi en session 63 (audit méthodologique 2, cf. publication
S64 du repo `mightIA/hermes-agent-rtx3090-cookbook`) :

> *enable_tool_search reste un compromis : ON pour modèles ≤ 14B, OFF
> pour ≥ 27B Q4-Q5 capables de gérer 87 outils en clair.*
> — `Projets/Cookbook_Hermes_RTX3090/docs/journey-s57-s63.md`

Confirmé S93 (03/05/2026) lors du redémarrage Hermès post-update v0.12.0 :
bannière affiche `ha-mcp (http) — 87 tool(s)`, qwen35-agent fonctionne
parfaitement (Test A reproduit OK : write `persistent_notification.create`
en ~3-6 min).

## Annule

Cette auto-memory **annule** l'auto-memory précédente Cowork S53
intitulée *« HA add-on enable_tool_search ON »* (référencée dans
le cache MEMORY.md Cowork web mais non versionnée localement). La S53
recommandait `enable_tool_search: ON` car teste à l'époque sur petit
modèle. Depuis S63, qwen35-agent (27B Q5) est l'agent par défaut → OFF
est le bon réglage.

## How to apply

- Si Mickael migre Hermès sur un modèle ≤ 14B (mistral-nemo, llama3
  8B...) → repasser le toggle ON via HA UI : Apps → ha-mcp →
  Configuration → `enable_tool_search` → **true** → Save + Restart
  add-on
- Si Mickael reste sur qwen35 ou bascule vers Qwen 3.6-27B / 3.6-35B-A3B
  ou Hermes 4 70B (T#77) → garder OFF
- Pour les modèles entre 14B et 27B (zone grise) : tester les 2
  configurations sur le Test B S63 et choisir celle qui donne meilleur
  ratio latence/qualité

## Lien

- Journey Hermès S57-S63 (raison du verdict) :
  `Projets/Cookbook_Hermes_RTX3090/docs/journey-s57-s63.md` ligne 256
- Configs reproductibles : `Projets/Cookbook_Hermes_RTX3090/docs/configs.md`
- T#76 retest 6 modèles : `tasks/task_076.md`
- Auto-memory Qwen 3.6 ratée : `memory/project_qwen36_sortie_avril_2026.md`
