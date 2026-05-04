# Midjourney — log d'itérations

Journal détaillé de chaque cycle complet sur Midjourney. Sert de mémoire
de ce qui a marché, ce qui a raté, et pourquoi.

---

## Format d'une entrée (standardisé S90 — patch P2-2)

```markdown
### YYYY-MM-DD — <titre court du brief>

**Brief Mickael**
> citation littérale ou paraphrase courte

**Stack créatif V7** (si applicable)
- Personalization codes : `<code1>`, `<code2>`
- Moodboard codes : `<code_moodboard>`
- sref URLs : `<url1>`, `<url2>` (sw=400)
- oref URL : `<url_omni>` (ow=800)

**Prompt v1**
```
<prompt v1 complet avec tous les --params>
```
- Mode : Standard / Draft / Enhance
- Paramètres : `--ar W:H --s X --c X --v 7 --exp X` (+ `--no` si applicable)
- Coût crédits : ~X
- Score v1 : XX/50 (Fidélité X / Style X / Composition X / Technique X / Mood X)
- Gap principal : <ce qui n'a pas marché>

**Prompt v2** (si itération)
- Diff : <ce qu'on a changé exactement>
- Score v2 : XX/50

**Prompt vN final**
```
<prompt final qui a convergé>
```
- Score final : XX/50
- Image finale : <