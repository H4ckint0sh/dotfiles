local M = {}

local filter = require("lsp.utils.filter").filter
local filterReactDTS = require("lsp.utils.filterReactDTS").filterReactDTS

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		silent = true,
		border = "rounded",
	}),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
	["textDocument/publishDiagnostics"] = vim.lsp.with(
		vim.lsp.diagnostic.on_publish_diagnostics,
		{ virtual_text = true }
	),
	["textDocument/definition"] = function(err, result, method, ...)
		if vim.isarray(result) and #result > 1 then
			local filtered_result = filter(result, filterReactDTS)
			return vim.lsp.handlers["textDocument/definition"](err, filtered_result, method, ...)
		end

		vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
	end,
}

local init_options = {
	maxTsServerMemory = 8192, -- Increase memory allocation
}

local settings = {
	typescript = {
		inlayHints = {
			parameterNames = { enabled = "literals" },
			parameterTypes = { enabled = false },
			variableTypes = { enabled = false },
			propertyDeclarationTypes = { enabled = true },
			functionLikeReturnTypes = { enabled = false },
			enumMemberValues = { enabled = true },
		},
		suggest = {
			includeCompletionsForModuleExports = false,
		},
	},
	javascript = {
		inlayHints = {
			parameterNames = { enabled = "literals" },
			parameterTypes = { enabled = false },
			variableTypes = { enabled = false },
			propertyDeclarationTypes = { enabled = true },
			functionLikeReturnTypes = { enabled = false },
			enumMemberValues = { enabled = true },
		},
		suggest = {
			includeCompletionsForModuleExports = false,
		},
	},
}

settings.javascript = vim.tbl_deep_extend("force", {}, settings.typescript, settings.javascript or {})

local on_attach = function(client, bufnr)
	vim.lsp.inlay_hint.enable(true, { bufnr })
	require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
end

M.handlers = handlers
M.init_options = init_options
M.settings = settings
M.on_attach = on_attach

return M
