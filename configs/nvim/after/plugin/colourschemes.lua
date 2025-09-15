-- Holds all the colour schemes (The ones to rotate through)

local colourSchemes = { "tokyonight", "evergarden-winter", "edge" }

local currentColour = 1
local transparent = false

-- Initial Setup
vim.cmd([[colorscheme ]] .. colourSchemes[currentColour])

vim.keymap.set("n", "<leader>n", function()
    currentColour = (currentColour) % #colourSchemes + 1
    vim.cmd("colorscheme " .. colourSchemes[currentColour])
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
    end
    transparent = not transparent
end)
