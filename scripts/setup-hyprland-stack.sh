#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_NAME="$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(realpath -m "$SCRIPT_DIR/..")"
SOURCE_CONFIG_ROOT="${SOURCE_CONFIG_ROOT:-$REPO_ROOT}"
TARGET_CONFIG_ROOT="${TARGET_CONFIG_ROOT:-$HOME/.config}"
BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.config-backups/hyprland-setup-$(date +%Y%m%d-%H%M%S)}"
STAGING_ROOT=""

OFFICIAL_PACKAGES=(
  awww
  base-devel
  bitwarden
  blueman
  copyq
  dunst
  gnome-keyring
  grim
  hypridle
  hyprland
  hyprlock
  hyprpicker
  jq
  kitty
  kvantum
  libnotify
  matugen
  network-manager-applet
  noto-fonts-emoji
  nwg-look
  openrgb
  polkit-kde-agent
  qt5-wayland
  qt5ct
  qt6-wayland
  qt6ct
  rofi
  signal-desktop
  slurp
  sunshine
  ttf-cascadia-code-nerd
  ttf-font-awesome
  ttf-jetbrains-mono-nerd
  waybar
  waypaper
  wayvnc
  wl-clipboard
  wlsunset
  wofi
  xdg-desktop-portal
  xdg-desktop-portal-hyprland
)

AUR_PACKAGES=(
  ferdium-bin
  grimblast-git
  hyprlauncher
  hyprpwcenter
)

CONFIG_DIRS=(
  alacritty
  environment.d
  ghostty
  gtk-3.0
  gtk-4.0
  hypr
  mako
  waybar
  rofi
  sunshine
  swaylock
  swaync
  swayosd
  walker
  wofi
  dunst
  kitty
  matugen
  qt5ct
  qt6ct
  Kvantum
  nwg-look
  waypaper
  wayvnc
  wlogout
  xdg-desktop-portal
)

CONFIG_FILES=(
  kdeglobals
  mimeapps.list
  autostart/bitwarden.desktop
  autostart/com.github.hluk.copyq.desktop
  autostart/ferdium.desktop
  autostart/OpenRGB.desktop
  systemd/user/hyprland-session.target
  systemd/user/sunshine.service
  wayvnc/config.example
)

log() {
  printf '[%s] %s\n' "$SCRIPT_NAME" "$*"
}

warn() {
  printf '[%s] warning: %s\n' "$SCRIPT_NAME" "$*" >&2
}

cleanup() {
  if [[ -n "$STAGING_ROOT" && -d "$STAGING_ROOT" ]]; then
    rm -rf "$STAGING_ROOT"
  fi
}

trap cleanup EXIT

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    printf '[%s] error: missing required command: %s\n' "$SCRIPT_NAME" "$1" >&2
    exit 1
  }
}

detect_aur_helper() {
  local helper
  for helper in yay paru; do
    if command -v "$helper" >/dev/null 2>&1; then
      printf '%s\n' "$helper"
      return 0
    fi
  done
  return 1
}

stage_sources_if_needed() {
  local source_real target_real item source_path staged_parent

  source_real="$(realpath -m "$SOURCE_CONFIG_ROOT")"
  target_real="$(realpath -m "$TARGET_CONFIG_ROOT")"

  if [[ "$source_real" != "$target_real" ]]; then
    return 0
  fi

  STAGING_ROOT="$(mktemp -d)"
  log "Source and target are both $target_real, staging selected config into $STAGING_ROOT"

  for item in "${CONFIG_DIRS[@]}" "${CONFIG_FILES[@]}"; do
    source_path="$SOURCE_CONFIG_ROOT/$item"
    [[ -e "$source_path" ]] || continue
    staged_parent="$STAGING_ROOT/$(dirname "$item")"
    mkdir -p "$staged_parent"
    cp -a "$source_path" "$STAGING_ROOT/$item"
  done

  SOURCE_CONFIG_ROOT="$STAGING_ROOT"
}

backup_existing() {
  local target_path="$1"
  local rel_path="$2"
  local backup_path="$BACKUP_ROOT/$rel_path"

  [[ -e "$target_path" || -L "$target_path" ]] || return 0

  mkdir -p "$(dirname "$backup_path")"
  mv "$target_path" "$backup_path"
  log "Backed up $target_path -> $backup_path"
}

copy_dir() {
  local rel_path="$1"
  local source_path="$SOURCE_CONFIG_ROOT/$rel_path"
  local target_path="$TARGET_CONFIG_ROOT/$rel_path"

  [[ -d "$source_path" ]] || return 0
  backup_existing "$target_path" "$rel_path"
  mkdir -p "$(dirname "$target_path")"
  cp -a "$source_path" "$target_path"
  log "Installed directory $rel_path"
}

copy_file() {
  local rel_path="$1"
  local source_path="$SOURCE_CONFIG_ROOT/$rel_path"
  local target_path="$TARGET_CONFIG_ROOT/$rel_path"

  [[ -e "$source_path" ]] || return 0
  backup_existing "$target_path" "$rel_path"
  mkdir -p "$(dirname "$target_path")"
  cp -a "$source_path" "$target_path"
  log "Installed file $rel_path"
}

install_packages() {
  local aur_helper

  require_cmd pacman
  require_cmd sudo

  log "Installing official packages with pacman"
  sudo pacman -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"

  if aur_helper="$(detect_aur_helper)"; then
    log "Installing AUR packages with $aur_helper"
    "$aur_helper" -S --needed --noconfirm "${AUR_PACKAGES[@]}"
  else
    warn "No AUR helper found. Install these manually if you need them: ${AUR_PACKAGES[*]}"
  fi
}

setup_systemd_user() {
  log "Reloading user systemd units"
  systemctl --user daemon-reload

  log "Enabling gnome-keyring-daemon.socket and hypridle.service"
  systemctl --user enable gnome-keyring-daemon.socket hypridle.service >/dev/null
}

setup_hyprpm() {
  command -v hyprpm >/dev/null 2>&1 || return 0

  if ! hyprpm list 2>/dev/null | grep -q 'Repository hyprland-plugins'; then
    log "Adding hyprland-plugins repository to hyprpm"
    hyprpm add https://github.com/hyprwm/hyprland-plugins || warn "Failed to add hyprland-plugins to hyprpm"
  fi

  log "Ensuring hyprexpo plugin is enabled"
  hyprpm enable hyprexpo || warn "Failed to enable hyprexpo with hyprpm"

  if [[ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
    hyprpm reload || warn "Failed to reload hyprpm state in the current Hyprland session"
  else
    warn "Hyprland is not running, so hyprpm reload was skipped"
  fi
}

apply_initial_theme() {
  local wallpaper

  command -v matugen >/dev/null 2>&1 || return 0

  wallpaper="$HOME/Pictures/674256.png"
  if [[ -f "$wallpaper" ]]; then
    log "Generating initial matugen theme from $wallpaper"
    matugen image "$wallpaper" || warn "matugen failed to generate colors from $wallpaper"
  else
    warn "Wallpaper $wallpaper was not found, skipping initial matugen generation"
  fi
}

main() {
  local dir file

  require_cmd cp
  require_cmd mv
  require_cmd realpath

  stage_sources_if_needed
  install_packages

  log "Copying Hyprland and theming config into $TARGET_CONFIG_ROOT"
  mkdir -p "$TARGET_CONFIG_ROOT"

  for dir in "${CONFIG_DIRS[@]}"; do
    copy_dir "$dir"
  done

  for file in "${CONFIG_FILES[@]}"; do
    copy_file "$file"
  done

  setup_systemd_user
  setup_hyprpm
  apply_initial_theme

  log "Setup complete"
  log "Backups were written to $BACKUP_ROOT"
  log "Log out and back into Hyprland to pick up the full session stack"
}

main "$@"
