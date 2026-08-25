vim.opt.termguicolors = true

vim.opt.number = true
vim.opt.relativenumber = true
vim.smartindent = true




vim.opt.mouse = 'a'
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

vim.opt.shiftwidth = 4
vim.opt.textwidth = 120
vim.opt.colorcolumn = "120"

vim.opt.expandtab = true
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- vim.opt.wrap = true -- Set to true if you want to wrap lines
vim.opt.scrolloff = 30
vim.opt.updatetime = 50

vim.opt.signcolumn = 'yes'


vim.g.default_terminal = "tmux-256color"

-- for my custom cursor
-- unsure if this is actually works on linux

-- windows doesnt like changing the width of certain cursor types
-- Remeber: you can look at the documentation (:help guicursor)
vim.opt.guicursor = "n:block-Cursor,i:hor20-Cursor"
