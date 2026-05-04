---
id: 3b
title: "Tester la migration (7 tests checklist post-migration)"
status: done
priority: P1
session_closed: S19
source: "Migration 19/04/2026"
---

# T#3b — Tester la migration (7 tests checklist post-migration)

## Description

Tester la migration (7 tests checklist post-migration)

## Source / Échéance

Migration 19/04/2026

## Statut

**FAIT 7/7 (session 19, 20/04/2026)** — Migration 100% validee. T1 presentation FR auto OK (Jarvis se presente correctement). T2 6/6 entites Frisquet citees (climate.maison_zone_1_2, water_heater.chauffe_eau_maison_2, sensor.maison_temperature_zone_1_2, sensor.maison_alerte_2, sensor.maison_consommation_chauffage_2, sensor.maison_consommation_eau_chaude_2). T3 skill `debannissement-ip` declenchee (3 methodes : SSH local, File Editor distant, MCP fallback). T4 skill `redaction-email` declenchee avec ton SAV + signature Mickael Rubino. T5 scripts cameras listes (snapshot/record/vider + shell_command pour les 3 cameras). T6 skill `chaudiere-frisquet` declenchee : distinction derogation/permanent + preset `confort_permanent` HVAC=heat. T7 MCP HA deja valide en S18 (`ha_get_state` + `light.turn_on`).
