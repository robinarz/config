local awful = require "awful"
local dpi = require("beautiful.xresources").apply_dpi
local wibox = require "wibox"

local M = {}

--- On Screen Connect
---@param s Awesome.screen
M.at_screen_connect = function(s)
  -- Create the bottom wibox
  local mybottomwibox = awful.wibar {
    position = "bottom",
    screen = s,
    border_width = dpi(0),
    height = dpi(32),
  }

  local borderwibox =
    awful.wibar { position = "bottom", screen = s, height = dpi(1), bg = theme.fg_focus, x = dpi(0), y = dpi(33) }

  -- Add widgets to the bottom wibox
  mybottomwibox:setup {
    layout = wibox.layout.align.horizontal,
    { -- Left widgets
      layout = wibox.layout.fixed.horizontal,
      mylauncher,
    },
    s.mytasklist, -- Middle widget
    { -- Right widgets
      layout = wibox.layout.fixed.horizontal,
      spr_bottom_right,
      netdown_icon,
      networkwidget,
      netup_icon,
      bottom_bar,
      cpu_icon,
      cpuwidget,
      bottom_bar,
      calendar_icon,
      calendarwidget,
      bottom_bar,
      clock_icon,
      clockwidget,
    },
  }
end

return M
