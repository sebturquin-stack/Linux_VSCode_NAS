# 03 - Scripts utilises

## 1) Script d'application

Fichier: `scripts/01_apply_workspace_icon_fix.sh`

Role:

- installe les alias d'icone MIME pour `.code-workspace`
- cree aussi la variante `application-x-code-workspace-symbolic`
- nettoie les anciens overrides
- force `metadata::custom-icon-name=vscode` sur les fichiers cibles
- rafraichit cache icones + Nemo

Execution:

```bash
./scripts/01_apply_workspace_icon_fix.sh
# ou avec racine personnalisee
./scripts/01_apply_workspace_icon_fix.sh /home/sebastien/03_VSCode_Workspaces
```

## 2) Script d'audit

Fichier: `scripts/02_audit_workspace_icons.sh`

Role:

- lit le theme actif
- verifie le lookup GTK des icones critiques
- audite chaque `.code-workspace` (MIME + icone custom)

Execution:

```bash
./scripts/02_audit_workspace_icons.sh
./scripts/02_audit_workspace_icons.sh > reports/$(date +%F)_audit_visuel_nemo.txt
```

## 3) Script deja en place (hors Nemo)

Fichier: `../03_Gestion_des_MAJ_sous_Linux_Mint/01_Strategie_MAJ_Automatisation/scripts/linux_maj_reminder.sh`

Role:

- rappel persistant Mardi/Samedi pour routine MAJ
- complete la stabilite globale (maintenance + visuel)

## 4) Script anti-BOM

Fichier: `scripts/03_bom_guard.sh`

Role:

- detecte les fichiers sensibles contenant un BOM
- peut corriger automatiquement le BOM en tete de fichier

Execution:

```bash
./scripts/03_bom_guard.sh <chemin> --check
./scripts/03_bom_guard.sh <chemin> --fix
```
