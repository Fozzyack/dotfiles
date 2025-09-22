local ts = require("nvim-treesitter.configs")


ts.setup {
    ensure_installed = { "c", "python", "typescript", "c_sharp", "lua", "go", "cpp", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
    auto_install = true,

    sync_install = false,

    ignore_install = {},

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = true,
        -- disable = function(lang, buf)
        --     return vim.bo[buf].filetype == "razor"
        -- end,
    },


}
