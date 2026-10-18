return {
    {
        "nvimdev/indentmini.nvim",
        config = function()
            require("indentmini").setup() -- use default config
            vim.cmd.highlight('IndentLine guifg=#123456')
        end,
    }
}
