-- Configure elixir-ls with Neovim 0.11 API
vim.lsp.config.elixirls = {
	cmd = { "elixir-ls" },
	settings = {
		elixirLS = {
			dialyzerEnabled = true,
			fetchDeps = false,
			enableTestLenses = true,
			suggestSpecs = true,
		},
	},
	on_attach = function(client, bufnr)
		-- Elixir LS handles formatting via its own formatter
	end,
}