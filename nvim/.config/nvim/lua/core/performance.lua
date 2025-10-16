local M = {}

-- Disable unused or slow default plugins
vim.g.loaded_matchit = 1 -- Disable enhanced % matching
vim.g.loaded_matchparen = 1 -- Disable highlight of matching parentheses
vim.g.loaded_tutor_mode_plugin = 1 -- Disable tutorial
vim.g.loaded_2html_plugin = 1 -- Disable 2html converter
vim.g.loaded_zipPlugin = 1 -- Disable zip file browsing
vim.g.loaded_tarPlugin = 1 -- Disable tar file browsing
vim.g.loaded_gzip = 1 -- Disable gzip file handling
vim.g.loaded_netrw = 1 -- Disable netrw (using nvim-tree instead)
vim.g.loaded_netrwPlugin = 1 -- Disable netrw plugin
vim.g.loaded_netrwSettings = 1 -- Disable netrw settings
vim.g.loaded_netrwFileHandlers = 1 -- Disable netrw file handlers
vim.g.loaded_spellfile_plugin = 1 -- Disable spellfile plugin

-- Performance optimizations
-- Reduce the frequency of status line updates
vim.opt.lazyredraw = true

-- Set higher CursorHold time to reduce CPU usage
vim.opt.updatetime = 300

-- Limit syntax highlighting for better performance
vim.opt.synmaxcol = 200

-- Limit the number of screen lines to be redrawn
vim.opt.redrawtime = 1500

-- Limit backups to improve performance
vim.opt.history = 500

-- Limit jumplist to improve performance
vim.opt.jumpoptions = "stack"
vim.opt.shada = "!,'100,<50,s10,h"

return M
