# Plan d'action — Audit Sécurité S66

**Compagnon de** : `Rapport_Audit_S65.md`
**Créé** : 2026-04-27 (session 66)
**Dernière mise à jour** : 2026-04-27

> Note : le dossier porte "S65" dans son nom car créé en référence à la dernière session connue, mais cet audit a été réalisé en **session 66**. Pas de renommage pour ne pas casser les liens.

## État du projet

🟦 **OUVERT** — En attente de session dédiée à la remédiation.

| Tâche TASKS.md | Catégorie | Statut |
|---|---|--------|
| T#79 | 🔴 P0 person.mqtt local_only | À faire |
| T#80 | 🔴 P1 ngrok désinstallation | À faire |
| T#81 | 🔴 P1 SSH clé ed25519 | À faire |
| T#82 | 🔴 P1 ZeroTier désinstallation | À faire |
| T#83 | 👤 P0 Audit users + MFA + LLATs | À faire |
| T#84 | 👤 P1 CF Access policies + country block | À faire |
| T#85 | 👤 P2 Audit secrets.yaml + grep config | À faire |
| T#86 | 👤 P2 Cap budget OpenAI | À faire |
| T#87 | 👤 P2 ip_bans.yaml état | À faire |
| T#88 | 👤 P3 Rotation secret_path ha-mcp | À faire |
| T#89 | 🟠 P2 Décider enable_tool_search ha-mcp | À faire |
| T#90 | 🟠 P2 Frigate state=error | À faire |
| T#91 | 🟠 P2 Désinstaller Get HACS | À faire |
| T#92 | 🟠 P2 Migrer/supprimer cards HACS abandonnées | À faire |
| T#93 | 🟡 P3 HomeKit port 21063 | À faire |
| T#94 | 🟡 P3 Désinstaller Log Viewer | À faire |

## Checklist actionnable (ordre recommandé)

### Phase 1 — Quick wins UI (15 min)

- [ ] **T#79** Settings → Personnes & zones → Utilisateurs → `mqtt` → cocher "Local only"
- [ ] **T#83a** Profil → Sécurité → vérifier MFA TOTP actif sur compte Mickael
- [ ] **T#83b** Profil → Sécurité → Long-lived access tokens → lister + révoquer obsolètes

### Phase 2 — Nettoyage add-ons (15 min)

- [ ] **T#80** Settings → Add-ons → ngrok → Désinstaller (ou révoquer token sur ngrok.com)
- [ ] **T#82** Settings → Add-ons → ZeroTier One → Désinstaller (sauf si encore utilisé)
- [ ] **T#91** Settings → Add-ons → Get HACS → Désinstaller (one-shot, déjà servi)
- [ ] **T#94** Settings → Add-ons → Log Viewer → Désinstaller si non utilisé

### Phase 3 — SSH durci (30 min)

- [ ] **T#81** Générer paire clé ed25519 sur PC : `ssh-keygen -t ed25519 -C "mickael@PC-Might-1000D"`
- [ ] Copier la **clé publique** dans Settings → Add-ons → Terminal & SSH → Configuration → `authorized_keys`
- [ ] **Vider** le champ `password` (le rendre vide ne désactive pas l'auth web ingress, juste le SSH par mot de passe)
- [ ] Tester depuis PC : `ssh -i ~/.ssh/id_ed25519 root@192.168.1.11 -p 22`
- [ ] Restart add-on Terminal & SSH

### Phase 4 — Cloudflare Access (15 min)

- [ ] **T#84a** dash.cloudflare.com → Zero Trust → Access → Applications → vérifier app sur `ha.might.ovh` active
- [ ] **T#84b** Vérifier policy : Allow + MFA Cloudflare + Country block (FR uniquement recommandé)
- [ ] **T#84c** Vérifier policy bypass `mcp.might.ovh` toujours OK (S25)
- [ ] **T#84d** Logs Access derniers 7j → tentatives échouées suspectes ?
- [ ] dash.cloudflare.com → Zero Trust → Networks → Tunnels → vérifier tunnel cloudflared healthy

### Phase 5 — Audit secrets côté HA (45 min)

- [ ] **T#85a** File editor → ouvrir `/config/secrets.yaml` → inventorier les `!secret`
- [ ] **T#85b** File editor → grep visuel sur `password|token|api_key|http://|curl ` dans `configuration.yaml`, `automations.yaml`, `scripts.yaml`
- [ ] **T#87** File editor → ouvrir `/config/ip_bans.yaml` → analyser provenance + nombre

### Phase 6 — Préventif coûts (15 min)

- [ ] **T#86a** platform.openai.com → Usage → vérifier consommation mois en cours
- [ ] **T#86b** platform.openai.com → Limits → confirmer cap budget mensuel actif (sinon le mettre)
- [ ] **T#86c** Vérifier que la clé HA est dédiée (pas une clé personnelle réutilisée)

### Phase 7 — Décisions Hermès / Frigate (30 min)

- [ ] **T#89** Décider du toggle `enable_tool_search` côté add-on ha-mcp (ON pour Hermès, OFF pour Cowork natif)
- [ ] **T#90** Frigate (Full Access) en error chronique → réparer (logs supervisor) ou désinstaller

### Phase 8 — Cosmétique (30 min)

- [ ] **T#92a** `ha_deep_search` côté Lovelace pour repérer où sont utilisées bar-card et simple-thermostat
- [ ] **T#92b** Migrer vers mini-graph-card / template-thermostat
- [ ] **T#92c** HACS → désinstaller bar-card + simple-thermostat
- [ ] **T#93** Settings → Intégrations → HomeKit → reconfigurer port 21063 (ou autre libre)
- [ ] **T#88** Si rotation `secret_path` ha-mcp décidée → suivre `reference_ha_mcp_secret_regeneration.md`

## Effort total estimé

| Phase | Effort | Cumulé |
|------|--------|--------|
| 1 — Quick wins UI | 15 min | 15 min |
| 2 — Nettoyage add-ons | 15 min | 30 min |
| 3 — SSH durci | 30 min | 1h00 |
| 4 — Cloudflare Access | 15 min | 1h15 |
| 5 — Audit secrets HA | 45 min | 2h00 |
| 6 — Préventif coûts | 15 min | 2h15 |
| 7 — Hermès / Frigate | 30 min | 2h45 |
| 8 — Cosmétique | 30 min | 3h15 |

**Total = ~3h15** étalable sur 2-3 sessions.

## Comment reprendre la conversation plus tard

Phrase d'amorce type :

> *"Jarvis, on reprend l'audit sécu HA. Lis `Projets/Audit_Securite_S65_2026-04-27/Rapport_Audit_S65.md` et `Plan_Action.md` puis on attaque la Phase X."*

Documents à charger :
1. `Projets/Audit_Securite_S65_2026-04-27/Rapport_Audit_S65.md` — rapport complet
2. `Projets/Audit_Securite_S65_2026-04-27/Plan_Action.md` — ce fichier
3. `memory/historique/2026-04-27_session_66_audit_securite.md` — archive session 66
4. `memory/project_audit_securite_s66.md` — auto-memory avec contexte rapide

Tâches dans `TASKS.md` : section "Audit Sécurité S66" (T#79 à T#94).

---

*Fin du Plan d'action — version 1.0 — 27 avril 2026*
