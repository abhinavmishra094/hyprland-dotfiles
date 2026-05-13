local colors_file = (os.getenv("HOME") or "/home/abhinav") .. "/.config/hypr/colors_matugen.conf"
local colors = {}

local function trim(value)
  return value:match("^%s*(.-)%s*$")
end

local file = io.open(colors_file, "r")
if file == nil then
  return
end

for line in file:lines() do
  local key, value = line:match("^%s*env%s*=%s*([%w_]+)%s*,%s*(%S+)%s*$")
  if key ~= nil and value ~= nil then
    hl.env(key, value)
  end

  local color_key, color_value = line:match("^%s*%$([%w_]+)%s*=%s*(%S+)%s*$")
  if color_key ~= nil and color_value ~= nil then
    colors[color_key] = trim(color_value)
  end
end

file:close()

local background = colors.background
local primary = colors.primary
local secondary = colors.secondary
local tertiary = colors.tertiary
local surface_variant = colors.surface_variant
local outline = colors.outline
local shadow = colors.shadow
local error = colors.error

hl.config({
  general = {
    col = {
      active_border = { colors = { primary, secondary, tertiary }, angle = 45 },
      inactive_border = surface_variant,
      nogroup_border = outline,
      nogroup_border_active = { colors = { primary, secondary }, angle = 45 },
    },
  },
  decoration = {
    shadow = {
      color = shadow,
      color_inactive = shadow,
    },
  },
  group = {
    col = {
      border_active = primary,
      border_inactive = surface_variant,
      border_locked_active = error,
      border_locked_inactive = surface_variant,
    },
    groupbar = {
      col = {
        active = primary,
        inactive = surface_variant,
        locked_active = error,
        locked_inactive = surface_variant,
      },
    },
  },
  misc = {
    background_color = background,
  },
})
