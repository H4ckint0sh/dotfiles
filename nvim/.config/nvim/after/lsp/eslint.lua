return {
	on_attach = function(client)
		-- Disable ESLint formatting if using Conform
		client.server_capabilities.documentFormattingProvider = false
		client.server_capabilities.diagnosticProvider = false -- Disable ESLint LSP diagnostics
	end,
}
