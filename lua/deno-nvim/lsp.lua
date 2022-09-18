local dn = require("deno-nvim")
local lspconfig = require("lspconfig")

local M = {}

local run_on_deno = function(fn)
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
        if client.name == 'denols' then
            fn(client)
            break
        end
    end
end

local function setup_commands()
    local lsp_opts = dn.config.options.server

    lsp_opts.commands = vim.tbl_deep_extend("force", lsp_opts.commands or {}, {
        DenoPerformance = {
            function()
                run_on_deno(function(client)
                    vim.pretty_print(client.request_sync('deno/performance'))
                end)
            end,
            description = "Requests the return of the timing averages for the internal instrumentation of Deno"
        },
        DenoReloadImportRegistries = {
            function()
                run_on_deno(function(client)
                    client.request_sync('deno/reloadImportRegistries')
                end)
            end,
            description = "Reloads any cached responses from import registries"
        },
        DenoTask = {
            function()
                run_on_deno(function(client)
                    local tasks = client.request_sync('deno/task').result

                    vim.ui.select(tasks, {
                        prompt = 'Select deno task to run',
                        format_item = function(task)
                            return task.name
                        end,
                    }, function(choice)
                        if choice == nil then
                            return
                        end
                        vim.cmd("split term://deno task " .. choice.name)
                    end)
                end)
            end,
            description = "List/Run deno tasks"
        },
    })
end

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
    setup_commands()
    setup_handlers()
    setup_lsp()
end

return M
