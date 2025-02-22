local ls = require("luasnip")

ls.config.set_config({
    history = true,
    updateevents = "TextChanged,TextChangedI",
    enable_autosnippets = true,

})
vim.keymap.set({"i", "s"}, "<C-3>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-1>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-2>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

