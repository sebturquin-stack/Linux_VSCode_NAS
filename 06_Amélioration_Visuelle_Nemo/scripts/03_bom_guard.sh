#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-$PWD}"
MODE="${2:---check}"

# Extensions consideres comme sensibles a BOM
is_target() {
  case "$1" in
    *.sh|*.service|*.timer|*.conf|*.desktop|*.yml|*.yaml|*.json|*.toml|*.env)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

count=0
changed=0

while IFS= read -r -d '' f; do
  if ! is_target "$f"; then
    continue
  fi

  count=$((count+1))
  head3="$(head -c 3 "$f" | od -An -t x1 | tr -d ' \n')"

  if [[ "$head3" == "efbbbf" ]]; then
    echo "BOM: $f"
    if [[ "$MODE" == "--fix" ]]; then
      sed -i '1s/^\xEF\xBB\xBF//' "$f"
      changed=$((changed+1))
    fi
  fi

done < <(find "$ROOT" -type f -print0)

echo "FILES_SCANNED=$count"
echo "FILES_FIXED=$changed"

if [[ "$MODE" == "--check" ]]; then
  echo "Mode check termine. Pour corriger: ./scripts/03_bom_guard.sh <chemin> --fix"
fi
