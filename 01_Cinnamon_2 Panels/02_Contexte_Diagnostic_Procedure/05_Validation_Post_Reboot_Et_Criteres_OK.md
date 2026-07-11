# 05 - Validation Post Reboot Et Criteres OK

## Objectif

Confirmer que la stabilisation est durable apres reboot et non seulement en session courante.

## Check-list rapide

| Controle   | Commande / Action                                                      | OK attendu              |
|------------|------------------------------------------------------------------------|-------------------------|
| Visuel     | Presence de 2 panels                                                   | Oui                     |
| Doctor     | `~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check`    | Verdict OK              |
| Cles DCONF | `dconf dump /org/cinnamon/  grep -E 'panels-enabled|enabled-applets'`  | Lignes non vides        |
| Topologie  | `gsettings get org.cinnamon panels-enabled`                            | 2 entrees               |
| Applets    | `gsettings get org.cinnamon enabled-applets`                           | Applets panel1 + panel2 |

## Matrice de verdict

| Etat                | Interpretation             | Action                                |
|---------------------|----------------------------|---------------------------------------|
| OK complet          | Stabilisation validee      | Garder cette baseline                 |
| KO visuel, OK DCONF | Refresh visuel necessaire  | `reset_cinnamon_safe.sh restart`      |
| OK visuel, KO DCONF | Faux positif visuel        | Refaire doctor + backup/restore       |
| KO DBus             | Contexte terminal invalide | Ouvrir terminal dans session Cinnamon |

## Evidence actuelle (session de reference)

- `panels-enabled` retourne 2 panels.
- `enabled-applets` contient des entrees panel1 et panel2.
- Doctor retourne un verdict OK.

## Definition de stabilite durable

- 3 validations successives (dont au moins 2 apres reboot) sans divergence.

## Journal des validations

| Date       | Controle               | Resultat | Commentaire                     |
|------------|------------------------|----------|---------------------------------|
| 2026-06-28 | Check doctor           | OK       | DCONF actif, 2 panels detectes  |
| 2026-06-28 | Verification gsettings | OK       | topologie et applets coherentes |
| 2026-06-28 | Reboot + check         | OK       | persistance confirmee           |
