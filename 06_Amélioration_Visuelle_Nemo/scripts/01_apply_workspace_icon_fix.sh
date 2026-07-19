#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$HOME/03_VSCode_Workspaces}"
ICON_ROOT="$HOME/.local/share/icons/hicolor"

echo "[1/4] Installation des alias MIME pour .code-workspace"
mkdir -p "$ICON_ROOT"
for s in 16 22 24 32 48 64 128; do
  d="$ICON_ROOT/${s}x${s}/mimetypes"
  mkdir -p "$d"
  src="/usr/share/icons/Mint-Y/apps/${s}/vscode.png"
  if [[ -f "$src" ]]; then
    ln -sfn "$src" "$d/application-x-code-workspace.png"
  elif [[ -f /usr/share/icons/Mint-Y/apps/64/vscode.png ]]; then
    ln -sfn /usr/share/icons/Mint-Y/apps/64/vscode.png "$d/application-x-code-workspace.png"
  fi

  if [[ -e "$d/application-x-code-workspace.png" ]]; then
    ln -sfn "$d/application-x-code-workspace.png" "$d/application-x-code-workspace-symbolic.png"
  fi
done

echo "[2/4] Rafraichissement cache icones"
gtk-update-icon-cache -f "$ICON_ROOT" >/dev/null 2>&1 || true

echo "[3/4] Harmonisation des .code-workspace"
if [[ -d "$ROOT" ]]; then
  find -L "$ROOT" -type f -name '*.code-workspace' -print0 | while IFS= read -r -d '' f; do
    # Nettoyage d'anciennes metadonnees, puis override explicite stable
    gio set -t unset "$f" metadata::custom-icon-name 2>/dev/null || true
    gio set -t unset "$f" metadata::custom-icon 2>/dev/null || true
    gio set "$f" metadata::custom-icon-name 'vscode'
  done
fi

echo "[4/4] Nettoyage cache Nemo"
rm -rf "$HOME/.cache/thumbnails/normal" "$HOME/.cache/thumbnails/large" 2>/dev/null || true
nemo -q >/dev/null 2>&1 || true

echo "OK - Correction icones .code-workspace appliquee"
