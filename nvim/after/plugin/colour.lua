
-- List of all Colour Schemes installed
local schemes = { "nightcity-afterlife", "nightcity-kabuki", "everblush", "material", "tokyonight", "tokyonight-night", "poimandres", "abscs", "miasma" }
local index = 1
local selectedColour = "nightcity"
local transparent = false
-- Set initial colour
--
local nsSet = {
    terminal_colors = true,
    on_highlights = function(groups, colours)
        groups.String = { fg = colours.yellow, bg = colours.none}
    end
}
local mSet = {
    disable = {
        background = false,
        colored_cursor = true,
    }
}
local eSet = {
    transparent_background = false,
    nvim_tree = {
        contrast = true,
    }
}

local pSet = {
    disable_background = false
}

local tSet = {
    transparent = false,
    terminal_colors = true
}

require("nightcity").setup(nsSet)
require("material").setup(mSet)
require("everblush").setup(eSet)
require("poimandres").setup(pSet)
require("tokyonight").setup(tSet)


vim.cmd.colorscheme(schemes[index])
local bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background
local hex_color = string.format("#%06x", bg_color)
-- Keymaps
vim.keymap.set("n", "<leader>n", function ()
    index = index % #schemes + 1
    selectedColour = schemes[index]
    vim.cmd.colorscheme(selectedColour)
    bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background
    hex_color = string.format("#%06x", bg_color)
    transparent = false
end)

vim.keymap.set("n", "<leader>r", function ()
    if not transparent then
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
        vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = "none" })
        vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "none" })
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#3e5b5c", bg = "none" })
    else
        vim.api.nvim_set_hl(0, "Normal", { bg = hex_color })
        vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = hex_color })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = hex_color })
        vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = hex_color })
        vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = hex_color })
        vim.api.nvim_set_hl(0, "LineNr", { fg = "#3e5b5c", bg = hex_color })
    end
    transparent = not transparent

end)


