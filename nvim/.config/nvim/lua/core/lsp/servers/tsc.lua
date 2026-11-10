-- TypeScript 7 native (Go) language server: `tsc --lsp --stdio`
-- Defaults (cmd, root_dir, filetypes, binary detection) come from nvim-lspconfig's lsp/tsc.lua.
-- A project-local node_modules/.bin/tsc is used if it is >= 7.0, otherwise the Mason one on $PATH.
vim.lsp.config("tsc", {
	settings = {
		["js/ts"] = {
			inlayHints = {
				parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
				parameterTypes = { enabled = true },
				variableTypes = { enabled = false },
				propertyDeclarationTypes = { enabled = false },
				functionLikeReturnTypes = { enabled = false },
				enumMemberValues = { enabled = true },
			},
			referencesCodeLens = { enabled = false },
			implementationsCodeLens = { enabled = false },
		},
	},
})
