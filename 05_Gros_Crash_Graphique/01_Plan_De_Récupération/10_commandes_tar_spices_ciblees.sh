#!/usr/bin/env bash
set -euo pipefail

# Commandes TAR ciblees pour spices Cinnamon
CUR_BASE="$HOME/.config/cinnamon/spices"
BAK_BASE="$HOME/.config/cinnamon.bak-2026-07-06-193710/spices"
OUT_BASE="$HOME/01_Infra/06_Services/06_Backups/Local_Staging"
TS="$(date +%F-%H%M%S)"

# 1) Sauvegarde SECURITE des fichiers ACTUELS qui diffèrent
#    (a faire avant toute restauration)
tar -czf "$OUT_BASE/spices_current_diff_only_${TS}.tar.gz" -C "$CUR_BASE" -T \
"/run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/05_Gros_Crash_Graphique/01_Plan_De_Récupération/08_spices_diff_files.txt"

# 2) Archive BACKUP des fichiers qui diffèrent (candidats restauration fine)
tar -czf "$OUT_BASE/spices_backup_diff_only_${TS}.tar.gz" -C "$BAK_BASE" -T \
"/run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/05_Gros_Crash_Graphique/01_Plan_De_Récupération/08_spices_diff_files.txt"

# 3) Archive BACKUP des fichiers absents de l'actuel
#    (plugins/instances presents dans backup mais pas aujourd'hui)
tar -czf "$OUT_BASE/spices_backup_absent_current_${TS}.tar.gz" -C "$BAK_BASE" -T \
"/run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/05_Gros_Crash_Graphique/01_Plan_De_Récupération/09_spices_absent_current_files.txt"

# 4) Dry-run de verification du contenu des archives
tar -tzf "$OUT_BASE/spices_current_diff_only_${TS}.tar.gz" | head -n 50
tar -tzf "$OUT_BASE/spices_backup_diff_only_${TS}.tar.gz" | head -n 50
tar -tzf "$OUT_BASE/spices_backup_absent_current_${TS}.tar.gz" | head -n 80
