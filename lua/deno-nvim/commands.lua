local dn = require('deno-nvim')

local M = {}

function M.setup_lsp_commands()
  vim.lsp.commands['deno.test'] = function(args)
    local file = args.arguments[1]:gsub('file:///', '/')
    local test_name = args.arguments[2]

    if args.title == 'Debug' then
      -- test command
      -- we use dap here
      dn.dap.start({
        program = file,
        test_filter = '/^' .. test_name .. '$/',
      })
    else
      -- run command
      local cmd = 'split term://deno test --no-check --unstable -A '
        .. file
        .. ' --filter '
        .. vim.fn.fnameescape("'/^" .. test_name .. "$/'")
      vim.cmd(cmd)
    end
  end
end

return M
