local lspconfig = require('lspconfig')


-- Sets up each of the LSP Servers
-- See :help lspconfig-all
-- Server-specific settings. See `:help lspconfig-setup`

lspconfig.tailwindcss.setup{} -- TailwindCSS Server 
lspconfig.lua_ls.setup{} -- Lua Language Server
lspconfig.ts_ls.setup{} -- Typescript Language Server
lspconfig.marksman.setup{} -- Marksman Language Server - Markdown
lspconfig.cmake.setup{} -- CMake Language Server
lspconfig.clangd.setup {} -- C++ / C Language Server
lspconfig.csharp_ls.setup {} -- C# Language Server
lspconfig.pyright.setup {} -- Python Language Server
lspconfig.bashls.setup {} -- Bash Language Server


vim.diagnostic.config({
    virtual_lines = true;
    severity_sort = true;
    -- virtual_text = true, -- this enables inline diagnostics
    signs = true,
    underline = true,
    update_in_insert = false,
})

