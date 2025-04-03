local cmp = require('cmp')
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(client, bufnr)
	--	see :help lsp-zero-keybindings
	-- to learn the available actions
	lsp_zero.default_keymaps({buffer = bufnr})
end)

--- if you want to know more about lsp-zero and mason.nvim
--- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({

	handlers = {
		lsp_zero.default_setup,
	},
})

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


