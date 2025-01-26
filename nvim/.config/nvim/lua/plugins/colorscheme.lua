return {
	"gbprod/nord.nvim",
	priority = 1000,

	config = function()
		require("nord").setup({
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
				-- Native
				highlights["@tag.builtin.tsx"] = { fg = colors.red }

				-- Snacks
				highlights.SnacksDashboardHeader = { fg = colors.green }
			end,
		})
		vim.cmd.colorscheme("nord")
	end,
}
