-- OLD CONFIG
-- vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
-- vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
-- vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
-- vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
-- vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')


local harpoon = require("harpoon");

harpoon:setup()

vim.keymap.set("n", "<leader>e", function()
    harpoon.ui:toggle_quick_menu(harpoon:list())
end)

vim.keymap.set("n", "<leader>a", function()
    harpoon:list():add()
end)

for i = 0, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
        harpoon:list():select(i)
    end)
end
