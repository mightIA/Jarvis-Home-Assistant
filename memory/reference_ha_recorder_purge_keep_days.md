---
name: HA recorder purge_keep_days
description: Distinction BD recorder (events bruts, purgés selon purge_keep_days) vs Long-Term Statistics (agrégations horaires, conservées indéfiniment). Valeur initiale 1, modifiée 35 S91.
type: reference
---

# HA recorder vs LTS — purge_keep_days

## Distinction critique

HA stocke en parallèle 2 choses différentes dans sa BD :

| Type | Contenu | Conservation | Utilisé par |
|------|---------|--------------|-------------|
| **Recorder** (events bruts) | Chaque state change individuel (état exact à chaque seconde) | `purge_keep_days` (modifiable dans `configuration.yaml`) | Logbook, history détaillée, certaines automatisations qui font référence à `state.last_changed` |
| **Long-Term Statistics (LTS)** | Agrégations horaires (mean/min/max/sum) | **∞** (jamais purgées sauf manuellement) | Graphiques long terme, Energy dashboard, ApexCharts statistics card |

## Conséquence pratique

- Les **graphiques sensors** (PM 2.5, conso énergie, météo, etc.) → données agrégées par heure conservées **indéfiniment** ✅
- Le **logbook** (qui s'est allumé / qui est arrivé / quel motion s'est déclenché à 14h32 précises) → purgé selon `purge_keep_days` ❌

## Configuration Mickael (S91, 2026-05-03)

```yaml
recorder:
  auto_purge: 1
  purge_keep_days: 35   # initialement 1, modifié S91 pour skill ha-logs-archive
```

**Modif `purge_keep_days` n'a PAS d'effet rétroactif** : HA arrête de purger les données >35j à partir du restart, mais ne récupère pas les données déjà purgées. La BD repart de zéro depuis le restart.

Restart HA Core obligatoire pour appliquer (pas un reload simple).

## Vérification disque post-modif

À surveiller dans **HA UI Settings → System → Storage** : taille de la BD recorder. Avec `purge_keep_days: 1 → 35` (×35), s'attendre à une croissance significative dans les 7-10 jours suivants. Si trop gros, revenir à `purge_keep_days: 7` ou rester à `1` et utiliser archive quotidienne (Option D skill ha-logs-archive v2).

## Lien skill

- `ha-logs-archive` v2 (S91) — utilise cette valeur pour décider du mode d'archivage (quotidien Option D si purge_keep_days < 2, hebdo possible si >= 7).

## Référence

- Test bout-en-bout T#34 S91 (2026-05-03) : seuil logbook MCP entre 48h et 72h
  → confirmation `purge_keep_days: 1` avant modif.
- Doc HA officielle : https://www.home-assistant.io/integrations/recorder/
