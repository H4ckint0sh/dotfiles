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
					"tailwindcss",
					"ts_ls",
					"astro",
					"emmet_language_server",
					"svelte",
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
				},
			})
		end,
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
}
