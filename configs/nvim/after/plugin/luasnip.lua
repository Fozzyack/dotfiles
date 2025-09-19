local ls = require("luasnip")
-- Setting up "friendly-snippets"
require("luasnip.loaders.from_vscode").lazy_load()
ls.filetype_extend("typescript", {"javascript"})
ls.filetype_extend("typescriptreact", {"html", "javascript", "typescript"}) -- Setting TypeScript React

--


-- Setting up other snippets 

local s = ls.snippet
local i = ls.insert_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt

ls.setup({
    enable_autosnippets = true,
    history = true,
    updateevents = "TextChanged,TextChangedI", -- live update while typing
})



vim.keymap.set({ "i" }, "<C-K>", function() ls.expand() end, { silent = true })
vim.keymap.set({"i", "s"}, "<C-l>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-h>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({ "i", "s" }, "<C-E>", function()
    if ls.choice_active() then
        ls.change_choice(1)
    end
end, { silent = true })


ls.add_snippets("typescriptreact", {
    s("rcomp", fmt([[
const $! = () => {
    return (
        <div>
            $!
        </div>
    )

}

export default $!;]], {
        i(1),
        rep(1),
        rep(1),
    }, { delimiters = "$!" }))
})

ls.add_snippets("cs", {
    s("prop", fmt([[public <> <> { get; set; }]], { i(1), i(2) }, { delimiters = "<>" }))
})
