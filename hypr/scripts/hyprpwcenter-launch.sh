#!/bin/bash
# Launch script for hyprpwcenter - prevents multiple instances

# Check if hyprpwcenter is already running
if hyprctl clients -j | jq -e '.[] | select(.class == "hyprpwcenter")' > /dev/null 2>&1; then
    # Window exists, close it (toggle behavior)
    hyprctl dispatch closewindow "class:hyprpwcenter"
else
    # Window doesn't exist, launch it
    hyprpwcenter
fi
