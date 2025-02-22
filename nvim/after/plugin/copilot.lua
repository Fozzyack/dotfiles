require('copilot').setup({
	panel = {
		enabled = true,
		auto_refresh = true,
		keymap = {
			jump_prev = "[[",
			jump_next = "]]",
			accept = "<CR>",
			refresh = "gr",
			open = "<M-CR>"
		},
		layout = {
			position = "right", -- | top | left | right
			ratio = 0.3
		},
	},
	suggestion = {
		enabled = true,
		auto_trigger = true,
		debounce = 75,
		keymap = {
			accept = "<M-1>",
			accept_word = false,
			accept_line = false,
			next = "<M-2>",
			prev = "<M-3>",
			dismiss = "<C-]>",
		},
	},
	filetypes = {
		yaml = false,
		markdown = false,
		help = false,
		gitcommit = false,
		gitrebase = false,
		hgcommit = false,
		svn = false,
		cvs = false,
		["."] = false,
	},
	copilot_node_command = 'node', -- Node.js version must be > 18.x
	server_opts_overrides = {},
})

vim.cmd("Copilot disable")
local enabled = false
vim.keymap.set("n", "<leader>l", function()
    if enabled then
        vim.cmd("Copilot disable")
        print("Copilot - DISABLED")
    else
        vim.cmd("Copilot enable")
        print("Copilot - ENABLED")
    end
    enabled = not enabled
end)












