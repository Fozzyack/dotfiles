local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', ":Telescope find_files hidden=true<CR>", { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })
