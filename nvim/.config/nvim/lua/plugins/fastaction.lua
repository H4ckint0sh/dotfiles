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
				{ pattern = "Fix all auto-fixable problems", key = "a", order = 2 },
				{ pattern = "Organize Imports", key = "o", order = 1 },
				{ pattern = "Add all missing imports", key = "m", order = 3 },
			},
		},
	},
}
