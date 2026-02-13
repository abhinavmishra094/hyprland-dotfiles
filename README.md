# Hyprland Dotfiles

A comprehensive Hyprland configuration featuring a modular setup with multiple application launchers, a customizable status bar, notification daemon, and various theming options.

## 📸 Preview

![Hyprland Setup](https://via.placeholder.com/800x450.png?text=Add+Your+Screenshot+Here)

## 🚀 Components

### Core
- **Hyprland** - Dynamic tiling Wayland compositor
- **Hyprpaper** - Wallpaper utility
- **Hyprlock** - Screen locker
- **Hypridle** - Idle management daemon

### Application Launchers
- **Rofi** - Highly configurable application launcher with multiple themes:
  - Android-style launchers
  - Applets (volume, brightness, battery, network, etc.)
  - Spotlight-style search
  - Power menus
  - Custom themes (Arc, Nord, Catppuccin, Material, Gruvbox)
- **Wofi** - Wayland-native application launcher

### Status Bar
- **Waybar** - Highly customizable status bar with:
  - Hyprland workspaces
  - Window title
  - System tray
  - Clock with calendar
  - PulseAudio (volume control)
  - Microphone control
  - Weather script

### Notifications
- **Dunst** - Lightweight notification daemon

### Terminal
- **Kitty** - GPU-based terminal emulator with Nord theme

## 📁 Structure

```
.
├── hypr/
│   ├── hyprland.conf      # Main configuration
│   ├── env.conf           # Environment variables
│   ├── exec.conf          # Autostart applications
│   ├── keybinds.conf      # Key bindings
│   ├── monitor.conf       # Monitor configuration
│   ├── windowrules.conf   # Window rules
│   ├── animations.conf    # Animation settings
│   ├── decoration.conf    # Window decorations
│   └── ...                # Additional modular configs
├── waybar/
│   ├── config.jsonc       # Waybar configuration
│   ├── style.css          # Waybar styling
│   └── scripts/
│       └── waybar-wttr.py # Weather script
├── rofi/
│   ├── config.rasi        # Main Rofi config
│   ├── themes/            # Theme collection
│   ├── applets/           # Various applets
│   ├── bin/               # Launcher scripts
│   └── scripts/           # Utility scripts
├── wofi/
│   ├── config             # Wofi configuration
│   └── style.css          # Wofi styling
├── dunst/
│   └── dunstrc            # Dunst configuration
└── kitty/
    ├── kitty.conf         # Kitty terminal config
    └── nord.conf          # Nord color scheme
```

## ⚙️ Installation

### Prerequisites

Install required packages:

```bash
# Arch Linux (using yay)
yay -S hyprland hyprpaper hyprlock hypridle waybar rofi-wayland wofi dunst kitty

# Additional dependencies
yay -S wl-clipboard swww wlsunset waypaper copyq

# Optional but recommended
yay -S polkit-kde-agent gnome-keyring blueman network-manager-applet
```

### Clone and Setup

```bash
# Backup existing configs
mv ~/.config/hypr ~/.config/hypr.bak
mv ~/.config/waybar ~/.config/waybar.bak
mv ~/.config/rofi ~/.config/rofi.bak
mv ~/.config/wofi ~/.config/wofi.bak
mv ~/.config/dunst ~/.config/dunst.bak
mv ~/.config/kitty ~/.config/kitty.bak

# Clone repository
cd ~/.config
git clone https://github.com/abhinavmishra094/hyprland-dotfiles.git temp

# Copy configs
cp -r temp/hypr temp/waybar temp/rofi temp/wofi temp/dunst temp/kitty .

# Clean up
rm -rf temp
```

Or manually copy individual directories as needed.

## ⌨️ Key Bindings

Default modifier key: `SUPER` (Windows/Super key)

### Window Management
- `SUPER + Q` - Close window
- `SUPER + M` - Exit Hyprland
- `SUPER + V` - Toggle floating
- `SUPER + R` - Toggle split orientation
- `SUPER + P` - Toggle pseudo-tiling

### Navigation
- `SUPER + H/J/K/L` - Move focus
- `SUPER + SHIFT + H/J/K/L` - Move window
- `SUPER + 1-9` - Switch to workspace
- `SUPER + SHIFT + 1-9` - Move window to workspace

### Launchers
- `SUPER + Space` - Application launcher (Rofi)
- `SUPER + Return` - Terminal (Kitty)
- `SUPER + E` - File manager
- `SUPER + B` - Browser

### System
- `SUPER + L` - Lock screen (Hyprlock)
- `SUPER + SHIFT + E` - Power menu
- `Print` - Screenshot
- `SUPER + SHIFT + S` - Screenshot region

### Media Controls
- `XF86AudioRaiseVolume` - Volume up
- `XF86AudioLowerVolume` - Volume down
- `XF86AudioMute` - Mute
- `XF86AudioPlay` - Play/Pause
- `XF86AudioNext` - Next track
- `XF86AudioPrev` - Previous track

## 🎨 Theming

### Rofi Themes
Multiple theme options available in `rofi/themes/` and `rofi/applets/styles/`:
- **Nord** - Arctic-inspired color palette
- **Catppuccin** - Soothing pastel theme
- **Gruvbox** - Retro groove color scheme
- **Material** - Material design colors
- **Arc** - Arc GTK theme colors

To switch themes, modify the `@import` line in `rofi/config.rasi`.

### Waybar Styling
Edit `waybar/style.css` to customize the status bar appearance.

## 🔧 Customization

### Monitor Configuration
Edit `hypr/monitor.conf`:
```conf
monitor = DP-1, 1920x1080@144, 0x0, 1
monitor = HDMI-A-1, 1920x1080@60, 1920x0, 1
```

### Autostart Applications
Edit `hypr/exec.conf` to add/remove startup applications.

### Window Rules
Edit `hypr/windowrules.conf` for application-specific settings:
```conf
windowrule = float, ^(pavucontrol)$
windowrule = size 800 600, ^(pavucontrol)$
windowrule = workspace 2, ^(firefox)$
```

## 📦 Dependencies

### Required
- `hyprland` - Window manager
- `waybar` - Status bar
- `kitty` - Terminal emulator
- `dunst` - Notifications
- `rofi-wayland` or `wofi` - Application launcher

### Optional
- `hyprpaper` / `swww` - Wallpaper
- `hyprlock` - Screen locker
- `hypridle` - Idle daemon
- `wl-clipboard` - Clipboard manager
- `wlsunset` - Blue light filter
- `waypaper` - Wallpaper GUI
- `polkit-kde-agent` - Authentication agent
- `gnome-keyring` - Keyring daemon
- `copyq` - Clipboard manager

## 🤝 Contributing

Feel free to fork this repository and submit pull requests for improvements.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Hyprland](https://hyprland.org/) - The amazing Wayland compositor
- [Rofi](https://github.com/davatorium/rofi) - Application launcher
- [Waybar](https://github.com/Alexays/Waybar) - Status bar
- [Catppuccin](https://catppuccin.com/) - Color schemes
- [Nord](https://www.nordtheme.com/) - Arctic color palette

---

**Note**: This is a personal configuration. You may need to adjust paths and settings to match your system setup.
