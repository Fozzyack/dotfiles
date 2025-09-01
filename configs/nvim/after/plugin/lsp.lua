-- local lspconfig = require('lspconfig')

-- Sets up each of the LSP Servers
-- See :help lspconfig-all
-- Server-specific settings. See `:help lspconfig-setup`


vim.lsp.enable("tailwindcss") -- TailwindCSS Server 
vim.lsp.enable("cssls") -- Visual Studio CSS 
vim.lsp.enable("html") --  Visual Studio HTML 
vim.lsp.enable("lua_ls") -- Lua Language Server
vim.lsp.enable("ts_ls") -- Typescript Language Server
vim.lsp.enable("marksman") -- Marksman Language Server - Markdown
vim.lsp.enable("cmake") -- CMake Language Server
vim.lsp.enable("pyright") -- Python Language Server
vim.lsp.enable("bashls") -- Bash Language Server
vim.lsp.enable("omnisharp") -- OmniSharp (C#) Language Server
vim.lsp.enable("vue_ls") -- Vue Language Server
vim.lsp.enable('gopls') -- Go language server
vim.lsp.config["omnisharp"] = {
    cmd = {"/home/fozzyack/.lsps/omnisharp/OmniSharp","-z", "--hostPID", "12345", "DotNet:enablePackageRestore=false", "--encoding", "utf-8", "--languageserver"},
    filetypes = { "cs", "vb", "razor", "cshtml" }
}

vim.diagnostic.config({
    virtual_lines = true;
    severity_sort = true;
    -- virtual_text = true, -- this enables inline diagnostics
    signs = true,
    underline = true,
    update_in_insert = false,
})

