# 07 - Annexe Chronologie Compte Rendu

## Chronologie simplifiee

| Etape | Observation                                  | Decision                                   |
|-------|----------------------------------------------|--------------------------------------------|
| C1    | Panels instables / perception DCONF corrompu | Lancer diagnostic cible                    |
| C2    | DBus + dconf.service actifs                  | Exclure panne totale DCONF                 |
| C3    | Incoherence references panel3                | Nettoyage et verrouillage 2 panels         |
| C4    | Reboot utilisateur                           | Validation persistance                     |
| C5    | Sortie vide percue dans un terminal          | Verification contexte terminal et commande |
| C6    | Scripts operationnels finalises              | Standardiser exploitation                  |

## Compte rendu des essais detaille

| ID | Test                      | Commande                                                            | Verdict |
|----|---------------------------|---------------------------------------------------------------------|---------|
| T1 | Etat DCONF service        | `systemctl --user status dconf.service`                             | OK      |
| T2 | Dump cles Cinnamon        | `dconf dump /org/cinnamon/`                                         | OK      |
| T3 | Topologie panels          | `gsettings get org.cinnamon panels-enabled`                         | OK      |
| T4 | Applets references        | `gsettings get org.cinnamon enabled-applets`                        | OK      |
| T5 | Script doctor             | `~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check` | OK      |
| T6 | Script reset safe (check) | `~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh check`    | OK      |

## Baseline actuelle retenue

- 2 panels actifs et persistants.
- Doctor renvoie OK.
- Backup automatise disponible.
- Relance Cinnamon securisee disponible.

## Retours d'experience

1. Toujours separer verification visuelle et verification de cles.
2. Ne pas conclure a corruption DCONF sans verifier DBus + dconf.service.
3. Garder un runbook TTY simple et tested.
4. Garder des scripts minimalistes, lisibles, et testables.

## Prochaines actions recommandees

1. Ajouter un memo ultra-court (1 page) pour usage quotidien.
2. Integrer ce dossier dans la structure NAS cible.
3. Archiver une baseline valide taggee par date.
