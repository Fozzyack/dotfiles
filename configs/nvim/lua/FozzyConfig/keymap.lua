vim.g.mapleader = ' '
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')
vim.keymap.set('v', '<leader>y', '"+y')
vim.keymap.set('n', '<leader>r', ":source %<CR>")

vim.keymap.set('n', '<leader><leader>r', function ()
    vim.diagnostic.enable(false, { bufnr = 0 })
end) 
vim.keymap.set('n', '<leader><leader>e', function ()
    vim.diagnostic.enable(true, { bufnr = 0 })
end)

