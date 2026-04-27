---
source: source.pdf (Brave PDF natif export de https://www.home-assistant.io/integrations/zwave_js/)
outil: pdf-toolkit MCP (read_pdf_content)
duree: < 2 s
caracteres: 9 883
pages: 60
date: 2026-04-25 (S45 Phase 1bis-b)
verdict: ÉCHEC fonts custom non décodables
---

# Extraction `pdf-toolkit` — Z-Wave JS (manuel HA)

> ⚠️ **Échec d'extraction** : le PDF généré par Brave embarque les fonts
> custom de la doc HA (CSS `@font-face`). Le rendu visuel est correct
> mais le mapping codepoint → caractère Unicode est brisé. `pdf-toolkit`
> retourne du charabia (9 883 chars de symboles non-ASCII), pas du
> texte exploitable.

## Échantillon (premiers 1500 chars)

```
  

     

     

     

     

     

              !""#$"%" &'()*(&)&+,-).)& /01234,0,5674,899:9;2<;

              !"#$%#!$!&'$($! )*+,-.*/01.233435,65

     

     

       !"#$!%&&'&()(

     

     

     

     

     

  !!"!#$#

     

     

     

       !"# $%%&%'('

  !"#$%"&''(')*)
```

→ Aucun mot identifiable. Le seul texte ASCII pur est l'aperçu de
caractères ponctuation (`!"#$%`, `'()*+,-.`) — c'est probablement la
suite ASCII rendue dans la font custom mais avec un mauvais mapping
inverse vers Unicode standard.

## Cause probable

1. Brave imprime la page web Z-Wave JS doc HA via le moteur Chromium
   PDF natif
2. La doc utilise un theme avec fonts custom embarquées (Noto Sans /
   Inter / similaire pour le texte, Noto Sans Mono pour les blocs de
   code)
3. Le PDF embarque les **glyphes** (visuel OK) mais sans table
   `ToUnicode` correcte → l'extraction texte échoue

## Conclusion verdict

**`pdf-toolkit` ne sait pas lire ce PDF**. Pour ce type de PDF (web
imprimé en PDF natif Chromium), il faut un outil OCR qui regarde le
**rendu visuel**, pas le flux texte.

C'est le **cas d'usage idéal de Mistral Document AI** — qui devrait
réussir là où `pdf-toolkit` échoue.

## Options pour faire fonctionner pdf-toolkit sur ce PDF

1. **Re-générer le PDF via Microsoft Print to PDF** au lieu de Fichier
   PDF natif Brave → utilise le pilote Windows qui peut produire des
   tables ToUnicode différentes (à tester si nécessaire)
2. **OCR-iser** le PDF avant extraction (`tesseract` + `ocrmypdf` →
   PDF avec couche texte OCR ajoutée, puis `read_pdf_content`)
3. **Utiliser Mistral Document AI** directement (cas testé ici)

## Score test 2 / pdf-toolkit (provisoire)

| Critère | Score |
|---|---|
| 1. Qualité texte | 0/5 (charabia) |
| 2. Fidélité tableaux | 0/5 (impossible) |
| 3. Description images | 0/5 |
| 4. Distracteurs | N/A (rien de lisible) |
| 5. Durée | 5/5 (< 2 s mais pour rien) |
| 6. Simplicité workflow | 5/5 (1 appel MCP) mais résultat inutilisable |
| **Total /30** | **10/30** (mais score "rapidité+simplicité" trompeur) |
