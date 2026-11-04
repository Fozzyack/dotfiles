local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

-- Hook call fragments: import the named hook from "react" at module scope.
return {
    s({ trig = "ruseid", dscr = "React useId for an accessible field (React 18+)" }, fmt([[
const $! = useId();
$!]], { i(1, "fieldId"), i(0) }, { delimiters = "$!" })),

    s({ trig = "rtransition", dscr = "React useTransition with a non-blocking update (React 18+)" }, fmt([[
const [$!, $!] = useTransition();

const $! = () => {
    $!(() => {
        $!
    });
};
$!]], {
        i(1, "isPending"), i(2, "startTransition"), i(3, "handleUpdate"),
        rep(2), i(4, "setValue(nextValue);"), i(0),
    }, { delimiters = "$!" })),

    s({ trig = "rdeferred", dscr = "React useDeferredValue for a deferred render value (React 18+)" }, fmt([[
const $! = useDeferredValue($!);
$!]], { i(1, "deferredValue"), i(2, "value"), i(0) }, { delimiters = "$!" })),

    -- Full module-level hook; includes its own React import.
    -- "!!" escapes the fmt closing delimiter, producing a single "!".
    s({ trig = "rtoggle", dscr = "Reusable boolean toggle hook with stable callback" }, fmt([[
import { useCallback, useState } from "react";

export function $!(initialValue = false) {
    const [enabled, setEnabled] = useState(initialValue);
    const toggle = useCallback(() => setEnabled(value => !!value), []);

    return [enabled, toggle];
}
$!]], { i(1, "useToggle"), i(0) }, { delimiters = "$!" })),
}
