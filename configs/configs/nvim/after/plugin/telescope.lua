local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader><leader>f', ":Telescope find_files hidden=true<CR>", { desc = 'Telescope find All files' })
vim.keymap.set('n', '<leader>g', builtin.live_grep, { desc = 'Telescope live grep' })

-- optional go to definition
 vim.api.nvim_create_autocmd("LspAttach", {
     callback = function(event)



         vim.keymap.set("n", "gd", vim.lsp.buf.definition, {
             buffer = event.buf,
             desc = "Go to definition",
         })

         -- Add more LSP telescope bindings below if needed

     end,
 })

