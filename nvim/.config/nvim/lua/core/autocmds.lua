-- Disable diagnostics in node_modules (0 is current buffer only)
vim.api.nvim_create_autocmd(
	{ "BufRead", "BufNewFile" },
	{ pattern = "*/node_modules/*", command = "lua vim.diagnostic.disable(0)" }
)
-- Enable spell checking for certain file types
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.txt", "*.md", "*.tex" },
	command = "setlocal spell",
})
-- Show `` in specific files
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.txt", "*.md", "*.json" },
	command = "setlocal conceallevel=0",
})
-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank({ higroup = "TabLineSel", timeout = 150 })
	end,
})

-- Disable diagnostics in node_modules (0 is current buffer only)
vim.api.nvim_create_autocmd(
	{ "BufRead", "BufNewFile" },
	{ pattern = "*/node_modules/*", command = "lua vim.diagnostic.disable(0)" }
)

-- Associate .handlebars and .hbs files with Handlebars syntax
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = { "*.handlebars", "*.hbs" },
	command = "set filetype=handlebars",
})

-- Auto reload aerospace config
vim.api.nvim_create_autocmd("BufWritePost", {
	pattern = { "aerospace.toml" },
	command = "!aerospace reload-config",
})

-- No comment on new line
vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove("c")
		vim.opt.formatoptions:remove("r")
		vim.opt.formatoptions:remove("o")
	end,
})

-- File rename
local prev = { new_name = "", old_name = "" } -- Prevents duplicate events
vim.api.nvim_create_autocmd("User", {
	pattern = "NvimTreeSetup",
	callback = function()
		local events = require("nvim-tree.api").events
		events.subscribe(events.Event.NodeRenamed, function(data)
			if prev.new_name ~= data.new_name or prev.old_name ~= data.old_name then
				data = data
				Snacks.rename.on_rename_file(data.old_name, data.new_name)
			end
		end)
	end,
})

-- open files at the last edit location
vim.api.nvim_create_autocmd("BufReadPost", {
	desc = "Open file at the last position it was edited earlier",
	group = misc_augroup,
	pattern = "*",
	command = 'silent! normal! g`"zv',
})

-- auto refresh files after Neogit discard
vim.api.nvim_create_autocmd("CursorHold", {
	pattern = "*",
	command = "checktime",
})
