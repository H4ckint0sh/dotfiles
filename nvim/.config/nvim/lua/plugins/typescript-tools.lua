local baseDefinitionHandler = vim.lsp.handlers["textDocument/definition"]

local filter = require("lsp.utils.filter").filter
local filterReactDTS = require("lsp.utils.filterReactDTS").filterReactDTS

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		silent = true,
		border = "rounded",
	}),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
	-- ["textDocument/publishDiagnostics"] = vim.lsp.with(
	--     vim.lsp.diagnostic.on_publish_diagnostics,
	--     { virtual_text = true }
	-- ),
	["textDocument/definition"] = function(err, result, method, ...)
		if vim.tbl_islist(result) and #result > 1 then
			local filtered_result = filter(result, filterReactDTS)
			return baseDefinitionHandler(err, filtered_result, method, ...)
		end

		baseDefinitionHandler(err, result, method, ...)
	end,
}

return {
	"pmizio/typescript-tools.nvim",
	event = { "BufReadPre", "BufNewFile" },
	ft = { "typescript", "typescriptreact" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
	},
	config = function()
		require("typescript-tools").setup({
			handlers = handlers,
			settings = {
				separate_diagnostic_server = false,
				-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
				complete_function_calls = true,
				include_completions_with_insert_text = true,
				code_lens = "off",
				tsserver_file_preferences = {
					includeInlayParameterNameHints = "all",
					includeCompletionsForModuleExports = true,
					quotePreference = "auto",
				},
				tsserver_plugins = {
					-- for TypeScript v4.9+
					-- "@styled/typescript-styled-plugin",
					-- or for older TypeScript versions
					"typescript-styled-plugin",
				},
				expose_as_code_action = "all",
			},
		})
	end,
}
