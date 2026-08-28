vim.diagnostic.config({
    virtual_text = true, -- inline diagnostics
    virtual_lines = false, -- multi-line diagnostics
    severity_sort = true,
    underline = true,
    update_in_insert = true,
})

-- Keymaps to supress and unsupress diagnostics
vim.keymap.set('n', '<leader><leader>r', function()
    vim.diagnostic.enable(false, { bufnr = 0 })
end)
vim.keymap.set('n', '<leader><leader>e', function()
    vim.diagnostic.enable(true, { bufnr = 0 })
end)
vim.keymap.set('n', '<leader><leader>d', function()
    vim.diagnostic.open_float()
end)

vim.keymap.set('n', '<leader>dj', function()
    vim.diagnostic.jump({count = 1})
end)
vim.keymap.set('n', '<leader>dk', function()
    vim.diagnostic.jump({count = -1})
end)
