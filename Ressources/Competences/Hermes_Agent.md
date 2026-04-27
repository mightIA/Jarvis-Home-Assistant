---
name: Hermes Agent — compétence Jarvis
description: Usage et configuration d'Hermes Agent (Nous Research, MIT) installé Phase 1bis-c S47 sur WSL2 Ubuntu 24.04 + Ollama RTX 3090.
version: 1.0
created: 2026-04-25 (S47)
last_update: 2026-04-25 (S47 — création initiale après install bouclée à 90%)
note: Fichier équivalent skill — la vraie skill `.claude/skills/hermes-agent/SKILL.md` à créer en S48 via Claude Code CLI car `.claude/` bloqué en écriture côté Cowork.
---

# Hermes Agent — compétence Jarvis

## Description

Cette compétence documente l'usage d'**Hermes Agent v0.11+** dans le setup
Jarvis : orchestrateur LLM local par Nous Research (MIT), installé en
Phase 1bis-c S47 sur WSL2 Ubuntu 24.04 LTS + Ollama RTX 3090 24 Go +
4 modèles (Qwen 2.5 32B, Llama 3.1 8B, DeepSeek-R1 14B, Qwen 3 Embedding 4B)
+ clé API Mistral.

Hermes est conçu comme **alter ego de Cowork** : Cowork = sessions riches
avec MCPs avancés et skills créatives, Hermes = daemon 24/7 + gateways mobile
HA/Telegram + traitement léger + orchestration multi-LLM. **Cohabitation, pas
remplacement** (décision D3-S36).

## Stack opérationnelle (S47)

- **OS** : WSL2 Ubuntu 24.04 LTS sur C: NVMe Samsung 970 (~110 Go utilisés / 659 Go libres)
- **GPU** : RTX 3090 24 Go via WDDM passthrough (CUDA 13.1, ~22.4 Go effectifs dispo Ollama)
- **Ollama** : v0.21.2 service systemd actif sur `127.0.0.1:11434`
- **Modèles** :
  - `qwen2.5:32b` — défaut Hermes, raisonnement local lourd, ~20 Go VRAM
  - `llama3.1:8b` — rapide, ~5 Go VRAM
  - `deepseek-r1:14b` — reasoning chain-of-thought, ~9 Go VRAM
  - `qwen3-embedding:4b` — embeddings vault Wiki Phase 1bis-d, ~3 Go
  - `llama3.2:1b` — smoke test seulement, à supprimer (`ollama rm llama3.2:1b`)
- **Hermes binaire** : `~/.local/bin/hermes` (PATH WSL2 user)
- **Hermes project** : `~/.hermes/hermes-agent/` (clone géré par install script)
- **Config** : `~/.hermes/config.yaml` (settings) + `~/.hermes/.env` (API keys, perm 600)
- **Provider configuré** : Custom OpenAI-compatible endpoint vers Ollama local
- **Modèle par défaut** : `qwen2.5:32b`

## Quand utiliser Hermes vs Cowork

| Usage | Outil |
|---|---|
| Sessions interactives PC riches (Skills + MCPs Cowork-only) | Cowork |
| Daemon 24/7 surveillance + automatisations | Hermes |
| Gateways mobile (Telegram, Signal, HA notif) | Hermes (gateway start) |
| LLM local rapide sans dépendance cloud | Hermes (Ollama qwen/llama) |
| Multi-LLM orchestration (Anthropic + OpenRouter + Ollama) | Hermes (Smart Routing v0.10+) |
| OCR PDF avec Mistral fallback | Scripts Python custom (PAS Hermes natif) |
| Sub-agents context fork (wiki_*, Phase 1bis-d) | Hermes via AGENTS.md |

## Commandes Hermes essentielles

| Action | Commande |
|---|---|
| Lancer chat interactif (TUI) | `hermes` |
| Choisir modèle/provider | `hermes setup model` |
| Ajouter/changer MCP servers | `hermes setup tools` (interactif) |
| Configurer messaging gateway | `hermes setup gateway` |
| Voir config courante | `hermes config` |
| Éditer config dans éditeur | `hermes config edit` |
| Set valeur spécifique | `hermes config set <key> <value>` |
| Diagnostic problèmes | `hermes doctor` |
| MAJ vers dernière version | `hermes update` |
| Lancer gateway messaging | `hermes gateway start` |

Slash commands en cours de conversation (CLI ou messaging) :

- `/new` ou `/reset` — nouvelle conversation
- `/model [provider:model]` — changer de modèle (ex. `/model llama3.1:8b` pour passer du 32B au 8B)
- `/personality [name]` — changer persona
- `/retry` ou `/undo` — refaire/annuler dernier tour
- `/compress` — compresser le contexte courant
- `/usage` — voir consommation tokens
- `/insights [--days N]` — voir insights conversationnels sur N jours
- `/skills` ou `/<skill-name>` — invoquer une skill Hermes
- `/stop` — interrompre travail courant
- `/quit` — quitter Hermes

## Workflow quotidien

### Lancer Hermes pour une tâche ad-hoc

```bash
# Depuis un terminal WSL2 Ubuntu (Win+X+I → Ubuntu, ou wsl depuis PS)
hermes
# → TUI s'ouvre, prompt déjà en attente
# → Tape ta question/instruction
# → Quitte avec /quit ou Ctrl+C Ctrl+C
```

### Switcher de modèle en cours de conv (selon besoin)

- Question simple, rapide : `/model llama3.1:8b` (~5 Go VRAM, vitesse max)
- Raisonnement complexe : reste sur `qwen2.5:32b` (défaut, ~20 Go)
- Reasoning chain-of-thought (math, debug) : `/model deepseek-r1:14b` (~9 Go)

### Ajouter un MCP server externe (ha-mcp prévu S48)

⚠ **Méthode exacte non encore validée S47** — à creuser début S48 via :

1. Lancer `hermes setup tools` (wizard interactif) pour voir si l'option apparaît
2. Sinon explorer `~/.hermes/hermes-agent/cli-config.yaml.example` (50 KB) pour syntaxe MCP server
3. Sinon consulter doc en ligne `hermes-agent.nousresearch.com/docs/user-guide/configuration` (URL à allowlister Cowork pour WebFetch)

URL ha-mcp à brancher : `https://mcp.might.ovh/private_PfjEvJTqhCdo9ELRqCPADlzo`

## Toolsets Hermes disponibles (par défaut Quick setup S47)

6/11 catégories actives :

- ✅ Vision (image analysis)
- ✅ Browser Automation (Local browser via Node.js v22.22.2)
- ✅ Text-to-Speech (Edge TTS)
- ✅ Terminal/Commands
- ✅ Task Planning (todo)
- ✅ Skills (view, create, edit)

5 désactivées par manque de clé API (à activer si besoin via `~/.hermes/.env`) :

- ❌ Mixture of Agents (manque OPENROUTER_API_KEY) — recommandé pour multi-LLM
- ❌ Web Search & Extract (manque EXA / PARALLEL / FIRECRAWL / TAVILY)
- ❌ Image Generation (manque FAL_KEY ou OPENAI_API_KEY)
- ❌ RL Training Tinker (manque TINKER_API_KEY) — non pertinent pour nous
- ❌ Skills Hub GitHub (manque GITHUB_TOKEN) — pour télécharger skills communautaires

## Sécurité (Règle 0)

- `~/.hermes/.env` permission **600** obligatoire (lecture/écriture user uniquement)
- Variables sensibles (clés API, tokens) **uniquement** dans `.env`, jamais dans `config.yaml`
- Reload des variables `.env` : redémarrage Hermes nécessaire (pas de hot-reload)
- Mistral API key stockée en `MISTRAL_API_KEY=` (pas un slot natif Hermes mais utilisable par scripts custom Phase 1bis-d)
- Si fuite suspectée d'une clé : régénérer immédiatement côté provider et MAJ `~/.hermes/.env`

## Pré-requis matériel validés S47

- CPU : i9-9900K 8c/16t (largement OK pour orchestration)
- RAM : 32 Go (~17 Go dispo, on alloue ~12-14 Go à WSL2 par défaut)
- GPU : RTX 3090 24 Go (~22.4 Go dispo Ollama, suffit pour Qwen 32B Q4)
- Stockage : C: NVMe Samsung 970 (~659 Go libres pré-install, ~549 Go post)
- Win11 Pro 24H2/25H1 build 26200 BIOS 1802 UEFI Asus Maximus XI Hero
- VBS/Hyper-V actif (réquisitionne VT-x — Speccy aveugle, voir auto-memory `feedback_speccy_aveugle_vt_x_hyperv.md`)

## Reste à faire S48+ (Phase 1bis-c finalisation + Phase 1bis-d)

- [ ] **S48-A** Config ha-mcp dans Hermes via `hermes setup tools` ou édition manuelle config.yaml/cli-config.yaml.example syntax
- [ ] **S48-A** Test V1 final `hermes` chat avec Qwen 2.5 32B (formalité)
- [ ] **S48-A** Suppression clone manuel redondant `rm -rf ~/hermes-agent/` (Hermes utilise `~/.hermes/hermes-agent/` officiel)
- [ ] **S48-A** `ollama rm llama3.2:1b` (smoke test inutile en prod)
- [ ] **S48-A** Création vraie skill `.claude/skills/hermes-agent/SKILL.md` via Claude Code CLI (Cowork bloqué sur ce path)
- [ ] **Phase 1bis-d** Édition `~/.hermes/hermes-agent/AGENTS.md` (35 KB existant) pour ajouter 3 sub-agents `wiki_ingestor` + `wiki_librarian` + `wiki_query` + `context fork` activé sur chaque + test V1 sur Projet_Complet_v2.pdf

## Voir aussi

- Auto-memory `reference_hermes_install_phase1bisc` — procédure transposable d'install
- Auto-memory `reference_hermes_agent` (S36) — fiche tech générale Hermes Agent
- Auto-memory `feedback_hermes_pas_de_mistral_natif` (S47) — Mistral pas natif, scripts custom
- Auto-memory `feedback_speccy_aveugle_vt_x_hyperv` (S47) — diag matériel Win11 Pro
- Auto-memory `feedback_mistral_studio_compat_rest` (S47) — clé Mistral type Studio OK pour REST
- Auto-memory `feedback_ollama_install_zstd_required` (S47) — zstd requis Ubuntu fresh
- Archive `memory/historique/2026-04-25_session_47_phase1bisc_hermes_install.md`
- Repo officiel : [github.com/NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent) (MIT)
- Doc : [hermes-agent.nousresearch.com/docs](https://hermes-agent.nousresearch.com/docs/) — à allowlister Cowork pour WebFetch
- Project Hermès : `Projets/Jarvis_Hermes_Projet/` (rapport Phase 1 + Projet complet S36)
