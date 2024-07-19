-- ~/.config/nvim/lua/statusline.lua

local M = {}

local is_recording = false
local recording_register = ""

-- Function to check if macro recording is active
function M.check_recording()
  if is_recording then
    return "Recording @" .. recording_register
  else
    return ""
  end
end

-- Autocommands to detect macro recording start and stop
vim.api.nvim_create_autocmd('RecordingEnter', {
  callback = function()
    is_recording = true
    recording_register = vim.fn.reg_recording()
    vim.cmd('redrawstatus')
  end,
})

vim.api.nvim_create_autocmd('RecordingLeave', {
  callback = function()
    is_recording = false
    vim.cmd('redrawstatus')
  end,
})

return M
