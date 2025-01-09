return {
	"Chaitanyabsprip/fastaction.nvim",
	opts = {
		dismiss_keys = { "j", "k", "<esc>", "q" },
		override_function = function(_) end,
		keys = "qwertyuiopasdfghlzxcvbnm",
		popup = {
			border = "rounded",
			hide_cursor = true,
			highlight = {
				divider = "FloatBorder",
				key = "MoreMsg",
				title = "Title",
				window = "NormalFloat",
			},
			title = "Select one of:",
		},
		register_ui_select = false,
	},
}
