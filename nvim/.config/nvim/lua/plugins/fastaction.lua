return {
	"Chaitanyabsprip/fastaction.nvim",
	opts = {
		dismiss_keys = { "j", "k", "<esc>", "q" },
		keys = "asdfghlzxcvbnm",
		popup = {
			border = "rounded",
			hide_cursor = true,
			highlight = {
				divider = "FloatBorder",
				key = "MoreMsg",
				title = "Title",
				window = "NormalFloat",
			},
			title = false, -- or false to disable title
		},
		priority = {
			typescript = {
				{ pattern = "to existing import declaration", key = "a", order = 2 },
				{ pattern = "from module", key = "i", order = 1 },
			},
		},
	},
}
