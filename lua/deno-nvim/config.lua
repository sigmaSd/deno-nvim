local M = {}

local defaults = {
    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by deno-nvim
    -- the defaults comes from https://github.com/denoland/vscode_deno/blob/main/package.json
    server = {
        settings = {
            deno = {
                enable = true,
                unstable = true,
                suggest = {
                    imports = {
                        hosts = {}
                    }
                }
            },
        }
    }, -- deno lsp options
}

for _, register in ipairs({ "https://deno.land", "https://x.nest.land", "https://crux.land" }) do
    defaults.server.settings.deno.suggest.imports.hosts[register] = true
end

function M.setup(options)
    M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

return M
