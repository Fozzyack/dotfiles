return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local nts = require("nvim-treesitter")
            nts.setup({
                install_dir = vim.fn.stdpath("data") .. "/site",
            })

            nts.install({
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "json",
                "lua",
                "vim",
                "vimdoc",
                "go",
                "python",
                "bash",
                "c",
                "cpp",
                "sql"
            })

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match)

                    if lang and vim.treesitter.language.add(lang) then
                        vim.treesitter.start(args.buf, lang)
                    end
                end,
            })
        end,
    }
}
