return {
	"sindrets/diffview.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewFileHistory",
	},
	opts = {
		keymaps = {
			view = { ["q"] = "<Cmd>DiffviewClose<CR>" },
			file_panel = { ["q"] = "<Cmd>DiffviewClose<CR>" },
			file_history_panel = { ["q"] = "<Cmd>DiffviewClose<CR>" },
		},
	},
	keys = {
		{ "q", "<cmd>DiffviewClose<CR>", mode = "n", desc = "Close Diffview" },
	},
	config = function()
		require("diffview").setup(opts)
	end,
}
