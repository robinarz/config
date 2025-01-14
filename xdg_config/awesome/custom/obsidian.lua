local awful = require "awful"

local M = {}

M.setup = function()
  client.connect_signal("property::name", function(c)
    if c.name == "edit-obisidian" then
      c.floating = true
      -- vertical monitor to the left, 0,0
      -- 3840 by 2160
      -- 2160 x 3840
      -- local screen_geometry = c.screen.geometry
      local width = 2500
      local height = 1800
      -- local x = 2160 + ((3840 - width) / 2)
      -- local y = (3840 - (2160 / 2)) + ((2160 - height) / 2)
      c:geometry { width = width, height = height }
      awful.placement.centered(c)
    end
  end)
end

--- Focus The Obsidian Client
---@param c Awesome.client
M.focus = function(c)
  -- Move to the current screen/tag
  c:move_to_screen(awful.screen.focused())
  c:move_to_tag(awful.screen.focused().selected_tag)

  -- Make floating/on top, not maximized/fullscreen
  c.floating = true
  c.ontop = true
  c.minimized = false
  c.maximized = false
  c.fullscreen = false

  -- Calculate 80% geometry and center it
  local s = awful.screen.focused()
  local wa = s.workarea
  local new_width = math.floor(wa.width * 0.8)
  local new_height = math.floor(wa.height * 0.8)
  local new_x = wa.x + (wa.width - new_width) / 2
  local new_y = wa.y + (wa.height - new_height) / 2

  c:geometry {
    x = new_x,
    y = new_y,
    width = new_width,
    height = new_height,
  }

  -- Raise and focus
  c:raise()
  client.focus = c
end

M.spawn = function(vault)
  awful.spawn(("obsidian %s"):format(vault))
end

return M
