---@type vim.lsp.Config
return {
	cmd = { "vtsls", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	---@param client vim.lsp.Client
	on_attach = function(client)
		-- Let biome do the formatting.
		if client.server_capabilities then
			client.server_capabilities.documentFormattingProvider = false
			client.server_capabilities.documentRangeFormattingProvider = false
			client.server_capabilities.documentOnTypeFormattingProvider = nil
		end
	end,
	root_markers = {
		"jsconfig.json",
		"package.json",
		"tsconfig.json",
	},
	settings = {
		complete_function_calls = true,
		javascript = common,
		typescript = common,
		vtsls = {
			autoUseWorkspaceTsdk = true,
			enableMoveToFileCodeAction = true,
			experimental = {
				completion = {
					enableServerSideFuzzyMatch = true,
				},
				maxInlayHintLength = 30,
			},
		},
	},
	single_file_support = true,
}
