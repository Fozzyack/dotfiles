return {
    { "neovim/nvim-lspconfig", },
    {
        "mason-org/mason.nvim",
        opts = {}
    },
    {
        "seblyng/roslyn.nvim",
        ft = {"cs", "razor"} ,
        dependencies = {
            { "tris203/rzls.nvim", config = true}
        }, 
        init = function ()
            vim.filetype.add({
                extension = {
                    razor = "razor",
                    cshtml = "razor"
                }
            })
        end
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
}
