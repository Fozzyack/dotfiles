require("FConfig")
require("autocomplete")


local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- All Packages Here!
require("lazy").setup({

    -- ColorSchemes

    { "cryptomilk/nightcity.nvim",  version = false },
    { "Everblush/nvim",             name = "everblush" },
    { "marko-cerovac/material.nvim" },
    { "diegoulloao/neofusion.nvim", priority = 1000,   config = true },
    { "catppuccin/nvim" },
    {
        "hachy/eva01.vim",
        lazy = false,
        priority = 1000,
    },
    {
        "water-sucks/darkrose.nvim",
        lazy = false,
        priority = 1000,
    },
    { "navarasu/onedark.nvim" },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    },
    { "tiagovla/tokyodark.nvim" },
    --
    --
    -- End of ColorSchemes
    --
    --
    {
        "sontungexpt/stcursorword",
        event = "VeryLazy",
        config = true,
    },
    {
        'echasnovski/mini.nvim',
        version = false,
        config = function()
            require('mini.indentscope').setup()
        end
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        -- or                              , branch = "0.1.x",
        dependencies = { "nvim-lua/plenary.nvim" }
    },
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
    { "ThePrimeagen/harpoon" },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" }
    },
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = {
            { "saadparwaiz1/cmp_luasnip" }
        },
    },
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            { "L3MON4D3/LuaSnip" },
            { "hrsh7th/cmp-nvim-lsp" }
        },
    },
    { "neovim/nvim-lspconfig" },
    { "tpope/vim-fugitive" }, -- Github integration
    {
        "stevearc/oil.nvim",
        opts = {},
        -- Optional dependencies
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "nvimdev/dashboard-nvim",
        event = "VimEnter",
        dependencies = { { "nvim-tree/nvim-web-devicons" } }
    },
    {
        "karb94/neoscroll.nvim",
        config = function()
            require("neoscroll").setup {} -- Comment / uncomment to enable / disable
        end
    },
    {
        "junegunn/vim-easy-align"
    },
    {
        "stevearc/conform.nvim",
        opts = {}
    },
    {
        "nvim-tree/nvim-tree.lua",
        config = function()
            require("nvim-tree").setup({
                auto_reload_on_write = true,
                update_focused_file = {
                    enable = true,
                    update_root = true
                }

            })
            vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<cr>")
        end
    },
    -- Markdown Rendering
    {
        "MeanderingProgrammer/render-markdown.nvim",
        -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
        -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" }, -- if you prefer nvim-web-devicons
        ---@module "render-markdown"
        ---@type render.md.UserConfig
        opts = {},
    },
    -- Formatting null-ls and prettier
    -- { "h-hg/fcitx.nvim" },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
})
