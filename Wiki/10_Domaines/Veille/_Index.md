---
title: Veille tech — Hub
created: 2026-04-27
tags: [moc, veille, domaine/veille]
status: actif
source_ressources:
  - Ressources/Competences/Hermes_Agent.md
  - Projets/Cookbook_Hermes_RTX3090/docs/troubleshooting.md
  - Projets/Cookbook_Hermes_RTX3090/docs/configs.md
---

# Veille tech — Hub central

Point d'entrée du domaine **Veille technologique** de Jarvis. Catalogue
vivant des issues GitHub à monitorer, des modeles LLM a tester quand ils
sortent, du paysage marche LLM 2026, des benchmarks providers et de la
backlog d'articles a lire.

Le but : ne plus se faire surprendre par un fix upstream qui aurait
debloque un modele abandonne (cf. cas qwen3:32b refute S48+S53 puis
rehabilite S57 via `hermes update`).

## Atomes du domaine

### Issues GitHub a suivre
- [[Issues_GitHub_A_Suivre]] — catalogue des issues upstream qui ont
  un impact direct sur la stack Jarvis (Hermes, Ollama, ha-mcp).

### Modeles LLM a tester
- [[Modeles_LLM_A_Tester]] — liste de modeles a (re)tester quand une
  nouvelle version sort, avec quantization viable RTX 3090 24 GB.
- [[Landscape_LLM_2026]] — etat du marche LLM avril 2026 (Anthropic,
  OpenAI, Google, Meta, Mistral, modeles locaux).
- [[Provider_Benchmarks]] — comparatif providers cloud + local (prix,
  latence, qualite tool calling, ecosysteme MCP).
- [[MCP_Ecosystem]] — etat des MCP servers communautaires et officiels.

### Articles & ressources a lire
- [[Articles_A_Lire]] — backlog articles techniques (Karpathy, Anthropic
  Cookbook, Build To Launch, etc.).

## Cadence de revue

- **Hebdo** : check Issues GitHub critiques (cf. atome dedie).
- **Mensuel** : passage Modeles_LLM_A_Tester pour reperer les nouvelles
  versions sorties (Hermes 4, Llama 3.5, Qwen 3.5+, DeepSeek-R2).
- **Trimestriel** : refresh Landscape_LLM_2026 et Provider_Benchmarks.

## Regle d'or — audit communautaire avant verdict

Avant d'eliminer un modele ou de declarer un bug definitif, croiser avec
les issues GitHub upstream. Pattern valide S57 (cf. auto-memory
`feedback_audit_communautaire_avant_verdict`).

## Liens externes

- Cookbook RTX 3090 (repo public) : `Projets/Cookbook_Hermes_RTX3090/`
- Fiche Hermes Agent : `Ressources/Competences/Hermes_Agent.md`
- Auto-memory landscape : `feedback_audit_communautaire_avant_verdict.md`,
  `reference_modelfile_qwen3_durci.md`,
  `reference_hermes_provider_openrouter_correct.md`

---

*Hub cree S65 (27/04/2026). Convention atomique stricte D4-S42.*
