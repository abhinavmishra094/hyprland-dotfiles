#!/bin/bash

# Set layout with notification
LAYOUT=$1

hyprctl keyword general:layout "$LAYOUT"
notify-send "Layout Changed" "Switched to: ${LAYOUT^}"
