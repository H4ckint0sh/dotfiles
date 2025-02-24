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
		highlight = {
			italic = false,
			bold = false,
			underline = false,
		},
	},
	init = function()
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = { "NeogitStatus", "NeogitPopup", "NeogitLogView" },
			callback = function()
				require("ufo").detach()
				vim.opt_local.foldenable = false
			end,
		})
	end,
}
