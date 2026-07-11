return {
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
      config = function()
          require('nvim-treesitter').setup {
              -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
              install_dir = vim.fn.stdpath('data') .. '/site'
          }
          require('nvim-treesitter').install { 'go', 'javascript', 'zig', 'tsx', 'typescript', 'css', 'html', 'lua', 'python'}
      end
    }
}
