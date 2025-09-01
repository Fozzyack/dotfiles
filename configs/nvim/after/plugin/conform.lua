local conform = require("conform")
conform.setup({
    formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        go = { "gofmt" },
    },
})

-- Setting to enable formatting on save
-- vim.api.nvim_create_autocmd("BufWritePre", {
--     pattern = "*",
--     callback = function(args)
--         require("conform").format({ bufnr = args.buf })
--     end,
-- })

vim.keymap.set("n", "<leader>w", function()
    print("Formatting")
    conform.format({
        lsp_format = "fallback",
        async = true,
        timeout_ms = 500
    })
end)
