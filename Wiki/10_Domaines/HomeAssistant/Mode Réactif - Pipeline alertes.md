---
title: Mode Réactif — Pipeline alertes (label Jarvis-Alert)
created: 2026-04-25
tags: [ha/mode-reactif, gmail/labels]
status: actif
---

# Mode Réactif — Pipeline alertes (label Jarvis-Alert)

## Label Gmail `Jarvis-Alert`

| Paramètre | Valeur |
|---|---|
| Label | `Jarvis-Alert` (+ sous-label `Jarvis-Alert/Traité` après traitement) |
| Filtre | Sujet contient `[JARVIS-ALERT]` |
| Actions du filtre | Appliquer label `Jarvis-Alert` + Marquer important |
| Exclusion | **Ne jamais classer dans tri email quotidien** (exclure de `tri-email-gmail`) |
| Conservation | 30 jours puis archive automatique |

⚠️ **Jamais TRASH** sur les mails Jarvis-Alert — bascule label `Jarvis-Alert` →
`Jarvis-Alert/Traité` uniquement (cf. [[Mode Réactif - Décisions S31 CLI]]).

## Convention de sujet (côté HA)

Format normalisé pour tous les emails sortants des automations HA :

```
[JARVIS-ALERT] <type_evenement> | <gravite> | <entite>
```

`gravite` ∈ `low` / `medium` / `high` — utilisée par Jarvis pour décider
de l'ordre de traitement en cas de file d'attente.

## Exemples

```
[JARVIS-ALERT] ban_ip | high | 192.0.2.12
[JARVIS-ALERT] log_erreur | high | sensor.zigbee_bridge
[JARVIS-ALERT] update_dispo | low | hacs
```

## Événements captés

### Phase 1 (événements *safe*) — déployée S29

- [x] `ban_ip_detected` — détection ban IP dans `ip_bans.yaml`
- [x] `log_erreur_critique` — ERROR/CRITICAL dans les logs HA (toggle OFF S30, garde-fou spam zigbee)

### Phase 2 (signalement) — TODO

- [ ] `update_ha_dispo` — nouvelle version HA Core
- [ ] `update_addon_dispo` — MAJ d'un add-on
- [ ] `cameras_stockage_plein` — seuil disque caméras dépassé
- [ ] `acces_ha_perdu` — test ping HA depuis Cowork échoue N fois

### Phase 3 (update auto + Proxmox) — bloquée

Migration Raspberry Pi → PC + Proxmox requise.

## Format d'un événement (`config/reactif_events.yaml`)

```yaml
- id: ban_ip_detected
  description: "Détection d'un nouveau ban IP dans ip_bans.yaml"
  trigger_ha: "sensor.ha_ip_bans state changes"
  sujet_mail: "[JARVIS-ALERT] ban_ip | high | {{ new_ip }}"
  classification: safe
  action_par_niveau:
    5: debanish_auto
    4: debanish_auto
    3: debanish_auto    # exception règle 0 — validée S15
    2: signaler
    1: ignorer
  garde_fou: "max 3 debannissements / 24h, au-delà → signaler uniquement"
```

## Log temps réel

Dossier : `memory/historique_reactif/` (un fichier par jour `AAAA-MM-JJ.md`).
Format détaillé dans `Ressources/Competences/Mode_Reactif.md` §7.1.
**Exclu de Git** (cf. `.gitignore`) — pollution sinon.

## Notes liées

- [[Mode Réactif - Vue d'ensemble]]
- [[Mode Réactif - Niveaux d'autonomie]]
- [[Mode Réactif - Décisions S31 CLI]]
- [[Débannissement IP]] — événement principal Phase 1

---

*Source : `Ressources/Competences/Mode_Reactif.md` §4 + §5.*
