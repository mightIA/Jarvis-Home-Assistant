# Audit cohérence projet Hardware Upgrade — pré-commande

**Date** : 27/04/2026 (S67 Cowork)
**Auteur** : Jarvis Cowork, sur demande Mickael
**Périmètre strict** : analyse des 8 fichiers existants du dossier `Hardware_Upgrade/` + `Documentation/REPRISE_CONVERSATION.md`. Aucune modification d'autres fichiers du projet.
**Statut** : 🟢 document de revue avant commande matériel (référent décision = Mickael)

---

## 0. Pourquoi ce document

Mickael a demandé une étude approfondie de l'état actuel du projet `Hardware_Upgrade` pour repérer incohérences, lacunes et idées d'amélioration **avant** d'engager la commande de 2410 € (ou variante). Ce fichier capture la conversation S67 pour relecture ultérieure et arbitrages.

**Une conversation parallèle est en cours** lors de la rédaction (S67 vault migration ou autre). Ce doc respecte la consigne "ne toucher qu'aux fichiers présents dans `Hardware_Upgrade/`".

---

## 1. Documents lus pour cet audit

| Fichier | Taille | Statut audit |
|---|---|---|
| `README.md` | ~90 lignes | ✅ Lu |
| `00_Decisions_et_audits.md` | ~180 lignes | ✅ Lu |
| `01_Architecture_cible.md` | ~200 lignes | ✅ Lu |
| `02_BoM_finalisee.md` | ~175 lignes | ✅ Lu |
| `03_Phasage_A_a_G.md` | ~410 lignes | ✅ Lu |
| `04_Risques_et_mitigations.md` | ~295 lignes | ✅ Lu |
| `05_Onduleurs_NUT.md` | ~270 lignes | ✅ Lu |
| `06_Migration_HA_Pi5_Proxmox.md` | ~430 lignes | ✅ Lu |
| `07_Frigate_VM_Coral.md` | ~430 lignes | ✅ Lu |
| `08_Audit_S63_et_re_evaluation_hardware.md` | ~120 lignes | ✅ Lu |
| `Documentation/REPRISE_CONVERSATION.md` | ~240 lignes | ✅ Lu |
| `Documentation/Architecture_Jarvis_v3.pdf` | binaire | ⏭️ non ouvert (sortie source S59, pas spec) |
| `Documentation/Sources/ChatGPT_Conv_Originale.md` | ~30 pages | ⏭️ non ouvert (source brute, pas spec) |

---

## 2. Avis général

**Globalement, dossier projet solide.** Niveau rare pour un homelab :
- audits pré-achat documentés (CM IOMMU, dongles Zigbee, onduleurs)
- BoM justifiée avec choix non retenus tracés
- phasage A→G avec critères GO/NO-GO et rollback par phase
- 10 risques cotés en matrice probabilité × impact
- doc REPRISE pour relancer une nouvelle conv proprement
- discipline « Pi5 reste actif jusqu'à T+90j »

**Mais le projet n'est pas à 100 %**, à 90 % :
- le doc 08 (re-cadrage S65) **change la donne** sans avoir été propagé dans 00/02/03/04
- plusieurs incohérences techniques mineures se sont glissées dans les fichiers détaillés
- quelques lacunes (sécurité, secrets, monitoring transitoire)

**Un dernier passage de revue avant commande** est recommandé, pas une refonte.

---

## 3. Incohérences identifiées (par criticité)

### 🔴 Bloquantes ou potentiellement dangereuses

#### 3.1. Référence morte dans `01_Architecture_cible.md`

Section VM Docker Host : `voir 02_Stack_Docker.md à créer`. Ce fichier **n'existe pas** dans le dossier.

➜ **Action** : soit créer `02_Stack_Docker.md` (recommandé), soit retirer la mention.

#### 3.2. IP de la VM Docker Host non fixée

- `01_Architecture_cible.md` ne donne pas d'IP à la VM Docker
- `07_Frigate_VM_Coral.md` § 5.3 utilise `192.168.1.X` (placeholder) pour le broker MQTT
- `03_Phasage_A_a_G.md` D.6 crée la VM ID 100 sans IP

➜ **Risque** : pendant Phase F, on bascule Frigate vers une IP floue → intégration HA Frigate via MQTT casse.

➜ **Action** : fixer l'IP dès maintenant (suggestion `192.168.1.13` pour cohérence avec `.10` Proxmox / `.11` HA / `.12` Frigate). Voir tableau récap § 5.

#### 3.3. Driver NUT incohérent entre `00` et `05`

| Doc | Driver proposé |
|---|---|
| `00_Decisions_et_audits.md` § 4 | `apc_modbus` (USB Modbus, plus précis) |
| `05_Onduleurs_NUT.md` § 2.2 | `usbhid-ups` |

Les deux marchent, mais `apc_modbus` est supérieur sur SMT2200IC (lectures plus riches, moins de polling errors). Si on choisit `apc_modbus`, il faut aussi `nut-driver-apc-modbus` + `protocol=usb`.

➜ **Action** : trancher et harmoniser entre les deux fichiers.

#### 3.4. Coral USB — vendor:product change après firmware loaded

- `07_Frigate_VM_Coral.md` § 4.2 mentionne le piège : `1a6e:089a` (bootloader) → `18d1:9302` (Google Inc., post-init firmware)
- **Mais `06_Migration_HA_Pi5_Proxmox.md` § 6.1 et § 6.3 utilisent uniquement `1a6e:089a`** pour le passthrough Phase E

➜ **Risque concret** : passthrough Coral fonctionne au premier boot, casse silencieusement après init firmware si on ne configure que l'ID bootloader.

➜ **Action** : ajouter dans `06` une note explicite + commande plan B `qm set 101 -usb2 host=18d1:9302`.

### 🟠 À corriger sans urgence

#### 3.5. README désynchronisé

Le tableau du `README.md` indique `03`, `04`, `05`, `06`, `07` comme `⏳ à créer prochaine étape`. Tous existent et sont remplis depuis S55-S59.

➜ **Action** : mettre à jour les statuts en `✅`.

#### 3.6. Doc 08 non répercuté dans 00/02/03

Le doc 08 (S65) introduit 3 variantes BoM dont 2 économiques après validation qwen35-agent V1 en S63. Mais :
- `00_Decisions_et_audits.md` D2 : "Ryzen 9 7950X dans tous les cas" (verrouillé)
- `02_BoM_finalisee.md` : reste à 2410 € avec 7950X
- `03_Phasage_A_a_G.md` Phase A : décrit toujours le test "écriture HA bloquée S48+S53" comme bloqueur, alors que **résolu depuis S63**

Le doc 08 dit explicitement « aucune modif des fichiers existants » — décision propre. Mais ça crée un risque de **lecture en silo** : quelqu'un (ou Jarvis dans 6 mois) qui ouvre directement `02_BoM_finalisee.md` sans lire `08` partira sur le 7950X par défaut.

➜ **Action** : ajouter en tête de `00`, `02`, `03` un encart `> ⚠️ Re-cadrage S65 — voir 08_Audit_S63_et_re_evaluation_hardware.md avant toute commande`.

#### 3.7. Switch BoM non-PoE mais doc 07 reco caméras PoE

- BoM `02` : `TL-SG108-M2` (non-PoE, 130 €)
- Doc 07 § 7.2 : « Si caméras PoE → switch alternatif `TL-SG108PE` (~140 €) »

Si la cible terme = 5-6 caméras dont 2-3 nouvelles en PoE, mieux vaut **acheter directement le PE** (+10 € vs 3 injecteurs PoE séparés à 15 €/cam = 45 €).

➜ **Action** : décider PoE ou non, puis aligner BoM et `07`.

#### 3.8. Caméras 4-5-6 hors budget BoM

~330 € (3× Reolink RLC-820A) + éventuel surcoût switch PoE. Pas dans les 2410 €. Le projet présente la BoM comme « complète » mais Phase F nécessitera un budget complémentaire.

➜ **Action** : clarifier dans `02` ou `07` que les caméras supplémentaires sont hors budget initial.

#### 3.9. Méthode passthrough HDD WD Purple ambiguë

Doc 07 § 3.1 propose « Méthode 1 (disque entier passthrough) » OU « Méthode 2 (LVM volume sur HDD pool) ». Mais doc 03 Phase D.5 prévoit **PBS datastore sur partition HDD séparée** (50 Go) → **Méthode 2 obligatoire**, sinon le HDD est monopolisé par Frigate.

➜ **Action** : expliciter dans `07` que seule la Méthode 2 est compatible avec PBS partagé.

### 🟡 Détails à préciser

#### 3.10. Adresses IP non recouvertes

Pas de tableau récap. Voir § 5.

#### 3.11. Câbles & accessoires non listés en BoM

Câbles SATA (HDD), câble USB-B onduleur SMT2200IC (probablement fourni mais à vérifier), pâte thermique CPU i9-9900K (refresh prévu doc 04 R5). 10-30 € à provisionner dans la marge.

#### 3.12. Doc 08 ne reflète pas S66/S67

- **Audit sécurité S66** (16 tâches T#79-T#94 dont 4 P0/P1) non mentionné. Pertinent ici car certains points concernent le PC actuel : ngrok auth_token, ZeroTier latent, SSH `authorized_keys` vide. Devrait être nettoyé **avant** Phase D (install Proxmox sur le même i9-9900K) sinon on hérite des cochonneries.
- **Migration vault S67** (Phase 1) non mentionnée. T#3 Hardware avait échoué quota agent — à coordonner avec ce projet quand on relancera T#96.

➜ **Action** : MAJ doc 08 ou créer `09_Pre_Phase_D_Nettoyage.md`.

---

## 4. Lacunes identifiées

### A. Sécurité réseau caméras IP

Pas de VLAN dédié IoT/caméras prévu. Best practice 2026 : caméras chinoises sur VLAN isolé qui ne peut pas accéder au LAN principal. Box Orange ne fait pas de VLAN propre, faut un switch L2 managé. Le `TL-SG108-M2` actuel **ne fait pas de VLAN**. À reconsidérer si on prend du Reolink/Dahua.

### B. Plan recovery du SSD système Proxmox

Pas couvert. Si le Crucial P3 Plus 1 To lâche, comment on remonte le host ? PBS datastore est sur le HDD = OK pour les VMs, mais la procédure réinstall Proxmox host depuis zéro + restore VMs n'est pas documentée. Doc 04 dit « RTO 4h » sans procédure.

### C. Backup hors-site (3-2-1)

PBS = local. Si incident maison (incendie, cambriolage), perte totale. Mention OneDrive uniquement pour HA OS Phase E. Idée : `pbs-sync-tool` vers Backblaze B2 chiffré (~5 €/mois pour 1 To).

### D. Tests rollback préventifs

La procédure rollback Pi5 < 30 min repose sur « Pi5 SD intacte ». Aucun test de rollback simulé prévu durant la fenêtre 7-90j. Si le Pi5 a un problème silencieux (carte SD qui se dégrade), on s'en aperçoit le jour où on en a besoin. Idée : à T+15j, rollback simulé sur 1h le weekend.

### E. Secrets management transitoire

Vaultwarden arrive en Phase G. Mais pendant Phases C-F (semaines 1-3), où vivent les mots de passe ? (root Proxmox, NUT users, RTSP cameras, broker MQTT). Risque de fichiers texte temporaires partout. Idée : Bitwarden cloud gratuit ou KeePassXC local pendant la transition.

### F. Monitoring pendant Phase E observation 7 jours

Grafana/Prometheus arrive en Phase G. Pendant les 7 jours critiques post-bascule HA, aucun monitoring continu sur Proxmox host (CPU/RAM/temp). Idée : `glances` ou `cockpit` en quick-fix sur Proxmox dès Phase D fin.

### G. Frais de port + imprévus

Marge 90 € sur 2410 € pour ~10 composants livrés en groupé. En pratique LDLC/TopAchat, on s'en sort souvent à 30-50 €. Mais si rupture stock chez vendeur principal et split sur 2-3 vendeurs : 90 € peut être juste.

### H. Plan B si RTX 3090 lâche

La 3090 a 5-6 ans, MTBF qui décline. Aucune mention. Plan B implicite = OpenRouter full-time, mais ça fait sortir la décision Variante 1 vs 2 : si on est OK pour OpenRouter en plan B, autant prendre Variante 2 (économie 120-260 €) dès maintenant et provisionner 60-120 € de crédits cloud.

---

## 5. Tableau récap IPs proposé (à intégrer dans `01`)

| Composant | IP suggérée | Source / décision |
|---|---|---|
| Box Orange Livebox | 192.168.1.1 | Existant |
| Proxmox host | 192.168.1.10 | Doc 03 D.3 |
| VM HA OS | 192.168.1.11 | Doc 06 (récup IP Pi5) |
| VM Frigate | 192.168.1.12 | Doc 07 § 3.2 |
| **VM Docker Host (MQTT/Portainer/Grafana)** | **192.168.1.13** | **À fixer** |
| **VM PBS** | **192.168.1.14** | **À fixer** |
| Pi5 (standby/rollback) | DHCP réservée | Phase E.5 transitoire |
| Switch 2.5G | DHCP | Géré L1, pas de management |
| Caméras IP (1-3 actuelles) | 192.168.1.20-29 | Plage dédiée |
| Caméras IP (4-6 futures) | 192.168.1.30-39 | Plage dédiée Phase F |

---

## 6. Idées d'amélioration

### 6.1. Capitaliser sur la décision S63 — passer en Variante 2

qwen35-agent V1 fonctionne sur la 3090 actuelle. Le 7900X (12C/24T) tient largement Cowork + Hermès + bureautique. **Économie 120 € à réinvestir** dans :

| Option réinvestissement | Coût | Valeur |
|---|---|---|
| 2× SSD système Proxmox en miroir ZFS | +70 € | Redondance immédiate, SSD ne lâche plus host |
| Provision OpenRouter étendue | +100 € | Plan B 3090 + dépassement cap mensuel |
| 2e HDD WD Purple miroir Frigate | +200 € | Vidéo redondante (utile si caméras critiques) |

### 6.2. Switch direct au TL-SG108PE (PoE)

+10 € mais déverrouille 3 caméras PoE futures sans injecteurs séparés. ROI immédiat.

### 6.3. AP9631 SmartSlot dans la BoM finale

+250 €. Pour un homelab où le SMT2200IC est l'onduleur critique (Proxmox + box + switch + Pi5), monitoring SNMP **indépendant** du host Proxmox = vrai filet de sécurité. Si Proxmox host crash hardware, l'onduleur continue à alerter par mail.

À mon sens, **meilleur investissement que +120 € sur le CPU**.

### 6.4. Document `02bis_Stack_Docker.md` à créer

Sur la VM Docker Host, lister explicitement les containers, leurs versions épinglées, leurs ports, et un docker-compose.yml de référence. Aujourd'hui c'est dispersé entre 01 et 03. Crée la même rigueur que 06/07.

### 6.5. Section « Maintenance & cadence updates »

Dans `03` ou doc dédié :
- Updates Proxmox host : mensuelles
- Updates VM HA OS : via UI HA, alerte hebdo
- Updates Docker images : Watchtower notifications (pas auto-apply, déjà prévu)
- CVE monitoring : abonnement RSS/mail sur HA OS, Proxmox, Frigate

### 6.6. Tableau récap IP centralisé

Dans `01_Architecture_cible.md` (cf § 5 ci-dessus). Source unique de vérité.

### 6.7. Procédure rollback simulée à T+15j

Ajouter checkpoint dans doc 06 § 10 : « T+15j — rollback test 1h le weekend, on rallume Pi5, on coupe VM HA OS, on bascule, on vérifie, on rebascule. Confirme procédure rollback < 30 min ».

### 6.8. Mettre à jour doc 08 avec S66 + S67

- Lien vers audit sécurité S66 + checklist nettoyage avant Phase D (ngrok, ZeroTier, ChatGPT integration disabled, SSH keys)
- Lien vers vault Hardware (T#3 échec quota S67, à reprendre T#96) qui doit pointer vers ce projet

### 6.9. Clarifier explicitement la décision Variante 1 vs 2 vs 3

Le doc 08 liste 3 variantes mais « aucune n'est recommandée à ce stade ». À 1 mois de S63, on a le recul nécessaire. Suggestion : trancher ou créer un doc `09_Arbitrage_BoM_Variante.md` avec la décision motivée.

### 6.10. Plan d'achat caméras explicite

Sous-section dans BoM ou doc 07 : « Caméras 4-5-6 — 330 € hors BoM principale, à acheter Phase F si caméras actuelles satisfaisantes ».

---

## 7. Ce qui est excellent et à conserver tel quel

- Le **phasage A→G** avec critères GO/NO-GO et rollback à chaque phase
- La **discipline Pi5 standby 90j** — exactement le bon réflexe
- La **matrice de risques** avec scores P×I et plans rollback
- Le **doc REPRISE** qui permet de relancer une conv proprement
- Le **doc 08** qui formalise le re-cadrage S63 sans casser les fichiers historiques
- Le **doc 06** très détaillé sur la migration HA (timeline T-7j → T+90j)
- Le **doc 07** complet sur Frigate VM (architecture, configuration, performance)

---

## 8. Synthèse — ordre d'action proposé avant commande

### Si tu veux raffiner avant commande (par valeur décroissante)

1. **Trancher Variante 1 / 2 / 3** (créer `09_Arbitrage_BoM_Variante.md` ou MAJ `02`)
2. **Fixer les IPs VM Docker + VM PBS** dans `01`
3. **Corriger la référence morte** `02_Stack_Docker.md` (créer ou retirer)
4. **Harmoniser driver NUT** (`00` ↔ `05`)
5. **Ajouter le piège Coral** `1a6e:089a` → `18d1:9302` dans `06`
6. **Mettre `08` à jour** avec S66 (sécu) + S67 (vault)
7. **Décider switch PoE** direct vs non-PoE
8. **Clarifier méthode passthrough HDD** (Méthode 2 obligatoire)
9. **MAJ `README.md`** statuts ⏳ → ✅
10. **Ajouter encart « voir 08 avant commande »** en tête de `00`/`02`/`03`

### Ce qui peut attendre Phase G

- Backup hors-site
- VLAN caméras
- AP9631 SmartSlot (sauf si on l'inclut directement BoM)

### Mon avis perso

Le projet mérite encore **une session de revue avant achat**, pas une refonte. La structure est bonne, ce sont des détails techniques et des arbitrages stratégiques qui restent. Si Mickael valide la **Variante 2 (7900X)** maintenant, commande possible sous 2-3 semaines après nettoyage S66 du i9-9900K.

---

## 9. Garde-fous appliqués pendant cet audit

- Aucune modification des 8 fichiers existants du projet (lecture seule)
- Aucune modification hors `Hardware_Upgrade/Documentation/` (consigne Mickael pour conv parallèle en cours)
- Aucune commande matériel proposée
- Aucune suppression
- Aucune nouvelle auto-memory créée
- Aucun TASKS.md / METRIQUES.md / CLAUDE.md touché

---

## 10. Pour la suite

Quand Mickael aura lu ce doc et que la conv parallèle sera close :
- Décision sur les **8-10 actions de raffinement** ci-dessus (§ 8)
- Choix de Variante 1 / 2 / 3
- Éventuelle session dédiée pour appliquer les corrections aux 8 fichiers existants
- Ouverture éventuelle Phase B (commande matériel)

---

*Fin de Audit_Coherence_Pre_Commande_S67.md — version 1.0 — 27 avril 2026.*
