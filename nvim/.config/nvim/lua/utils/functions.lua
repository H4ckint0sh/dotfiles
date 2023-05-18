local utils = require('utils')

local async_present, async = pcall(require, "plenary.async")
if not async_present then
  return
end

-- Exported functions
local M = {}

M.first_h4ckintosh_run = function()
  local is_first_run = utils.file_exists('/tmp/first-h4ckint0sh-run')

  if is_first_run then
    async.run(function()
      require('notify')("Welcome to h4ckint0sh! Hope you'll have a nice experience!", "info", { title = "H4ckint0sh", timeout = 5000 })
      require('notify')("Please install treesitter servers manually by :TSInstall command.", "info", { title = "Installation", timeout = 10000 })
    end)
    local suc = os.remove('/tmp/first-h4ckint0sh-run')
    if (not suc) then print("Error: Couldn't remove /tmp/first-h4ckint0sh-run!") end
  end
end

M.first_h4ckint0sh_run()

local present, win = pcall(require, "lspconfig.ui.windows")
if not present then
  return
end

local _default_opts = win.default_opts
win.default_opts = function(options)
  local opts = _default_opts(options)
  opts.border = H4ckint0sh.ui.float.border
  return opts
end

return M
