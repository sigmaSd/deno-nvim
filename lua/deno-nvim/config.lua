local M = {}

local defaults = {
    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by deno-nvim
    -- see TODO
    server = {
        settings = {
            deno = {
                enable = true,
                unstable = true,
            }
        }
    }, -- deno lsp options
}

function M.setup(options)
    M.options = vim.tbl_deep_extend("force", {}, defaults, options or {})
end

return M
