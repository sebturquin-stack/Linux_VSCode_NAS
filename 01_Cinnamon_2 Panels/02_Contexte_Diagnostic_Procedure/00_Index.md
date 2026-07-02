# Dossier Documentation Cinnamon 2 Panels

## Objectif

Ce dossier documente l'incident Cinnamon/DCONF, le diagnostic, la stabilisation, les scripts de maintenance, la validation post-reboot, et le runbook de secours TTY.

## Structure

1. `01_Contexte_Incident_Et_Symptomes.md`
2. `02_Diagnostic_Technique_Et_Causes_Racines.md`
3. `03_Procedure_Stabilisation_Pas_A_Pas.md`
4. `04_Scripts_Usage_Check_Backup_Restore_Reset.md`
5. `05_Validation_Post_Reboot_Et_Criteres_OK.md`
6. `06_Runbook_Recovery_TTY_Urgence.md`
7. `07_Annexe_Chronologie_Compte_Rendu.md`
8. `08_Memo_Quotidien_1_Page.md`

## Resume Executif

- DCONF est actif et persistant.
- Le faux negatif principal venait de la verification sur un mauvais chemin DCONF.
- Les 2 panels sont verrouilles et persistants.
- 3 scripts operationnels sont disponibles dans `~/Scripts`.
- Un runbook d'urgence est fourni pour eviter les boucles de depannage.

## Regle d'exploitation

- Toujours lancer les commandes de verification depuis une session graphique Cinnamon active.
- Toujours faire une sauvegarde DCONF avant action intrusive.
- En cas de doute, utiliser le script doctor avant toute relance de Cinnamon.

## Demarrage rapide

1. Lancer `~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check`
2. Si besoin, lancer `~/01_Infra/02_Scripts/01_Cinnamon/save_dconf_cinnamon.sh`
3. En cas de refresh session, lancer `~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh restart`
4. Valider avec `dconf dump /org/cinnamon/ | grep -E 'panels-enabled|enabled-applets'`
