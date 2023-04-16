local M = {}

local defaults = {
    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by deno-nvim
    -- the defaults comes from https://github.com/denoland/vscode_deno/blob/main/package.json
    server = {
        settings = {
            deno = {
                enable = true,
                suggest = {
                    imports = {
                        hosts = {
                            ["https://crux.land"] = true,
                            ["https://deno.land"] = true,
                            ["https://x.nest.land"] = true
                        }
                    }
                },
            },
        }
    }, -- deno lsp options
    -- debugging stuff
    dap = {
        adapter = {
            type = "server",
            host = "localhost",
            port = "${port}",
            name = "dn_node",
            executable = {
                command = "node",
                -- `args` needs to be set
                -- follow the instruction here `https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#javascript-deno` to download and extract dapDebugServer
                -- then set `args` to the full path to dapDebugServer.js + "${port}"
                -- example:
                -- ```lua
                -- require("deno-nvim").setup {
                --   dap = {
                --     adapter = {
                --       executable = {
                --         args = {
                --           "/absolute-path/to/js-debug/src/dapDebugServer.js", "${port}"
                --         }
                --       }
                --     }
                --   }
                -- }
                -- ```
                args = {},
            },
        }
    }
}


function M.setup(options)
    M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

return M
