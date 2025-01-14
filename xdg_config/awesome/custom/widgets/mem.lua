local wibox = require "wibox"
local gears = require "gears"
local awful = require "awful"

-- Create memory widget
local mem_widget = wibox.widget {
  {
    id = "text",
    text = "Mem: 0",
    widget = wibox.widget.textbox,
  },
  widget = wibox.container.margin,
  margins = 5,
}

-- Function to update memory usage
local function update_mem_usage(widget)
  awful.spawn.easy_async_with_shell("free -m | awk '/Mem:/ {printf(\"%.1f%%\", $3/$2 * 100)}'", function(stdout)
    widget.text = "Mem: " .. stdout
  end)
end

-- Periodically update memory usage
gears.timer {
  call_now = true,
  timeout = 5, -- Update every 5 seconds
  autostart = true,
  callback = function()
    update_mem_usage(mem_widget:get_children_by_id("text")[1])
  end,
}

-- Return widget for inclusion in topbar
return mem_widget
