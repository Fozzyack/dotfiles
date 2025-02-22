require("FConfig")


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

    { 'cryptomilk/nightcity.nvim', version = false },
    { 'Everblush/nvim', name = 'everblush' },
    { 'Abstract-IDE/Abstract-cs'},
    { 'marko-cerovac/material.nvim'},
    { 'olivercederborg/poimandres.nvim'},
    { "xero/miasma.nvim"},
    { "kyazdani42/blue-moon" },
    {
		'nvim-telescope/telescope.nvim', tag = '0.1.5',
		-- or                              , branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
	{'ThePrimeagen/harpoon'},
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		lazy = true,
		config = false,
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
		}
	},
    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = {
            {'saadparwaiz1/cmp_luasnip'}
        },
    },
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{'L3MON4D3/LuaSnip'}
		},
	},
	{'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{"zbirenbaum/copilot.lua"},
	{'tpope/vim-fugitive'},
	{
        'MunifTanjim/prettier.nvim',
        dependencies = {
            {'jose-elias-alvarez/null-ls.nvim'},
            {'neovim/nvim-lspconfig'},
        },
    },
    {'ThePrimeagen/vim-be-good'},
    {
      'stevearc/oil.nvim',
      opts = {},
      -- Optional dependencies
      dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
      'nvimdev/dashboard-nvim',
      event = 'VimEnter',
      dependencies = { {'nvim-tree/nvim-web-devicons'}}
    },
    {
      "karb94/neoscroll.nvim",
      config = function ()
        -- require('neoscroll').setup {} -- Comment / uncomment to enable / disable
      end
    },
    {
        'nvim-tree/nvim-tree.lua',
        config = function ()
            require('nvim-tree').setup({
                auto_reload_on_write = true,
                update_focused_file = {
                    enable = true,
                    update_root = true
                }

            })
            vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<cr>")
       end
    },
    {
      "folke/tokyonight.nvim",
      lazy = false,
      priority = 1000,
      opts = {},
    },
    {
        "ellisonleao/glow.nvim", 
        config = true, 
        cmd = "Glow"
    },
    {'h-hg/fcitx.nvim'},
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
 --   {
 --    "folke/noice.nvim",
 --    event = "VeryLazy",
 --    opts = {
 --      -- add any options here
 --    },
 --    dependencies = {
 --      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
 --      "MunifTanjim/nui.nvim",
 --      -- OPTIONAL:
 --      --   `nvim-notify` is only needed, if you want to use the notification view.
 --      --   If not available, we use `mini` as the fallback
 --      "rcarriga/nvim-notify",
 --      }
 --  }, 
})
