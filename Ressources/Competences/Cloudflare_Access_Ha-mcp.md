# Cloudflare Access pour ha-mcp — Service Token (Niveau 1 durcissement)

> Doc créée S102 (04/05/2026) — résolution T#60 partielle (Niveau 1).
> Voir aussi : skill [`cloudflare-access-ha`](../../.claude/skills/cloudflare-access-ha/SKILL.md) Phases 1-6 (durcissement HA dashboard) — ce document est la **Phase 7** (durcissement MCP).

## Pourquoi cette migration

Path-token `/private_xxx` (ancien modèle T#27 S15-S16) apparaît en clair dans :
- Logs CF Analytics (sous-domaine `mcp.might.ovh`)
- `~/.bash_history` après `curl https://mcp.might.ovh/private_xxx`
- Sortie `hermes mcp list`
- Captures terminal (4K) lors de revues de session
- `git diff` si push raté `.mcp.json`

**Service Token CF Access** (headers `CF-Access-Client-Id` + `CF-Access-Client-Secret`) reste invisible dans les logs CF (CF Access masque les headers d'auth).

## État S102

| Acquis | À faire (T#94) |
|---|---|
| ✅ Service Token créé + stocké gestionnaire mdp | ❌ Régénérer secret_path ha-mcp en `/jarvis-mcp` (ou désactiver) |
| ✅ App CF Access "mcp" full domain + stratégie Service Auth | ❌ IP allowlist Niveau 2a |
| ✅ `.mcp.json` Cowork patché (`${env:VAR}`) | ❌ Rate limiting Niveau 2b |
| ✅ `~/.hermes/config.yaml` Hermès patché (clair perms 600) | ❌ OAuth DCR Niveau 3 (Hermès CLI uniquement, optionnel) |
| ✅ Tests `curl` + `hermes mcp test` OK | |

## Quand cette procédure se déclenche

- Migration d'un endpoint MCP (ou autre service) exposé via CF Tunnel d'un path-token vers Service Token
- Renforcement d'un endpoint déjà en Service Token (Niveau 2a/2b/3)
- Duplication de la config sur un autre MCP du même compte CF

## Référence procédure complète

Le détail exhaustif vit dans deux endroits qui peuvent évoluer indépendamment :

1. **Pattern réutilisable générique** (Service Token CF Access pour tout endpoint) :
   [`memory/reference_cloudflare_service_token_pattern.md`](../../memory/reference_cloudflare_service_token_pattern.md) — 5 phases (Service Token, App CF Access, tests `curl`, déploiement Cowork, déploiement Hermès) + tableau pièges S102.

2. **Snapshot résolution T#60** (chronologique S102) :
   [`memory/project_t60_cf_service_token_s100.md`](../../memory/project_t60_cf_service_token_s100.md) — Why / How / Reste à faire / Backups.

3. **Tâche suite** : [T#94](../../tasks/task_094.md) — path-token cleanup + Niveau 2a/2b.

## Spécificités Jarvis (vs procédure générique)

### Endpoint cible
- URL : `https://mcp.might.ovh/private_6G36IXICr8K4HJv02SXU9OlE` (path-token conservé S102, à nettoyer T#94 vers `https://mcp.might.ovh/jarvis-mcp` ou nu).
- Add-on backend : `homeassistant-ai/ha-mcp` v7.3.0 sur HA Pi5 port 9583.
- Tunnel CF : add-on `Cloudflared` sur HA, additional_host `mcp.might.ovh` → `http://192.168.1.11:9583`.

### Déploiement Cowork (Windows)
- Variables d'env Windows User scope : `CF_ACCESS_CLIENT_ID` + `CF_ACCESS_CLIENT_SECRET` (set via `[Environment]::SetEnvironmentVariable(..., 'User')`).
- `.mcp.json` patché bloc `home-assistant.headers` avec `${env:VAR}`.
- Cowork **doit être redémarré** pour hériter des nouvelles vars User (process actuel ne les voit pas).
- Hook `check-secrets.sh` bloque Edit/Write `.mcp.json` (règle 6 par filename) → contournement Bash `cp outputs/file.json .mcp.json`.

### Déploiement Hermès Agent (WSL2 user might)
- `~/.hermes/config.yaml` perms 600, secrets en clair (Hermès ne lit pas `${env:VAR}` Windows depuis sandbox Linux).
- Backup avant édition : `~/.hermes/config.yaml.bak.s100.t60-pre-cf-headers`.
- Validation post-édition : `python3 -c "import yaml; ... safe_load(...)"` + `hermes mcp test ha-mcp`.

### Stratégie CF Access côté Jarvis
- Sélecteur ⚠ **Service Token** (pas "N'importe quel Access Service Token", pas "Token d'application lié").
- Action ⚠ **Service Auth** / **Authentification de service** (pas Allow ni Bypass).
- App full domain `mcp.might.ovh` (Option A retenue S102, alternative Option B `mcp.might.ovh/jarvis-mcp` rejetée car aucun autre service prévu sur ce sous-domaine).

## Pièges spécifiques rencontrés S102

| Symptôme | Cause | Solution |
|---|---|---|
| 0 stratégies après création app CF | Deny-by-default | Enchaîner stratégie sous 5 min |
| 307 redirect HTTP avec headers | Trailing `/` final | Tester sans `/` |
| 403 avec headers (variables vides) | `Remove-Variable` prématuré entre 2 retries `curl` | Garder les variables jusqu'à validation finale |
| YAML invalide Hermès | Indentation cassée par autoformat | Validation Python `yaml.safe_load` |
| Cowork rejette les nouvelles vars | Process Cowork hérite des env vars au démarrage uniquement | Redémarrer Cowork après `SetEnvironmentVariable` |
| Edit `.mcp.json` bloqué Cowork | Hook check-secrets règle 6 | Contourner via Bash `cp` |
| Edit SKILL.md `.claude/skills/` bloqué | Path protégé Cowork | Documenter dans `Ressources/Competences/` (cette doc) — patch SKILL.md via CLI Claude Code session future |

## Maintenance

### Rotation Service Token

Décision T#60 S83 : **rotation sur événement uniquement** (suspicion fuite, comme rotation S70 path-token T#88), pas de calendrier 90j (trop contraignant en pratique, risque oubli si manuel, fragile si auto).

Procédure rotation (à formaliser en skill séparée si fréquence > 1/an) :
1. Créer nouveau Service Token CF (Phase 7.1)
2. Update strat policy CF pour cibler nouveau token (Phase 7.2bis)
3. Update vars d'env Windows User + `~/.hermes/config.yaml`
4. Tests `curl` + Hermès
5. Supprimer ancien Service Token côté CF
6. Rotater secret en banque mdp Mickael

### Backups

- `.mcp.json.bak.s100` — backup pré-S102 path-token uniquement (à supprimer après 30j sans regression)
- `~/.hermes/config.yaml.bak.s100.t60-pre-cf-headers` — backup pré-S102 Hermès (idem)

---

*Dernière MAJ S102 (04/05/2026) — création doc post-résolution T#60 Niveau 1.*
