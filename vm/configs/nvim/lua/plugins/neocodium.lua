return {
    "monkoose/neocodeium",
    event = "VeryLazy",
    config = function()
        local neocodeium = require("neocodeium")
        neocodeium.setup()
        vim.keymap.set("i", "<C-l>", neocodeium.accept)
        vim.keymap.set("i", "<C-h>", neocodeium.accept_word)
        vim.keymap.set("n", "<leader>z", function()
            vim.cmd("NeoCodeium toggle")
        end)
        vim.cmd([[NeoCodeium disable]])
    end,
}
