local function sh(cmd)
  return hl.dsp.exec_cmd(cmd)
end

local function dispatch(command)
  return sh("hyprctl dispatch " .. command)
end

local function bind(keys, dispatcher, opts)
  hl.bind(keys, dispatcher, opts)
end

local function hyprexpo(action)
  return function()
    if hl.plugin.hyprexpo ~= nil then
      hl.plugin.hyprexpo.expo(action)
    end
  end
end

bind("SUPER + B", sh("firefox"))
bind("SUPER + N", sh("vivaldi"))
bind("SUPER + SHIFT + N", sh("helium-browser"))
bind("SUPER + SHIFT + B", sh("flatpak run com.brave.Browser"))

bind("SUPER + Z", sh("/home/abhinav/.local/bin/zed"))
bind("SUPER + C", sh("google-chrome-stable"))
bind("SUPER + V", sh("code"))
bind("SUPER + L", sh("wlogout"))
bind("SUPER + P", sh("/usr/bin/postman"))
bind("SUPER + H", sh("ghb"))
bind("SUPER + T", sh("kate"))
bind("SUPER + ALT + T", sh("t3code"))
bind("SUPER + M", sh("flatpak run io.missioncenter.MissionCenter"))
bind("SUPER + K", sh("~/.config/hypr/keybind"))
bind("SUPER + J", hyprexpo("toggle"))
bind("SUPER + F12", sh("pactl set-sink-volume @DEFAULT_AUDIO_SINK@ +5%"))
bind("SUPER + F11", sh("pactl set-sink-volume @DEFAULT_AUDIO_SINK@ -5%"))
bind("ALT + H", sh("~/.config/hypr/toggle-scale.sh"))
bind("SUPER + SPACE", sh("wofi --show drun"))
bind("SUPER + I", sh("hyprsettings"))
bind("SUPER + U", sh("~/.config/hypr/scripts/hyprpwcenter-launch.sh"))

bind("SUPER + SHIFT + T", sh("/home/abhinav/.local/bin/matugen-theme-gui"))
bind("SUPER + SHIFT + W", sh("/home/abhinav/.local/bin/waypaper"))

local screenshot_area = 'hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area "/home/abhinav/Screen Shot/$(date +%Y-%m-%d_%H-%M-%S).png"; hyprctl keyword animation "fadeOut,1,4,default"'
bind("SUPER + SHIFT + S", sh(screenshot_area))
bind("Print", sh("grimblast --notify --cursor copysave output"))
bind("ALT + Print", sh("grimblast --notify --cursor copysave screen"))

bind("SUPER + SHIFT + X", sh("hyprpicker -a -n"))
bind("CTRL + ALT + L", sh("hyprlock"))
bind("SUPER + Return", sh("kitty"))
bind("SUPER + X", sh("kitty"))
bind("SUPER + E", sh("krusader"))
bind("SUPER + d", sh("kate ~/.config/hypr/hyprland.lua"))
bind("SUPER + R", sh("wofi --show drun"))
bind("ALT + R", sh("hyprlauncher"))
bind("SUPER + period", sh('killall rofi || rofi -show emoji -emoji-format "{emoji}" -modi emoji -theme ~/.config/rofi/global/emoji'))
bind("SUPER + escape", sh("wlogout --protocol layer-shell -b 5 -T 400 -B 400"))

bind("SUPER + Q", hl.dsp.window.close())
bind("SUPER + SHIFT + Q", hl.dsp.exit())
bind("SUPER + F", hl.dsp.window.fullscreen())
bind("SUPER + P", hl.dsp.window.pseudo())
bind("SUPER + S", hl.dsp.layout("togglesplit"))

bind("SUPER + SHIFT + D", sh("~/.config/hypr/scripts/set-layout.sh dwindle"))
bind("SUPER + SHIFT + M", sh("~/.config/hypr/scripts/set-layout.sh master"))
bind("SUPER + SHIFT + C", sh("~/.config/hypr/scripts/set-layout.sh scrolling"))
bind("SUPER + CTRL + S", sh("~/.config/hypr/scripts/toggle-dwindle-split.sh"))

bind("ALT + bracketleft", hl.dsp.layout("prev"))
bind("ALT + bracketright", hl.dsp.layout("next"))
bind("ALT + SHIFT + f", hl.dsp.layout("focusincol"))
bind("ALT + SHIFT + right", hl.dsp.layout("movecoltoendright"))
bind("ALT + SHIFT + left", hl.dsp.layout("movecoltoendleft"))
bind("ALT + SHIFT + up", hl.dsp.layout("movecoltoendtop"))
bind("ALT + SHIFT + down", hl.dsp.layout("movecoltoendbottom"))

bind("ALT + space", hl.dsp.layout("swapwithmaster"))
bind("ALT + m", hl.dsp.layout("focusmaster"))
bind("ALT + j", hl.dsp.window.cycle_next())
bind("ALT + k", hl.dsp.window.cycle_next("prev"))
bind("ALT + comma", hl.dsp.layout("addmaster"))
bind("ALT + period", hl.dsp.layout("removemaster"))

bind("ALT + Tab", hl.dsp.window.cycle_next())
bind("ALT + SHIFT + Tab", hl.dsp.window.cycle_next("prev"))

bind("SUPER + left", hl.dsp.focus({ direction = "left" }))
bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
bind("SUPER + up", hl.dsp.focus({ direction = "up" }))
bind("SUPER + down", hl.dsp.focus({ direction = "down" }))

bind("SUPER + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
bind("SUPER + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
bind("SUPER + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
bind("SUPER + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

bind("SUPER + CTRL + left", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
bind("SUPER + CTRL + right", hl.dsp.window.resize({ x = 20, y = 0, relative = true }))
bind("SUPER + CTRL + up", hl.dsp.window.resize({ x = 0, y = -20, relative = true }))
bind("SUPER + CTRL + down", hl.dsp.window.resize({ x = 0, y = 20, relative = true }))

bind("SUPER + g", hl.dsp.group.toggle())
bind("SUPER + tab", hl.dsp.group.next())

bind("SUPER + grave", hl.dsp.workspace.toggle_special())
bind("SUPER + SHIFT + grave", hl.dsp.window.move({ workspace = "special" }))

for i = 1, 10 do
  local key = i % 10
  bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))
  bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

bind("SUPER + ALT + up", hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + ALT + down", hl.dsp.focus({ workspace = "e-1" }))
bind("SUPER + ALT + right", hl.dsp.focus({ workspace = "e+1" }))
bind("SUPER + ALT + left", hl.dsp.focus({ workspace = "e-1" }))

bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
bind("CTRL + ALT + right", hl.dsp.focus({ workspace = "e+1" }))
bind("CTRL + ALT + left", hl.dsp.focus({ workspace = "e-1" }))
bind("SUPER + ALT + M", sh(".local/bin/minimizew"))
