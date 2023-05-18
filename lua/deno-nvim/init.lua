local M = {
    config = nil,
    lsp = nil,
    dap = nil,
}

function M.setup(opts)
    local commands = require("deno-nvim.commands")

    local config = require("deno-nvim.config")
    M.config = config

    local lsp = require("deno-nvim.lsp")
    M.lsp = lsp

    local dn_dap = require("deno-nvim.dap")
    M.dap = dn_dap

    local custom_commands = require("deno-nvim.custom_commands")

    config.setup(opts)
    lsp.setup()
    commands.setup_lsp_commands()
    custom_commands.setup_custom_commands()

    if pcall(require, "dap") then
        dn_dap.setup_adapter()
    end
end

return M
