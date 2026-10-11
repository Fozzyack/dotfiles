local wezterm = require "wezterm"
local config = wezterm.config_builder()
local act = wezterm.action

-- Note: This is mainly used for my windows config
-- Windows host, WSL shell. Keep your existing font and launch behavior.
config.default_prog = { "wsl.exe", "~" }
config.font = wezterm.font "Hurmit Nerd Font"
config.font_size = 11.5

-- Retro dark: charcoal, burnt orange, teal, and warm cream.
local palette = {
    base = "#090d0e",
    mantle = "#060909",
    surface = "#2b3e3e",
    muted = "#7c8b85",
    text = "#e5d5b7",
    accent = "#ff851b",
    teal = "#66b2a5",
}
config.colors = {
    background = palette.base,
    foreground = palette.text,
    cursor_bg = palette.accent,
    cursor_border = palette.accent,
    cursor_fg = palette.base,
    selection_bg = "#315653",
    selection_fg = "#fff0d5",
    split = palette.teal,
    -- ANSI order: black, red, green, yellow, blue, magenta, cyan, white.
    ansi = {
        "#202829", "#cf6b56", "#8fa878", "#e88728",
        "#6f9fa6", "#b58b95", "#58a99b", "#d8c9ad",
    },
    brights = {
        "#64736e", "#ed8b6f", "#b0c795", "#ff9b38",
        "#93bec4", "#d3abb5", "#86d1bf", "#fff0d5",
    },
    tab_bar = {
        background = palette.mantle,
        active_tab = { bg_color = palette.accent, fg_color = palette.base },
        inactive_tab = { bg_color = palette.mantle, fg_color = palette.muted },
        inactive_tab_hover = { bg_color = palette.surface, fg_color = palette.text },
        new_tab = { bg_color = palette.mantle, fg_color = palette.accent },
        new_tab_hover = { bg_color = palette.surface, fg_color = palette.text },
    },
}

-- Native Windows acrylic. Keep resize handles; drop the OS title bar.
config.win32_system_backdrop = "Acrylic"
config.window_background_opacity = 0.70
config.text_background_opacity = 1.0
config.window_decorations = "RESIZE"
config.window_padding = { left = 22, right = 22, top = 16, bottom = 14 }
config.initial_cols = 120
config.initial_rows = 32
config.adjust_window_size_when_changing_font_size = false
config.inactive_pane_hsb = { saturation = 0.85, brightness = 0.72 }

config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 650
config.cursor_blink_ease_in = "Constant"
config.cursor_blink_ease_out = "Constant"
config.scrollback_lines = 10000
config.audible_bell = "Disabled"

-- Hidden for now; set enable_tab_bar to true to restore the bottom tabs.
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 28
config.show_new_tab_button_in_tab_bar = true
config.status_update_interval = 1000

wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
    local title = tab.tab_title
    if title == "" then
        title = tab.active_pane.title
    end
    title = wezterm.truncate_right(title, math.max(1, max_width - 7))
    return "  " .. (tab.tab_index + 1) .. "  " .. title .. "  "
end)

wezterm.on("update-status", function(window)
    window:set_right_status(wezterm.format {
        { Foreground = { Color = palette.accent } },
        { Text = "  WSL  " },
        { Foreground = { Color = palette.muted } },
        { Text = wezterm.strftime("%H:%M") .. "  " },
    })
end)

-- All other WezTerm shortcuts keep their defaults.
config.keys = {
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
    { key = "d", mods = "CTRL|SHIFT", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "e", mods = "CTRL|SHIFT", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Left" },
    { key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Down" },
    { key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Up" },
    { key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Right" },
    { key = "z", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },
}

return config
