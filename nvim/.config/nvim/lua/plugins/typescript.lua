return {
	{
		"pmizio/typescript-tools.nvim",
		event = "LspAttach",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"saghen/blink.cmp",
				-- Ensure blink.cmp is loaded before typescript-tools
				lazy = false,
				priority = 1000,
			},
		},
		config = function()
			require("typescript-tools").setup({})
		end,
		keys = {
			{ "<leader>oi", "<CMD>TSToolsOrganizeImports<CR>", desc = "Organize Imports" },
			{ "<leader>ui", "<CMD>TSToolsRemoveUnusedImports<CR>", desc = "Remove Unused Imports" },
			{ "<leader>mi", "<CMD>TSToolsAddMissingImports<CR>", desc = "Add Missing Imports" },
			{ "<leader>rf", "<CMD>TSToolsRenameFile<CR>", desc = "Rename File" },
			{ "<leader>si", "<CMD>TSToolsSortImports<CR>", desc = "Sort Imports" },
			{ "<leader>fa", "<CMD>TSToolsFixAll<CR>", desc = "Fix All" },
		},
	},
	{
		"razak17/tailwind-fold.nvim",
		opts = {
			min_chars = 50,
		},
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		ft = { "html", "svelte", "astro", "vue", "typescriptreact" },
		keys = {
			{ "<leader>tf", "<CMD>TailwindFoldToggle<CR>", desc = "Toggle Tailwind Fold" },
		},
	},
	{
		"mawkler/jsx-element.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		ft = { "typescriptreact", "javascriptreact", "javascript" },
		opts = {},
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
		"js-everts/cmp-tailwind-colors",
		config = true,
	},

	{
		"laytan/tailwind-sorter.nvim",
		cmd = {
			"TailwindSort",
			"TailwindSortOnSaveToggle",
		},
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		build = "cd formatter && npm i && npm run build",
		config = true,
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
		"styled-components/vim-styled-components",
		ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
	},

	{ "artemave/workspace-diagnostics.nvim" },
}
