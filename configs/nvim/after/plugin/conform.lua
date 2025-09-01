require("conform").setup({
    formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        go = { "gofmt" },
    },
    format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback"
    }
})

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(args)
        require("conform").format({ bufnr = args.buf })
    end,
})
