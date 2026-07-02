# 01 - Contexte Incident Et Symptomes

## Perimetre

- OS: Linux Mint / Cinnamon
- Session cible: X-Cinnamon
- Scope: persistance panels Cinnamon, stabilite session graphique, liaison DCONF/DBus

## Symptome initiaux observes

| ID | Symptome                                              | Impact                                  |
|----|-------------------------------------------------------|-----------------------------------------|
| S1 | Panels visibles mais non persistants                  | Reconfiguration repetitive apres reboot |
| S2 | Sortie vide sur certaines commandes DCONF             | Faux diagnostic de corruption totale    |
| S3 | Comportements fantomes panel3 / applets               | Incoherence entre visuel et config      |
| S4 | Relances Cinnamon non fiables selon contexte terminal | Risque de blocage session               |

## Contexte operationnel

- Plusieurs tentatives de reset/restart avaient deja ete faites avant stabilisation finale.
- Des applets etaient referencees sur un panel fantome (panel3) non attendu dans la config finale.
- L'objectif final etait de verrouiller 2 panels propres, persistants, et faciles a maintenir.

## Hypotheses de depart

1. DCONF totalement corrompu.
2. Service DCONF inactif.
3. Bus DBus utilisateur absent.
4. Probleme de chemin de verification des cles.

## Decision de methode

- Passer d'une logique "reset global" a une logique "diagnostic cible + correction minimale".
- Valider chaque etape avec commandes explicites et criteres de succes.
