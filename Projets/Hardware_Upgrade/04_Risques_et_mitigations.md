# 04 — Risques et mitigations

**Date** : 26/04/2026 (S55)
**Méthodologie** : matrice probabilité × impact, échelle 1-5, mitigations concrètes

---

## Matrice de risques

```
                    IMPACT
              1     2     3     4     5
       5   │     │     │     │     │  R1 │  ← Catastrophe
       4   │     │     │  R5 │  R3 │  R2 │
       3   │     │  R8 │  R6 │  R4 │     │
       2   │  R10│  R9 │  R7 │     │     │
       1   │     │     │     │     │     │
PROBABILITÉ
```

Légende :
- 5 = Critique → action immédiate / show-stopper
- 4 = Élevé → mitigation explicite obligatoire
- 3 = Moyen → mitigation recommandée
- 2 = Faible → surveillance
- 1 = Négligeable

---

## R1 — Migration HA Pi5 → Proxmox casse les devices Zigbee

**Probabilité** : 5 / **Impact** : 5 / **Score** : 25 (CRITIQUE)

### Description

La network key Zigbee est stockée dans le flash du dongle. Si on casse / reflash / reformate par erreur le dongle, **les ~30 devices Zigbee ne seront plus appairés**. Réappairage manuel = 4-8h de manipulation device par device, risque de perte de scènes/automations.

### Indicateurs précurseurs

- Dongle non détecté en passthrough Proxmox
- Erreur "coordinator not responding" dans ZHA
- LED dongle clignote anormalement

### Mitigations préventives

1. **Backup ZHA / Z2M avant migration** (Settings → System → Backups, et exporter coordinator backup)
2. **NE PAS** reflasher les dongles
3. **Migration physique** : les mêmes dongles physiques migrent du Pi5 au Proxmox
4. **Passthrough par numéro de série** (stable, pas par port USB qui peut permuter)
5. **Test passthrough en VM jetable** avant la VM HA OS de production

### Plan de rollback (si déclenché)

1. Éteindre VM HA OS Proxmox
2. Rebrancher dongles sur Pi5
3. Rallumer Pi5 (qui a son ancienne config intacte)
4. Réinitialiser projet à Phase D fin (HA Pi5 production)
5. Investigation : pourquoi le passthrough a échoué ? log Proxmox + dmesg
6. Reprise tentative seulement après root cause analysis

---

## R2 — Hermès local n'écrit toujours pas dans HA

**Probabilité** : 5 / **Impact** : 4 / **Score** : 20 (ÉLEVÉ)

### Description

Constat S48 + S53 : qwen3:32b lit OK mais bloque sur l'écriture HA ("Model returned empty after tool calls"). Si aucun modèle local ne sait fiablement écrire, l'investissement Ryzen 7950X est partiellement perdu (le Ryzen reste utile, mais pas justifié à 580 € si Ryzen 7700 suffit).

### Indicateurs précurseurs

- Phase A.2 (mistral-nemo:12b) échoue
- Phase A.3 (Llama 3.3 70B) échoue ou crash OOM
- Phase A.4 (OpenRouter Claude Haiku) reste seule option viable

### Mitigations préventives

1. **Phase A AVANT Phase B** (achat) — règle stricte
2. **Test 10 écritures consécutives**, pas une seule (taux ≥ 80%)
3. **Mesure coût OpenRouter** : si <2 €/mois en hybride, c'est viable

### Plan de rollback (si déclenché)

1. Architecture hybride confirmée → **Ryzen 7700 ou 7900X suffit** (économie 120-260 €)
2. Réinvestir économie dans : 128 Go RAM (futur 70B Q4) ou 2× SSD miroir ZFS
3. Hermès tourne avec routing : lecture local + écriture OpenRouter
4. T#69 OpenRouter Claude Haiku 4.5 devient cœur de l'architecture, pas option

---

## R3 — IOMMU mal configuré, passthrough impossible

**Probabilité** : 4 / **Impact** : 4 / **Score** : 16 (ÉLEVÉ)

### Description

Si la CM ASUS ROG Maximus XI Hero a des groupes IOMMU mal séparés (devices regroupés sur un même groupe), le passthrough USB ciblé est impossible — on ne peut passthrough qu'un groupe entier. Cas typique : tous les ports USB dans un même groupe → impossible de passthrough seulement Zigbee/Coral, doit donner tous les USB à une VM.

### Indicateurs précurseurs

- Audit IOMMU Phase D.2 montre groupes regroupés
- Erreur "device assigned to a group that is not isolatable"

### Mitigations préventives

1. **Audit IOMMU live Linux AVANT install Proxmox** (Phase D.2)
2. **Workaround si groupes regroupés** : ACS Override patch (kernel paramètre `pcie_acs_override=downstream,multifunction`)
3. **Plan B** : ajouter un hub USB PCIe dédié (~30 €) sur un slot PCIe avec groupe IOMMU séparé

### Plan de rollback (si déclenché)

1. Si ACS Override fonctionne → continuer (note : non recommandé en prod, risque sécurité limité en homelab)
2. Si pas viable → achat carte USB PCIe (StarTech ou équivalent ~40 €) + retest
3. Si toujours bloqué → repenser archi : VM HA OS dédiée avec **tous** les USB passthrough (acceptable, juste moins flexible)

---

## R4 — Cloudflare Tunnel cassé pendant migration HA

**Probabilité** : 4 / **Impact** : 3 / **Score** : 12 (MOYEN)

### Description

Le tunnel cloudflared tourne sur le Pi5 actuellement (probablement en addon HA). Si on bascule HA en VM Proxmox, **où tourne cloudflared** ? Si on l'oublie, ha.might.ovh tombe → accès distant + Mode Réactif HS (dépend de l'envoi mail HA→Gmail→label).

### Indicateurs précurseurs

- Erreur CF dashboard "tunnel disconnected"
- ha.might.ovh inaccessible distant
- Mode Réactif scheduled task échoue (mail non envoyé)

### Mitigations préventives

1. **Avant Phase E** : noter exactement où tourne cloudflared (addon HA OS Pi5 ?)
2. **Plan A** : addon cloudflared installé dans la VM HA OS (continuité directe)
3. **Plan B** : container cloudflared dans VM Docker Host (séparation propre)
4. **Test post-migration** : `curl -I https://ha.might.ovh/` retourne 200 dans les 5 min

### Plan de rollback (si déclenché)

1. Rallumer Pi5, dongles toujours sur Proxmox → casse tout, pas viable
2. Donc : ne pas migrer les dongles tant que CF tunnel pas validé
3. **Ordre strict Phase E** : E.6 (vérif HA) → **E.6.5 vérif CF Tunnel** → E.7 (bascule DNS public)

---

## R5 — Bruit / chaleur i9-9900K en 24/7

**Probabilité** : 3 / **Impact** : 4 / **Score** : 12 (MOYEN)

### Description

L'i9-9900K en charge soutenue Proxmox + 4 VM peut chauffer à 70-80°C avec ventirad d'origine (Wraith ou stock). Bruit = nuisance bureau si même pièce.

### Indicateurs précurseurs

- Température package > 80°C en idle
- Bruit ventilateurs audible jour
- Throttling CPU thermique (perfs en chute)

### Mitigations préventives

1. **Repassage pâte thermique** : pâte d'origine 2018 = sèche, refaire avec Noctua NT-H2 (~10 €)
2. **Vérifier ventirad** : si stock Intel, considérer upgrade Noctua NH-U12S Redux (~50 €)
3. **Localisation serveur** : pièce dédiée (cellier, bureau séparé) si possible
4. **Configuration Proxmox** : limiter CPU governor à "balanced" pas "performance" 24/7

### Plan de rollback (si déclenché)

1. Achat ventirad upgrade ~50 €
2. Boîtier serveur insonorisé si nuisance bureau (~100 €)

---

## R6 — Frigate sortie du Supervisor casse les automations HA

**Probabilité** : 3 / **Impact** : 3 / **Score** : 9 (MOYEN)

### Description

Quand Frigate est addon HA (Supervisor), l'intégration HA "Frigate" se configure auto via discovery. Quand il devient VM externe, il faut reconfigurer l'intégration manuellement (URL, MQTT topic). Risque : perte temporaire d'automations basées sur événements Frigate.

### Mitigations préventives

1. **Backup config addon Frigate AVANT** désinstallation (config.yml + zones)
2. **Setup VM Frigate** avant désinstall addon (parallèle quelques heures)
3. **Liste automations dépendantes** Frigate → vérifier toutes après bascule

### Plan de rollback

1. Réinstaller addon Frigate depuis HA
2. Restaurer config.yml backup
3. VM Frigate reste pour test ultérieur

---

## R7 — Caméras Frigate incompatibles ou stream cassé

**Probabilité** : 2 / **Impact** : 3 / **Score** : 6 (FAIBLE)

### Description

Caméras achetées Phase F.5 incompatibles RTSP ou stream H.265 non décodé par Coral. Achat à perte.

### Mitigations préventives

1. **Recherche compat avant achat** : Frigate community list / Reddit r/homeassistant
2. **Modèles validés** : Reolink RLC-820A, Dahua IPC-HFW2531T, Hikvision DS-2CD2143G2
3. **Tester 1 caméra avant achat des 2 autres**

---

## R8 — RAM AM5 instable en 64 Go

**Probabilité** : 2 / **Impact** : 2 / **Score** : 4 (FAIBLE)

### Description

AM5 + DDR5-6000 + 2×32 Go : généralement stable, mais variabilité silicon possible (1-2% de cas).

### Mitigations préventives

1. **Kit certifié EXPO AM5** (G.Skill Trident Z5 NEO) — déjà BoM
2. **Installer dans slots A2+B2** (recommandation Gigabyte)
3. **memtest86 1 cycle minimum** après montage
4. **Si instable** : retomber en DDR5-5600 ou JEDEC 4800, retest

---

## R9 — Onduleur ne shutdown pas correctement

**Probabilité** : 2 / **Impact** : 2 / **Score** : 4 (FAIBLE)

### Description

NUT mal configuré → coupure secteur prolongée → batterie vide → arrêt brutal Proxmox → corruption ZFS / VMs.

### Mitigations préventives

1. **Test NUT initial** : simuler coupure (débrancher onduleur du mur 5 min) → vérifier shutdown gracieux à 20% batterie
2. **Configuration upsmon** : seuil shutdown à 25-30% (pas 5%)
3. **Backup PBS quotidien** = filet de sécurité dernier recours

---

## R10 — Données utilisateur perdues pendant migration

**Probabilité** : 1 / **Impact** : 2 / **Score** : 2 (FAIBLE)

### Description

Photos, fichiers, configurations perso oubliés sur l'ancien SSD Windows i9-9900K avant install Proxmox.

### Mitigations préventives

1. **SSD Windows actuel SORTI de la machine** avant install Proxmox (cf Phase D pré-requis)
2. **Backup complet préalable** OneDrive + HDD externe
3. **Inventaire perso** : Documents / Pictures / Downloads check avant démontage

---

## Plan rollback global (si abandon projet)

Si décision d'abandonner à n'importe quel stade :

| Stade abandon | Action rollback |
|---|---|
| Phase A | Garder PC actuel, pas d'achat. Hermès reste en l'état. |
| Phase B (post-achat) | Stocker matériel, vendre si décision définitive (perte ~5% dépréciation) |
| Phase C (Ryzen monté) | Garder Ryzen comme PC perso, i9-9900K reste actif Cowork |
| Phase D (Proxmox installé) | Rebooter sur SSD Windows backup, Proxmox archivé. HA Pi5 jamais touché. |
| Phase E (HA migré) | Rallumer Pi5, éteindre VM HA OS, switch DNS si besoin. <30 min. |
| Phase F (Frigate VM) | Réinstaller addon Frigate, supprimer VM. ~2h. |
| Phase G (services) | Désinstaller services secondaires, garder core (HA + Frigate VM). |

**Garantie principale** : Pi5 reste opérationnel jusqu'à 90 jours après bascule HA confirmée.

---

## Suivi des risques

À mettre à jour à chaque phase :

| Risque | Phase actuelle | Statut | Notes |
|---|---|---|---|
| R1 Zigbee | Phase 0 | 🟡 Préventif activé | Backup ZHA prévu Phase E pré-req |
| R2 Hermès | Phase 0 | 🟡 Phase A à exécuter | Critère d'arrêt go/no-go |
| R3 IOMMU | Phase 0 | 🟡 Audit Phase D.2 | Live Linux à boot |
| R4 CF Tunnel | Phase 0 | 🟡 Plan défini | Cloudflared addon migration |
| R5 Bruit | Phase 0 | 🟢 Mitigation simple | Pâte thermique à racheter |
| R6 Frigate | Phase 0 | 🟢 Plan parallèle Phase F | |
| R7 Caméras | Phase 0 | 🟢 Recherche avant achat | Modèles validés liste |
| R8 RAM | Phase 0 | 🟢 Kit EXPO certifié | |
| R9 Onduleur | Phase 0 | 🟢 NUT seuil 25-30% | |
| R10 Données | Phase 0 | 🟢 Backup OneDrive + HDD | |
