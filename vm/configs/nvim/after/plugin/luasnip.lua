local ls = require("luasnip")

ls.setup({
    enable_autosnippets = true,
    history = true,
    update_events = "TextChanged,TextChangedI", -- live update while typing
})

ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("typescriptreact", { "html" })
ls.filetype_extend("razor", { "html" })

-- Keep friendly-snippets and load custom snippets from filetype folders.
require("luasnip.loaders.from_vscode").lazy_load()
require("luasnip.loaders.from_lua").lazy_load({
    paths = vim.fn.stdpath("config") .. "/after/luasnippets",
})

-- Blink expands accepted snippets; leave <C-k> available for completion navigation.
vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { silent = true })
vim.keymap.set({ "i", "s" }, "<C-h>", function() ls.jump(-1) end, { silent = true })

vim.keymap.set({ "i", "s" }, "<C-E>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })
