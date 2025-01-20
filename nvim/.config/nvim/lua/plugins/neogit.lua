return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim",
	},
	keys = {
		{ "<leader>n", ":Neogit<CR>", desc = "Neogit" },
	},
	cmd = "Neogit",
	opts = {
		graph_style = "kitty",
	},
}
