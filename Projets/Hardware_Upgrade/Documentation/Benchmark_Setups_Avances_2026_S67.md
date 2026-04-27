# Benchmark setups avancés homelab 2026 — ce qu'on n'a pas couvert

**Date** : 27/04/2026 (S67 Cowork)
**Auteur** : Jarvis Cowork, sur demande Mickael
**Périmètre strict** : recherche web sur les setups homelab haut de gamme 2026, comparaison avec le projet actuel, identification des manques. **Aucune modification d'autres fichiers** (consigne Mickael, conv parallèle).
**Statut** : 🟢 document de référence — ne décide rien, propose des angles d'enrichissement à arbitrer plus tard.

---

## 0. Méthodologie

J'ai croisé 8 recherches web sur le « state of homelab 2026 » :

1. Best advanced homelab setup 2026 (Proxmox + HA + NAS + rack)
2. Frigate dedicated NVR storage (TrueNAS / Synology)
3. Essential self-hosted services (reverse proxy + SSO + DNS)
4. 10-inch rack mini homelab + MikroTik / UniFi
5. Voice assistant local HA (Whisper / Piper / VPE)
6. Sécurité homelab (CrowdSec / Wazuh / fail2ban / SIEM)
7. VLAN segmentation IoT/caméras
8. Monitoring (Grafana + Prometheus + Alertmanager)
9. PDU monitoring + Shelly EM
10. Backup 3-2-1 (Restic / Borg / PBS)
11. Mesh VPN (Tailscale / NetBird / Headscale)
12. Local LLM (Ollama / vLLM / RTX 3090)

Sources principales (tous 2026) : Virtualization Howto, Techno Tim, Jeff Geerling Mini Rack, cr0x.net, corelab.tech, Bas Nijholt, Frigate docs, HomeLab Starter, JazzCyberShield, NetBird/Tailscale docs, Pi-hole/Authentik, Apollo Automation HA Voice PE.

---

## 1. Vue d'ensemble — ce qui se fait de plus avancé en 2026

| Domaine | Tendance 2026 | Notre projet actuel | Gap ? |
|---|---|---|---|
| **Format physique** | 10" mini-rack (Jeff Geerling) ou 19" rack | Tower Define 7 + i9 dans ancien boîtier | 🟡 Pas critique mais limité |
| **Compute** | Mini-PCs ou tower puissant + Proxmox | Ryzen tower + i9 Proxmox | ✅ OK |
| **Stockage** | NAS dédié (TrueNAS/Synology) + ZFS | HDD WD Purple direct dans Proxmox | 🟠 NAS absent |
| **Réseau** | Switch managé L2/L3 + VLAN + 2.5/10 GbE | TL-SG108-M2 non managé 2.5G | 🔴 VLAN impossible |
| **Reverse proxy + SSO** | Traefik/Caddy + Authentik/Authelia | CF Tunnel + auth HA seul | 🟡 Auth fragmentée |
| **DNS local** | Pi-hole + Unbound (privacy + adblock) | DNS box Orange / 1.1.1.1 | 🟡 Manqué |
| **Défense réseau** | CrowdSec + fail2ban + (option Wazuh) | CF Access policies + HSTS + MFA | 🟠 Pas de défense locale |
| **Backup 3-2-1** | PBS + Restic/Borg + cloud chiffré | PBS local + OneDrive partiel | 🟠 Hors-site partiel |
| **Mesh VPN** | Tailscale ou NetBird | CF Tunnel uniquement | 🟡 Plan B distant absent |
| **Monitoring** | Grafana + Prometheus + Alertmanager | Uptime Kuma seul (Phase G) | 🟡 Alertes plate-forme manquantes |
| **Voice assistant local** | HA Voice PE + Whisper + Piper | Aucun (peut-être à venir) | 🟢 Hors scope |
| **Energy monitoring** | Shelly EM/3EM + dashboard HA Energy | Aucun | 🟠 Pertinent pour homelab 24/7 |
| **Local LLM** | Ollama (simple) ou vLLM (perf) | Ollama + Hermès | ✅ OK, mais vLLM en alternative perf |

---

## 2. Détail des angles à creuser

### 2.1. Format physique — mini-rack 10" ou rack 19" ?

**Tendance 2026** (Jeff Geerling « Project Mini Rack ») : les homelabbers passent du « tower dans un coin » au **mini-rack 10"** (largeur réduite, format propre, modulaire). Permet de monter switch + mini-PC + PDU 10" + patch panel keystone sur une structure verticale.

**Composants typiques d'un mini-rack 10" 2026** :
- Rack alu 6-12U (~80-150 €)
- MikroTik **CRS310-8G+2S+IN** : 8× 2.5 GbE + 2× SFP+ 10G, format 10", management complet (~280 €)
- PDU 10" managée 8 prises (~40-50 €)
- Patch panel keystone 12 ports
- Mini-PCs format SFF (Beelink SER, Minisforum UM, etc.)

**Pour le projet** :
- Le tower Define 7 actuel est un excellent boîtier silencieux mais **encombrant** et pas modulaire
- L'i9 Proxmox dans son boîtier d'origine = idem
- Un **mini-rack 12U** (~150 €) à côté avec **switch managé + PDU + patch panel** rendrait l'install pro et facilement extensible (ajout futur de mini-PC pour cluster Proxmox 2-3 nœuds, ou NAS 2.5" SFF)

**Verdict** : pas critique pour MVP, mais **vraie valeur ajoutée pour l'évolutivité 2-3 ans**. Si tu vises une vraie infra perso pérenne et propre, c'est ce qui change le plus la vie au quotidien.

### 2.2. NAS dédié vs HDD direct dans Proxmox

**Pratique 2026** : la majorité des setups avancés séparent **compute (Proxmox)** et **stockage (NAS)**.

| Approche | Avantages | Inconvénients |
|---|---|---|
| **HDD direct dans Proxmox** (notre choix actuel) | Simple, peu de matériel | Compute et stockage couplés, pas de mutualisation, pas de snapshot ZFS niveau pool |
| **NAS dédié (TrueNAS/Synology)** | Snapshots ZFS, partage NFS/SMB, backup centralisé, extension facile | +1 machine, complexité, coût |
| **Proxmox + TrueNAS VM avec disk passthrough** | Une seule machine, le meilleur des deux | Demande IOMMU propre, plus complexe |

**Frigate spécifiquement** : la doc Frigate 2026 recommande **stockage réseau** (NFS) pour les enregistrements vidéo, pas le disque local de la VM. Raisons :
- Évite la corruption disque VM en cas de plantage Frigate
- Permet d'utiliser un pool RAID/ZFS pour la vidéo (résilience)
- Décompte storage indépendant du compute

**Pour le projet** :
- **Option A** : on garde le HDD WD Purple direct, simple et fonctionnel (BoM actuelle)
- **Option B** : on ajoute un mini-NAS (Synology DS224+ ~330 € + 2× HDD 8 To miroir) **plus tard** quand caméras > 5
- **Option C** : on installe **TrueNAS comme VM Proxmox** avec passthrough disque (gratuit, mais plus complexe)

**Verdict** : pas un manque critique aujourd'hui, mais **prévoir le chemin d'évolution**. Si on choisit Option B, il faut un switch 2.5GbE+ pour ne pas saturer (donc cohérent avec passage à switch managé § 2.3).

### 2.3. Switch managé + VLAN — **point le plus important manqué**

**Best practice 2026** : tout homelab sérieux a **3 à 5 VLAN** :

| VLAN | Usage | Subnet exemple |
|---|---|---|
| 1 (mgmt) | Proxmox host, switch admin | 192.168.1.0/24 |
| 10 | Trusted (PC, laptops) | 192.168.10.0/24 |
| 20 | IoT (HA, dongles, devices Zigbee/Matter) | 192.168.20.0/24 |
| 30 | **Cameras IP** (RTSP isolées du LAN) | 192.168.30.0/24 |
| 40 | Guest WiFi | 192.168.40.0/24 |

**Pourquoi c'est critique pour les caméras IP** :
- Caméras chinoises (Reolink/Dahua/Hikvision) = **firmware propriétaire opaque**, souvent backdoorée
- Une caméra compromise sur le LAN principal = pivot vers tout le reste (HA, Proxmox, mots de passe, etc.)
- VLAN dédié + firewall qui bloque l'accès au LAN = isolation totale, caméra ne peut plus que sortir vers internet (et même ça on peut bloquer, sauf NTP)

**Notre BoM actuel** : `TL-SG108-M2` est **non managé** → **VLAN impossible**.

**Alternatives 2026** :

| Switch | Prix | Caractéristiques | Verdict |
|---|---|---|---|
| TP-Link **TL-SG108E** v6 | ~40 € | 8× 1G, smart managed (VLAN 802.1Q), pas de 2.5G | Trop juste si caméras 4K |
| TP-Link **TL-SG3210XHP-M2** | ~280 € | 8× 2.5G + 2× SFP+ 10G + PoE+ 240W, full L2 managé | Sweet spot 2026 |
| MikroTik **CRS310-8G+2S+IN** | ~280 € | 8× 2.5G + 2× SFP+, full RouterOS, 10" rack | Top community 2026 |
| UniFi **USW-Pro-Max-16-PoE** | ~470 € | 16× 2.5G + 4× 10G PoE++, controller | Si écosystème UniFi |

**Pour le projet** :
- Le TL-SG108PE (PoE non managé, ~140 €) que j'avais suggéré dans l'audit précédent **ne fait toujours pas de VLAN**
- **Vraie reco 2026** : MikroTik **CRS310-8G+2S+IN** (280 €) → +150 € sur la BoM mais débloque VLAN + 10G futur (NAS, cluster) + monitoring SNMP

**Si Mickael veut PoE intégré** : le MikroTik CRS310 n'a **PAS de PoE**. Il faudrait soit le **CRS328-24P-4S+RM** (24 ports PoE, mais 1U 19", ~430 €), soit garder injecteurs PoE séparés (~15 € × 3 = 45 €).

**Verdict** : **c'est le seul manque que je qualifierais de bloquant à terme**. Une fois les caméras posées, refaire le câblage 1 an plus tard = enfer.

### 2.4. Reverse proxy + SSO interne (Authentik / Authelia / Traefik)

**Pratique 2026** : tous les setups homelab sérieux ont **un seul point d'entrée HTTPS interne** avec **SSO**.

**Stack typique** :
- **Reverse proxy** : Traefik (cloud-native, Docker-aware) ou Caddy (HTTPS auto, simple) ou Nginx Proxy Manager (UI conviviale)
- **SSO/IdP** : Authentik (recommandé 2026, blueprints IaC) ou Authelia (plus simple, 2FA TOTP/WebAuthn)
- **Certificats** : Let's Encrypt via DNS-01 (Cloudflare API)

**Pour le projet** :
- Aujourd'hui : CF Access (côté CF) + auth HA + auth Proxmox + auth Frigate + auth Portainer + ... = **fragmentation**
- Avec SSO : un login unique → accès à toutes les UIs internes (HA, Proxmox, Frigate, Grafana, Vaultwarden, ...)
- **Bénéfice annexe** : audit log centralisé des connexions, MFA enforced partout, désactivation utilisateur en 1 clic

**Architecture recommandée** :

```
Internet
   ▼
Cloudflare Tunnel (déjà en place, à conserver)
   ▼
Traefik (VM Docker Host)
   ▼ proxie auth via Authentik
   ├── ha.might.ovh → HA OS VM
   ├── proxmox.local → Proxmox UI
   ├── frigate.local → VM Frigate
   ├── grafana.local → VM Docker
   └── ... (tout le reste)
```

**Verdict** : pas critique en MVP mais **gros gain de qualité de vie**. À planifier en Phase G.

### 2.5. DNS local — Pi-hole / AdGuard Home

**Pratique 2026** : la quasi-totalité des homelabs ont un DNS local.

**Pour quoi faire** :
- **Adblock réseau-wide** (Pi-hole : 5-10 % de bande passante économisée + meilleur UX surfing)
- **DNS interne** : `proxmox.lan`, `ha.lan`, `nas.lan` au lieu d'IPs
- **Privacy** : DNS-over-HTTPS upstream (Cloudflare 1.1.1.1, Quad9)
- **Logs des requêtes** : voir ce que les caméras IP ou IoT essayent de joindre

**Stack** :
- **Pi-hole** : option historique, UI simple, communauté énorme
- **AdGuard Home** : meilleure UI 2026, support DoH/DoT natif, listes de blocage avancées
- **Unbound** : resolver récursif local (privacy max, pas de fuite à upstream)

**Pour le projet** :
- Un Pi-hole + Unbound dans la VM Docker Host (1 conteneur chacun, ~100 Mo RAM) ne coûte rien
- À configurer comme DNS primaire dans la box Orange
- Bonus : permet de bloquer le phone-home des caméras chinoises sans toucher au routeur

**Verdict** : **petit effort, gros bénéfice**. À ajouter en stack Docker Phase D ou G.

### 2.6. Défense réseau active — CrowdSec et au-dessus

**Constat 2026** : fail2ban reste utile mais **CrowdSec a pris le pas** comme standard homelab.

**Pourquoi CrowdSec** :
- **Crowd-sourced** : chaque instance partage les IPs malveillantes détectées → tu hérites de la défense de milliers d'autres
- **Behavior-based** : pas juste « X tentatives échec login » mais patterns d'attaque (scan de ports, exploit tentatives, etc.)
- **Bouncers** dispos : sur Traefik/Nginx/iptables/Cloudflare → blocage à plusieurs niveaux
- **Dashboard** clair, intégration Grafana, alerting Alertmanager

**Stack défense en profondeur 2026** :
1. **Niveau 1 — Cloudflare** (déjà actif) : règles WAF, country block, rate limiting
2. **Niveau 2 — CrowdSec** (à ajouter) : bouncer Traefik + bouncer iptables Proxmox host
3. **Niveau 3 — Authentik** (Phase G) : MFA enforced sur tous les services
4. **Niveau 4 — Wazuh** (overkill pour homelab perso) : SIEM complet, file integrity monitoring, vulnerability scanning

**Pour le projet** :
- **CrowdSec** : recommandé. Conteneur Docker dans VM Docker Host, ~50 Mo RAM, free
- **Wazuh** : overkill sauf si tu as besoin de compliance (SOC2, GDPR audit) → skip pour l'instant

**Verdict** : ajouter **CrowdSec** dans la stack Docker Phase G.

### 2.7. Voice assistant local Home Assistant — angle nouveau

**Tendance 2026** : Home Assistant pousse fort sur le voice control 100 % local.

**Stack officielle 2026** :
- **HA Voice Preview Edition** (~70 €) : hardware ESP32 dédié, micro 4 capsules, anti-écho, wake word « Nabu »
- **Whisper** (STT) : modèle base/small en local (CPU OK pour une langue, GPU pour multi)
- **Piper** (TTS) : voix neuronale française naturelle, ultra-rapide
- **Assist** (intent) : moteur HA natif, pas besoin de LLM pour les commandes simples

**Hardware au choix** :
- **HA Voice PE** (Apollo Automation, ameriDroid) : 13-70 € selon modèle, plug & play
- **Atom Echo M5Stack** : 13 €, basique mais OK
- **ESP32-S3-BOX** : 50 €, bon compromis

**Pour le projet** :
- **Hors scope** du projet hardware actuel (qui se concentre sur infra)
- Mais **complément naturel** une fois l'infra en place : Whisper et Piper tourneraient idéalement sur la **VM HA OS** (ou conteneur dédié sur VM Docker), GPU non requis pour 1 utilisateur

**Verdict** : à mentionner comme évolution future Phase G+, pas dans la BoM. Mickael l'évoquera quand prêt.

### 2.8. Energy monitoring — Shelly EM / 3EM

**Tendance 2026** : tout homelab sérieux mesure sa conso électrique pour :
- Surveiller le coût des serveurs 24/7
- Détecter les pannes (crash → conso anormale)
- Optimiser (quel service consomme quoi)

**Hardware** :
- **Shelly EM Gen3** (~50 €) : 1 phase, 2 circuits, CT clamps fournis, intégration HA native
- **Shelly 3EM** (~120 €) : 3 phases triphasé, monitoring complet panneau électrique
- **PDU monitorée 10"** (~150-200 €) : par prise, top en mini-rack

**Pour le projet** :
- Une **Shelly EM** sur le circuit du serveur Proxmox + UPS = **50 €** investis pour avoir la conso temps réel dans HA Energy Dashboard
- Permet de mesurer le **vrai TCO** du Proxmox (typique i9 Proxmox + 4 VMs : 80-150 €/an d'élec selon usage)

**Verdict** : petit investissement (~50 €), gros bénéfice analytique. À ajouter en Phase G ou plus tôt.

### 2.9. Backup 3-2-1 — détail Restic vs Borg vs PBS

Je l'avais déjà signalé dans l'audit précédent. Précisions issues du benchmark 2026 :

**Stack idéale** :

| Niveau | Outil | Cible | Fréquence |
|---|---|---|---|
| 1 — Local primaire | **PBS** | Datastore HDD WD Purple | Quotidien (existe déjà BoM) |
| 2 — Local secondaire | **PBS sync** ou **Restic** | HDD externe rotation | Hebdo (à ajouter) |
| 3 — Off-site chiffré | **Restic → Backblaze B2** | Cloud encrypted | Hebdo (~5 €/mois pour 1 To) |

**Comparatif Borg vs Restic** (benchmark 2026) :

| Critère | Borg | Restic |
|---|---|---|
| Vitesse backup | **3× plus rapide** (250 vs 696 CPU sec) | Plus lent |
| Cloud natif | Non (besoin SSH/repo) | **Oui** (S3, B2, OneDrive, GDrive...) |
| Chiffrement | AES-256 | **AES-256 par défaut, obligatoire** |
| Dédup | Buzhash content-defined | Dédup contenu |
| Verdict | Local, fast, single-host | **Cloud-native, multi-host, mainstream** |

**Pour le projet** :
- Garder **PBS** comme backup primaire (déjà BoM)
- Ajouter **Restic** pour push hebdo vers **Backblaze B2** chiffré → 1 To = 5 €/mois
- Backup HDD externe rotation manuelle = bonus

**Verdict** : **3-2-1 strict** = stack PBS + Restic + B2. À provisionner ~60 €/an en Phase G.

### 2.10. Mesh VPN — alternative ou complément CF Tunnel

**Constat 2026** : CF Tunnel est super pour exposer publiquement. Mais pour **accès admin distant**, beaucoup ajoutent un **mesh VPN**.

**Comparatif 2026** :

| Solution | Self-host | Setup | Free tier | Verdict |
|---|---|---|---|---|
| **Tailscale** | Non (control plane SaaS) | Le plus simple | 100 devices, 3 users | Standard pour la plupart |
| **NetBird** | **Oui (full)** | Modéré | Pas de limite si self-host | Souverain, recommandé 2026 |
| **Headscale** | Oui (control plane uniquement) | Avancé | Cohabite avec clients Tailscale | Pour ex-Tailscale qui veulent l'autonomie |
| **WireGuard pur** | Oui | Manuel | Total | Old school, lourd à maintenir |

**Pour le projet** :
- **CF Tunnel** = couvre l'exposition publique (`ha.might.ovh`, `mcp.might.ovh`)
- **Tailscale** ou **NetBird** = couvre l'accès admin distant (Proxmox UI, SSH host, PBS UI, ...) sans rien exposer
- 5 min à setup, 0 € (Tailscale free), gros gain de sécurité

**Verdict** : **complément CF Tunnel, pas remplacement**. Ajouter Tailscale (le plus simple) ou NetBird (plus self-host) en Phase D ou C.

### 2.11. Monitoring + alerting — Grafana + Prometheus + Alertmanager

Déjà mentionné dans le projet (Phase G). Mais **profondeur insuffisante**.

**Stack standard 2026** :
- **Prometheus** : scrape metrics depuis exporters (`node_exporter`, `cadvisor`, `pve_exporter`, `frigate_exporter`, `homeassistant_exporter`)
- **Grafana** : dashboards (templates communautaires Proxmox, HA, Docker)
- **Alertmanager** : routing alertes vers email + Telegram + push HA
- **Loki** (bonus) : centralisation des logs

**Cas d'usage réels** :
- CPU Proxmox > 90 % pendant 5 min → mail
- HDD Frigate > 85 % capacité → notif HA
- VM HA OS down → SMS via Telegram bot
- Backup PBS échec → escalade immédiate

**Pour le projet** :
- Phase G mention juste « Grafana + Prometheus monitoring complet » → **manque Alertmanager** explicitement
- Ajouter `pve_exporter` (Proxmox) et `homeassistant_exporter` (metrics HA → Prometheus)

**Verdict** : préciser la stack Phase G dans `03_Phasage_A_a_G.md`.

### 2.12. Local LLM — Ollama vs vLLM

Mickael utilise déjà Ollama + Hermès. État de l'art 2026 :

| Critère | Ollama | vLLM |
|---|---|---|
| Setup | Très simple (1 commande) | Moyen (Python + CUDA stack) |
| Perf single-user | Bonne | **2-4× supérieure** (PagedAttention) |
| Multi-user concurrent | Limité | **Excellent** |
| Format modèles | GGUF, GGML, safetensors | Safetensors, AWQ, GPTQ |
| Cas d'usage | Homelab solo | Production / multi-utilisateurs |

**Pour le projet** :
- **Ollama suffit** pour Mickael (1 utilisateur, pas de concurrence)
- **vLLM** intéressant **uniquement si** : tu fais tourner Hermès + Cowork + autre service en parallèle qui appellent l'API LLM locale

**Verdict** : **rester sur Ollama**. Mentionner vLLM comme évolution si charge multi-clients un jour.

---

## 3. Synthèse — manques classés par valeur ajoutée

### 🔴 Vrai manque, à arbitrer avant commande

**M1 — Switch non managé, VLAN impossible**
- Notre BoM a un `TL-SG108-M2` non managé
- VLAN caméras IP = best practice 2026 incontournable
- Refonte plus tard = recâblage complet
- **Reco** : remplacer par MikroTik **CRS310-8G+2S+IN** (~280 € au lieu de 130 € → +150 €) OU TP-Link **TL-SG3210XHP-M2** (~280 €) si PoE intégré préféré

### 🟠 Manques significatifs, à planifier (mais pas bloquant achat)

**M2 — Pas de NAS dédié pour stockage vidéo Frigate**
- À terme avec 5-6 caméras 4K, tenir tout sur HDD direct dans Proxmox = limite
- **Reco** : à provisionner Phase G+ (Synology DS224+ ~330 € + 2× HDD 8 To ~400 €) OU TrueNAS VM avec passthrough disque (gratuit)

**M3 — Pas de reverse proxy interne + SSO**
- Aujourd'hui auth fragmentée HA + Proxmox + Frigate + ...
- **Reco** : Traefik + Authentik sur VM Docker Host Phase G (gratuit, ~30 min à setup une fois compris)

**M4 — Pas de DNS local (Pi-hole/AdGuard)**
- Adblock + privacy + visibilité requêtes IoT
- **Reco** : Pi-hole + Unbound dans VM Docker Phase D (gratuit, ~15 min)

**M5 — Pas de défense locale active (CrowdSec)**
- CF Access côté CDN + rien côté serveur
- **Reco** : CrowdSec dans VM Docker + bouncers Phase G (gratuit, fort retour)

**M6 — Backup hors-site partiel**
- PBS local + OneDrive ad hoc HA, pas de stratégie globale
- **Reco** : Restic → Backblaze B2 chiffré, ~5 €/mois pour 1 To

### 🟡 Évolutions à considérer, pas urgent

**M7 — Energy monitoring du serveur (Shelly EM ~50 €)**
- Visibilité conso 24/7 dans HA Energy Dashboard

**M8 — Mesh VPN admin (Tailscale free ou NetBird self-host)**
- Accès admin distant sans rien exposer

**M9 — Mini-rack 10" + PDU + patch panel** (~250-400 € total)
- Modularité, propreté, futur cluster
- Tendance forte 2026 (Jeff Geerling Project Mini Rack)

**M10 — Voice assistant local HA Voice PE** (~70 €)
- Évolution naturelle post-MVP

### 🟢 Couvert ou non pertinent pour Mickael

- **HA Voice PE** : hors scope, à voir post-projet
- **vLLM** : Ollama suffit pour usage solo
- **Wazuh SIEM** : overkill homelab perso
- **Headscale / WireGuard pur** : Tailscale ou NetBird suffisent
- **Kubernetes / K3s / Talos** : Docker Compose suffit, pas de besoin d'orchestration complexe

---

## 4. Proposition d'enrichissement BoM (à arbitrer)

### Variante « Pro 2026 » (BoM + ~280 €)

| Ajout | Prix | Bénéfice |
|---|---|---|
| Switch MikroTik CRS310-8G+2S+IN (au lieu de TL-SG108-M2) | +150 € (de 130 → 280) | VLAN + 10G futur |
| Mini-rack 10" 12U alu | +120 € | Modularité, propreté |
| Shelly EM Gen3 + CT clamps | +50 € | Energy monitoring HA |
| Tailscale ou NetBird (logiciel) | 0 € | Mesh VPN admin |
| Pi-hole + Restic + CrowdSec + Authentik (logiciel) | 0 € | Stack défense + qualité de vie |
| Backblaze B2 (1 To) | ~60 €/an | 3-2-1 cloud chiffré |
| **Sous-total ajouts hardware** | **~+320 €** | |

**Total revisé** : 2410 + 320 = **~2730 €** (au lieu de 2500 € budget initial)

### Variante « Hardcore enthusiast » (BoM + ~700 €)

Tout ce qui précède + :

| Ajout | Prix | Bénéfice |
|---|---|---|
| Synology DS224+ + 2× HDD 8 To miroir | +730 € | NAS dédié, vidéo isolée, snapshots ZFS |
| Carte AP9631 SmartSlot SMT2200IC | +250 € | Monitoring SNMP onduleur indépendant |

➡️ Hors budget ~2500 €, à étaler sur Phase G+ et trimestre suivant si Mickael veut viser le haut du panier.

### Variante « Minimal défense » (BoM + ~50 €)

Compromis si on veut juste lever les points de sécurité critiques sans gonfler le budget :
- **Switch managé d'entrée** : TP-Link TL-SG108E v6 (40 €) au lieu du TL-SG108-M2 (130 €) → -90 €, mais pas de 2.5G
- **Stack logicielle gratuite** : Pi-hole + CrowdSec + Tailscale + Restic
- **Énergie** : Shelly EM (+50 €)

Total : 2410 - 90 + 50 = **~2370 €** (économie 40 € avec gains majeurs sur la sécu, mais on perd le 2.5G)

➡️ **Pas recommandé** : sacrifier 2.5G sur 5-6 ans pour 90 € est un mauvais deal.

---

## 5. Mon avis

**Le manque le plus important** dans le projet actuel est **le switch managé**. Ce n'est pas un détail : sans VLAN, les caméras IP partagent le LAN avec ton PC, ton HA, ton Proxmox. Une caméra Reolink/Dahua compromise = pivot complet vers tout le reste. C'est documenté en best practice 2026 partout.

**Les autres manques** sont des « évolutions Phase G » qui ne bloquent pas l'achat mais que tu vas mettre en place plus tard de toute façon. Mieux vaut les anticiper dans le plan que les redécouvrir.

**Ce qui est cohérent et bien dimensionné** dans la BoM actuelle :
- Le tower Define 7 + Ryzen 7950X (ou 7900X variante 2)
- L'i9-9900K + Proxmox + RAM upgrade
- Le HDD WD Purple 8 To (pour MVP, pas critique d'avoir un NAS dédié day-1)
- PBS local + onduleurs

**Ma reco synthétique** :

1. **Acheter le switch managé MikroTik CRS310** (+150 €) → débloque tout le reste
2. **Provisionner ~60 €/an** pour Backblaze B2 (3-2-1 strict)
3. **Phase G** : ajouter Pi-hole + CrowdSec + Authentik + Tailscale (gratuit, ~2-3h de setup au total)
4. **Phase Future** : NAS Synology si caméras > 5 ou si tu veux séparer compute/storage proprement
5. **Mini-rack 10"** : si tu veux la version « belle », +120 € pour un truc propre et évolutif

Bottom line : **+150 € sur la BoM (switch managé) débloque 90 % de la valeur**. Le reste est software gratuit + petits achats étalés.

---

## 6. Sources consultées

### Setups & architectures

- [Ultimate Home Lab Starter Stack for 2026 — Virtualization Howto](https://www.virtualizationhowto.com/2025/12/ultimate-home-lab-starter-stack-for-2026-key-recommendations/)
- [Best Server for Home Lab 2026 — Edy Werder](https://edywerder.ch/best-server-for-home-lab/)
- [Best Proxmox Homelab Build 2026 — cr0x.net](https://cr0x.net/en/best-proxmox-homelab-build/)
- [My HomeLab Setup in 2026 — Danb Blog](https://danb.me/blog/2026-homelab/)
- [What I'm Running in My Homelab in 2026 — Techno Tim](https://technotim.com/posts/homelab-services-tour-2026/)
- [State of Homelab 2026](https://mrlokans.work/posts/state-of-homelab-2026/)
- [The 2026 Homelab Stack — elest.io](https://blog.elest.io/the-2026-homelab-stack-what-self-hosters-are-actually-running-this-year/)
- [What's in my HomeLab 2026 — Roman Zipp](https://romanzipp.com/blog/whats-in-my-homelab-2026)

### Mini-rack 10"

- [Project Mini Rack — Jeff Geerling](https://mini-rack.jeffgeerling.com/)
- [Inside My Mini Rack Proxmox and Kubernetes Home Lab 2026 — Virtualization Howto](https://www.virtualizationhowto.com/2026/01/inside-my-mini-rack-proxmox-and-kubernetes-home-lab-for-2026/)
- [I Bought a 10 Inch Home Lab Rack for 2026 — Virtualization Howto](https://www.virtualizationhowto.com/2026/01/i-bought-a-10-inch-home-lab-rack-for-2026-and-it-surprised-me/)

### Frigate + NAS

- [Frigate official docs — Installation](https://docs.frigate.video/frigate/installation/)
- [HA Network Storage — Frigate docs](https://docs.frigate.video/guides/ha_network_storage/)
- [How I self-host Frigate on my NAS — XDA](https://www.xda-developers.com/self-host-frigate-on-nas/)
- [HA Frigate NVR Setup Guide 2026 — HomeShift](https://joinhomeshift.com/home-assistant-frigate)

### VLAN & sécurité réseau

- [VLAN for Home Network 2026 — JazzCyberShield](https://blog.jazzcybershield.com/vlan-for-home-network-2026/)
- [Network Segmentation Best Practices 2026 — Calmops](https://calmops.com/network/network-segmentation-vlan-best-practices/)
- [Home Network VLANs Isolate IoT — State of Surveillance](https://stateofsurveillance.org/guides/advanced/home-network-vlans-segmentation/)

### Reverse proxy & SSO

- [Authentik Self-Hosted SSO — ANTLATT](https://www.antlatt.com/blog/authentik-self-hosted-sso/)
- [Authelia SSO 2FA — HomeLab Starter](https://homelabstarter.com/homelab-authelia-sso/)
- [Homelab 2026 Self-Hosted on Proxmox — qtekfun GitHub](https://github.com/qtekfun/homelab-2026)

### Sécurité

- [The Agentic Shift Fail2Ban CrowdSec Wazuh 2026 — DoHost](https://dohost.us/index.php/2026/03/05/the-agentic-shift-comparing-fail2ban-with-crowdsec-and-wazuh-in-2026/)
- [Homelab Security Guide 2026 — corelab.tech](https://corelab.tech/digital-castle-swag-crowdsec-authelia/)
- [Networking & Cybersecurity Roadmap 2026 — corelab.tech](https://corelab.tech/cybersecroadmap/)
- [Wazuh Homelab Security GitHub — BeardedTinker](https://github.com/BeardedTinker/wazuh-homelab-security)

### Monitoring

- [Grafana & Prometheus Complete Guide 2026 — AiCybr](https://aicybr.com/blog/grafana-prometheus-complete-guide)
- [Infrastructure Monitoring Prometheus Grafana 2026 — Hostperl](https://hostperl.com/blog/infrastructure-monitoring-prometheus-grafana-production-observability-2026)

### Voice assistant local

- [HA Voice Preview Edition](https://www.home-assistant.io/voice-pe/)
- [Self-Hosted Voice Assistant with HA 2026 — Kunal Ganglani](https://www.kunalganglani.com/blog/self-hosted-voice-assistant-home-assistant-2026-guide)

### Energy monitoring

- [HA Energy Monitoring — HomeLab Starter](https://homelabstarter.com/home-assistant-energy-monitoring/)
- [Top 10 Shelly Smart Home Devices Spring 2026](https://us.shelly.com/pages/top-10-shelly-smart-home-devices-for-spring-2026)
- [Best Energy Meters for HA — SmartHomeScene](https://smarthomescene.com/top-picks/best-energy-meters-for-home-assistant/)

### Backup

- [Backup-Strategie Homelab — Homelab Guide DE](https://homelab-guide.de/tutorials/backup-strategie-homelab/)
- [Best Linux Backup Software 2026 — Shell & Coin](https://cavecreekcoffee.com/reviews/best-linux-backup-software-2026/)
- [Borg vs Restic — Remote Backups](https://remote-backups.com/blog/borg-vs-restic)
- [Self-Hosted Backup 2026 — SelfHostWise](https://selfhostwise.com/posts/self-hosted-backup-solutions-in-2026-duplicati-restic-borg-compared/)

### Mesh VPN

- [Tailscale vs NetBird vs Headscale 2026 — PkgPulse](https://www.pkgpulse.com/blog/tailscale-vs-netbird-vs-headscale-mesh-vpn-2026)
- [NetBird vs Tailscale — wz-it](https://wz-it.com/en/blog/netbird-vs-tailscale-comparison/)
- [Tailscale alternatives 2026 — Pinggy](https://pinggy.io/blog/top_open_source_tailscale_alternatives/)

### Local LLM

- [Best Local LLM Setup on a Single RTX 3090 — Code Coup Medium](https://medium.com/coding-nexus/the-best-local-llm-setup-on-a-single-rtx-3090-aa8aa07f73e4)
- [Local LLM 24GB GPU Optimizations — IntuitionLabs](https://intuitionlabs.ai/articles/local-llm-deployment-24gb-gpu-optimization)
- [Best GPUs for Local LLM Inference April 2026 — corelab](https://corelab.tech/llmgpu/)
- [Multi-GPU LLM Setup 2026 — Compute Market](https://www.compute-market.com/blog/multi-gpu-local-llm-setup-guide-2026)

---

## 7. Garde-fous appliqués pendant cet audit

- Aucune modification des 8 fichiers existants du projet (lecture seule)
- Aucune modification hors `Hardware_Upgrade/Documentation/`
- Aucune commande matériel proposée (juste arbitrages)
- Aucune suppression
- Aucune nouvelle auto-memory créée
- Aucun TASKS.md / METRIQUES.md / CLAUDE.md touché

---

*Fin de Benchmark_Setups_Avances_2026_S67.md — version 1.0 — 27 avril 2026.*
