# Custom LuaSnip snippets

These supplement friendly-snippets; they do not replace it. The Lua loader is
configured in `after/plugin/luasnip.lua`.

## Add snippets

Create `after/luasnippets/<neovim-filetype>/<name>.lua`. Each Lua file returns a list of
snippets. Use `:set filetype?` to check the current buffer's filetype.

```lua
local ls = require("luasnip")

return {
    ls.snippet("example", {
        ls.text_node("Hello "),
        ls.insert_node(1, "world"),
        ls.insert_node(0),
    }),
}
```

Numbered insert nodes define the jump order; `insert_node(0)` is the final exit.
Use a separate node for each editable section and `rep` only for mirrored text.
Existing snippet files reload when saved. Restart Neovim if a newly added file
is not picked up.

## Available custom snippets

| Filetype | Trigger | Expansion |
| --- | --- | --- |
| `javascriptreact`, `typescriptreact` | `rcomp` | Arrow component with default export; name and body are separate placeholders |
| `javascriptreact`, `typescriptreact` | `ruseid` | Stable ID for accessible fields (React 18+) |
| `javascriptreact`, `typescriptreact` | `rtransition` | Non-blocking state update with a pending flag (React 18+) |
| `javascriptreact`, `typescriptreact` | `rdeferred` | Deferred render value (React 18+) |
| `javascriptreact`, `typescriptreact` | `rtoggle` | Reusable boolean toggle hook; TSX version returns a typed tuple |
| `cs` | `prop` | C# auto-property (moved from the inline configuration) |
| `zig` | `zfn` | Function declaration |
| `zig` | `zstruct` | Named struct with `Self` alias |
| `zig` | `ztest` | Named test block |
| `c` | `cqsortcmp` | Overflow-safe comparator for sorting `int` elements |
| `python` | `pydataclass` | Dataclass with a per-instance list default (Python 3.9+) |
| `python` | `pyargparse` | Standard-library argument parser |
| `python` | `pyrun` | Checked subprocess with captured text output |

The `ruseid`, `rtransition`, and `rdeferred` snippets are hook-call fragments for
component or custom-hook bodies. Add the corresponding named imports from
`"react"` at module scope. `rtoggle` is a complete module-level hook and includes
its imports. Hooks must be called unconditionally at the top level of a component
or custom hook. `useId` is for accessibility IDs, not list keys.

Common component and hook templates remain available through friendly-snippets,
including `rfc`, `rafce`, `us` (useState), and `ue` (useEffect).

React, Zig, C and Python additions fill gaps checked against the installed
friendly-snippets collection. Future collection updates may add similar snippets.
The C comparator is file-scope code; the Python snippets are module-level
scaffolds and include imports at the expansion point.

## Keys

- Accept snippets through Blink's completion menu (currently `<C-u>`).
- `<C-l>` / `<C-h>`: jump forward / backward in insert or select mode.
- `<C-e>`: cycle an active choice node.
- `<C-k>`: previous completion in Blink, not manual LuaSnip expansion.
- `<C-g>l` / `<C-g>h`: NeoCodeium acceptance, avoiding the snippet jump keys.
