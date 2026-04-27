---
name: hermes-agent
description: Utiliser cette skill pour toute tâche autour d'Hermes Agent (Nous Research, MIT) — install/config Phase 1bis-c, ajout/test MCP servers, choix du modèle local Ollama selon usage (tool calling vs contexte vs taille), bascule modèle en cours de conv, gateway messaging Telegram/HA, scripts de test V1, sub-agents context fork wiki_* Phase 1bis-d. Triggers : "Hermes Agent", "hermes mcp add", "hermes setup", "tool calling Ollama", "modèle local pour Hermès", "AGENTS.md sub-agents", "Phase 1bis-c", "Phase 1bis-d", "wiki_ingestor / wiki_librarian / wiki_query".
---

# Skill : Hermes Agent

## Quand l'utiliser

- Mickael demande d'ajouter, tester, ou diagnostiquer un MCP server dans Hermès
- Question sur le choix du modèle Ollama pour une tâche donnée (tool calling, raisonnement, vitesse)
- Configuration des sub-agents Phase 1bis-d (`wiki_ingestor`, `wiki_librarian`, `wiki_query`) via `~/.hermes/hermes-agent/AGENTS.md`
- Setup d'un gateway messaging (Telegram, Home Assistant, Signal)
- Troubleshooting : modèle qui hallucine sur tool calling, erreur HTTP 400 "does not support tools", erreur 64k contexte minimum, fenêtre TUI qui ne s'affiche pas
- Mise à jour Hermès, ou ajout d'une clé API provider (OpenRouter, Anthropic, Mistral) dans `~/.hermes/.env`

## Stack opérationnelle (S48)

- **Hermès binaire** : `~/.local/bin/hermes` v0.11.0+
- **Project** : `~/.hermes/hermes-agent/` (clone géré par install script)
- **Config** : `~/.hermes/config.yaml` (settings) + `~/.hermes/.env` (secrets, perm 600 obligatoire)
- **Provider défaut** : Custom OpenAI-compatible endpoint → Ollama local `http://localhost:11434/v1`
- **MCP server branché** : `ha-mcp` via `https://mcp.might.ovh/<secret_path>` (87 tools `ha_*`)

## Choix du modèle Ollama selon usage

Matrice essentielle (apprentissages S48 — RTX 3090 24 Go) :

| Modèle | Taille | VRAM | Contexte | Tool calling Ollama | Usage recommandé |
|---|---|---|---|---|---|
| `mistral-nemo:12b` | 12B | ~7 Go | 128k | ✅ excellent | **Daemon Hermès quotidien**, gateway messaging, sub-agent `wiki_query` |
| `qwen3:32b` | 32B | ~20 Go | 128k | ✅ solide | Tâches lourdes, sub-agents `wiki_ingestor` / `wiki_librarian`, raisonnement |
| `qwen2.5:32b` | 32B | ~20 Go | 32k natif | ✅ solide | ⚠ < 64k min Hermès → workaround override risqué |
| `llama3.1:8b` | 8B | ~5 Go | 128k | ✅ basique | Trop petit pour catalogues > 50 tools (hallucine) |
| `deepseek-r1:14b` | 14B | ~9 Go | 64k | ❌ **non supporté Ollama** | Raisonnement pur uniquement, pas d'agents |
| `qwen3-embedding:4b` | 4B | ~3 Go | – | N/A (embedding) | Vectorisation vault Phase 1bis-d |

**Règle d'or** : pour le tool calling avec catalogue > 50 outils + Hermès qui exige 64k contexte min → **mistral-nemo:12b** par défaut, **qwen3:32b** pour qualité supérieure si besoin.

## Commandes Hermès essentielles

| Action | Commande WSL2 |
|---|---|
| Lancer chat interactif (TUI) | `hermes` |
| Choisir modèle/provider | `hermes model` (interactif) ou `hermes setup model` |
| Lister MCP servers configurés | `hermes mcp list` |
| Tester connexion MCP server | `hermes mcp test <name>` |
| Voir tous les modèles Ollama dispo | `ollama list` |
| Diagnostic config | `hermes doctor` |
| MAJ Hermès | `hermes update` |
| Lancer gateway messaging | `hermes gateway start` |

Slash-commands en cours de conversation TUI :

- `/exit` ou `/quit` — quitter
- `/new` — nouvelle conversation
- `/model <name>` — bascule modèle in-session
- `/help` — liste complète

## Workflow ajout MCP server externe

⚠ **Piège connu S48** : `hermes mcp add <name> --url <url>` lance un agent test (mode "discovery-first install") mais **ne persiste rien** dans `config.yaml`. Solution = édition manuelle.

### Méthode validée S48 — édition directe `~/.hermes/config.yaml`

```bash
cat >> ~/.hermes/config.yaml << 'EOF'

# ── MCP Servers ────────────────────────────────────────────────────
mcp_servers:
  <name>:
    url: https://exemple.com/path
EOF
```

Puis vérification :

```bash
hermes mcp list           # doit montrer le nouveau server enabled
hermes mcp test <name>    # handshake JSON-RPC, attendu "Connected (Xms)" + "Tools discovered: N"
```

Variantes structure (depuis `~/.hermes/hermes-agent/cli-config.yaml.example` lignes 687-740) :

```yaml
mcp_servers:
  http_server:
    url: https://...
    headers:                    # optionnel — pour auth header
      Authorization: "Bearer xxx"
    timeout: 120                # optionnel — défaut 120s
    connect_timeout: 60         # optionnel — défaut 60s
  stdio_server:
    command: npx
    args: ["-y", "@modelcontextprotocol/server-X"]
    env:
      KEY: "value"
```

## Pièges documentés (S48)

1. **`hermes mcp add` ne persiste pas** côté CLI — édition manuelle `config.yaml` obligatoire
2. **DeepSeek-R1 ne supporte pas le tool calling** via Ollama (HTTP 400 "does not support tools") — modèle de raisonnement pur
3. **Llama 3.1 8B hallucine** quand exposé à un catalogue > 50 outils MCP (génère faux résultats sans appel réel)
4. **Qwen 2.5 32B contexte 32k natif** — Hermès exige 64k min → soit override `model.context_length: 64000` (risqué), soit basculer Qwen 3 32B / Mistral Nemo 12B
5. **Hermès TUI redémarre une session à chaque commande mal interprétée** — Mickael colle parfois des blocs multi-lignes dans le chat au lieu de bash → toujours utiliser des étiquettes claires "À coller dans WSL2 (bash)" vs "À taper dans Hermes chat (prompt ❯)"
6. **Régénération secret_path ha-mcp** : changer la valeur dans config add-on HA (champ `secret_path`) + Stop+Start (PAS Restart, leçon S16) + patch `~/.hermes/config.yaml` + patch `.mcp.json` projet Cowork

## Sécurité (Règle 0)

- `~/.hermes/.env` permission **600** obligatoire (lecture/écriture user uniquement)
- Variables sensibles **uniquement** dans `.env`, jamais dans `config.yaml` (qui peut finir versionné)
- Mistral API key stockée en `MISTRAL_API_KEY=` (pas un slot natif Hermès — utilisable par scripts Python custom Phase 1bis-d, pas via Hermès directement)
- Si fuite suspectée : régénérer côté provider + MAJ `~/.hermes/.env` + redémarrer Hermès

## Sub-agents Phase 1bis-d (à venir)

Configuration via `~/.hermes/hermes-agent/AGENTS.md` (~35 KB existant) — 3 sub-agents prévus :

| Sub-agent | Rôle | Modèle recommandé | Context fork |
|---|---|---|---|
| `wiki_ingestor` | PDF → Markdown propre via Mistral OCR + pdf-toolkit | qwen3:32b | ✅ |
| `wiki_librarian` | Markdown → vectorisation Qwen 3 Embedding 4B + index BM25 | qwen3:32b | ✅ |
| `wiki_query` | Question utilisateur → BM25 + cosinus reranking → extraits < 4000 tokens | mistral-nemo:12b | ✅ |

**Test V1 cible** : ingérer `Projet_Complet_v2.pdf` (25 p), interroger "explique-moi Harness Engineering" → vérifier que la réponse cite la bonne section sans avoir chargé tout le PDF dans le contexte principal.

## Voir aussi

- `Ressources/Competences/Hermes_Agent.md` — fiche compétence détaillée (équivalent de cette skill avec plus de contexte historique)
- Auto-memory `reference_hermes_install_phase1bisc` — procédure transposable d'install
- Auto-memory `reference_hermes_agent` — fiche tech générale Hermès
- Auto-memory `feedback_hermes_pas_de_mistral_natif` — Mistral pas natif, scripts custom requis
- Archive `memory/historique/2026-04-25_session_47_phase1bisc_hermes_install.md` — install bouclée à 90% S47
- Archive `memory/historique/2026-04-25_session_48_phase1bisc_cloture.md` — finalisation Phase 1bis-c S48 (à créer en fin de session)
- Repo officiel : [github.com/NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) (MIT)
- Doc : [hermes-agent.nousresearch.com/docs](https://hermes-agent.nousresearch.com/docs/)
- Project Hermès : `Projets/Jarvis_Hermes_Projet/` (rapport Phase 1 + Projet complet S36)
