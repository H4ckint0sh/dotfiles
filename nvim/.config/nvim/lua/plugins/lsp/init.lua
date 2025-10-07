-- File: lua/plugins/lsp.lua
local on_attach = require("plugins.lsp.on_attach")

vim.api.nvim_create_user_command("LspFormat", function()
	vim.lsp.buf.format({ async = false })
end, {})

return {
	{
		"neovim/nvim-lspconfig",
		event = "BufReadPre", -- Set event to BufReadPre for faster loading
		dependencies = {
			{ "mason-org/mason.nvim", cmd = "Mason" },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			require("mason").setup({
				registries = {
					"github:mason-org/mason-registry",
					"github:crashdummyy/mason-registry",
				},
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Use mason-lspconfig's handlers to apply the on_attach function
			require("mason-lspconfig").setup({
				ensure_installed = {
					"bashls",
					"eslint",
					"graphql",
					"html",
					"jsonls",
					"emmylua_ls",
					"zls",
					"ember",
					"prismals",
					"tailwindcss",
					"ts_ls",
					"astro",
					"jdtls",
					"emmet_language_server",
					"svelte",
					"somesass_ls",
				},
				automatic_enable = {
					exclude = {
						"emmet_language_server",
						"ts_ls",
					},
				},
				handlers = {
					function(server_name)
						require("lspconfig")[server_name].setup({
							on_attach = on_attach,
						})
					end,
				},
			})

			require("mason-tool-installer").setup({
				ensure_installed = {
					"prettier",
					"djlint",
					"eslint",
					"rzls",
					"roslyn",
				},
			})
		end,
	},
	{
		"folke/neoconf.nvim",
		cmd = "Neoconf",
		opts = {},
	},
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		},
	},
	{
		"antosha417/nvim-lsp-file-operations",
		name = "nvim-lsp-file-operations",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = true,
		opts = {},
	},
	{
		"joechrisellis/lsp-format-modifications.nvim",
		lazy = true,
		dependencies = { "nvim-lua/plenary.nvim" },
		init = function()
			vim.api.nvim_create_user_command("FormatModified", function()
				local bufnr = vim.api.nvim_get_current_buf()
				local clients = vim.lsp.get_clients({
					bufnr = bufnr,
					method = "textDocument/rangeFormatting",
				})

				if #clients == 0 then
					Snacks.notify.error("Format request failed, no matching language servers", { title = "LSP" })
				end

				for _, client in pairs(clients) do
					require("lsp-format-modifications").format_modifications(client, bufnr)
				end
			end, {})
		end,
	},
}
