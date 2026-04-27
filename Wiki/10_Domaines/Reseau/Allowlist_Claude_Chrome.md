---
title: Allowlist Claude in Chrome — débloquer les actions MCP
created: 2026-04-27
tags: [reseau, claude-chrome, allowlist]
status: actif
domaine: Reseau
sources: [S20]
---

# Allowlist Claude in Chrome

## Contexte

Mickael utilise **Claude in Chrome** (extension Brave) pour piloter
des dashboards web (HA, Cloudflare, Outlook) depuis Cowork. Par défaut,
le **classifieur serveur Anthropic** bloque les actions MCP sur :

- IPs privées RFC1918 (`192.168.x.x` etc.)
- Interfaces admin (Home Assistant, Cloudflare dashboard, GitHub)
- Services financiers, crypto, adulte

Message affiché trompeur : `"This site is blocked by your organization's
policy"` — ce **n'est pas** une policy Chrome entreprise, mais un blocage
côté serveur Anthropic (issue GitHub `anthropics/claude-code#41034` :
durcissement récent).

**Découverte S20 (Mickael — non documentée Anthropic)** : il existe une
**vraie allowlist utilisateur** côté `claude.ai`, débloquée pour le plan
**Max individuel**.

## Configuration

### Trouver les paramètres

`claude.ai` → **Paramètres Claude dans Chrome** → section **Autorisations**.

Trois éléments :

1. **Dropdown "Par défaut pour tous les sites"** : `Bloquer l'extension`
   par défaut, autres options possibles
2. **Section "Sites autorisés"** + bouton `Ajouter des sites web`
   (allowlist utilisateur)
3. **Section "Vos sites approuvés"** : "Vous avez autorisé Claude à
   effectuer toutes les actions (naviguer, cliquer, saisir) sur ces sites"

### Sites ajoutés (état S20)

- `ha.might.ovh` — dashboard HA distant
- `dash.cloudflare.com` — Cloudflare dashboard (DNS, SSL/TLS, Access)

### Procédure obligatoire (PIÈGE)

⚠️ **Toujours ouvrir un NOUVEAU tab après ajout d'un site dans
l'allowlist** — un tab déjà ouvert avant l'ajout reste bloqué (le
classifieur serveur est évalué à l'ouverture du tab).

## Ce qui est débloqué

| Action MCP                | Avant       | Après (allowlist + nouveau tab) |
|---------------------------|-------------|---------------------------------|
| `navigate`                | OK          | OK                              |
| `screenshot` / `read_page`| Bloquée     | **OK**                          |
| `computer.left_click`     | Bloquée     | **OK**                          |
| `find` / `form_input`     | Bloquée     | **OK**                          |

Conséquence : Jarvis pilote directement HA distant et Cloudflare
dashboard via Claude in Chrome, sans passer systématiquement par
le guidage photo. Gain de temps majeur sur les tâches de config.

## Limites

- **IPs privées** (`192.168.1.11`) restent bloquées même via allowlist
  (classifieur catégorie séparée). Solutions :
  - URL publique via tunnel CF (`https://ha.might.ovh`)
  - MCP `ha-mcp` direct (voir [[MCP_HA_OAuth]])
- **Allowlist utilisateur ≠ allowlist Team/Enterprise** : la doc
  Anthropic ne mentionne que la version organisation. La version Max
  individuel est non documentée mais opérationnelle.

## Pièges connus

- **Pas un nouveau tab → action bloquée même après ajout** (vérifié S20).
- **Texte d'erreur trompeur** : "blocked by your organization's policy"
  ne signifie pas qu'une policy Chrome entreprise est en place, mais que
  le classifieur serveur Anthropic bloque la requête.
- **Pattern isolation tab Brave** (S25) : pour les pages avec données
  sensibles (formulaires + secrets), Jarvis prépare le formulaire dans
  un tab MCP, Mickael **drag le tab HORS du groupe MCP** avant le clic
  final qui révèle un secret. Combine gain de temps + Règle 0
  (auto-memory `feedback_claude_chrome_sensitive_drag`).

## Liens internes

- [[Cloudflare_Setup]] — dashboard CF piloté via Claude in Chrome
- [[../HomeAssistant/_Index|HA]] — dashboard HA distant
- Auto-memory `feedback_claude_chrome_allowlist`
- Auto-memory `feedback_claude_chrome_sensitive_drag`

## Sources

- `memory/historique/2026-04-20_session_20_allowlist_csp_ha.md` (découverte)
- Issue GitHub `anthropics/claude-code#41034`
