local conform = require("conform")



conform.setup({
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    cs = { "csharpier" },
    python = { "autopep8", "black", stop_after_first = true }
})

local formatOnSave = false

vim.keymap.set("n", "<leader>wr", function()
    formatOnSave = not formatOnSave
    print("Formatting on Save: " .. tostring(formatOnSave))
end)

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        if formatOnSave then
            conform.format({ timeout_ms = 300, bufnr = args.buf, lsp_format = "fallback" })
        end
    end
})

vim.keymap.set("n", "<leader>wt", function()
    print("Formatting Buffer")
    conform.format({ async = true, lsp_format = "fallback" })
end)
