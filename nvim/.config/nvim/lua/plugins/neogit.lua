return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim",
	},
	keys = {
		{ "<leader>ng", ":Neogit<CR>", desc = "Neogit" },
	},
	cmd = "Neogit",
	opts = {
		graph_style = "kitty",
		commit_editor = {
			staged_diff_split_kind = "vsplit",
		},
	},
}
