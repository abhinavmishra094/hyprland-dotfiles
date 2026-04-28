#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_NAME="$(basename "$0")"

log() {
  printf '[%s] %s\n' "$SCRIPT_NAME" "$*"
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf '[%s] error: missing required command: %s\n' "$SCRIPT_NAME" "$1" >&2
    exit 1
  }
}

main() {
  require_cmd flatpak

  log "Applying user Flatpak theme overrides for GTK and cross-version Qt"
  flatpak override --user \
    --unset-env=QT_QPA_PLATFORMTHEME \
    --filesystem=xdg-config/gtk-3.0:ro \
    --filesystem=xdg-config/gtk-4.0:ro \
    --filesystem=xdg-config/qt5ct:ro \
    --filesystem=xdg-config/qt6ct:ro \
    --filesystem=xdg-config/kdeglobals:ro \
    --filesystem=~/.themes:ro \
    --filesystem=~/.icons:ro \
    --filesystem=xdg-data/themes:ro \
    --filesystem=xdg-data/icons:ro \
    --env=GTK_APPLICATION_PREFER_DARK_THEME=1 \
    --env=GTK_USE_PORTAL=1 \
    --env=XDG_CURRENT_DESKTOP=Hyprland \
    --env=XDG_SESSION_DESKTOP=Hyprland \
    --env=QT_QPA_PLATFORMTHEME=gtk3 \
    --unset-env=GTK_THEME \
    --unset-env=QT_STYLE_OVERRIDE

  log "Removing unused Kvantum Flatpak overrides"
  flatpak override --user \
    --nofilesystem=xdg-config/Kvantum \
    --unset-env=QT_STYLE_OVERRIDE

  log "Flatpak theme overrides updated"
}

main "$@"
