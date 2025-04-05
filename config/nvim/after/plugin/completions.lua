local cmp = require('cmp')
cmp.setup({
    window = {
        completion = {
            border = 'rounded',
        }
    },
    snippet = {
        expand = function(args)
            local luasnip = require('luasnip')
            luasnip.lsp_expand(args.body)
        end,

    },

    mapping = {
        ['<C-k>'] = cmp.mapping.select_prev_item(),
        ['<C-j>'] = cmp.mapping.select_next_item(),
        ['<C-u>'] = cmp.mapping.confirm({select = true})
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip', option = {show_autosnippets = true}},
        { name = 'buffer' },
    }
})
