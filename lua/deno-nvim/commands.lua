local M = {}

function M.setup_lsp_commands()
    vim.lsp.commands["deno.test"] = function(args)
        local file = args.arguments[1]:gsub("file:///", "/")
        local test_name = args.arguments[2]
        local cmd = "split term://deno test --no-check --unstable -A " .. file .. " --filter " .. test_name
        vim.cmd(cmd)
    end
end

return M
