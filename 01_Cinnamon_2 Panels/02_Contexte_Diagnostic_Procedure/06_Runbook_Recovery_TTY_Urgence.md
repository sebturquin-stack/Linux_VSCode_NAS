# 06 - Runbook Recovery TTY Urgence

## Quand utiliser ce runbook

- Ecran graphique fige.
- Panels absents et session instable.
- Relance Cinnamon impossible depuis terminal graphique.

## Regles de securite

- Ne pas lancer de commandes destructrices hors sequence.
- Toujours prendre une sauvegarde si le desktop est encore accessible.
- Prioriser la restauration minimale.

## Procedure TTY standard

### 1) Basculer en TTY

- `Ctrl+Alt+F2`
- login utilisateur

### 2) Verifier contexte systeme

```bash
whoami
loginctl list-sessions
```

### 3) Option soft: revenir a session graphique

```bash
sudo systemctl restart display-manager
```

### 4) Option hard: reboot propre

```bash
sudo reboot
```

## Procedure de reconstruction config (dernier recours)

### 1) Sauvegarde (si possible avant incident)

```bash
~/01_Infra/02_Scripts/01_Cinnamon/save_dconf_cinnamon.sh
```

### 2) Restauration d'une baseline connue

```bash
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh restore /run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/00_Cinnamon_Backup_DCONF/dconf_cinnamon_backup_YYYY-MM-DD_HHMMSS.ini
```

### 3) Reconnexion session

- logout/login ou reboot.

### 4) Verification immediate

```bash
~/01_Infra/02_Scripts/01_Cinnamon/cinnamon_panels_doctor.sh check
```

## Post-mortem minimal

Documenter:

- commande executee juste avant incident
- message d'erreur exact
- comportement visuel
- resultat doctor apres recovery

## Escalade

Si 2 recoveries consecutives echouent:

1. figer les manipulations
2. collecter sorties de diagnostic
3. analyser avant nouvelle action
