local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s("prop", fmt("public <> <> { get; set; }<>", {
        i(1, "string"), i(2, "Name"), i(0),
    }, { delimiters = "<>" })),
}
