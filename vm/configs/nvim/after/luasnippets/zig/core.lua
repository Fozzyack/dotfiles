local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s({ trig = "zfn", dscr = "Zig function declaration" }, fmt([[
fn <>(<>) <> {
    <>
}
<>
]], { i(1, "name"), i(2), i(3, "void"), i(4), i(0) }, { delimiters = "<>" })),

    s({ trig = "zstruct", dscr = "Zig named struct with Self alias" }, fmt([[
const <> = struct {
    const Self = @This();

    <>
};
<>
]], { i(1, "Name"), i(2), i(0) }, { delimiters = "<>" })),

    s({ trig = "ztest", dscr = "Zig named test block" }, fmt([[
test "<>" {
    <>
}
<>
]], { i(1, "description"), i(2), i(0) }, { delimiters = "<>" })),
}
