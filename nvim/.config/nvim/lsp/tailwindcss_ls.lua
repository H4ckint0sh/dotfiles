---@type vim.lsp.Config
return {
	cmd = { "tailwindcss-language-server", "--stdio" },
	filetypes = { "html", "mdx", "javascript", "typescript", "javascriptreact", "typescriptreact", "vue", "svelte" },
	root_markers = { "package.json", ".git" },
	init_options = {
		userLanguages = {
			eelixir = "html-eex",
			eruby = "erb",
		},
	},

	settings = {
		tailwindCSS = {
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidConfigPath = "error",
				invalidScreen = "error",
				invalidTailwindDirective = "error",
				invalidVariant = "error",
				recommendedVariantOrder = "warning",
			},
			experimental = {
				classRegex = {
					"tw`([^`]*)",
					'tw="([^"]*)',
					'tw={"([^"}]*)',
					"tw\\.\\w+`([^`]*)",
					"tw\\(.*?\\)`([^`]*)",
					{ "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
					{ "classnames\\(([^)]*)\\)", "'([^']*)'" },
					{ "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
					{ "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
				},
			},
			validate = true,
		},
	},
}
