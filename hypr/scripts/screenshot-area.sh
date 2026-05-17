#!/usr/bin/env bash

set -u

screenshot_dir="$HOME/Screen Shot"
screenshot_path="$screenshot_dir/$(date +'%Y-%m-%d_%H-%M-%S').png"

mkdir -p "$screenshot_dir"

if grimblast --freeze --notify copysave area "$screenshot_path"; then
  exit 0
fi

notify-send "Screenshot failed" "Area capture did not complete"
exit 1
