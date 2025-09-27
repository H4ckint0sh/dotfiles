return {
	"H4ckint0sh/nord.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		require("nord").setup({
			transparent = true,
			errors = { mode = "fg" },
			diff = { mode = "fg" },
			styles = {
				-- Style to be applied to different syntax groups
				-- Value is any valid attr-list value for `:help nvim_set_hl`
				comments = { italic = true },
				keywords = { italic = true },
				constants = { italic = true },
				functions = {},
				variables = {},

				-- To customize lualine/bufferline
				bufferline = {
					current = {},
					modified = { italic = true },
				},
			},
			-- on_highlights = function(highlights, colors)
			-- end,
		})
		vim.cmd.colorscheme("nord")
	end,
}
