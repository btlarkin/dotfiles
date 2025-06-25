#!/bin/bash

# --- Project Launcher Script ---

# Get the name of the current directory (which is your project name)
PROJECT_NAME=$(basename "$(pwd)")

echo "Launching tmuxp session for project: $PROJECT_NAME"

# Check if a tmux server is running. If not, start it explicitly.
# This helps ensure tmux is ready before tmuxp tries to interact with it.
if ! tmux info &> /dev/null; then
    echo "No tmux server running. Starting a new one."
    tmux start-server
    sleep 0.5 # Give the server a moment to fully start
fi

# Check if the session already exists
if tmux has-session -t "$PROJECT_NAME" 2>/dev/null; then
    echo "Session '$PROJECT_NAME' already exists. Attaching to it."
    tmux attach-session -t "$PROJECT_NAME"
    exit 0
fi

# Use tmuxp load to create the session.
# -y: automatically answer yes to prompts
# -d: don't attach immediately
# -s "$PROJECT_NAME": explicitly set the session name, overriding any in the YAML
# .tmuxp.yaml: This is the required positional argument specifying the config file.
tmuxp load -y -d -s "$PROJECT_NAME" .tmuxp.yaml

# Now, attach to the newly created session.
# If already in a tmux session, switch to the new one. Otherwise, attach.
if [[ -z "$TMUX" ]]; then
    tmux attach-session -t "$PROJECT_NAME"
else
    tmux switch-client -t "$PROJECT_NAME"
fi

if [ $? -ne 0 ]; then
    echo "Failed to load tmuxp or attach to session. Check logs for errors."
    echo "Also verify your .tmuxp.yaml for any syntax errors."
fi

