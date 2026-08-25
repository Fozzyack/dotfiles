return {
    {
        "NeogitOrg/neogit",
        lazy = true,
        dependencies = {
            "esmuellert/codediff.nvim",  -- optional
            "nvim-telescope/telescope.nvim", -- optional
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
