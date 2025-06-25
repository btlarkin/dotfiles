#!/usr/bin/env bash
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "Usage: new_project.sh \"<Project Title>\""
  exit 1
fi

# Paths (adjust if you wish)
VAULT_ROOT="$HOME/workspace/DevAccelerator"
TEMPLATE_DIR="$VAULT_ROOT/11_Project_Templates/VanillaWebProject"
PROJECTS_DIR="$HOME/projects"
KANBAN_FILE="$VAULT_ROOT/00_Roadmap_Kanban.md"
OBSIDIAN_NOTE_DIR="$VAULT_ROOT/03_Projects"

TITLE="$1"
SLUG=$(echo "$TITLE" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-|-$//g')

PROJECT_PATH="$PROJECTS_DIR/$SLUG"
NOTE_PATH="$OBSIDIAN_NOTE_DIR/$SLUG.md"

# 1) Copy skeleton
rm -rf "$PROJECT_PATH"
cp -r "$TEMPLATE_DIR" "$PROJECT_PATH"

# 2) Git init
cd "$PROJECT_PATH"
rm -rf .git
git init && git add . && git commit -m "chore: scaffold '$TITLE'"

# 3) Create note
mkdir -p "$OBSIDIAN_NOTE_DIR"
cat > "$NOTE_PATH" <<EOF
---
title: "$TITLE"
date: $(date +%F)
tags: [project]
---

# $TITLE

## Overview

## Tasks

- [ ] Kickoff
EOF

# 4) Update Kanban
echo "- [ ] $TITLE" >> "$KANBAN_FILE"

echo "✅ Project '$TITLE' scaffolded."

# 5) Open note
obsidian "$NOTE_PATH" &>/dev/null &

