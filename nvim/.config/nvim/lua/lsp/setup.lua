-- Setup installer & lsp configs
local mason_ok, mason = pcall(require, "mason")
local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
local blink_cmp_ok, blink_cmp = pcall(require, "blink.cmp")
local mason_tool_installer_ok, mason_tool_installer = pcall(require, "mason-tool-installer")

if not mason_ok or not mason_lsp_ok or not mason_tool_installer_ok or not blink_cmp_ok then
	return
end

mason.setup({
	ui = {
		-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
		border = "rounded",
		backdrop = 100,
	},
})

mason_lsp.setup({
	-- A list of servers to automatically install if they're not already installed
	ensure_installed = {
		"bashls",
		"cssls",
		"eslint",
		"graphql",
		"html",
		"jsonls",
		"lua_ls",
		"zls",
		"ember",
		"prismals",
		"tailwindcss",
		"astro",
		"ts_ls",
		"jdtls",
		"emmet_language_server",
	},
	automatic_installation = true,
})

mason_tool_installer.setup({
	ensure_installed = {
		"prettier", -- prettier formatter
		"djlint", -- handlebars formatter
		"eslint", -- javascript formatter
	},
})

local lspconfig = require("lspconfig")

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
}

---@diagnostic disable-next-line: unused-local
local function on_attach(client, bufnr)
	-- disable as we use vtsls instead
end

local capabilities = blink_cmp.get_lsp_capabilities()

capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}

require("mason-lspconfig").setup_handlers({
	-- The first entry (without a key) will be the default handler
	-- and will be called for each installed server that doesn't have
	-- a dedicated handler.
	function(server_name)
		require("lspconfig")[server_name].setup({
			on_attach = on_attach,
			capabilities = capabilities,
			handlers = handlers,
		})
	end,

	["zls"] = function()
		lspconfig.zls.setup({
			capabilities = capabilities,
			handlers = handlers,
			on_attach = on_attach,
		})
	end,

	["emmet_language_server"] = function()
		lspconfig.emmet_language_server.setup({
			capabilities = capabilities,
			handlers = handlers,
			on_attach = on_attach,
			settings = require("lsp.servers.emmet-language-server").settings,
		})
	end,

	["jdtls"] = function() end, -- Prevent Mason from attaching `jdtls`

	["ts_ls"] = function()
		require("typescript-tools").setup({
			capabilities = capabilities or vim.lsp.protocol.make_client_capabilities(),
			handlers = require("lsp.servers.ts_ls").handlers,
			on_attach = require("lsp.servers.ts_ls").on_attach,
			settings = require("lsp.servers.ts_ls").settings,
		})
	end, -- disabel to use typescript-tools

	["tailwindcss"] = function()
		capabilities.textDocument.completion.completionItem.snippetSupport = true
		capabilities.textDocument.colorProvider = { dynamicRegistration = false }
		capabilities.textDocument.foldingRange = {
			dynamicRegistration = false,
			lineFoldingOnly = true,
		}

		lspconfig.tailwindcss.setup({
			capabilities = capabilities,
			filetypes = require("lsp.servers.tailwindcss").filetypes,
			handlers = handlers,
			init_options = require("lsp.servers.tailwindcss").init_options,
			on_attach = require("lsp.servers.tailwindcss").on_attach,
			settings = require("lsp.servers.tailwindcss").settings,
			flags = {
				debounce_text_changes = 1000,
			},
		})
	end,

	["cssls"] = function()
		lspconfig.cssls.setup({
			capabilities = capabilities,
			handlers = handlers,
			on_attach = require("lsp.servers.cssls").on_attach,
			settings = require("lsp.servers.cssls").settings,
		})
	end,

	["eslint"] = function()
		lspconfig.eslint.setup({
			capabilities = capabilities,
			handlers = handlers,
			on_attach = require("lsp.servers.eslint").on_attach,
			settings = require("lsp.servers.eslint").settings,
			flags = {
				allow_incremental_sync = false,
				debounce_text_changes = 1000,
				exit_timeout = 1500,
			},
		})
	end,

	["jsonls"] = function()
		lspconfig.jsonls.setup({
			capabilities = capabilities,
			handlers = handlers,
			on_attach = on_attach,
			settings = require("lsp.servers.jsonls").settings,
		})
	end,

	["lua_ls"] = function()
		lspconfig.lua_ls.setup({
			capabilities = capabilities,
			handlers = handlers,
			on_attach = on_attach,
			settings = require("lsp.servers.lua_ls").settings,
		})
	end,

	["vuels"] = function()
		lspconfig.vuels.setup({

			filetypes = require("lsp.servers.vuels").filetypes,
			handlers = handlers,
			init_options = require("lsp.servers.vuels").init_options,
			on_attach = require("lsp.servers.vuels").on_attach,
			settings = require("lsp.servers.vuels").settings,
		})
	end,

	["astro"] = function()
		lspconfig.astro.setup({})
	end,

	-- ["glint"] = function()
	-- 	lspconfig.glint.setup({
	-- 		cmd = { "glint-language-server" },
	-- 		filetypes = { "html.handlebars", "handlebars" },
	-- 		root_dir = vim.uv.cwd,
	-- 	})
	-- end,

	["ember"] = function()
		lspconfig.ember.setup({
			cmd = { "ember-language-server", "--stdio" },
			filetypes = { "handlebars" },
			root_dir = vim.uv.cwd,
		})
	end,
})
