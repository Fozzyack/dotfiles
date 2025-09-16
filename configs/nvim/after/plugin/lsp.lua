-- local lspconfig = require('lspconfig')

-- Sets up each of the LSP Servers
-- See :help lspconfig-all
-- Server-specific settings. See `:help lspconfig-setup`

vim.lsp.enable("tailwindcss") -- TailwindCSS Server
vim.lsp.enable("cssls")       -- Visual Studio CSS
vim.lsp.enable("html")        --  Visual Studio HTML
vim.lsp.enable("lua_ls")      -- Lua Language Server
vim.lsp.enable("ts_ls")       -- Typescript Language Server
vim.lsp.enable("marksman")    -- Marksman Language Server - Markdown
vim.lsp.enable("cmake")       -- CMake Language Server
vim.lsp.enable("pyright")     -- Python Language Server
vim.lsp.enable("bashls")      -- Bash Language Server
vim.lsp.enable('docker_compose_language_service') -- Docker compose lsp

vim.lsp.enable('gopls')       -- Go language server
vim.lsp.enable('harper_ls')   -- For Language Checking


-- Spell Checking
vim.lsp.config('harper_ls', {
    settings = {

        ["harper-ls"] = {
            linters = {
                SpellCheck = true,
                SpelledNumbers = false,
                AnA = true,
                SentenceCapitalization = true,

                UnclosedQuotes = true,
                WrongQuotes = false,
                LongSentences = true,
                RepeatedWords = true,

                Spaces = true,
                Matcher = true,
                CorrectNumberSuffix = true
            },
            markdown = {
                IgnoreLinkTitle = true
            },
            dialect = "Australian"
        }
    },

})

-- Allowing Neovim to Access the path with Roslyn
-- Make sure to set the file your lsp is trying to execute to executable -> chmod +x [FILE THAT NEEDS TO BE EXECUTABLE]
-- In this case its Microsoft.CodeAnalysis.LanguageServer
vim.env.PATH = vim.env.PATH .. ":/home/fozzyack/.lsps/roslyn/content/LanguageServer/linux-x64"
vim.lsp.enable("roslyn")
vim.lsp.config("roslyn", {
    on_attach = function()
        print("Roslyn Attached")
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


vim.diagnostic.config({
    -- virtual_lines = true, -- this enables multi line diagnostics
    severity_sort = true,

    virtual_text = true, -- this enables inline diagnostics signs = true,
    underline = true,
    update_in_insert = false,
})
