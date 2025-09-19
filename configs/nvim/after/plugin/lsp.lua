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


vim.lsp.enable("cssls")                           -- Visual Studio CSS
vim.lsp.enable("html")                            -- Visual Studio HTML
vim.lsp.enable("lua_ls")                          -- Lua Language Server
vim.lsp.enable("marksman")                        -- Marksman Language Server - Markdown
vim.lsp.enable("cmake")                           -- CMake Language Server
vim.lsp.enable('docker_compose_language_service') -- Docker compose lsp
vim.lsp.enable("roslyn")                          -- C# Language Server
vim.lsp.enable('gopls')                           -- Go language server
vim.lsp.enable("tailwindcss")                     -- TailwindCSS Server
-- vim.lsp.enable("ts_ls")                           -- Typescript Language Server
vim.lsp.enable("vue_ls")
vim.lsp.enable("vtsls")
vim.lsp.enable('harper_ls')                       -- For Language Checking


vim.diagnostic.config({
    -- virtual_lines = true, -- this enables multi line diagnostics
    severity_sort = true,

    virtual_text = true, -- this enables inline diagnostics signs = true,
    underline = true,
    update_in_insert = false,
})
