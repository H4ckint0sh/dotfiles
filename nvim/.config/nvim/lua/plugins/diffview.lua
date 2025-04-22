return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	keys = {
		{ "<leader>dv", "<cmd>DiffviewFileHistory %<cr>", desc = "View git history for current file" },
		{ "<leader>dh", "<cmd>DiffviewFileHistory<cr>", desc = "View git history for repo" },
		{ "<leader>do", "<cmd>DiffviewOpen<cr>", desc = "View modified files" },
		{ "<leader>dc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
	},
	opts = {
		enhanced_diff_hl = true,
		use_icons = true,
		view = {
			default = {
				layout = "diff2_horizontal",
			},
		},
		keymaps = {
			view = { ["q"] = "<Cmd>DiffviewClose<CR>" },
			file_panel = { ["q"] = "<Cmd>DiffviewClose<CR>" },
			file_history_panel = { ["q"] = "<Cmd>DiffviewClose<CR>" },
		},
	},
	config = function(_, opts)
		require("diffview").setup(opts)
	end,
}
