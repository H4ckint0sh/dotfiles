---@diagnostic disable: different-requires
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- lazy
require("core.lazy")

-- Utils
require("util")
require("util.globals")
require("custom.substitute") -- Substitutes in the statusline
require("custom.session") -- Substitutes in the statusline

-- LSP
require("lsp.config")
require("lsp.setup")
require("lsp.functions")

-- These modules are not loaded by lazy
require("core.autocmds")
require("core.options")
require("core.keymaps")

-- Load custom modules
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/user_functions", [[v:val =~ '\.lua$']])) do
	require("user_functions." .. file:gsub("%.lua$", ""))
end
