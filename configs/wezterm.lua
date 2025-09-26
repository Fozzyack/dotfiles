local wezterm = require "wezterm"
local config = {}

config.color_scheme = "FrontEndDelight"
config.window_frame = {

    font = wezterm.font("Hurmit Nerd Font", { weight = "Bold", italic = true })
}
config.default_prog = { "wsl.exe" }
config.inactive_pane_hsb = {
    saturation = 0.9,
    brightness = 0.8,
}
config.window_background_image = ""
config.window_background_image_hsb = {
    -- Darken the background image by reducing it to 1/3rd
    brightness = 0.3,

    -- You can adjust the hue by scaling its value.
    -- a multiplier of 1.0 leaves the value unchanged.
    hue = 1.0,

    -- You can adjust the saturation also.
    saturation = 1.0,
}
config.window_background_opacity = 0.9
return config
