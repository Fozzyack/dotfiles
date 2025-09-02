local conform = require("conform")
conform.setup({
    formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        go = { "gofmt" },
        python = {"autopep8", "black", stop_after_first = true, lsp_format = "fallback"}
    },
})

vim.keymap.set("n", "<leader>wt", function()
    print("Formatting file...")
    conform.format({
        lsp_format = "fallback",
        async = true,
        timeout_ms = 500
    })
end, { desc = "Formatting file" })

local format_on_save_enabled = false

vim.keymap.set("n", "<leader>wr", function()
    format_on_save_enabled = not format_on_save_enabled
    print("Format on save " .. tostring(format_on_save_enabled))
end, { desc = "Toggle Format on save" })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        if format_on_save_enabled then
            require("conform").format({ bufnr = args.buf, lsp_format = "fallback"})
        end
    end,
})
