
-- List of all Colour Schemes installed
-- This list is looped through when using the macro below
local schemes = { "onedark", "blue-moon", "nord", "colorschemefromhell", "nightcity-afterlife", "nightcity-kabuki", "everblush", "material", "tokyonight", "tokyonight-night", "tokyodark", "poimandres", "abscs", "miasma" }
local index = 1
local selectedColour = "nightcity"
local transparent = false
-- Set initial colour
local nsSet = {
    terminal_colors = true,
    on_highlights = function(groups, colours)
        groups.String = { fg = colours.yellow, bg = colours.none}
    end
}
-- Setting some defaults for some colours
-- I think it was to attempt to get the background to become transparent with some colours
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

local one_dark_setup = {
    style = "darker"
}

-- Setting up Colourschemes with some of their setups
-- could use better naming conventions and honestly 
-- now that I'm reading this after a year I'm not sure if this works
require("onedark").setup(one_dark_setup)
require("nightcity").setup(nsSet)
require("material").setup(mSet)
require("everblush").setup(eSet)
require("poimandres").setup(pSet)
require("tokyonight").setup(tSet)


vim.cmd.colorscheme(schemes[index])
local bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background
local hex_color = string.format("#%06x", bg_color)

-- Keymaps
-- This loops through the colours in the list at the top of the code
vim.keymap.set("n", "<leader>n", function ()
    index = index % #schemes + 1
    selectedColour = schemes[index]
    vim.cmd.colorscheme(selectedColour)
    bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background
    hex_color = string.format("#%06x", bg_color)
    transparent = false -- upon changeing colour we reset the transparency to false
end)

-- Making the page transparent or not transparent with leader<r>
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


