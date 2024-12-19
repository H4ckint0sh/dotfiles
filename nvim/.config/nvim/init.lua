require("util.globals")
require("core.options")

-- lazy
require("core.lazy")

-- Custom
require("custom.session") -- Substitutes in the statusline

-- LSP
require("lsp.config")
require("lsp.setup")

-- These are not Loaded by lazy.nvim
require("core.autocmds")
require("core.keymaps")

-- Load custom modules
for _, file in ipairs(vim.fn.readdir(vim.fn.stdpath("config") .. "/lua/user_functions", [[v:val =~ '\.lua$']])) do
	require("user_functions." .. file:gsub("%.lua$", ""))
end
