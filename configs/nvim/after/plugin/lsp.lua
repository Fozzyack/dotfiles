-- local lspconfig = require('lspconfig')

-- Sets up each of the LSP Servers
-- See :help lspconfig-all
-- Server-specific settings. See `:help lspconfig-setup`

-- Allowing Neovim to Access the path with Roslyn

require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})

vim.lsp.enable("tailwindcss") -- TailwindCSS Server
vim.lsp.enable("cssls")       -- Visual Studio CSS
vim.lsp.enable("html")        --  Visual Studio HTML
vim.lsp.enable("lua_ls")      -- Lua Language Server
vim.lsp.enable("ts_ls")       -- Typescript Language Server
-- vim.lsp.enable("marksman") -- Marksman Language Server - Markdown
vim.lsp.enable("cmake")       -- CMake Language Server
vim.lsp.enable("pyright")     -- Python Language Server
vim.lsp.enable("bashls")      -- Bash Language Server
vim.lsp.enable('gopls')       -- Go language server

-- Allowing Neovim to Access the path with Roslyn
vim.env.PATH = vim.env.PATH .. ":/home/fozzyack/.lsps/roslyn/content/LanguageServer/linux-x64"
vim.lsp.config("roslyn", {
    on_attach = function()
        print("This will run when the server attaches!")
    end,
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
    },
})
-- vim.lsp.enable("csharp_ls") -- csharp-ls minimal
-- vim.lsp.enable("omnisharp") -- Omnisharp - This needs work
-- vim.lsp.config("omnisharp", {
--     cmd = { "/home/fozzyack/.lsps/omnisharp/OmniSharp", "-z", "--hostPID", "12345", "DotNet:enablePackageRestore=false", "--encoding", "utf-8", "--languageserver" },
--     filetypes = {"cs", "vb", "razor", "cshtml"}
-- })

vim.diagnostic.config({
    -- virtual_lines = true, -- this enables multi line diagnostics
    severity_sort = true,
    virtual_text = true, -- this enables inline diagnostics
    signs = true,
    underline = true,
    update_in_insert = false,
})
