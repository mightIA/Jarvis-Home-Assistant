# Stable Diffusion — log d'itérations

Journal détaillé de chaque cycle complet sur SD (toutes versions).

---

## Format d'une entrée

```markdown
### YYYY-MM-DD — <titre court du brief>

**Brief Mickael**
> citation littérale ou paraphrase

**Setup**
- Interface : A1111 / ComfyUI / Forge / Fooocus / InvokeAI
- Version : SD 1.5 / SDXL / SD3 / FLUX.1 dev / FLUX.1 schnell
- Checkpoint : <nom du modèle>
- LoRA : <liste éventuelle>
- VAE : <nom>

**Prompt v1**
```
<prompt v1 complet>
```

**Negative prompt v1**
```
<negative complet>
```

**Paramètres v1**
```
CFG: X | Steps: X | Sampler: X | Size: WxH | Seed: X | Hires: ...
```

- Score v1 : XX/50
- Gap principal : <ce qui n'a pas marché>

**Itérations v2, v3...** (diff)
- v2 : <changement> → score XX/50
- v3 : <changement> → score XX/50

**Prompt vN final**
```
<prompt final qui a convergé>
```

**Paramètres vN final**
```
<...>
```

**Image générée** (référencer le path local si sauvegardée)

**Leçons**
- <leçon retenue, à reporter dans 00_core/lessons_learned.md ou
  style_library.md>

**Tags** : #portrait #realiste #SDXL #RealisticVision
```

---

## Journal

> *Vide pour l'instant. Première itération à venir.*

---

## Index par tags (auto-tenu)

> *À enrichir au fur et à mesure.*

- `#SD1.5` :
- `#SDXL` :
- `#SD3` :
- `#FLUX` :
- `#portrait` :
- `#paysage` :
- `#anime` :
- `#concept_art` :
- `#produit` :

---

## Index par checkpoint

- `RealisticVision` :
- `Juggernaut XL` :
- `DreamShaper XL` :
- `MeinaMix` :
- `epiCRealism` :
- `FLUX.1 dev` :
- `FLUX.1 schnell` :

---

*Créé le 2026-04-26*
