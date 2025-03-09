local M = {}

local function get_latest_version(line, on_data)
  if on_data == nil then
    return
  end
  -- if line doesn't resemble an http dependency, return
  if not string.match(line, 'https://') then
    return
  end
  -- extract the url from the line
  local url = string.match(line, '"(.+)"')
  -- if the url doesn't contain '@' then there is nothing we can update
  if not url:match('@') then
    print("line doesn't contain an updateable module")
    return
  end
  -- extract the module name
  -- in this case its simple_shell
  local module = string.match(url, '/x/(.+@.+)')
  local namespace = module and 'x' or 'std'
  if not module then
    module = string.match(url, '/(std@.+)')
  end
  module = vim.split(module, '/')[1]
  -- fetch the latest version
  local latest_url = string.format(
    'https://apiland.deno.dev/v2/modules/%s',
    namespace == 'x' and vim.split(module, '@')[1] or 'std'
  )

  local uv = vim.loop
  local stdout = uv.new_pipe()
  local stderr = uv.new_pipe()

  local cmd = string.format(
    [[
        const latest_version = await fetch("%s").then(r=>r.json()).then(r => r.latest_version)
        console.log(latest_version)
        ]],
    latest_url
  )
  uv.spawn('deno', {
    args = { 'eval', cmd },
    stdio = { stdout, stderr },
  })

  if stderr ~= nil then
    uv.read_start(stderr, function(err, data)
      assert(not err, err)
      if data then
        local latest_version = data
        local new_module = vim.split(module, '@')[1] .. '@' .. latest_version
        new_module = vim.trim(new_module)
        if new_module == module then
          on_data()
          return
        end

        local new_line, _ = string.gsub(line, module, new_module)
        on_data(new_line, new_module)
        -- return new_line, new_module
      end
    end)
  end
end

local namespace_id = vim.api.nvim_create_namespace('deno update')
local function mark_line(buf, mark, start_idx)
  vim.schedule(function()
    local extmark_id = vim.api.nvim_buf_set_extmark(
      buf,
      namespace_id,
      start_idx,
      -1,
      { id = start_idx + 1, virt_text = { { mark } } }
    )
    vim.defer_fn(function()
      vim.api.nvim_buf_del_extmark(buf, namespace_id, extmark_id)
    end, 3000)
  end)
end

function DenoUpdateImports()
  local buf = vim.api.nvim_get_current_buf()
  local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  for i, line in ipairs(content) do
    if line:match('@') then
      get_latest_version(line, function(new_line)
        vim.schedule(function()
          local start_idx = i - 1
          if new_line ~= nil then
            vim.api.nvim_buf_set_lines(buf, start_idx, start_idx + 1, false, { new_line })
          end
          mark_line(buf, '✨', start_idx)
        end)
      end)
    end
  end
end

function DenoUpdateImport()
  local buf = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_buf_get_lines(buf, cursor_pos[1] - 1, cursor_pos[1], false)[1]

  if line:match('@') then
    get_latest_version(line, function(new_line)
      vim.schedule(function()
        if new_line ~= nil then
          vim.api.nvim_buf_set_lines(buf, cursor_pos[1] - 1, cursor_pos[1], false, { new_line })
        end
        mark_line(buf, '✨', cursor_pos[1] - 1)
      end)
    end)
  end
end

function DenoCheckImports()
  local buf = vim.api.nvim_get_current_buf()
  local content = vim.api.nvim_buf_get_lines(buf, 0, -1, false)

  for i, line in ipairs(content) do
    if line:match('@') then
      get_latest_version(line, function(new_line, new_module)
        local mark
        if new_line then
          mark = string.format('🔺%s', new_module)
        else
          mark = '✨'
        end
        mark_line(buf, mark, i - 1)
      end)
    end
  end
end

function DenoCheckImport()
  local buf = vim.api.nvim_get_current_buf()
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_buf_get_lines(buf, cursor_pos[1] - 1, cursor_pos[1], false)[1]

  if line:match('@') then
    get_latest_version(line, function(new_line, new_module)
      local mark
      if new_line then
        mark = string.format('🔺%s', new_module)
      else
        mark = '✨'
      end
      mark_line(buf, mark, cursor_pos[1] - 1)
    end)
  end
end

function M.setup_custom_commands()
  vim.api.nvim_create_user_command('Deno', function(meta)
    if meta.args == 'update_imports' then
      DenoUpdateImports()
    elseif meta.args == 'update_import' then
      DenoUpdateImport()
    elseif meta.args == 'check_imports' then
      DenoCheckImports()
    elseif meta.args == 'check_import' then
      DenoCheckImport()
    end
  end, {
    nargs = 1,
    complete = function()
      return { 'update_imports', 'update_import', 'check_imports', 'check_import' }
    end,
  })
end

return M
