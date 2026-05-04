---
name: Git Jarvis repo — décisions et stratégie (CLI local)
description: Référence du repo Git racine projet Jarvis créé S42 (25/04/2026) — branche main, commit 3a63421, .gitignore strict Q1-Q4
type: reference
session: 42
date: 2026-04-25
---

# Git Jarvis repo — décisions et stratégie

## Init S42

- Repo : `D:\Documents\IA\Projets Cowork\Jarvis - Home Assistant\.git\`
- Branche par défaut : `main` (pas `master`)
- User config : `Mickael` / `might57290@gmail.com`
- Premier commit : `3a63421` — 130 fichiers, 40 230 lignes
- **Push GitHub mightIA reporté** — local uniquement pour validation 1-2 jours

## Stratégie .gitignore — décisions Q1-Q4 (S42)

| Q | Élément | Décision | Pattern .gitignore |
|---|---|---|---|
| Q1 | `memory/` | Versionner SAUF `historique*` | Lignes 43-45 |
| Q2 | `Runtime/` | Tout exclure (135 Mo) | Ligne 35 |
| Q3 | `.mcp.json` | Exclure + `.mcp.json.template` versionné | Ligne 12 |
| Q4 | Push GitHub | Local uniquement aujourd'hui | — |

## Patterns sensibles vérifiés (`git check-ignore -v`)

- `.gitignore:12:.mcp.json` → URL CF Tunnel exclue
- `.gitignore:15:.claude/settings.local.json` → allowlist locale exclue
- `.gitignore:18:.claude/jarvis-config.json` → config personnelle exclue
- `.gitignore:35:Runtime/` → 135 Mo Gmail-MCP-Server exclus
- `.gitignore:43:memory/historique/` → archives sessions exclues
- `.gitignore:44:memory/historique_reactif/` → logs Mode Réactif exclus

## Recloner ailleurs

```powershell
git clone <repo> Jarvis
cd Jarvis
cp .mcp.json.template .mcp.json
# Remplir <YOUR_HA_MCP_DOMAIN>, <YOUR_PRIVATE_TOKEN_PATH>, <ABSOLUTE_PATH_TO_REPO>
git clone https://github.com/GongRzhe/Gmail-MCP-Server.git Runtime/Gmail-MCP-Server
cd Runtime/Gmail-MCP-Server
git checkout a890d19
npm install
npm run build
```

Configurer credentials Gmail dans `C:\Users\<USER>\.gmail-mcp\` (ACL NTFS restreintes).

## Convention de message de commit

```
<type>: <résumé court session>

<body multi-paragraphe avec décisions structurantes,
livrables, validation pré-commit>
```

Types : `chore` (init/config), `feat` (skill/intégration), `fix`,
`docs` (Wiki / Ressources), `refactor`.

## TODO Git futurs

- [ ] Push initial `mightIA/Jarvis` privé (S43+)
- [ ] Activer Obsidian Git auto-commit du vault `Wiki/`
- [ ] SSH key GitHub si HTTPS demande trop souvent les credentials
- [ ] Stratégie de tags : `vS42` à chaque session importante

## Notes liées

- `feedback_git_sandbox_cowork_bloque.md` (S42)
- Wiki : `Wiki/10_Domaines/HomeAssistant/_Index.md`
- Source : footer CLAUDE.md S42

---

*Source : décisions S42 (25/04/2026) — réplique CLI local de l'auto-memory Cowork web pour assurer restauration depuis le repo Git.*
