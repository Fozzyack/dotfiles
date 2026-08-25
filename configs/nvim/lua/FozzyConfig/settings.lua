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
-- Remember: you can look at the documentation (:help guicursor)
-- Also - check to make sure colourschemes do not OVERRIDE THE CURSOR
vim.opt.guicursor = table.concat({
    "n:block-Cursor",     -- normal
    "v:block-Cursor",     -- visual
    "i:hor25-Cursor",     -- insert
    "c:hor20-Cursor",     -- command-line
    "r:ver25-Cursor",     -- replace
    "cr:ver25-Cursor",    -- command-line replace
    "o:hor20-Cursor",     -- operator-pending
    "sm:block-Cursor",    -- showmatch
    "t:block-TermCursor", -- terminal
}, ",")
