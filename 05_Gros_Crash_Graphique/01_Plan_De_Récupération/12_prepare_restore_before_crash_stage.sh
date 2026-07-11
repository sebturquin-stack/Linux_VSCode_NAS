#!/usr/bin/env bash
set -euo pipefail

STAGE_DIR="${1:-/home/sebastien/07_restore_before_crash_stage}"
CONFIG_BAK="/home/sebastien/.config/cinnamon.bak-2026-07-06-193710"
LOCAL_BAK="/home/sebastien/.local/share/cinnamon.bak-2026-07-06-193710"
HOME_SRC="/home/sebastien"

echo "[1/5] Preparation du stage: $STAGE_DIR"
mkdir -p "$STAGE_DIR/.config" "$STAGE_DIR/.local/share"

echo "[2/5] Injection du backup historique .config/cinnamon"
rsync -a --delete "$CONFIG_BAK/" "$STAGE_DIR/.config/cinnamon/"

echo "[3/5] Injection du backup historique .local/share/cinnamon"
rsync -a --delete "$LOCAL_BAK/" "$STAGE_DIR/.local/share/cinnamon/"

echo "[4/5] Copie des themes et icones actuels"
mkdir -p "$STAGE_DIR/.themes" "$STAGE_DIR/.icons"
rsync -a --delete "$HOME_SRC/.themes/" "$STAGE_DIR/.themes/"
rsync -a --delete "$HOME_SRC/.icons/" "$STAGE_DIR/.icons/"

echo "[5/5] Resume du stage"
find "$STAGE_DIR" -maxdepth 4 \( -type d -o -type f \) | sort | sed -n '1,200p'

echo "Stage pret. Dry-run conseille:"
echo "rsync -aAXHvin --delete --filter=\"merge /run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS/05_Gros_Crash_Graphique/01_Plan_De_Récupération/11_filtre_cinnamon_avant_crash_agressif.rsync-filter\" \"$STAGE_DIR/\" /home/sebastien/"
