local M = {
    config = nil,
    lsp = nil,
}

function M.setup(opts)
    local commands = require("deno-nvim.commands")

    local config = require("deno-nvim.config")
    M.config = config

    local lsp = require("deno-nvim.lsp")
    M.lsp = lsp


    config.setup(opts)
    lsp.setup()
    commands.setup_lsp_commands()
end

return M
