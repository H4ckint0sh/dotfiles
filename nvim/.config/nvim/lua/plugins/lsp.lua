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
			-- Load diagnostic configuration
			require("core.lsp.config")
			-- Load LSP functions
			require("core.lsp.functions")

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
					"lua_ls",
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

				-- Load LSP configurations using vim.lsp.config API
				require("core.lsp"),
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
	{
		"antosha417/nvim-lsp-file-operations",
		event = "LspAttach",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "folke/snacks.nvim" },
		},
		config = function()
			require("lsp-file-operations").setup()
		end,
	},
}
