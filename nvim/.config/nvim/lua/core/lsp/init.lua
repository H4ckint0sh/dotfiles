-- Setup default configs for all LSP clients
vim.lsp.config("*", {
	handlers = {
		["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
	},
	capabilities = (function()
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		-- Improved folding support
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		-- Enhanced semantic tokens
		capabilities.textDocument.semanticTokens = {
			dynamicRegistration = false,
			formats = { "relative" },
			multilineTokenSupport = true,
			overlappingTokenSupport = true,
			requests = {
				range = true,
				full = { delta = true },
			},
			tokenModifiers = {},
			tokenTypes = {},
		}

		return capabilities
	end)(),
	on_attach = function(client, bufnr)
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end,
})

-- Override floating preview border
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or "rounded"
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- Load all the LSP server configurations from individual files
require("core.lsp.servers.lua_ls")
require("core.lsp.servers.jsonls")
require("core.lsp.servers.cssls")
require("core.lsp.servers.eslint")
require("core.lsp.servers.tailwindcss")
require("core.lsp.servers.vuels")
require("core.lsp.servers.html")
require("core.lsp.servers.bashls")
require("core.lsp.servers.graphql")
require("core.lsp.servers.prismals")
require("core.lsp.servers.denols")

-- Note: Server enabling is now handled by mason-lspconfig's automatic_enable feature
return {}
