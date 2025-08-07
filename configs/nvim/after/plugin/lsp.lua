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
vim.lsp.config["omnisharp"] = {
    cmd = {"/home/fozzyack/.lsps/omnisharp/OmniSharp", "--languageserver"},
    filetypes = { "cs", "vb", "razor", "cshtml" }
}
-- IF USING ROSLYN (DISABLE OMNISHARP)
--vim.lsp.enable("roslyn_ls") -- roslyn (C#) Language Server
-- vim.lsp.config["roslyn_ls"] = {
--       cmd = {
--     'dotnet',
--     '/home/fozzyack/.lsps/roslyn/content/LanguageServer/linux-x64/Microsoft.CodeAnalysis.LanguageServer.dll',
--     '--logLevel', -- this property is required by the server
--     'Information',
--     '--extensionLogDirectory', -- this property is required by the server
--     '/home/fozzyack/.lsps/roslyn/content/LanguageServer/linux-x64/logs',
--     '--stdio',
--   },
-- 
-- }



-- LEGACY
-- lspconfig.tailwindcss.setup{} -- TailwindCSS Server 
-- lspconfig.lua_ls.setup{} -- Lua Language Server
-- lspconfig.ts_ls.setup{} -- Typescript Language Server
-- lspconfig.marksman.setup{} -- Marksman Language Server - Markdown
-- lspconfig.cmake.setup{} -- CMake Language Server
-- lspconfig.clangd.setup {} -- C++ / C Language Server
-- lspconfig.omnisharp.setup {
--     cmd = {
--         "/home/fozzyack/.omnisharp/OmniSharp", "-lsp"
--     }
-- }
-- lspconfig.pyright.setup {} -- Python Language Server
-- lspconfig.bashls.setup {} -- Bash Language Server

vim.diagnostic.config({
    virtual_lines = true;
    severity_sort = true;
    -- virtual_text = true, -- this enables inline diagnostics
    signs = true,
    underline = true,
    update_in_insert = false,
})

