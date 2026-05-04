---
id: 99
title: "Système meta-skills manuel-* (9 apps + INDEX) — pattern standardisé pour navigation/références/procédures"
status: open
priority: P1
session_opened: S109
tags: [skills, meta, manuel, navigation, references, procedures, ui, fr-en, anti-recidive]
source: "Session 109 / Demande Mickael après erreur navigation CF (Settings → Service Auth inexistant, vrai chemin Contrôles Access → Identifiants du service). Renfort S111 : 3 errances supplémentaires sur navigation CF Zero Trust pendant T#100 Phases 6+7."
---

# T#99 — Système meta-skills `manuel-*`

## Contexte / Pourquoi

Erreur S109 : j'ai guidé Mickael vers "Settings → Service Auth → Service Tokens" dans CF Zero Trust alors que le vrai chemin 2026 est "Contrôles Access → Identifiants du service". Mickael a perdu du temps. Cause : pas de skill consolidée pour la navigation CF UI à jour.

Aujourd'hui les références UI sont éparpillées en `memory/reference_*.md` et `memory/feedback_*.md`. Pas de pattern unifié.

## Objectif

Créer un système meta-skills "manuel d'application" qui pour chaque outil/app du daily Mickael regroupe sous une structure standardisée :
- **Menu/index** principal pointant vers sous-fichiers `.md`
- **Glossaire FR ↔ EN** des libellés UI
- **Navigation UI** (chemins exacts, "où cliquer pour faire X")
- **Procédures courantes** (créer token, ajouter filtre, proxy, clé API, etc.)
- **Pièges à éviter** (capitalisés en sessions)
- **Raccourcis claviers + URLs directes**
- **Tutoriels / guides / docs officielles + non-officielles si utile**

Quand Jarvis doit guider Mickael sur une app, il lit la skill `manuel-<app>` AVANT de donner les instructions → plus d'erreur de chemin / libellé.

## Pattern structure standardisée

```
.claude/skills/manuel-<app>/
├── SKILL.md                    (déclencheurs : nom app + variantes courantes)
└── references/
    ├── menu.md                 (table des matières + liens vers les autres .md)
    ├── glossaire-fr-en.md      (Service Tokens = Identifiants du service, Add-ons = Apps, etc.)
    ├── navigation-ui.md        (sidebar, menus, chemins en représentation texte ASCII)
    ├── pieges.md               (anti-patterns, erreurs fréquentes, mitigations)
    ├── raccourcis.md           (clavier + URLs directes)
    └── procedures/
        ├── procedure-1.md
        ├── procedure-2.md
        └── ...
```

## Représentation des écrans en texte (pas de screenshots)

Pas de PNG. Les écrans sont décrits en **markdown ASCII/wireframe** :

```
Sidebar gauche (déroulée "Contrôles Access") :
├── Vue d'ensemble
├── Applications
├── Stratégies
├── Identifiants du service       ← Service Tokens
└── Paramètres Access

Page "Vos applications" (3 sur 3) :
┌────────┬─────────────────┬───────┬──────────┐
│ Nom    │ URL             │ Strat │ Type     │
├────────┼─────────────────┼───────┼──────────┤
│ mcp    │ mcp.might.ovh   │ 1     │ Auto-héb │
└────────┴─────────────────┴───────┴──────────┘
```

Avantages : ~500 bytes vs 200-500 KB par PNG, recherchable `grep`, versionnable Git proprement.

## Pas de versioning UI auto

Pas de check de date `ui_check`. Mickael signale ou envoie une capture si l'UI a changé → mode "patch UI" met à jour le fichier `.md` correspondant.

## Mode "patch UI"

Commande type "le menu Service Tokens est passé de X à Y" → met à jour le fichier `.md` correspondant. Évite la doc périmée.

## Promotion auto-memories existants

Les `feedback_*` et `reference_*` Cowork persistante OU `memory/*.md` projet qui décrivent une app sont absorbés par la skill `manuel-<app>` correspondante (consolidation). Anciens fichiers conservés en pointeur "voir manuel-X" ou supprimés selon pertinence.

## Skill méta `manuel-INDEX`

Skill annuaire qui liste TOUS les `manuel-*` disponibles avec leur périmètre. S'auto-déclenche au début d'une tâche impliquant un outil non immédiatement reconnu. Évite que Jarvis rate une skill existante.

## Liste prioritaire — 9 manuels + 1 méta

| # | Skill | Priorité | Couvre |
|---|-------|----------|--------|
| 1 | `manuel-cloudflare` | 🔥 P1 | CF Zero Trust, Tunnels, DNS, WAF, Service Tokens, IP allowlist, rate limiting |
| 2 | `manuel-home-assistant` | P1 | HA UI 2026 (Settings, Apps, Lovelace, Devs, Logs), addons, intégrations, automations YAML |
| 3 | `manuel-claude-cli` | P2 | `claude mcp *`, slash commands, options, scopes (project/user/local), `~/.claude.json` |
| 4 | `manuel-cowork-desktop` | P2 | UI Cowork, paramètres, connecteurs, capacités, limites (no stdio, no headers HTTP custom) |
| 5 | `manuel-hermes-agent` | P2 | TUI Hermès, `~/.hermes/config.yaml`, Modelfile durci, MCP servers, tool calling |
| 6 | `manuel-powershell` | P3 | Patterns Windows (sed manquant, BOM UTF-8, encoding, `${env:VAR}`, Invoke-WebRequest) |
| 7 | `manuel-ubuntu-wsl2` | P3 | sed, grep, find, tar, perms NTFS↔WSL, mount /mnt/d, `wsl bash -c` quoting |
| 8 | `manuel-windows` | P3 | Explorer, Settings, Task Manager, Variables d'env User/System, Services, Registre, schtasks |
| 9 | `manuel-claude-desktop` | P3 | UI claude.ai web fallback (mode chat sans Cowork), Knowledge .md, Description projet |
| ★ | `manuel-INDEX` | P1 | Méta-annuaire de tous les manuels disponibles |

## Roadmap implémentation

**Phase 1 (à chaud post-rotation T#100)** :
- Créer `manuel-cloudflare` avec procédures issues de la session S109 (créer Service Token, IP allowlist, rate limiting, tunnel)
- Créer `manuel-INDEX` minimal pointant sur `manuel-cloudflare`

**Phase 2** :
- Créer `manuel-home-assistant` (consolidation de `reference_ha_ui_naming.md` + `reference_ha_sidebar_tools.md` + `reference_lovelace_patterns.md` + skills HA spécifiques)
- Créer `manuel-claude-cli` (capitaliser apprentissages S109 — `claude mcp get/list/add/reset-project-choices`, scopes, limitation `${env:VAR}` headers HTTP)
- Créer `manuel-cowork-desktop`

**Phase 3** :
- Créer `manuel-hermes-agent` (consolidation Cookbook RTX3090 + skill `benchmark-modele-hermes`)
- Créer `manuel-powershell`
- Créer `manuel-ubuntu-wsl2`
- Créer `manuel-windows`
- Créer `manuel-claude-desktop`
- Enrichir `manuel-INDEX` avec tous les nouveaux

## Livrables attendus

- (a) Template `SKILL.md` réutilisable + structure `references/` standardisée
- (b) 9 skills `manuel-*` créées selon la priorité (P1 d'abord)
- (c) Skill méta `manuel-INDEX` opérationnelle
- (d) Mode "patch UI" documenté (commande slash ou skill dédiée)
- (e) Promotion des `reference_*` / `feedback_*` éparpillés vers les `manuel-*` (consolidation)
- (f) MAJ `memory/SKILLS_INDEX.md` (passage de 32 skills à ~42 skills)
- (g) MAJ `CLAUDE.md` §5 avec mention système meta-skills

## Liens

- Anti-récidive : [`memory/feedback_alerter_avant_commandes_revelant_secrets.md`](../memory/feedback_alerter_avant_commandes_revelant_secrets.md) (auto-memory Cowork S109)
- Référence existante CF Access : [`.claude/skills/cloudflare-access-ha/SKILL.md`](../.claude/skills/cloudflare-access-ha/SKILL.md) (à absorber dans `manuel-cloudflare`)
- Apprentissages S109 (à capitaliser) : récit session à venir + leak Service Token + limitation `${env:VAR}` CLI claude
- Tâche dépendante : T#100 (rotation Service Token avant phase 1) — ✅ clôturée S111

---

## Renfort S111 (4 mai 2026, T#100 Phases 6+7) — promotion P2 → P1

Pendant T#100 Phases 6+7, **3 nouvelles errances de navigation CF Zero Trust** ont coûté ~10 min cumulés à Mickael :

1. **Étape 5** : guidage initial vers "Identifiants du service" sans préciser le chemin → Mickael "je sais plus où on a accès à ce menu".
2. **Réponse erronée** : "Paramètres (engrenage) → Authentification → Jetons de service" → Mickael atterrit sur la page **Stratégies** (mauvais menu).
3. **Vrai chemin trouvé via screenshot** : **`Contrôles Access → Identifiants du service`** (sidebar gauche, pas Paramètres).

Mickael a explicitement demandé pendant la session : *« faudra penser a faire les skill menu on voit l'utilité ;) »*.

### Apprentissages capitalisables pour `manuel-cloudflare` Phase 1

Chemins UI 2026 confirmés par screenshot S111 :

```
Sidebar CF Zero Trust (déroulé) :
├── Vue d'ensemble
├── Insights
├── Équipe et ressources
├── Réseaux
│   ├── Vue d'ensemble
│   ├── Connecteurs
│   ├── Routes
│   └── Résolveurs et Proxys
├── Contrôles Access            ← section rotation Service Tokens
│   ├── Vue d'ensemble
│   ├── Applications            ← édition policy par app
│   ├── Stratégies              ← liste des policies réutilisables (PAS les tokens !)
│   ├── Contrôles IA (Bêta)
│   ├── Destinations
│   ├── Identifiants du service ← Service Tokens (création/rotation/suppression)
│   └── Paramètres Access
├── Stratégies de trafic
│   ├── Vue d'ensemble
│   ├── Stratégies de pare-feu
│   ├── Stratégies de pr… (Nouveau)
│   ├── Stratégies de sortie
│   └── Paramètres du trafic
├── Observations Cloud et SaaS
├── Sécurité des e-mails
├── Protection contre la perte de…
├── Isolation du navigateur
├── Composants réutilisables
└── Intégrations
```

Procédure rotation Service Token (issue T#100 S110+S111, 7 phases) à capitaliser dans `manuel-cloudflare/procedures/rotation-service-token.md`.

Pièges identifiés à capitaliser dans `manuel-cloudflare/pieges.md` :
- Suppression d'un Service Token bloquée tant qu'une stratégie le référence → erreur "références existantes" → **fix** : aller dans Contrôles Access → Stratégies → ouvrir la policy SERVICE AUTH → retirer l'ancien token de la liste Inclure → Save.
- Pendant rotation, garder les **deux tokens** dans la policy Inclure (mode OU) pour transition smooth, ne retirer le v1 qu'après validation v2 bout-en-bout.
- Bandeau orange "dégradation services Access" en haut de page CF → vérifier [https://www.cloudflarestatus.com/](https://www.cloudflarestatus.com/) avant de diagnostiquer un échec UI.
- L'option **Pivoter** (rotation in-place) existe à côté de Supprimer, mais garde une entrée orpheline → préférer Supprimer après cleanup référence.

### Bascule priorité P2 → P1

Pré-requis "post-rotation T#100" levé : T#100 close S111. Phase 1 (`manuel-cloudflare` + `manuel-INDEX` minimal) doit démarrer dès la prochaine session disponible. P1 reflète l'urgence (anti-récidive forte sur les rotations Service Tokens semestrielles).
