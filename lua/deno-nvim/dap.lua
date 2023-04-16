local dn = require("deno-nvim")

local M = {}

local function scheduled_error(err)
    vim.schedule(function()
        vim.notify(err, vim.log.levels.ERROR)
    end)
end

function M.start(args)
    if not pcall(require, "dap") then
        scheduled_error("nvim-dap not found.")
        return
    end
    local dap = require("dap")

    local dap_config = {
        name = "Deno debug",
        type = 'pwa-node',
        request = 'launch',
        runtimeExecutable = "deno",
        runtimeArgs = {
            "test",
            "--inspect-wait",
            "--unstable",
            "--no-check",
            "--allow-all",
            "--filter",
            args.test_filter,
        },
        program = args.program,
        cwd = "${workspaceFolder}",
        attachSimplePort = 9229,
    }
    dap.run(dap_config)
end

function M.setup_adapter()
    local dap = require("dap")
    local opts = dn.config.options

    if opts.dap.adapter ~= false then
        dap.adapters["pwa-node"] = opts.dap.adapter
        vim.print(dap.adapters.dn_node)
    end
end

return M
