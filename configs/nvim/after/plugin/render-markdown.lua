
require('render-markdown').setup({
    completions = { lsp = { enabled = true } },
    render_modes = { 'n', 'c', 't' },
    heading = { border = true }
})
