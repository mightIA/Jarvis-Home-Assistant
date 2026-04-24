---
name: yaml-automation
description: Generation d'automations YAML pretes a coller pour Home Assistant. Couvre gestion des lumieres (scenes, gradation, horaires), chauffage (plannings, eco/confort, presence), securite (alertes, detection mouvement, simulation presence), confort (routines matin/soir, scenes perso), economies d'energie (coupures auto, suivi conso). Toujours proposer un test apres modification.
---

# Skill : Creation d'automations YAML

## Quand cette skill est declenchee

- Demande de Mickael : "je voudrais une automation qui fait X".
- Demande de modification d'une automation existante.
- Demande de scene, de routine, de declenchement temporise.

## Structure type d'une automation

```yaml
automation:
  - alias: "Nom court et explicite"
    trigger:
      - platform: time
        at: "21:00:00"
    condition: []
    action:
      - service: light.turn_on
        target:
          area_id: salon
        data:
          brightness_pct: 30
```

## Exemples courants

### Lumieres tamisees le soir

```yaml
automation:
  - alias: "Lumieres tamisees le soir"
    trigger:
      - platform: time
        at: "21:00:00"
    action:
      - service: light.turn_on
        target:
          area_id: salon
        data:
          brightness_pct: 30
```

### Bouton on/off pour activer/desactiver une automation

```yaml
input_boolean:
  mode_soiree:
    name: "Mode Soiree"
    initial: false
    icon: mdi:weather-night
```

## Bonnes pratiques

- **Toujours nommer** l'automation (alias clair).
- **Utiliser des conditions** pour eviter les declenchements indesirables
  (presence, heure, jour de la semaine).
- **Tester apres chaque creation** : demander a Mickael de verifier.
- **Prevenir si conflit** avec une automation existante.
- **Documenter** dans le fil de discussion si important.

## Ou coller le code

- Via l'interface HA : Parametres > Automatisations & scenes > Creer une
  automation > Editer en YAML.
- OU dans `automations.yaml` (fichier racine). Rechargement requis :
  Parametres > Outils dev > YAML > Automations.

## Regles de securite

- Ne jamais supprimer une automation existante sans avertissement explicite.
- Ne jamais modifier une automation critique (securite, alertes) sans
  validation.
- Toujours proposer le code complet pret a coller (ne pas modifier les
  fichiers directement).

## Reference longue

Voir `Ressources/Mode_Chat/Jarvis_Instructions.md` section 5.2.
