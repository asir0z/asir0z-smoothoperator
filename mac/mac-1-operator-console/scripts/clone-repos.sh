#!/usr/bin/env bash
# MAC-1 — Clone canonical operator repositories into ~/Projects
set -euo pipefail

PROJECTS="${PROJECTS_DIR:-$HOME/Projects}"
ORG="${GITHUB_ORG:-asir0z}"

# name|required(yes/no)|notes
REPOS=(
  "asir0z-smoothoperator|yes|primary SmoothOperator™ repo"
  "asir0z-devopslab|yes|production infrastructure laboratory"
  "asir0z-web|yes|product site"
  "asir0z-product-intelligence|yes|product intelligence"
  "asir0z-project-pulse|no|optional — skip if remote missing"
  "asir0z-cortex|no|deferred until GitHub repo restored"
)

mkdir -p "$PROJECTS"
cd "$PROJECTS"

remote_for() {
  local name="$1"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    echo "git@github.com:${ORG}/${name}.git"
  elif [[ -f "$HOME/.ssh/id_ed25519" ]] || [[ -f "$HOME/.ssh/id_rsa" ]]; then
    echo "git@github.com:${ORG}/${name}.git"
  else
    echo "https://github.com/${ORG}/${name}.git"
  fi
}

remote_exists() {
  local url="$1"
  git ls-remote --exit-code "$url" HEAD >/dev/null 2>&1
}

echo "Projects root: $PROJECTS"

for entry in "${REPOS[@]}"; do
  IFS='|' read -r name required note <<<"$entry"
  dest="$PROJECTS/$name"
  url="$(remote_for "$name")"

  if [[ -d "$dest/.git" ]]; then
    echo "OK   $name (already cloned)"
    continue
  fi

  if ! remote_exists "$url"; then
    if [[ "$required" == "yes" ]]; then
      echo "FAIL $name — remote not reachable: $url" >&2
      exit 1
    fi
    echo "SKIP $name — $note"
    continue
  fi

  echo "CLONE $name ← $url"
  git clone "$url" "$dest"
done

echo
echo "Workspace:"
ls -1 "$PROJECTS"
