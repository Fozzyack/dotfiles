-- Holds all the colour schemes (The ones to rotate through)
            local blink = require("blink.cmp")

            blink.setup({
                keymap = {
                    preset = 'default',
                    ["<C-K>"] = { "select_prev", "fallback" },
                    ["<C-J>"] = { "select_next", "fallback" },
                    ["<Tab>"] = { "select_next", "fallback" },
                    ["<C-U>"] = { "select_and_accept", "fallback" },
                    ["<C-Space"] = { "select_and_accept", "fallback" },
                },
                appearance = {
                    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                    -- Adjusts spacing to ensure icons are aligned
                    nerd_font_variant = 'mono'
                },

                completion = {
                    accept = {
                        auto_brackets = { enabled = false }
                    }
                },

                -- Default list of enabled providers defined so that you can extend it
                -- elsewhere in your config, without redefining it, due to `opts_extend`
                snippets = { preset = "luasnip" },
                sources = {
                    default = { "lazydev", 'lsp', 'path', 'snippets', 'buffer' },
                    providers = {
                        lazydev = {
                            name = "LazyDev",
                            module = "lazydev.integrations.blink",
                            -- make lazydev completions top priority (see `:h blink.cmp`)
                            score_offset = 100,
                        }
                    }
                },


                cmdline = {
                    keymap = { preset = 'inherit' },
                    completion = { menu = { auto_show = true } },
                },

            })

local colourSchemes = {
    "kanagawa",
    "bluloco-dark",
    "tokyonight",
    "ashen",
    "nord",
    "onedark",
    "evergarden",
    "catppuccin",
    "elflord",
    "edge"
}

local currentColour = 1
local transparent = false

local function setIndentColour()
    vim.cmd.highlight('IndentLine guifg=#4c4b59') -- Sets the indent colour (unselected)
end

local function makeTransparent()
    -- Removed "NormalFloat" from the list to keep highlighting
    local groups = { "Normal", "FloatBorder", "Pmenu" }
    for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
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
    end
    transparent = not transparent
end)
