local render_markdown = require("render-markdown")

render_markdown.setup({
    completions = {
        lsp = { enabled = true },
        blink = { enabled = true },
    },
})
