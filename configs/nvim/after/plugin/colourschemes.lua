-- Holds all the colour schemes (The ones to rotate through)

local colourSchemes = { "evergarden", "tokyonight" }
local groups = { "Normal", "NormalFloat", "FloatBorder", "Pmenu" }

local currentColour = 1
local transparent = false
local saved = {}

local function capture()
    for _, g in ipairs(groups) do
        saved[g] = vim.api.nvim_get_hl(0, { name = g, link = false })
    end
end

-- Initial Setup
vim.cmd([[colorscheme ]] .. colourSchemes[currentColour])
capture()

vim.keymap.set("n", "<leader>n", function()
    currentColour = (currentColour) % #colourSchemes + 1
    vim.cmd("colorscheme " .. colourSchemes[currentColour])
    capture()
end)


vim.keymap.set("n", "<leader><leader>n", function()
    for _, group in ipairs(groups) do
        if transparent then
            print("Setting Tran parent")
            vim.api.nvim_set_hl(0, group, { bg = 'none' })
        else
            print("Setting Not Transparent")
            vim.api.nvim_set_hl(0, group, { bg = saved[group]["bg"] })
        end
    end
    transparent = not transparent
end)
