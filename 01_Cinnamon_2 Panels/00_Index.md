# Index - 01_Cinnamon_2 Panels

## Objectif du dossier

Centraliser l'historique, les procedures, les diagnostics et les assets de stabilisation Cinnamon 2 panels.

## Parcours conseille

1. Lire la documentation structuree dans `02_Contexte_Diagnostic_Procedure/00_Index.md`.
2. Executer les scripts utilitaires depuis `~/Scripts`.
3. Valider apres reboot avec le doctor.

## Contenu du dossier

- `01_Config_Avance_Cinnamon.md` (historique de configuration)
- `02_Redemarrage_Supprimer_DCONF.md` (etapes de reset/reboot)
- `03_Console_TTY_Cinnamon.md` (operations en console)
- `04_Console_TTY_Cinnamon_Suite.md` (suite incident et correction)
- `02_Contexte_Diagnostic_Procedure/` (documentation finale structuree)

## Documentation finale (detail)

- `02_Contexte_Diagnostic_Procedure/00_Index.md`
- `02_Contexte_Diagnostic_Procedure/01_Contexte_Incident_Et_Symptomes.md`
- `02_Contexte_Diagnostic_Procedure/02_Diagnostic_Technique_Et_Causes_Racines.md`
- `02_Contexte_Diagnostic_Procedure/03_Procedure_Stabilisation_Pas_A_Pas.md`
- `02_Contexte_Diagnostic_Procedure/04_Scripts_Usage_Check_Backup_Restore_Reset.md`
- `02_Contexte_Diagnostic_Procedure/05_Validation_Post_Reboot_Et_Criteres_OK.md`
- `02_Contexte_Diagnostic_Procedure/06_Runbook_Recovery_TTY_Urgence.md`
- `02_Contexte_Diagnostic_Procedure/07_Annexe_Chronologie_Compte_Rendu.md`
- `02_Contexte_Diagnostic_Procedure/08_Memo_Quotidien_1_Page.md`

## Scripts operatoires

```bash
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check
~/01_Infra/02_Scripts/01_Cinnamon/save_dconf_cinnamon.sh
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh check
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh restart
```

## Etat actuel

- Stabilisation validee.
- 2 panels persistants.
- Procedure de maintenance disponible et documentee.
