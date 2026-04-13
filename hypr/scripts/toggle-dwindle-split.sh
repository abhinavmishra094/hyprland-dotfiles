#!/bin/bash

# Toggle dwindle split direction between horizontal and vertical
# split_bias values: 0 = auto, 1 = vertical, 2 = horizontal

# Get current split_bias value
CURRENT_BIAS=$(hyprctl getoption dwindle:split_bias -j 2>/dev/null | jq -r '.int // 0')

if [ "$CURRENT_BIAS" = "1" ]; then
    # Currently vertical, switch to horizontal
    hyprctl keyword dwindle:split_bias 2
    notify-send "Dwindle Split" "Changed to Horizontal"
else
    # Currently horizontal or auto, switch to vertical
    hyprctl keyword dwindle:split_bias 1
    notify-send "Dwindle Split" "Changed to Vertical"
fi
