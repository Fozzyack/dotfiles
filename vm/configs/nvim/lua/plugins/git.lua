return {
    {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            "esmuellert/codediff.nvim", -- optional

            -- For a custom log pager
            "m00qek/baleia.nvim", -- optional
        },
        cmd = "Neogit",
        keys = {
            { "<leader><leader>g", "<cmd>Neogit<cr>", desc = "Show Neogit UI" }
        }
    },
    {
        "lewis6991/gitsigns.nvim"
    },
}
