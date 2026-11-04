local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
    s({ trig = "cqsortcmp", dscr = "Overflow-safe qsort comparator for int elements" }, fmt([[
static int [](const void *lhs, const void *rhs)
{
    const int a = *(const int *)lhs;
    const int b = *(const int *)rhs;

    return (a > b) - (a < b);
}
[]
]], { i(1, "compare_int"), i(0) }, { delimiters = "[]" })),
}
