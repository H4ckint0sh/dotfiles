return {
	on_attach = function()
		require("lazydev")
	end,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
			},
			workspace = { checkThirdParty = false },
			codeLens = { enable = true },
			telemetry = { enable = false },
			doc = { privateName = { "^_" } },
			diagnostics = {
				unusedLocalExclude = { "_*" },
			},
			format = { enable = false },
			hint = {
				enable = true,
				setType = false,
				paramType = true,
				arrayIndex = "Disable",
			},
		},
	},
}
