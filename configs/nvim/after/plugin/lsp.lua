local lspconfig = require('lspconfig')
lspconfig.pyright.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['pyright'] = {},
  },
}

lspconfig.clangd.setup {
  -- Server-specific settings. See `:help lspconfig-setup`
  settings = {
    ['clangd'] = {},
  },
}

require'lspconfig'.tailwindcss.setup{}
require'lspconfig'.lua_ls.setup{}
require'lspconfig'.ts_ls.setup{}
require'lspconfig'.marksman.setup{}
require'lspconfig'.cmake.setup{}


local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.diagnostic.config({
  virtual_text = true, -- this enables inline diagnostics
  signs = true,
  underline = true,
  update_in_insert = false,
})

