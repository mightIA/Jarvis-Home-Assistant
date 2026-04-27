---
name: Préférence "Ubuntu" plutôt que "WSL2"
description: Quand on parle du terminal Linux côté PC Mickael, dire "Ubuntu" (ou "Ubuntu (WSL2)" si la précision technique est utile) plutôt que "WSL2" seul. WSL2 est jargon, Ubuntu est ce que Mickael voit dans son terminal.
type: feedback
---

Quand on évoque le terminal Linux côté PC Mickael, écrire **"Ubuntu"** (ou "Ubuntu (WSL2)" si la précision technique est utile au contexte), pas **"WSL2"** seul.

**Why:** WSL2 est un terme technique abstrait (la couche Microsoft de virtualisation Linux). "Ubuntu" est ce que Mickael voit concrètement dans son terminal Windows Terminal et son prompt (`might@Might-1000D:~$`). Lui demander de "coller dans WSL2" ne lui évoque pas immédiatement le bon terminal — il jongle entre PowerShell, cmd.exe, Hermès chat, Claude Code CLI, et Ubuntu.

**How to apply:**
1. Dans les blocs "À coller dans X" (règle d'étiquetage application S48), écrire **"À coller dans Ubuntu (bash)"** au lieu de "À coller dans WSL2 (bash)".
2. Dans les explications transverses, dire "côté Ubuntu" ou "depuis Ubuntu" (ex. "le sandbox bash Cowork ne voit pas le filesystem Ubuntu").
3. Garder "WSL2" uniquement quand on parle vraiment de la couche d'infrastructure (ex. "config `.wslconfig`", "WSL2 alloue 50% RAM Windows par défaut") — c'est-à-dire quand WSL2 est le sujet technique et pas juste un synonyme du terminal.
4. Si confusion possible (ex. installation côté Windows pour configurer WSL2), préciser "Ubuntu (WSL2)" — meilleur des deux mondes.

**Origine:** S70 (27/04/2026) lors du cleanup `~/.hermes/.env` post-révocation MISTRAL_API_KEY (T#71). Mickael a explicitement demandé "Ubuntu" plutôt que "WSL2" : "se n'est pas trop parlant WSL2 met genre Unbuntu merci".
