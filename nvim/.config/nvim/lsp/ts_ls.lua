---@type vim.lsp.Config
return {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },

	init_options = {
		hostInfo = "neovim",
	},
	{
		-- Performance settings
		separate_diagnostic_server = true,
		publish_diagnostic_on = "insert_leave",
		tsserver_max_memory = "auto",

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

		-- File preferences (combining your inlay hints with default preferences)
		tsserver_file_preferences = {
			-- Your current inlay hint settings
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayVariableTypeHints = false,
			includeInlayVariableTypeHintsWhenTypeMatchesName = false,
			includeInlayPropertyDeclarationTypeHints = false,
			includeInlayFunctionLikeReturnTypeHints = false,
			includeInlayEnumMemberValueHints = true,

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
			includeCompletionsWithSnippetText = true,
			includeCompletionsWithClassMemberSnippets = true,
			includeCompletionsWithObjectLiteralMethodSnippets = true,
			useLabelDetailsInCompletionEntries = true,
			allowIncompleteCompletions = true,
			displayPartsForJSDoc = true,
			disableLineTextInReferences = true,
		},

		-- Feature settings
		expose_as_code_action = "all",
		complete_function_calls = false,
		include_completions_with_insert_text = true,
		code_lens = "implementations_only",
	},
}
