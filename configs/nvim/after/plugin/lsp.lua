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
    filetypes = { "razor", "typescriptreact" }
})
vim.lsp.enable("tailwindcss") -- TailwindCSS Server
-- vim.lsp.enable("ts_ls")       -- Typescript Language Server
vim.lsp.enable("vue_ls")
vim.lsp.enable("vtsls")
-- vim.lsp.enable('harper_ls') -- For Language Checking

-- local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
-- local cmd = {
--     "roslyn",
--     "--stdio",
--     "--logLevel=Information",
--     "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
--     "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
--     "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
--     "--extension",
--     vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
-- }

vim.lsp.config("roslyn", {
    cmd = cmd,
    handlers = require("rzls.roslyn_handlers"),
    on_attach = function(client, bufnr)
        vim.cmd.highlight('IndentLine guifg=#4c4b59') -- Sets the indent colour (unselected)
        if vim.bo[bufnr] == "razor" then
            client.server_capabilities.semanticTokensProvider = nil
        end
    end
})
vim.lsp.enable("roslyn")

vim.diagnostic.config({
    virtual_lines = true, -- this enables multi line diagnostics
    severity_sort = true,

    -- virtual_text = true, -- this enables inline diagnostics signs = true,
    underline = true,
    update_in_insert = false,
})
