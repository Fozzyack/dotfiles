vim.cmd('highlight! HarpoonInactive guibg=NONE guifg=#63698c')
vim.cmd('highlight! HarpoonActive guibg=NONE guifg=white')
vim.cmd('highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7')
vim.cmd('highlight! TabLineFill guibg=NONE guifg=white')


local harpoonMark = require("harpoon.mark")
local harpoonUI = require("harpoon.ui")

vim.keymap.set("n", "<leader>e", function()
    harpoonUI.toggle_quick_menu()
end)

vim.keymap.set("n", "<leader>a", function()
    harpoonMark.add_file()
end)

for i = 0, 9 do
    vim.keymap.set("n", "<leader>" .. i, function()
        harpoonUI.nav_file(i)
    end)
end
