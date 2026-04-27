---
pdf: AUCUN (test abandonné)
type: formulaire administratif officiel AcroForm — CHASSE INFRUCTUEUSE
url_source: 3 URLs essayées sans succès (voir corps)
form_fields: NON MESURÉ
encrypted: NON MESURÉ
date: 2026-04-25 (S46 Phase 1bis-b clôture)
status: ABANDONNÉ — leçon dématérialisation documentée
---

# Notes test 03 — CERFA AcroForm — TEST ABANDONNÉ

## Décision S46

Test 3 **abandonné** après 3 pièges dématérialisation successifs. La leçon
"la plupart des CERFA service-public.fr ne sont plus téléchargeables" est
documentée et intégrée au rapport final — elle a plus de valeur structurante
pour Phase 1bis-c que le scoring d'un seul PDF AcroForm test.

## Les 3 pièges rencontrés

| Tentative | URL | Type réel | Verdict |
|---|---|---|---|
| 1 | service-public.fr/particuliers/vosdroits/R39697 | Lettre type web (modèle d'attestation d'hébergement) | Pas un CERFA, formulaire interactif |
| 2 | service-public.fr/particuliers/vosdroits/F2191 (CERFA 10798) | Attestation d'accueil — délivrée en mairie après dépôt de demande | Pas téléchargeable, retrait sur place |
| 3 | service-public.fr/particuliers/vosdroits/F1359 (CERFA 15646*01) | Autorisation de sortie de territoire | Bouton de téléchargement absent (re-piège) |
| Mention | demarches.interieur.gouv.fr (CERFA 15776*02 cession véhicule) | 100% portail ANTS depuis 2017 | Pas téléchargeable |

## Section archivée — Pourquoi ce CERFA (changement S46)

## Pourquoi ce CERFA (changement S46)

CERFA 14011 / R39697 / cession véhicule **abandonnés** : les 2 premiers
n'étaient pas des CERFA AcroForm (lettre type web et formulaire interactif),
le 3ᵉ est 100% dématérialisé depuis 2017 (portail ANTS).

Le CERFA **15646*01 (Autorisation de sortie de territoire)** reste
téléchargeable :

- **Pas de dématérialisation** (formulaire papier obligatoire à signer
  par le parent avant le voyage)
- **PDF AcroForm officiel** (cas idéal pour `fill_pdf` pdf-toolkit)
- **Léger** (~1 page A4)
- **Pas de données sensibles** dans le PDF vide téléchargé
- **Cas archi-classique** (parent qui autorise un mineur à voyager seul)

## Pré-requis téléchargement

À faire par Mickael depuis Brave :

1. Ouvrir [service-public.fr/particuliers/vosdroits/F1359](https://www.service-public.fr/particuliers/vosdroits/F1359)
2. Bouton **"Accéder au formulaire"** ou lien CERFA 15646*01 vers le PDF
3. Sauvegarder vers
   `D:\Might\IA\Projets Cowork\Jarvis - Home Assistant\Projets\Mistral_Doc_AI_Test\03_CERFA_AcroForm\source.pdf`
4. Me confirmer "CERFA téléchargé" → je lance pdf-toolkit + Mistral

## Mesures à venir (par pdf-toolkit)

- [ ] `get_pdf_info` (taille, nb pages, dimensions)
- [ ] `read_pdf_fields` → liste des champs AcroForm (attendu : > 0)
- [ ] `read_pdf_content` → texte brut + labels visibles
- [ ] `get_page_analysis` → structure visuelle si AcroForm

## Mesures à venir (par Mistral Le Chat)

- [ ] Durée upload + génération
- [ ] Capacité à reproduire les **labels** des champs (vs juste lire le texte)
- [ ] Capacité à structurer la sortie en sections
- [ ] Détection des cases à cocher

## Hypothèses à confirmer

- **pdf-toolkit gagne haut la main** : `read_pdf_fields` donne directement la
  liste structurée des champs AcroForm en quelques ms — Mistral ne peut pas
  faire mieux car il regarde le rendu visuel, pas la structure du PDF
- **Mistral pourrait gagner sur la description visuelle** des cases à cocher
  ou sur la mise en forme des sections, mais c'est secondaire pour un CERFA
- **Cas d'usage idéal pdf-toolkit confirmé** : tous les formulaires AcroForm
  (CERFA, contrats DocuSign, exports Word avec champs)

## Score attendu (à valider après tests)

Provisoire avant mesures :

| Critère | pdf-toolkit | Mistral | Gagnant attendu |
|---|---|---|---|
| 1. Qualité texte | 5/5 | 4/5 | pdf-toolkit |
| 2. Fidélité tableaux | N/A | N/A | (pas de tableau dans CERFA) |
| 3. Description images | 0/5 | 2/5 | Mistral (logos Marianne) |
| 4. Distracteurs | 5/5 | 5/5 | égalité |
| 5. Durée | 5/5 (< 1 s) | 2/5 (~30 s) | pdf-toolkit |
| 6. Simplicité workflow | 5/5 | 2/5 | pdf-toolkit |
| **Total /30** | **20/30** | **15/30** | **pdf-toolkit** (de loin) |

À mesurer pour confirmer ou infirmer.

## Leçon S46 — dématérialisation des CERFA

À documenter dans le rapport final : la **plupart des CERFA service-public.fr
ont été retirés du téléchargement public** (procédure 100% en ligne via
portails dédiés ANTS / impots.gouv.fr / FranceConnect). Le pipeline
Phase 1bis-c sub-agent `wiki_ingestor` doit donc anticiper qu'un CERFA
téléchargeable est l'exception, pas la règle. Sources à archiver localement
quand un parent / tiers nous transmet un PDF rempli.

CERFA encore téléchargeables (au 25/04/2026, à re-vérifier) :

- **15646*01** AST (notre cobaye) — service-public.fr/particuliers/vosdroits/F1359
- **13406*15** Permis de construire maison individuelle — F1986
- **2042** Déclaration revenus — impots.gouv.fr
- Certains formulaires DGFiP, ANTS, MSA, CAF restent disponibles en PDF

CERFA dématérialisés (PDF retiré) :

- 15776*02 Déclaration de cession véhicule (ANTS only, depuis 2017)
- 10798 Attestation d'accueil (mairie only)
- Formulaires fiscaux récents (déclaration en ligne obligatoire)
