-- Load from hyprland.lua with dofile("/absolute/path/hyprland-widgets.lua").
local directory = "/home/fozzyack/code/gtk-widgets"
local city = "Perth"

-- Widgets use the Wayland bottom layer, behind normal windows.
-- Edge anchors and spacing are configured in widget.py's POSITIONS table.

local function quote(value)
    return "'" .. value:gsub("'", "'\\''") .. "'"
end

-- Only runs at compositor startup, not each configuration reload.
hl.on("hyprland.start", function()
    for _, script in ipairs({"clock.py", "calendar_widget.py", "weather.py", "system_load.py"}) do
        local command = "env GDK_BACKEND=wayland python3 " .. quote(directory .. "/" .. script)
        if script == "weather.py" then
            command = command .. " --city " .. quote(city)
        end
        hl.exec_cmd(command)
    end
end)
