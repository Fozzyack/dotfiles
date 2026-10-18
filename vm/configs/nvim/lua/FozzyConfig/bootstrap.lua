-- Run after Lazy! sync, not on every editor startup.
return function()
    local ok, err = pcall(function()
        local registry = require("mason-registry")
        local refreshed, refresh_ok = false, false
        registry.refresh(function(success)
            refresh_ok = success
            refreshed = true
        end)
        assert(vim.wait(300000, function() return refreshed end, 100), "Mason registry refresh timed out")
        assert(refresh_ok, "Mason registry refresh failed")

        -- Package names, rather than lspconfig server names. Roslyn comes
        -- from the Crashdummyy registry configured in after/plugin/lsp.lua.
        local tools = {
            "css-lsp", "html-lsp", "lua-language-server", "marksman",
            "cmake-language-server", "docker-compose-language-service", "gopls",
            "tailwindcss-language-server", "django-language-server", "pyright",
            "bash-language-server", "vue-language-server", "vtsls", "sqls",
            "svelte-language-server", "clangd", "zls", "roslyn",
            "prettier", "prettierd", "csharpier", "autopep8", "black", "clang-format",
        }
        local failed = {}
        -- Install sequentially to keep memory use manageable in small VMs.
        for _, name in ipairs(tools) do
            local pkg = registry.get_package(name)
            if not pkg:is_installed() then
                print("Installing " .. name)
                local finished, installed = false, false
                pkg:install():once("closed", function()
                    installed = pkg:is_installed()
                    finished = true
                end)
                assert(vim.wait(900000, function() return finished end, 100), name .. " installation timed out")
                if not installed then
                    table.insert(failed, name)
                end
            end
        end
        assert(#failed == 0, "Mason installations failed (see :MasonLog): " .. table.concat(failed, ", "))

        local parsers = require("FozzyConfig.parsers")
        require("nvim-treesitter").install(parsers):wait(900000)
        -- Do not report success if a parser download or compilation failed.
        for _, lang in ipairs(parsers) do
            assert(vim.treesitter.language.add(lang), "Tree-sitter parser missing: " .. lang)
        end
        print("Neovim language servers, formatters and parsers are installed.")
    end)
    if not ok then
        vim.api.nvim_err_writeln(tostring(err))
        vim.cmd("cquit 1")
    end
end
