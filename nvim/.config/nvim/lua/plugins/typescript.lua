local filter = require("util.filter").filter
local filterReactDTS = require("util.filterReactDTS").filterReactDTS
local on_attach = require("plugins.lsp.on_attach")
local _methods = vim.lsp.protocol.Methods

return {
	{
		"pmizio/typescript-tools.nvim",
		event = { "FileType" },
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			on_attach = on_attach,
			handlers = {
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
					-- Simply allow the default Neovim handler to process all diagnostics.
					-- If you still need to hide these, use a separate plugin like 'diagnostic-nvim'
					-- or the native `vim.diagnostic.config` to filter by source/code globally,
					-- which is often more performant.
					config = config or {}
					config.virtual_text = true
					vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ctx, config)
				end,
			},
			filetype = { "svelte", "typescriptreact", "typescript", "javascript", "javascriptreact" },
			-- TODO : check if needed
			init_options = {
				globalPlugins = {
					{
						name = "@vue/typescript-plugin",
						languages = { "vue" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
					{
						name = "@astrojs/ts-plugin",
						languages = { "astro" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
					{
						name = "typescript-svelte-plugin",
						languages = { "svelte" },
						configNamespace = "typescript",
						enableForWorkspaceTypeScriptVersions = true,
					},
				},
			},
			settings = {
				-- Performance settings
				separate_diagnostic_server = true,
				publish_diagnostic_on = "insert_leave",
				tsserver_max_memory = "4096",

				-- Formatting preferences (from default_format_options)
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
					indentSwitchCase = true,
				},

				-- File preferences (Inlay Hints are disabled here)
				tsserver_file_preferences = {
					-- ** INLAY HINTS DISABLED **
					includeInlayParameterNameHints = "none", -- Changed from "all"
					includeInlayParameterNameHintsWhenArgumentMatchesName = false, -- Changed from true
					includeInlayFunctionParameterTypeHints = false, -- Changed from true
					includeInlayVariableTypeHints = false, -- Changed from true
					includeInlayVariableTypeHintsWhenTypeMatchesName = false, -- Changed from true
					includeInlayPropertyDeclarationTypeHints = false, -- Changed from true
					includeInlayFunctionLikeReturnTypeHints = false, -- Changed from true
					includeInlayEnumMemberValueHints = false, -- Changed from true

					-- Important default preferences
					quotePreference = "auto",
					importModuleSpecifierEnding = "auto",
					jsxAttributeCompletionStyle = "auto",
					allowTextChangesInNewFiles = true,
					providePrefixAndSuffixTextForRename = true,
					allowRenameOfImportPath = true,
					includeAutomaticOptionalChainCompletions = true,
					provideRefactorNotApplicableReason = true,
					generateReturnInDocTemplate = true,
					includeCompletionsForImportStatements = true,
					includeCompletionsWithSnippetText = false,
					includeCompletionsWithClassMemberSnippets = true,
					includeCompletionsWithObjectLiteralMethodSnippets = true,
					useLabelDetailsInCompletionEntries = true,
					allowIncompleteCompletions = true,
					displayPartsForJSDoc = true,
					disableLineTextInReferences = true,
				},

				-- Feature settings
				expose_as_code_action = "all",
				complete_function_calls = true,
				include_completions_with_insert_text = true,
			},
		},
		keys = {
			{ "<leader>oi", "<CMD>TSToolsOrganizeImports<CR>", desc = "Organize Imports" },
			{ "<leader>ui", "<CMD>TSToolsRemoveUnusedImports<CR>", desc = "Remove Unused Imports" },
			{ "<leader>mi", "<CMD>TSToolsAddMissingImports<CR>", desc = "Add Missing Imports" },
			{ "<leader>rf", "<CMD>TSToolsRenameFile<CR>", desc = "Rename File" },
			{ "<leader>si", "<CMD>TSToolsSortImports<CR>", desc = "Sort Imports" },
		},
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
		"laytan/tailwind-sorter.nvim",
		cmd = {
			"TailwindSort",
			"TailwindSortOnSaveToggle",
		},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		build = "cd formatter && npm i && npm run build",
		config = true,
	},
	{ "artemave/workspace-diagnostics.nvim" },
}
