-- List of all Colour Schemes installed
-- This list is looped through when using the macro below
local schemes = { "catppuccin-mocha", "onedark", "neofusion", "darkrose",  "everblush", "material", "tokyonight", "tokyodark"}
local index = 1
local selectedColour = "nightcity"
local transparent = false
-- Set initial colour



-- Setting some defaults for some colours
-- I think it was to attempt to get the background to become transparent with some colours
local material_setup = {
    disable = {
        background = false,
        colored_cursor = true,
    }
}
local everblush_setup = {
    transparent_background = false,
    nvim_tree = {
        contrast = true,
    }
}

local tokyonight_setuo = {
    transparent = false,
    terminal_colors = true
}

local one_dark_setup = {
    style = "darker"
}
local catppuccin_setup = {
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
    }
}
local neofusion_setup = {
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,

  invert_signs = false,
  invert_tabline = false,

  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  palette_overrides = {},
  overrides = {},
  dim_inactive = false,
  transparent_mode = false,
}
local darkrose_setup = {
    -- Override colors
    colors = {
        orange = "#F87757",
    },
    -- Override existing or add new highlight groups
    overrides = function(c)
        return {
            Class = { fg = c.magenta },
            ["@variable"] = { fg = c.fg_dark },
        }
    end,
    -- Styles to enable or disable
    styles = {
        bold = true, -- Enable bold highlights for some highlight groups
        italic = true, -- Enable italic highlights for some highlight groups
        underline = true, -- Enable underline highlights for some highlight groups
    }
}


-- Setting up Colourschemes with some of their setups
-- could use better naming conventions and honestly 
-- now that I'm reading this after a year I'm not sure if this works
require("darkrose").setup(darkrose_setup)
require("catppuccin").setup(catppuccin_setup)
require("neofusion").setup(neofusion_setup)
require("onedark").setup(one_dark_setup)
require("material").setup(material_setup)
require("everblush").setup(everblush_setup)
require("tokyonight").setup(tokyonight_setuo)


vim.cmd.colorscheme(schemes[index])
local bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background
local hex_color = string.format("#%06x", bg_color)

-- Keymaps
-- This loops through the colours in the list at the top of the code
vim.keymap.set("n", "<leader>n", function ()
    print(index)
    index = index % #schemes + 1
    print(index)
    selectedColour = schemes[index]
    vim.cmd.colorscheme(selectedColour)
    bg_color = vim.api.nvim_get_hl_by_name("Normal", true).background
    hex_color = string.format("#%06x", bg_color)
    transparent = false -- upon changeing colour we reset the transparency to false
end)

-- This is to index through the list faster
vim.keymap.set("n", "<leader>h", function ()
    index = (index + 3) % #schemes
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


