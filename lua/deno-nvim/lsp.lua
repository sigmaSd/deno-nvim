local dn = require("deno-nvim")
local lspconfig = require("lspconfig")

local M = {}

local function setup_handlers()
    local lsp_opts = dn.config.options.server
    local custom_handlers = {}

    custom_handlers['deno/registryState'] = function(_, result, context)
        -- https://github.com/denoland/vscode_deno/blob/45d343516ab1250867a5cb254460278f0ceca2a2/client/src/notification_handlers.ts
        local client = vim.lsp.get_client_by_id(context.client_id)
        local suggest_imports_config = (client.config.settings.deno.suggest or {}).imports or {}
        local hosts = suggest_imports_config.hosts or {}
        hosts[result.origin] = true

        local new = { deno = { suggest = { imports = { hosts = hosts } } } }
        client.config.settings = vim.tbl_deep_extend('force', client.config.settings, new)
        client.notify('workspace/didChangeConfiguration', {
            settings = new,
        })
    end

    lsp_opts.handlers = vim.tbl_deep_extend(
        "force",
        custom_handlers,
        lsp_opts.handlers or {}
    )
end

local function setup_lsp()
    lspconfig.denols.setup(dn.config.options.server)
end

function M.setup()
    setup_handlers()
    setup_lsp()
end

return M
