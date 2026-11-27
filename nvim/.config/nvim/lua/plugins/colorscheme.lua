return {
	"H4ckint0sh/nord.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		require("nord").setup({
			transparent = true,
			errors = { mode = "fg" },
			diff = { mode = "bg" },
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
			on_highlights = function(highlights, colors)
				-- Neovim 0.13 multicursor (Q, see :h multicursor). Without these the
				-- extra cursors borrow CurSearch and look like the current search match.
				highlights.MCursor = { fg = colors.polar_night.origin, bg = colors.frost.ice } -- extra cursors
				highlights.MCursorVisual = { bg = colors.polar_night.brightest } -- their Visual selections
			end,
		})
		vim.cmd.colorscheme("nord")
	end,
}
