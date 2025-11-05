return {
	{
		"pmizio/typescript-tools.nvim",
		event = "BufReadPre",
		ft = {
			"javascript",
			"javascriptreact",
			"typescript",
			"typescriptreact",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
			{
				"saghen/blink.cmp",
				-- Ensure blink.cmp is loaded before typescript-tools
				lazy = false,
				priority = 1000,
			},
		},
		config = function()
			-- typescript-tools replaces the standard tsserver LSP completely
			-- This is using the separate plugin setup function, not vim.lsp.config
			require("typescript-tools").setup({
				capabilities = require("blink.cmp").get_lsp_capabilities(),
				handlers = require("core.lsp.servers.tsserver").handlers,
				on_attach = require("core.lsp.servers.tsserver").on_attach,
				settings = require("core.lsp.servers.tsserver").settings,
			})
		end,
	},

	{
		"razak17/tailwind-fold.nvim",
		opts = {
			min_chars = 50,
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
	},

	{
		"MaximilianLloyd/tw-values.nvim",
		keys = {
			{ "<Leader>cv", "<CMD>TWValues<CR>", desc = "Tailwind CSS values" },
		},
		opts = {
			border = "rounded", -- Valid window border style,
			show_unknown_classes = true, -- Shows the unknown classes popup
		},
	},

	{
		"axelvc/template-string.nvim",
		event = "InsertEnter",
		ft = {
			"javascript",
			"typescript",
			"javascriptreact",
			"typescriptreact",
		},
		config = true, -- run require("template-string").setup()
	},

	{
		"dmmulroy/tsc.nvim",
		cmd = { "TSC" },
		config = true,
	},

	{
		"dmmulroy/ts-error-translator.nvim",
		config = true,
	},
}
