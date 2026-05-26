#!/usr/bin/env bash
set -euo pipefail

direction="${1:-}"
case "$direction" in
  up|down|left|right) ;;
  *) exit 2 ;;
esac

move_window() {
  hyprctl dispatch "hl.dsp.window.move({ direction = \"$direction\" })"
}

active_json="$(hyprctl activewindow -j)"
monitor_id="$(jq -r '.monitor // empty' <<<"$active_json")"

if [[ -z "$monitor_id" ]]; then
  move_window
  exit 0
fi

should_block="$(
  jq -r --argjson win "$active_json" --argjson monitor_id "$monitor_id" '
    ($win.fullscreen // 0) as $fullscreen
    | ($win.fullscreenClient // 0) as $fullscreen_client
    | ($win.contentType // "") as $content_type
    | ($win.class // "") as $class
    | ($win.initialClass // "") as $initial_class
    | ($class | test("^(steam_app_|gamescope$)"; "i")) as $known_game_class
    | ($initial_class | test("^(steam_app_|gamescope$)"; "i")) as $known_game_initial_class
    | if ($fullscreen != 0)
        or ($fullscreen_client != 0)
        or ($content_type == "game")
        or $known_game_class
        or $known_game_initial_class
      then "yes"
      else "no"
      end
  ' < <(hyprctl monitors -j)
)"

if [[ "$should_block" == "yes" ]]; then
  exit 0
fi

move_window
