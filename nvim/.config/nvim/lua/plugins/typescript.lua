local filter = require("util.filter").filter
local filterReactDTS = require("util.filterReactDTS").filterReactDTS
local on_attach = require("plugins.lsp.on_attach")
local methods = vim.lsp.protocol.Methods
local inlay_hint_handler = vim.lsp.handlers[methods.textDocument_inlayHint]
local max_inlay_hint_length = 50

return {
	{
		"pmizio/typescript-tools.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"saghen/blink.cmp",
				lazy = false,
				priority = 1000,
			},
		},
		opts = {
			on_attach = on_attach,
			handlers = {
				["textDocument_inlayHint"] = function(err, result, ctx, config)
					local client = vim.lsp.get_client_by_id(ctx.client_id)
					if client and client.name == "typescript-tools" then
						result = vim.iter(result)
							:map(function(hint)
								local label = hint.label ---@type string
								if label:len() >= max_inlay_hint_length then
									label = label:sub(1, max_inlay_hint_length - 1) .. "..."
								end
								hint.label = label
								return hint
							end)
							:totable()
					end

					inlay_hint_handler(err, result, ctx, config)
				end,
				["textDocument/hover"] = function(_, result, ctx, config)
					config = config or {}
					config.border = "rounded"
					config.focusable = false
					config.silent = true
					vim.lsp.handlers.hover(_, result, ctx, config)
				end,
				["textDocument/signatureHelp"] = function(_, result, ctx, config)
					config = config or {}
					config.border = "rounded"
					config.focusable = false
					vim.lsp.handlers.signature_help(_, result, ctx, config)
				end,
				["textDocument/definition"] = function(err, result, ctx, config)
					-- If result is a list and has more than one item, apply the filter
					if vim.tbl_islist(result) and #result > 1 then
						local filtered_result = filter(result, filterReactDTS)
						return vim.lsp.handlers["textDocument/definition"](err, filtered_result, ctx, config)
					end
					-- If the condition is not met, pass the original result without filtering
					return vim.lsp.handlers["textDocument/definition"](err, result, ctx, config)
				end,
				["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
					if result and result.diagnostics then
						-- Filter out specific diagnostic codes
						result.diagnostics = vim.tbl_filter(function(diagnostic)
							local ignore_codes = {
								[6133] = true, -- unused variable
								[6192] = true, -- unused import
								[80001] = true, -- convert to ES module
								[1005] = true,
							}
							return not ignore_codes[diagnostic.code]
						end, result.diagnostics)
					end

					config = config or {}
					config.virtual_text = true
					vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
				end,
			},
			filetype = { "svelte", "typescriptreact", "typescript", "javascript", "javascriptreact" },
			settings = {
				separate_diagnostic_server = true,
				publish_diagnostic_on = "insert_leave",
				tsserver_max_memory = "auto",
				tsserver_locale = "en",

				tsserver_format_options = {
					insertSpaceAfterCommaDelimiter = true,
					insertSpaceAfterConstructor = false,
					insertSpaceAfterSemicolonInForStatements = true,
					insertSpaceBeforeAndAfterBinaryOperators = true,
					insertSpaceAfterKeywordsInControlFlowStatements = true,
					insertSpaceAfterFunctionKeywordForAnonymousFunctions = true,
					insertSpaceBeforeFunctionParenthesis = false,
					insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis = false,
					insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets = false,
					insertSpaceAfterOpeningAndBeforeClosingNonemptyBraces = true,
					insertSpaceAfterOpeningAndBeforeClosingEmptyBraces = true,
					insertSpaceAfterOpeningAndBeforeClosingTemplateStringBraces = false,
					insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces = false,
					insertSpaceAfterTypeAssertion = false,
					placeOpenBraceOnNewLineForFunctions = false,
					placeOpenBraceOnNewLineForControlBlocks = false,
					semicolons = "ignore",
				},

				tsserver_file_preferences = {
					disableSuggestions = true,
					quotePreference = "auto",
					importModuleSpecifierPreference = "auto",
					jsxAttributeCompletionStyle = "auto",
					allowTextChangesInNewFiles = true,
					providePrefixAndSuffixTextForRename = true,
					allowRenameOfImportPath = true,
					includeAutomaticOptionalChainCompletions = true,
					provideRefactorNotApplicableReason = true,
					generateReturnInDocTemplate = true,
					includeCompletionsForImportStatements = true,
					includeCompletionsWithSnippetText = true,
					includeCompletionsWithClassMemberSnippets = true,
					includeCompletionsWithObjectLiteralMethodSnippets = true,
					useLabelDetailsInCompletionEntries = true,
					allowIncompleteCompletions = true,
					displayPartsForJSDoc = true,
					includeInlayParameterNameHints = "literals",
					includeInlayParameterNameHintsWhenArgumentMatchesName = false,
					includeInlayFunctionParameterTypeHints = true,
					includeInlayVariableTypeHints = false,
					includeInlayVariableTypeHintsWhenTypeMatchesName = false,
					includeInlayPropertyDeclarationTypeHints = true,
					includeInlayFunctionLikeReturnTypeHints = false,
					includeInlayEnumMemberValueHints = true,
					disableLineTextInReferences = true,
				},

				complete_function_calls = false,
				include_completions_with_insert_text = true,
				tsserver_plugins = {
					"typescript-styled-plugin",
				},
			},
		},
		keys = {
			{ "<leader>oi", "<CMD>TSToolsOrganizeImports<CR>", desc = "Organize Imports" },
			{ "<leader>ui", "<CMD>TSToolsRemoveUnusedImports<CR>", desc = "Remove Unused Imports" },
			{ "<leader>mi", "<CMD>TSToolsAddMissingImports<CR>", desc = "Add Missing Imports" },
			{ "<leader>rf", "<CMD>TSToolsRenameFile<CR>", desc = "Rename File" },
			{ "<leader>si", "<CMD>TSToolsSortImports<CR>", desc = "Sort Imports" },
			{ "<leader>fa", "<CMD>TSToolsFixAll<CR>", desc = "Fix All" },
			{
				"<leader>i",
				"<CMD>lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
				desc = "Toggle Inlay Hints",
			},
		},
	},
	{
		"mawkler/jsx-element.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		ft = { "typescriptreact", "javascriptreact", "javascript" },
		opts = {},
	},
	{
		"MaximilianLloyd/tw-values.nvim",
		keys = {
			{ "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
		},
		opts = {
			border = "rounded", -- Valid window border style,
			show_unknown_classes = true, -- Shows the unknown classes popup
		},
	},

	{
		"js-everts/cmp-tailwind-colors",
		config = true,
	},

	{
		"laytan/tailwind-sorter.nvim",
		cmd = {
			"TailwindSort",
			"TailwindSortOnSaveToggle",
		},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		build = "cd formatter && npm i && npm run build",
		config = true,
	},

	{
		"axelvc/template-string.nvim",
		event = "InsertEnter",
		ft = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		},
		config = true, -- run require("template-string").setup()
	},

	{
		"dmmulroy/tsc.nvim",
		cmd = { "TSC" },
		config = true,
	},

	{
		"styled-components/vim-styled-components",
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
	},

	{ "artemave/workspace-diagnostics.nvim" },
}
