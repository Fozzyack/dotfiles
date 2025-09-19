-- Holds all the colour schemes (The ones to rotate through)

local colourSchemes = { "tokyonight", "kanagawa", "evergarden", "evergarden-winter", "catppuccin", "nord", "edge" }

local currentColour = 1
local transparent = false

local function setIndentColour()
    vim.cmd.highlight('IndentLine guifg=#4c4b59') -- Sets the indent colour (unselected)
end

local function makeTransparent()
    -- Removed "NormalFloat" from the list to keep highlighting
    local groups = { "Normal", "FloatBorder", "Pmenu" }
    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = 'none' })
    end
end


-- Initial Setup
vim.cmd([[colorscheme ]] .. colourSchemes[currentColour])
setIndentColour()

vim.keymap.set("n", "<leader>n", function()
    currentColour = (currentColour) % #colourSchemes + 1
    vim.cmd("colorscheme " .. colourSchemes[currentColour])
    if transparent then
        makeTransparent()
    end
    setIndentColour()
end)


vim.keymap.set("n", "<leader><leader>n", function()
    if not transparent then
        makeTransparent()
        setIndentColour()
    else
        vim.cmd("colorscheme " .. colourSchemes[currentColour])
        setIndentColour()
    end
    transparent = not transparent
end)
