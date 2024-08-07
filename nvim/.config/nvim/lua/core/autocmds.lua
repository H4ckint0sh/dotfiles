-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
	end,
})
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
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 100 })
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
