local function float_title(name, title)
  hl.window_rule({
    name = name,
    float = true,
    match = { title = title },
  })
end

float_title("windowrule-2", "file_progress")
float_title("windowrule-3", "confirm")
float_title("windowrule-4", "dialog")
float_title("windowrule-5", "download")
float_title("windowrule-6", "notification")
float_title("windowrule-7", "error")
float_title("windowrule-8", "splash")
float_title("windowrule-9", "confirmreset")
float_title("windowrule-10", "Open File")
float_title("windowrule-11", "branchdialog")
float_title("windowrule-12", "Lxappearance")

hl.window_rule({
  name = "windowrule-13",
  float = true,
  animation = "none",
  match = { title = "Rofi" },
})

float_title("windowrule-14", "viewnior")
float_title("windowrule-15", "feh")
float_title("windowrule-16", "pavucontrol-qt")
float_title("windowrule-17", "pavucontrol")
float_title("windowrule-18", "file-roller")

hl.window_rule({
  name = "windowrule-19",
  fullscreen = true,
  float = true,
  match = { title = "wlogout" },
})

hl.window_rule({
  name = "windowrule-20",
  idle_inhibit = "focus",
  match = { title = "mpv" },
})

hl.window_rule({
  name = "windowrule-21",
  idle_inhibit = "fullscreen",
  match = { title = "firefox" },
})

float_title("windowrule-22", "^(Media viewer)$")

hl.window_rule({
  name = "windowrule-23",
  float = true,
  size = "800 600",
  move = "(75) ((monitor_h*0.44))",
  match = { title = "^(Volume Control)$" },
})

float_title("windowrule-24", "^(Picture-in-Picture)$")

hl.workspace_rule({ workspace = "w[t1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "w[tg1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

local function no_gap_rule(name, workspace)
  hl.window_rule({
    name = name,
    border_size = 0,
    rounding = 0,
    match = {
      float = false,
      workspace = workspace,
    },
  })
end

no_gap_rule("windowrule-25", "w[t1]")
no_gap_rule("windowrule-26", "w[tg1]")
no_gap_rule("windowrule-27", "f[1]")

local transparent_terminals = {
  "^(kitty)$",
  "^(Alacritty)$",
  "^(GNOME Terminal)$",
  "^(konsole)$",
  "^(xterm)$",
  "^(urxvt)$",
  "^(termite)$",
  "^(foot)$",
  "^(Tilix)$",
  "^(Terminator)$",
  "^(Ghostty)$",
}

for i, class in ipairs(transparent_terminals) do
  hl.window_rule({
    name = "windowrule-" .. (27 + i),
    opacity = "0.8 0.8",
    match = { class = class },
  })
end

hl.window_rule({
  name = "windowrule-hyprpwcenter",
  float = true,
  size = "720 600",
  move = "(100%-740) 40",
  match = { class = "^(hyprpwcenter)$" },
})
