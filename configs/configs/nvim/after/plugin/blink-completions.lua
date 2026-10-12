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
