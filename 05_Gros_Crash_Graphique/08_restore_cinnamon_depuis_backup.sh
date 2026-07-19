#!/usr/bin/env bash
set -euo pipefail

WORKSPACE_ROOT="/run/user/1000/gvfs/smb-share:server=sebinfranas.local,share=infradata/07_VSCode_Workspaces/05_Linux_VSCode_NAS"
DEFAULT_BACKUP="$WORKSPACE_ROOT/00_Cinnamon_Backup_DCONF/dconf_cinnamon_backup_final.ini"

usage() {
  cat <<'EOF'
Usage:
  bash 05_Gros_Crash_Graphique/08_restore_cinnamon_depuis_backup.sh [--panel-only|--full] [--backup-file <path>]

Modes:
  --panel-only  Restaure uniquement panels + applets + tailles + ids (mode recommande)
  --full        Restaure tout /org/cinnamon/ depuis le fichier INI

Options:
  --backup-file <path>  Fichier dconf .ini source (defaut: dconf_cinnamon_backup_final.ini)

Comportement securise:
  1) Sauvegarde l'etat courant dans 00_Cinnamon_Backup_DCONF/
  2) Applique le restore choisi
  3) Relance Cinnamon
EOF
}

MODE="panel-only"
BACKUP_FILE="$DEFAULT_BACKUP"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --panel-only)
      MODE="panel-only"
      shift
      ;;
    --full)
      MODE="full"
      shift
      ;;
    --backup-file)
      BACKUP_FILE="${2:-}"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Option inconnue: $1" >&2
      usage
      exit 1
      ;;
  esac
done

if [[ ! -f "$BACKUP_FILE" ]]; then
  echo "Backup introuvable: $BACKUP_FILE" >&2
  exit 1
fi

TS="$(date +%F-%H%M%S)"
CUR_BAK="$WORKSPACE_ROOT/00_Cinnamon_Backup_DCONF/dconf_cinnamon_pre_restore_${TS}.ini"

echo "[1/4] Sauvegarde etat courant -> $CUR_BAK"
dconf dump /org/cinnamon/ > "$CUR_BAK"

if [[ "$MODE" == "full" ]]; then
  echo "[2/4] Restore FULL depuis $BACKUP_FILE"
  dconf load /org/cinnamon/ < "$BACKUP_FILE"
else
  echo "[2/4] Restore PANEL-ONLY depuis $BACKUP_FILE"
  TMP_FILE="/tmp/dconf_panel_restore_${TS}.ini"
  {
    echo "[/]"
    awk -F= '
      $1 ~ /^(enabled-applets|next-applet-id|panels-enabled|panels-height|panels-autohide|panels-hide-delay|panels-show-delay|panel-zone-icon-sizes|panel-zone-symbolic-icon-sizes|panel-zone-text-sizes|panel-edit-mode|panel-launchers|no-adjacent-panel-barriers)$/ {
        print $0
      }
    ' "$BACKUP_FILE"
  } > "$TMP_FILE"
  dconf load /org/cinnamon/ < "$TMP_FILE"
  rm -f "$TMP_FILE"
fi

echo "[3/4] Securite icones bureau"
dconf write /org/nemo/desktop/show-desktop-icons true

echo "[4/4] Relance Cinnamon"
nohup cinnamon --replace >/tmp/cinnamon-restore.log 2>&1 &

echo "Termine. Log: /tmp/cinnamon-restore.log"
