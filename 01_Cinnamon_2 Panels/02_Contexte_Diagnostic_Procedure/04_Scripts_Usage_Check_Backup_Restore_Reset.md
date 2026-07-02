# 04 - Scripts Usage Check Backup Restore Reset

## Inventaire scripts

| Script                    | Emplacement | Role                             |
|---------------------------|-------------|----------------------------------|
| save_dconf_cinnamon.sh    | `~/Scripts` | Sauvegarde simple DCONF Cinnamon |
| cinnamon_panels_doctor.sh | `~/Scripts` | Check / backup / restore         |
| reset_cinnamon_safe.sh    | `~/Scripts` | Relance Cinnamon securisee       |

## Script 1 - save_dconf_cinnamon.sh

### Fonction

- Dump complet de `/org/cinnamon/` vers `00_Cinnamon_Backup_DCONF/`.

### Commande

```bash
~/01_Infra/02_Scripts/01_Cinnamon/save_dconf_cinnamon.sh
```

### Sortie attendue

- Message de confirmation avec timestamp.
- Fichier backup cree.

## Script 2 - cinnamon_panels_doctor.sh

### Modes

```bash
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh backup
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh restore /chemin/backup.ini
```

### Check: controles effectues

- Presence du bus DBus utilisateur.
- Etat de `dconf.service` utilisateur.
- Presence de 2 panels minimum.
- Presence d'applets referencees.

### Restore: comportement de securite

- Fait une sauvegarde automatique avant restauration.
- Charge le fichier backup cible dans `/org/cinnamon/`.

## Script 3 - reset_cinnamon_safe.sh

### Modes 1.0

```bash
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh check
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh restart
~/01_Infra/02_Scripts/01_Cinnamon/reset_cinnamon_safe.sh restart --no-backup
```

### Garanties

- Verifie le contexte X-Cinnamon avant relance.
- Sauvegarde DCONF automatique (sauf `--no-backup`).
- Relance `cinnamon --replace` proprement en arriere-plan.

### Journal

- Fichier log: `/tmp/reset_cinnamon_safe.log`

## Scripts (reference code)

### save_dconf_cinnamon.sh

```bash
#!/bin/bash
set -euo pipefail
timestamp=$(date +%F_%H%M%S)
backup_dir="${CINNAMON_BACKUP_DIR:-/run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/00_Cinnamon_Backup_DCONF}"
mkdir -p "$backup_dir"
dconf dump /org/cinnamon/ > "$backup_dir/dconf_cinnamon_backup_${timestamp}.ini"
echo "Sauvegarde DCONF Cinnamon effectuee a $timestamp"
```

### Note de fiabilite

Les scripts ont ete corriges pour supprimer le BOM UTF-8 en tete de fichier afin d'eviter les erreurs shebang.
