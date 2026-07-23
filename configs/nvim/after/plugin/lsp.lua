-- local lspconfig = require('lspconfig')

-- Sets up each of the LSP Servers
-- See :help lspconfig-all
-- Server-specific settings. See `:help lspconfig-setup`

require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})


vim.lsp.enable("cssls") -- Visual Studio CSS
vim.lsp.config("html", {
    filetypes = { "html", "razor" }
})
vim.lsp.enable("html")                            -- Visual Studio HTML
vim.lsp.enable("lua_ls")                          -- Lua Language Server
vim.lsp.enable("marksman")                        -- Marksman Language Server - Markdown
vim.lsp.enable("cmake")                           -- CMake Language Server
vim.lsp.enable('docker_compose_language_service') -- Docker compose lsp
vim.lsp.enable('gopls')                           -- Go language server
vim.lsp.config("tailwindcss", {
    filetypes = { "razor", "typescriptreact", "html" }
})
vim.lsp.config('tailwindcss', {
    filetypes = { "html", "typescriptreact", "svelte" },
})
vim.lsp.enable("tailwindcss") -- TailwindCSS Server
vim.lsp.enable("djls")        -- python DJANGO
vim.lsp.enable('pyright')     -- Python
vim.lsp.enable("clangd")
vim.lsp.enable("bashls")
vim.lsp.enable("vue_ls")
vim.lsp.enable('vtsls')
vim.lsp.enable('sqls')
vim.lsp.config('svelte', {
    cmd = { 'svelteserver', '--stdio' },
    filetypes = { 'svelte' },
    root_markers = { '.git', 'svelte.config.js', 'svelte.config.ts', 'package.json' },
})
vim.lsp.enable('svelte')
-- vim.lsp.enable("ts_ls")
-- vim.lsp.enable('harper_ls') -- For Language Checking

vim.diagnostic.config({
    virtual_lines = true, -- this enables multi line diagnostics
    severity_sort = true,

    -- virtual_text = true, -- this enables inline diagnostics signs = true,
    underline = true,
    update_in_insert = false,
})
