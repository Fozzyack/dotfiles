local nts = require("nvim-treesitter")

nts.setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

nts.install({
  "lua",
  "vim",
  "vimdoc",
  "query",
  "bash",
  "json",
  "yaml",
  "markdown",
  "markdown_inline",
  "javascript",
  "typescript",
  "tsx",
  "python",
  "rust",
  "go",
})
