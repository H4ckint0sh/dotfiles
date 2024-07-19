return {
	"folke/trouble.nvim",
	cmd = { "Trouble" },
	opts = {
		auto_close = true, -- auto close when there are no items
		focus = true, -- Focus the window when open
		keys = {
			zo = "fold_open",
		},
		preview = {
			scratch = false,
		},
		modes = {
			mode = "lsp_references",
			preview = {
				type = "split",
				relative = "win",
				position = "right",
				size = 0.3,
			},
		},
	},
	config = function(_, opts)
		require("trouble").setup(opts)
	end,
	keys = {
		{
			"<leader>cD",
			"<cmd>Trouble diagnostics toggle<cr>",
			desc = "Workspace Diagnostics",
		},
		{
			"<leader>cd",
			"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
			desc = "Buffer Diagnostics",
		},
		{
			"<leader>cs",
			"<cmd>Trouble symbols toggle focus=true<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cx",
			"<cmd>Trouble lsp toggle win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>gr",
			"<cmd>Trouble lsp_references<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>gd",
			"<cmd>Trouble lsp_definitions<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>gi",
			"<cmd>Trouble lsp_implementations<cr>",
			desc = "LSP Definitions / refere)",
		},
		{
			"<leader>gy",
			"<cmd>Trouble lsp_type_definitions<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>cL",
			"<cmd>Trouble loclist toggle<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>cq",
			"<cmd>Trouble qflist toggle<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}
