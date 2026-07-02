# 08 - Memo Quotidien 1 Page

## Objectif

Avoir une procedure ultra-courte, fiable et repetable pour verifier, sauvegarder, restaurer et relancer Cinnamon sans retomber dans les blocages precedents.

## Routine quotidienne (2 minutes)

1. Ouvrir un terminal dans la session graphique Cinnamon.
2. Lancer:

```bash
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_daily_check.sh
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check
```

1. Si verdict OK: ne rien changer.
2. Si modification prevue: faire une sauvegarde.

## Avant toute modification

```bash
~/01_Infra/02_Scripts/01_Cinnamon/save_dconf_cinnamon.sh
```

Resultat attendu: un fichier `dconf_cinnamon_backup_YYYY-MM-DD_HHMMSS.ini` dans `00_Cinnamon_Backup_DCONF/`.

## Verification rapide de persistance

```bash
gsettings get org.cinnamon panels-enabled
gsettings get org.cinnamon enabled-applets
dconf dump /org/cinnamon/ | grep -E 'panels-enabled|enabled-applets'
```

Resultat attendu:

- 2 panels definis
- applets panel1 et panel2 presentes
- lignes non vides

## Relance Cinnamon sans casse

```bash
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh check
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh restart
```

Option sans backup automatique:

```bash
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh restart --no-backup
```

## Restauration d'une baseline

```bash
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh restore /home/sebastien/01_Infra/06_Services/06_Backups/Local_Staging/dconf_cinnamon_backup_YYYY-MM-DD_HHMMSS.ini
```

Puis: deconnexion/reconnexion ou reboot.

## Check post-reboot

```bash
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check
```

Critere OK:

- DCONF actif
- 2 panels detectes
- applets detectees

## Escalade TTY (si session graphique bloquee)

1. `Ctrl+Alt+F2`
2. Login utilisateur
3. `sudo systemctl restart display-manager`
4. Si echec: `sudo reboot`

## Anti-erreurs a retenir

- Toujours verifier depuis une session Cinnamon active.
- Eviter les commandes de reset en boucle sans diagnostic.
- Conserver au moins une sauvegarde valide recente.

## Commandes reference

```bash
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh backup
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh restore /chemin/backup.ini
~/01_Infra/02_Scripts/01_Cinnamon/save_dconf_cinnamon.sh
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh check
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh restart
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_daily_check.sh
```
