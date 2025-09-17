-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- OR setup with some options
require("nvim-tree").setup({

    sync_root_with_cwd = true,

    update_focused_file = {
        enable = true,
        update_root = {
            enable = true,
        },
    },


    sort = {
        sorter = "case_sensitive",
    },
    view = {
        width = 30,
    },
    renderer = {
        group_empty = true,
        icons = {
            show = {
                file = true,
                folder = true,
                folder_arrow = true,
                git = true,
                modified = true,
                hidden = true,
                diagnostics = true,
                bookmarks = true,
            },
        },
    },
    filters = {
        dotfiles = true,
    },
})



vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader><leader>t", ":NvimTreeCollapse<CR>")
