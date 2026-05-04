---
name: T#48 MCP Outlook abandonné S92 — critères de réactivation
description: Abandon T#48 le 03/05/2026 après 2 murs Microsoft (app reg directe + sandbox Dev Program refusés pour compte perso @live.fr). Veille auto via T#91. Critères de réactivation listés.
type: project
---

T#48 (MCP Outlook softeria) abandonné définitivement S92 après itérations
S87 (research) → S88 (Plans A/B/C/I infra) → S92 (Plan D bloqué Microsoft).

**Why** : Microsoft a serré les critères pour comptes perso `@live.fr` en
2024-2025. Création app reg directe = bloquée. M365 Developer Program =
inscription OK mais sandbox subscription refusée. Sans tenant Azure dédié,
pas d'app reg, pas de softeria fonctionnel avec `--public-url`.

**How to apply** : NE PAS retenter Plan D tel quel. Si Mickael redemande
le tri Outlook MCP, vérifier d'abord les critères de réactivation
ci-dessous avant tout setup.

## Critères de réactivation T#48

Réouvrir T#48 si **AU MOINS UN** des éléments suivants se concrétise (à
vérifier par T#91 veille auto hebdomadaire) :

1. **softeria patche son app reg shared** pour accepter `redirect_uris`
   custom whitelistés dynamiquement (issue #288 et apparentées). Surveiller
   `https://github.com/softeria/ms-365-mcp-server/issues` + releases v1.x.
2. **Un nouveau MCP Outlook 1-clic** compatible compte perso `@live.fr`
   sort, SANS app reg Azure / Entra requise (auth déléguée par le serveur).
3. **Le connecteur officiel Anthropic Microsoft 365** ajoute les outils
   write : `outlook_move_email`, `outlook_archive_email`, `outlook_trash_email`,
   `outlook_create_filter`. Vérifier sur
   `https://support.claude.com/en/articles/12542951` régulièrement.
4. **Mickael décide d'ouvrir un compte Azure free tier** (CB sans débit)
   si gain MCP devient critique pour sa charge mentale email Outlook.
5. **Une voie communautaire émerge** (Reddit, HN, blogs dev) avec preuve
   de fonctionnement sur compte perso, validée par 2+ témoignages
   indépendants.

## Solutions écartées définitivement S92

| Option | Raison écart |
|--------|--------------|
| Composio Outlook MCP | Tokens OAuth chez tiers (3rd-party) → Règle 0 violée pour Mickael |
| ryaker/outlook-mcp | Même blocage app reg que softeria |
| syedazharmbnr1/claude-outlook-mcp | Idem |
| marlonluo2018/outlook-mcp-server (win32COM) | Nécessite Outlook desktop client installé. Mickael n'utilise que Outlook web |
| Connecteur officiel Anthropic M365 actuel | Read-only, ne couvre pas tri |

## Workflow Outlook actuel (à conserver)

Skills `tri-email-outlook` + `tri-email-outlook-priorites` via Brave +
Claude in Chrome. Marche, sécurisé, maintenu. Coût en tokens et temps
significativement plus élevé que MCP, mais acceptable pour la fréquence
d'usage Outlook (boîte secondaire).

## Référence ancienne mémoire S88 (obsolète mais conservée pour contexte)

- `memory/reference_setup_outlook_mcp_s88.md` — état infra S88 (devenue
  obsolète après cleanup S92, conserver pour contexte historique)
- `memory/feedback_softeria_redirect_uri_app_reg.md` — bug technique
  identifié (toujours valide, utile pour T#91 veille)
