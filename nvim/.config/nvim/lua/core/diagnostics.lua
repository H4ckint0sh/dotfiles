vim.diagnostic.config({
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "", -- ◉✘
			[vim.diagnostic.severity.WARN] = "", -- ●▲
			[vim.diagnostic.severity.INFO] = "", -- •
			[vim.diagnostic.severity.HINT] = "", -- ·⚑
		},
		linehl = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "",
		},
		texthl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
		},
		numhl = {
			[vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
			[vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
			[vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
		},
		severity = { min = vim.diagnostic.severity.WARN },
		-- prefix = "icons", -- TODO: nvim 0.10.0
	},
	float = { header = "", source = true },
	virtual_text = true,
	virtual_lines = false,
	update_in_insert = true,
	severity_sort = true,
	underline = false, -- use custom diagnostic handler instead to filter for which diagnostics to show an underline
})

vim.keymap.set("n", "[e", function()
	vim.diagnostic.jump({
		count = -1,
		enable_popup = false,
		severity = vim.diagnostic.severity.ERROR,
	})
end, { desc = "Prev error" })
vim.keymap.set("n", "]e", function()
	vim.diagnostic.jump({
		count = 1,
		enable_popup = false,
		severity = vim.diagnostic.severity.ERROR,
	})
end, { desc = "Next error" })
vim.keymap.set("n", "[w", function()
	vim.diagnostic.jump({
		count = -1,
		enable_popup = false,
		severity = vim.diagnostic.severity.WARN,
	})
end, { desc = "Prev warning" })
vim.keymap.set("n", "]w", function()
	vim.diagnostic.jump({
		count = 1,
		enable_popup = false,
		severity = vim.diagnostic.severity.WARN,
	})
end, { desc = "Next warning" })

-- Disable LSP logging
vim.lsp.set_log_level("off")
