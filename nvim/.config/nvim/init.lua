require("util.globals")
require("core.diagnostics")
require("core.options")

-- lazy
require("core.lazy")

-- Custom
require("custom.session") -- Substitutes in the statusline

-- LSP
require("core.lsp")

-- These are not Loaded by lazy.nvim
require("core.autocmds")
require("core.keymaps")

-- Load custom modules
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/user_functions", [[v:val =~ '\.lua$']])) do
	require("user_functions." .. file:gsub("%.lua$", ""))
end
