return {
	"sindrets/diffview.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	cmd = {
		"DiffviewOpen",
		"DiffviewClose",
		"DiffviewToggleFiles",
		"DiffviewFocusFiles",
		"DiffviewRefresh",
		"DiffviewFileHistory",
	},
	keys = {
		{ "<leader>gdo", "<cmd>DiffviewOpen<cr>", desc = "Open" },
		{ "<leader>gdO", "<cmd>DiffviewOpen origin/HEAD...HEAD --imply-local<cr>", desc = "Open (HEAD)" },
		{ "<leader>gdC", "<cmd>DiffviewClose<cr>", desc = "Close" },
		{ "<leader>gdt", "<cmd>DiffviewToggleFiles<cr>", desc = "Toggle Files" },
		{ "<leader>gdf", "<cmd>DiffviewFocusFiles<cr>", desc = "Focus Files" },
		{ "<leader>gdhb", "<cmd>DiffviewFileHistory<cr>", desc = "Branch History" },
		{ "<leader>gdhf", "<cmd>DiffviewFileHistory %<cr>", desc = "File History" },
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
