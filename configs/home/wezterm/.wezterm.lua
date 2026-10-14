local wezterm = require "wezterm"
local config = wezterm.config_builder()
local act = wezterm.action


config.default_prog = { "wsl.exe", "~" }
config.font = wezterm.font "Terminess Nerd Font"
config.font_size = 12

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
        inactive_tab = { bg_color = palette.mantle, fg_color = palette.teal },
        inactive_tab_hover = { bg_color = palette.surface, fg_color = palette.accent },
        new_tab = { bg_color = palette.mantle, fg_color = palette.accent },
        new_tab_hover = { bg_color = palette.surface, fg_color = palette.text },
    },
}

-- Native Windows acrylic. Keep resize handles; drop the OS title bar.
config.win32_system_backdrop = "Acrylic"
config.window_background_opacity = 0.75
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

-- Always-visible, cell-based tabs for the retro terminal look.
config.enable_tab_bar = true
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
    local prefix = " [" .. (tab.tab_index + 1) .. "] "
    local suffix = tab.is_active and " * " or "   "
    title = wezterm.truncate_right(title, math.max(1, max_width - #prefix - #suffix))
    return prefix .. title .. suffix
end)

wezterm.on("update-status", function(window)
    local mode = window:active_key_table()
    local label = "WSL"
    if mode == "resize_pane" then
        label = "RESIZE [HJKL / ESC]"
    elseif window:leader_is_active() then
        label = "LEADER"
    end
    window:set_right_status(wezterm.format {
        { Foreground = { Color = palette.accent } },
        { Text = "  " .. label .. "  " },
        { Foreground = { Color = palette.teal } },
        { Text = wezterm.strftime("%H:%M") .. "  " },
    })
end)

-- All other WezTerm shortcuts keep their defaults.
-- Press Ctrl+S, release it, then press the command key within two seconds.
config.leader = { key = "s", mods = "CTRL", timeout_milliseconds = 2000 }
config.keys = {
    { key = "b", mods = "LEADER|CTRL", action = act.SendKey { key = "b", mods = "CTRL" } },
    { key = "c", mods = "LEADER", action = act.SpawnTab "CurrentPaneDomain" },
    { key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
    { key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
    { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "\"", mods = "LEADER|SHIFT", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    -- Select a labeled pane to swap positions, keeping focus on this pane.
    { key = "w", mods = "LEADER", action = act.PaneSelect { mode = "SwapWithActiveKeepFocus" } },
    { key = "h", mods = "LEADER", action = act.ActivatePaneDirection "Left" },
    { key = "j", mods = "LEADER", action = act.ActivatePaneDirection "Down" },
    { key = "k", mods = "LEADER", action = act.ActivatePaneDirection "Up" },
    { key = "l", mods = "LEADER", action = act.ActivatePaneDirection "Right" },
    { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
    { key = "x", mods = "LEADER", action = act.CloseCurrentPane { confirm = true } },
    { key = "r", mods = "LEADER", action = act.ActivateKeyTable {
        name = "resize_pane", one_shot = false,
    } },
    { key = "Enter", mods = "ALT", action = act.ToggleFullScreen },
    { key = "d", mods = "CTRL|SHIFT", action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
    { key = "e", mods = "CTRL|SHIFT", action = act.SplitVertical { domain = "CurrentPaneDomain" } },
    { key = "h", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Left" },
    { key = "j", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Down" },
    { key = "k", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Up" },
    { key = "l", mods = "CTRL|SHIFT", action = act.ActivatePaneDirection "Right" },
    { key = "z", mods = "CTRL|SHIFT", action = act.TogglePaneZoomState },
}

for i = 1, 9 do
    table.insert(config.keys, {
        key = tostring(i), mods = "LEADER",
        action = act.ActivateTab(i == 9 and -1 or i - 1),
    })
end

-- Resize repeatedly without holding modifiers; Escape or Enter exits.
config.key_tables = {
    resize_pane = {
        { key = "h", action = act.AdjustPaneSize { "Left", 1 } },
        { key = "j", action = act.AdjustPaneSize { "Down", 1 } },
        { key = "k", action = act.AdjustPaneSize { "Up", 1 } },
        { key = "l", action = act.AdjustPaneSize { "Right", 1 } },
        { key = "LeftArrow", action = act.AdjustPaneSize { "Left", 1 } },
        { key = "DownArrow", action = act.AdjustPaneSize { "Down", 1 } },
        { key = "UpArrow", action = act.AdjustPaneSize { "Up", 1 } },
        { key = "RightArrow", action = act.AdjustPaneSize { "Right", 1 } },
        { key = "Escape", action = act.PopKeyTable },
        { key = "Enter", action = act.PopKeyTable },
    },
}

return config
