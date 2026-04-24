---
name: Pieges pandoc + template LaTeX custom XeLaTeX
description: Quatre pieges techniques a connaitre avant d'ecrire un template pandoc LaTeX custom pour compilation XeLaTeX (babel/french, `$` comme variable, MakeUppercase+color, DejaVu sans emojis). Decouverts S37 lors de la refonte Projet_Complet.pdf Hermes.
type: feedback
session: 37
date: 2026-04-24
---

# Pieges pandoc + template LaTeX custom

**Quand utiliser cette fiche** : la prochaine fois que j'ecris ou modifie
un template pandoc a passer a `pandoc --pdf-engine=xelatex --template=X.tex`.

**Why** : j'ai rencontre ces 4 pieges consecutivement durant la refonte
S37. Les resoudre a coute ~5 min chacun alors qu'ils etaient tous
previsibles. Garder la fiche sous la main evite de les retrouver.

**How to apply** : verifier les 4 points avant la 1re compilation.

---

## 1. Babel `french` absent du conteneur TeX Live -> polyglossia

Le conteneur Linux TeX Live 2022 Debian (celui utilise par le workspace
Cowork bash sandbox) n'a pas `french.ldf`. `\usepackage[french]{babel}`
echoue avec "Unknown option 'french'".

**Fix** : utiliser `polyglossia` (disponible, et c'est la convention
moderne XeLaTeX/LuaLaTeX de toute facon) :

```latex
\usepackage{polyglossia}
\setmainlanguage{french}
```

---

## 2. `$...$` dans un template pandoc = variable, pas math LaTeX

Pandoc utilise la syntaxe `$variable$` pour les templates. Toute commande
math inline comme `$\bullet$`, `$+$`, `$-$`, `$\alpha$` dans le template
est interpretee comme variable inconnue et provoque :

> Error compiling template: unexpected "$" expecting letter or digit or "()"

Meme regle pour `\$` (dollar echappe) : pandoc ne le tolere pas dans le
template. Pour un signe dollar visible, utiliser `\textdollar{}`.

**Fixes** :

| Voulu | NON | OUI |
|---|---|---|
| Puce bullet | `$\bullet$` | `\textbullet` |
| Plus | `$+$` | `+` ou `\textcolor{X}{+}` |
| Signe dollar | `\$/mois` | `\textdollar{}/mois` |
| Fleche | `$\to$` | `\textrightarrow` |

La regle : pas de `$` dans un template pandoc, point. Mettre toutes les
maths dans le corps du document (le .md ou le `$body$` injecte) ou dans
un `.sty` charge avant.

---

## 3. `\MakeUppercase` + `\textcolor{nom}` = couleur mise en MAJ aussi

Ecrire `\MakeUppercase{texte \textcolor{accent}{bullet}}` fait passer AUSSI
le nom de la couleur en majuscules -> xcolor cherche `ACCENT` qui n'est pas
defini et echoue avec :

> Package xcolor Error: Undefined color `ACCENT'.

**3 fixes possibles** :

1. **Le plus simple** : ecrire directement le texte en MAJUSCULES dans
   le template (`DOCUMENT INTERNE bullet SESSION 36`).
2. Sortir le `\textcolor` du `\MakeUppercase` (mettre la puce a
   l'exterieur).
3. Definir un alias de couleur majuscule en plus :
   `\colorlet{ACCENT}{accent}` en plus de la definition originale.

Solution 1 pour les entetes fixes, solution 2/3 pour du texte dynamique.

---

## 4. DejaVu Sans n'a pas ✅ U+2705 ni ❌ U+274C

Piege deja documente S36 dans `feedback_pdf_tools_mcp.md`, rappele ici
pour completude du pipeline pandoc+XeLaTeX+DejaVu :

Les glyphes emojis de style "check vert plein" et "croix rouge pleine" ne
sont PAS couverts par DejaVu Sans malgre ce que `fc-match` peut laisser
croire. La compilation echoue ou affiche des carres.

**Fix systematique** dans une copie de travail .md avant pandoc :

```bash
sed -i 's/✅/✓/g; s/❌/✗/g' Projet_work.md
```

(Source .md originale laissee intacte.)

---

## Checklist avant 1re compilation pandoc+template+XeLaTeX

- [ ] `polyglossia` et pas `babel` pour le francais
- [ ] zero `$...$` dans le template (math uniquement dans le body)
- [ ] zero `\$` dans le template (utiliser `\textdollar{}`)
- [ ] aucun `\textcolor` a l'interieur d'un `\MakeUppercase`
- [ ] copie de travail `.md` avec ✅ -> ✓ et ❌ -> ✗ si presents
- [ ] frontmatter YAML retire de la copie de travail si le template a ses
      propres `documentclass`/`geometry` (evite les conflits)
- [ ] `\setkeys{Gin}{width=linewidth,height=0.78textheight,keepaspectratio}`
      si les schemas risquent de deborder
- [ ] `\usepackage[section]{placeins}` pour forcer le flush des floats
