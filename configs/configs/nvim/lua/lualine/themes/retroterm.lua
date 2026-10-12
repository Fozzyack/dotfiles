local p = require("retroterm.palette")

local function mode(color)
    return {
        a = { fg = p.base, bg = color, gui = "bold" },
        b = { fg = p.text, bg = p.surface },
        c = { fg = p.text, bg = p.mantle },
    }
end

return {
    normal = mode(p.accent),
    insert = mode(p.teal),
    visual = mode(p.magenta),
    replace = mode(p.red),
    command = mode(p.bright_yellow),
    terminal = mode(p.green),
    inactive = {
        a = { fg = p.muted, bg = p.mantle },
        b = { fg = p.muted, bg = p.mantle },
        c = { fg = p.muted, bg = p.mantle },
    },
}
