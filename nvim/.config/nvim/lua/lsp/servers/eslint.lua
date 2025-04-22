local M = {}

local on_attach = function(client, bufnr)
	client.server_capabilities.documentFormattingProvider = true
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

M.on_attach = on_attach

M.settings = {
	slint = {
		packageManager = "npm",
		run = "onSave",
		rulesCustomizations = {},
		validate = "on", -- Validate JS/TS files
		codeAction = {
			disableRuleComment = {
				enable = true,
				location = "separateLine",
			},
			showDocumentation = {
				enable = true,
			},
		},
		-- Critical performance flags:
		experimental = {
			useFlatConfig = true, -- For eslint.config.js (new config system)
		},
		workingDirectory = {
			mode = "auto", -- Auto-detect project root
		},
	},
}

return M
