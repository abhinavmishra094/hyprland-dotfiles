#!/bin/bash

MONITOR="DP-2"
CURRENT_FORMAT=$(hyprctl monitors -j | jq -r ".[] | select(.name==\"$MONITOR\") | .currentFormat")

echo "Current format: $CURRENT_FORMAT"

if [[ "$CURRENT_FORMAT" == "XRGB2101010" ]]; then
    echo "Disabling HDR..."
    hyprctl keyword monitor "$MONITOR,highrr,0x0,1.0,vrr,3"
else
    echo "Enabling HDR..."
    hyprctl keyword monitor "$MONITOR,highrr,0x0,1.0,bitdepth,10,cm,hdr,sdrbrightness, 1.1, sdrsaturation, 1.3,vrr,3"
fi
