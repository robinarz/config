local gears = require "gears"

local xresources = require "beautiful.xresources"
local dpi = xresources.apply_dpi

local barcolor = gears.color {
  type = "linear",
  from = { 0, dpi(46) },
  to = { dpi(46), dpi(46) },
  stops = { { 0, theme.bg_focus }, { 0.9, theme.bg_focus2 } },
}

local barcolor2 = gears.color {
  type = "linear",
  from = { 0, dpi(46) },
  to = { dpi(46), dpi(46) },
  stops = { { 0, "#323232" }, { 1, theme.bg_normal } },
}

local dockshape = function(cr, width, height)
  gears.shape.partially_rounded_rect(cr, width, height, false, true, true, false, 6)
end

function theme.vertical_wibox(s)
  -- Create the vertical wibox
  s.dockheight = (35 * s.workarea.height) / 100

  s.myleftwibox = wibox {
    screen = s,
    x = 0,
    y = s.workarea.height / 2 - s.dockheight / 2,
    width = dpi(6),
    height = s.dockheight,
    fg = theme.fg_normal,
    bg = barcolor2,
    ontop = true,
    visible = true,
    type = "dock",
  }

  if s.index > 1 and s.myleftwibox.y == 0 then
    s.myleftwibox.y = screen[1].myleftwibox.y
  end

  -- Add widgets to the vertical wibox
  s.myleftwibox:setup {
    layout = wibox.layout.align.vertical,
    {
      layout = wibox.layout.fixed.vertical,
      lspace1,
      s.mytaglist,
      lspace2,
      s.layoutb,
      wibox.container.margin(mylauncher, dpi(5), dpi(8), dpi(13), dpi(0)),
    },
  }

  -- Add toggling functionalities
  s.docktimer = gears.timer { timeout = 2 }
  s.docktimer:connect_signal("timeout", function()
    local s = awful.screen.focused()
    s.myleftwibox.width = dpi(9)
    s.layoutb.visible = false
    mylauncher.visible = false
    if s.docktimer.started then
      s.docktimer:stop()
    end
  end)
  tag.connect_signal("property::selected", function(t)
    local s = t.screen or awful.screen.focused()
    s.myleftwibox.width = dpi(38)
    s.layoutb.visible = true
    mylauncher.visible = true
    gears.surface.apply_shape_bounding(s.myleftwibox, dockshape)
    if not s.docktimer.started then
      s.docktimer:start()
    end
  end)

  s.myleftwibox:connect_signal("mouse::leave", function()
    local s = awful.screen.focused()
    s.myleftwibox.width = dpi(9)
    s.layoutb.visible = false
    mylauncher.visible = false
  end)

  s.myleftwibox:connect_signal("mouse::enter", function()
    local s = awful.screen.focused()
    s.myleftwibox.width = dpi(38)
    s.layoutb.visible = true
    mylauncher.visible = true
    gears.surface.apply_shape_bounding(s.myleftwibox, dockshape)
  end)
end
