#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$HOME/03_VSCode_Workspaces}"

echo "=== Audit visuel .code-workspace ==="
echo "Date: $(date '+%F %T')"

echo
echo "[Theme]"
gsettings get org.cinnamon.desktop.interface icon-theme || true

echo
echo "[Lookup GTK]"
python3 - <<'PY'
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk
th = Gtk.IconTheme.get_default()
for n in ['application-x-code-workspace', 'application-x-code-workspace-symbolic', 'vscode']:
    i = th.lookup_icon(n, 64, 0)
    print(f"{n}: {i.get_filename() if i else 'NOT_FOUND'}")
PY

echo
echo "[Fichiers .code-workspace]"
find -L "$ROOT" -type f -name '*.code-workspace' -print0 | while IFS= read -r -d '' f; do
  echo "# $f"
  gio info "$f" | grep -E 'standard::content-type|metadata::custom-icon-name|standard::icon' || true
  echo
done

echo "=== Fin audit ==="
