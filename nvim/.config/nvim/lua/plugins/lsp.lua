---@module 'lazy.types'
---@type LazySpec[]
return {
	{
		"mason-org/mason.nvim",
		cmd = "Mason",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		init = function()
			-- add Mason packages to $PATH; allows lazy-loading
			vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH
		end,
		---@module 'mason.settings'
		---@type MasonSettings
		opts = {
			ensure_installed = {},
			registries = {
				"github:mason-org/mason-registry",
				"github:mistweaverco/zana-registry",
			},
			ui = {
				-- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
				border = "rounded",
				backdrop = 100,
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)

			local registry = require("mason-registry")
			registry:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local package = registry.get_package(tool)
					if not package:is_installed() then
						package:install()
					end
				end
			end

			if registry.refresh then
				registry.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		lazy = true,
		opts = {
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
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		lazy = true,
		opts = {
			ensure_installed = {
				"prettier", -- prettier formatter
				"djlint", -- handlebars formatter
				"eslint", -- javascript formatter
			},
		},
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
				-- Load luvit types when the `vim.uv` word is found
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
