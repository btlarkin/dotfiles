#!/usr/bin/env bash
set -euo pipefail
# Usage: devnew.sh <template> <target-dir>
DEVENV="$HOME/DevEnv"
TEMPLATES="$DEVENV/templates"
TARGET="$HOME/projects/$2"

if [ $# -ne 2 ]; then
  cat <<-USAGE
Usage:
  $(basename $0) project "<Project Title>"
  $(basename $0) roadmap-builder <dir-name>
USAGE
  exit 1
fi

tpl=$1; name=$2

case $tpl in
  project)
    # 1) Scaffold vanilla project
    "$DEVENV/scripts/new_project.sh" "$*"
    slug=$(echo "$*" | tr '[:upper:]' '[:lower:]' \
      | sed -E 's/[^a-z0-9]+/-/g; s/^-|-$//g')
    cd ~/projects/"$slug"

    # 2) Launch with tmuxp & Obsidian
    "$DEVENV/scripts/launch_project.sh" .tmuxp.yaml "$slug"
    obsidian ~/workspace/DevAccelerator/03_Projects/"$slug".md &>/dev/null &
    ;;

  roadmap-builder)
    # 1) Copy roadmap template
    cp -R "$TEMPLATES/custom-roadmap-builder" "$TARGET"
    cd "$TARGET"

    # 2) Exec perms & seed config
    chmod +x build.zsh gist.zsh
    [[ -f config.json ]] || cp config.json.sample config.json

    # 3) Initial build
    ./build.zsh || echo "⚠️  Skipped build; install deps first"

    # 4) Launch tmuxp session
    "$DEVENV/scripts/launch_project.sh" .tmuxp/roadmap.yaml "$name"
    ;;

  *)
    echo "Unknown template: $tpl" >&2
    exit 1;;
esac
