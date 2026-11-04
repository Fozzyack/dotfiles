local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
    s({ trig = "rcomp", dscr = "React arrow component with a default export" }, fmt([[
const $! = () => {
    return (
        <div>
            $!
        </div>
    );
};

export default $!;
$!]], {
        i(1, "Component"),
        i(2),
        rep(1),
        i(0),
    }, { delimiters = "$!" })),
}
