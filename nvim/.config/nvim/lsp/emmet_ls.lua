---@type vim.lsp.Config
return {
	cmd = { "emmet-language-server", "--stdio" },
	filetypes = { "html" },
	root_markers = { "package.json", ".git" },
	settings = {
		filetypes = {
			"css",
			"eruby",
			"html",
			"javascript",
			"javascriptreact",
			"less",
			"sass",
			"scss",
			"pug",
			"typescriptreact",
		},
		-- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
		-- **Note:** only the options listed in the table are supported.
		init_options = {
			---@type table<string, string>
			includeLanguages = {},
			--- @type string[]
			excludeLanguages = {},
			--- @type string[]
			extensionsPath = {},
			--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
			preferences = {},
			--- @type boolean Defaults to `true`
			showAbbreviationSuggestions = true,
			--- @type "always" | "never" Defaults to `"always"`
			showExpandedAbbreviation = "always",
			--- @type boolean Defaults to `false`
			showSuggestionsAsSnippets = false,
			--- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
			syntaxProfiles = {},
			--- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
			variables = {},
		},
	},
}
