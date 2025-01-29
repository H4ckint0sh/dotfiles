return {
	"H4ckint0sh/nord.nvim",
	priority = 1000,
	lazy = false,
	config = function()
		require("nord").setup({
			errors = { mode = "fg" },
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
				highlights["@tag.builtin.tsx"] = {
					fg = colors.aurora.orange,
				}
				highlights["SnacksDashboardHeader"] = {
					fg = colors.aurora.green,
				}
				highlights["SnacksDashboardFooter"] = {
					fg = colors.frost.artic_water,
				}
				highlights["Special"] = {
					fg = colors.frost.ice,
				}
				highlights["Pmenu"] = {
					bg = colors.polar_night.origin,
				}
				highlights["BlinkCmpMenuBorder"] = {
					fg = colors.frost.ice,
				}
				highlights["IncSearch"] = {
					fg = colors.frost.ice,
				}
			end,
		})
		vim.cmd.colorscheme("nord")
	end,
}
