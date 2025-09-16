-- Holds all the colour schemes (The ones to rotate through)

local colourSchemes = { "tokyonight", "kanagawa", "evergarden", "evergarden-winter", "catppuccin", "nord", "edge" }

local currentColour = 1
local transparent = false

local function setIndentColour()
    vim.cmd.highlight('IndentLine guifg=#4c4b59') -- Sets the indent colour (unselected)
end

-- Initial Setup
vim.cmd([[colorscheme ]] .. colourSchemes[currentColour])
setIndentColour()

vim.keymap.set("n", "<leader>n", function()
    currentColour = (currentColour) % #colourSchemes + 1
    vim.cmd("colorscheme " .. colourSchemes[currentColour])
    setIndentColour()
    transparent = false
end)


local groups = { "Normal", "NormalFloat", "FloatBorder", "Pmenu" }
vim.keymap.set("n", "<leader><leader>n", function()
    if not transparent then
        print("Setting: Transparent")
        for _, group in ipairs(groups) do
            vim.api.nvim_set_hl(0, group, { bg = 'none' })
        end
    else
        vim.cmd("colorscheme " .. colourSchemes[currentColour])
        setIndentColour()
    end
    transparent = not transparent
end)
