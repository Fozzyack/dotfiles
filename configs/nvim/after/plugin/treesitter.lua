local ts = require("nvim-treesitter.configs")


ts.setup {
    ensure_installed = { "c", "python", "typescript", "c_sharp", "lua", "go", "cpp", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
    auto_install = true,
}
