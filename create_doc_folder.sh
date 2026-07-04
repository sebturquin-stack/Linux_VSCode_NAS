#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage:
  ./create_doc_folder.sh <dossier> [--with-captures|--no-captures]

Examples:
  ./create_doc_folder.sh 05_Nouveau_Sujet --with-captures
  ./create_doc_folder.sh 06_Autre_Sujet --no-captures
  ./create_doc_folder.sh 07_Tests

Behavior:
  - Cree le dossier cible s'il n'existe pas.
  - Si aucune option n'est passee, demande interactivement si un dossier captures doit etre cree.
  - Le dossier de captures cree est: <dossier>/assets
EOF
}

if [[ ${1:-} == "-h" || ${1:-} == "--help" || $# -lt 1 ]]; then
  usage
  exit 0
fi

target_dir="$1"
mode="ask"

if [[ ${2:-} == "--with-captures" ]]; then
  mode="with"
elif [[ ${2:-} == "--no-captures" ]]; then
  mode="without"
elif [[ $# -ge 2 ]]; then
  echo "Option non reconnue: $2" >&2
  usage
  exit 1
fi

mkdir -p "$target_dir"
echo "Dossier cree/valide: $target_dir"

create_assets="no"

if [[ "$mode" == "with" ]]; then
  create_assets="yes"
elif [[ "$mode" == "without" ]]; then
  create_assets="no"
else
  read -r -p "Associer un dossier captures (assets) ? [y/N] " answer
  case "$answer" in
    y|Y|yes|YES) create_assets="yes" ;;
    *) create_assets="no" ;;
  esac
fi

if [[ "$create_assets" == "yes" ]]; then
  mkdir -p "$target_dir/assets"
  echo "Dossier captures cree: $target_dir/assets"
else
  echo "Aucun dossier captures cree."
fi
