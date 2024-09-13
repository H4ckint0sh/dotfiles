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
	bin = "eslint", -- or `eslint_d`P-- allows to use flat config format
	experimental = {
		useFlatConfig = false,
	},
	codeAction = {
		disableRuleComment = {
			enable = true,
			location = "separateLine",
		},
		showDocumentation = {
			enable = true,
		},
	},
	codeActionOnSave = {
		enable = false,
		mode = "all",
	},
	format = true,
	nodePath = "",
	onIgnoredFiles = "off",
	packageManager = "npm",
	quiet = false,
	rulesCustomizations = {},
	run = "onType",
	useESLintClass = false,
	validate = "on",
	workingDirectory = {
		mode = "location",
	},
}

return M
