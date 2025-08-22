local M = {}

local function get_summary(context, opts)
    local model_choice
    if opts.args == "" then
        model_choice = "gemma3:1b"
    else
        model_choice = opts.args
    end
    local data = vim.fn.json_encode({
        model = model_choice,
        prompt = ([[
        You are a summarization assistant. You will receive a prompt and a file content. Your task is to provide a concise summary of the file.

            If the file contains code:

            - Summarize the purpose of the code.

            - For each function or method, provide a concise professional definition in comment style (e.g., `// functionName(params): Description`).
            - Focus on clarity and brevity.
            - Do not include the function implementation—only the comment-style definitions.

            Do not include unnecessary explanations or commentary. Your response should be a high-level overview suitable for a professional audience.


                File content:
        ]] .. context),
        stream = false
    })
    local response = vim.fn.system({
        "curl",
        "-s",
        "-X", "POST",
        "-H", "Content-Type: application/json",
        "-d", data,
        "http://localhost:11434/api/generate"
    })

    local decoded = vim.fn.json_decode(response)
    return decoded.response
end


local function set_summary_window(long_string)
    local buf = vim.api.nvim_create_buf(false, true)
    local lines = {}
    for line in long_string:gmatch("[^\n]*") do
        table.insert(lines, line)
    end
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_command("vsplit")
    vim.api.nvim_win_set_buf(0, buf)
end




function M.hello_world(opts)
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local content = table.concat(lines, "\n");
    print(opts.args)
    local text = get_summary(content, opts)
    set_summary_window(text)
end

vim.api.nvim_create_user_command("Summarise", function(opts)
    require("autocomplete").hello_world(opts)
end, { nargs = "?" })

return M
